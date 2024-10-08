Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B801C9B99;
	Tue,  8 Oct 2024 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392840; cv=none; b=AzOX2ErgEWfCnfu79O+oSsuy5hNSJoNyVSJp09zt+cq1b0mJ/po6WFFuwQ76XA5KUaDPkddE4kZy3jnziV1O0yLPAR+0qGE/8bvx3dH+a1Q6H5A3CywZ66k7zrwLyyOHVi3kZzH16MU+QS+bgsoeb08fs5ezX16WqVL+Vx3KSfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392840; c=relaxed/simple;
	bh=uy3KL7yr2r82IlofVHvBsx6Q5ve3TcfPQs4rDaAd8Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIA8PlrNtvUmMkwfIPTfZxkueI+MKMGnK55hsHQ2kTdxnSWN3iQzENSuySl2PGU3mwzmDmXxpMWSv9SXT/pfozoao91N4xojEpppRiwZM2COsbx3F2Ru4+RYiGFaX+HbSDvE8miMFO8kR0ExNGAVzqJum3SsG9Q0iiz4km59YKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rctUZ88x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rctUZ88x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC55C4CEC7;
	Tue,  8 Oct 2024 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392840;
	bh=uy3KL7yr2r82IlofVHvBsx6Q5ve3TcfPQs4rDaAd8Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rctUZ88xc99z9kEmo8ANoNxqCuOOoC5gCHUrcfT2DMQtJqaTTwA6t62mdy8YVTUbN
	 Pm7c3c+uJoCIwLaGlRpwUn0ZCKaIjwZAuUIPTIf8sWKCwA2rFGP3PTHHOWp2SC3H51
	 D607IAZj5cZDeswjxFufAFlFSxY0QJH+BFRjoFvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 534/558] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Tue,  8 Oct 2024 14:09:24 +0200
Message-ID: <20241008115723.246726535@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 34820304cc2cd1804ee1f8f3504ec77813d29c8e upstream.

xol_add_vma() maps the uninitialized page allocated by __create_xol_area()
into userspace. On some architectures (x86) this memory is readable even
without VM_READ, VM_EXEC results in the same pgprot_t as VM_EXEC|VM_READ,
although this doesn't really matter, debugger can read this memory anyway.

Link: https://lore.kernel.org/all/20240929162047.GA12611@redhat.com/

Reported-by: Will Deacon <will@kernel.org>
Fixes: d4b3b6384f98 ("uprobes/core: Allocate XOL slots for uprobes use")
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 333c44f2ce55d..56cd0c7f516d3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1500,7 +1500,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



