Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E3232D0E0;
	Mon, 27 Oct 2025 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593236; cv=none; b=nkgYrO83dn09rGxpmt9n97Hnz4LFGD+yLgyC/OC8/I5Pw2tbCfOrkUFkBGRYImwD+6ab25tPOBb29r5Mmmxkebtb8QYTMzByABe9XzG3uJx9VENC4Ba41rsV2bTPx+jL7qOR4W9bVTqqwhH15IKr/n+wLIDJvZVWfEiURh7tUFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593236; c=relaxed/simple;
	bh=ckiLdYMm/pn6i5s4Jf7WwYEBg1TBt8NK5got+XaxBvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXgKLPgwQ838tQcaAKrVKP/UL5+iajX8i5eybrt5n9rqWutv1Y8phnA8RayYSlHUT82zwHSVYULFiGw708zZo0S63kQvAyRrDGCbCe+ez5DqFxMmpSE/YVmFS1QuHAGCoDafRBTZAicpvMTVAGQMIPb6+EKonbnqNdciQYsVJc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTfxozn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTfxozn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B10C4CEF1;
	Mon, 27 Oct 2025 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593236;
	bh=ckiLdYMm/pn6i5s4Jf7WwYEBg1TBt8NK5got+XaxBvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTfxozn4wgGNR75sgiPrI4ldGvSmt44lMSTsqp6VcZvRNHAWe745Zf6CofRz4qTRE
	 aels1GxSSR+r8U6IPtAYN/T3hHf4oOD/hKx2YxRdZ+dafncnXri3OE7oWXbc7NGqm6
	 eOxfKSjRhxYSSW0isQg2h3jjBvVKLBZnDXLdNP3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com,
	syzbot+665739f456b28f32b23d@syzkaller.appspotmail.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 064/184] mm: dont spin in add_stack_record when gfp flags dont allow
Date: Mon, 27 Oct 2025 19:35:46 +0100
Message-ID: <20251027183516.615109663@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

commit c83aab85e18103a6dc066b4939e2c92a02bb1b05 upstream.

syzbot was able to find the following path:
  add_stack_record_to_list mm/page_owner.c:182 [inline]
  inc_stack_record_count mm/page_owner.c:214 [inline]
  __set_page_owner+0x2c3/0x4a0 mm/page_owner.c:333
  set_page_owner include/linux/page_owner.h:32 [inline]
  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
  prep_new_page mm/page_alloc.c:1859 [inline]
  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
  alloc_pages_nolock_noprof+0x94/0x120 mm/page_alloc.c:7554

Don't spin in add_stack_record_to_list() when it is called
from *_nolock() context.

Link: https://lkml.kernel.org/r/CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com
Reported-by: syzbot+665739f456b28f32b23d@syzkaller.appspotmail.com
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_owner.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index c3ca21132c2c..589ec37c94aa 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -168,6 +168,9 @@ static void add_stack_record_to_list(struct stack_record *stack_record,
 	unsigned long flags;
 	struct stack *stack;
 
+	if (!gfpflags_allow_spinning(gfp_mask))
+		return;
+
 	set_current_in_page_owner();
 	stack = kmalloc(sizeof(*stack), gfp_nested_mask(gfp_mask));
 	if (!stack) {
-- 
2.51.1



