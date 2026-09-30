Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB70502D5A;
	Wed, 30 Sep 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792346; cv=none; b=AA4k6KxvfLwl9OcWbqpEmbBtSczKvUzdeqCwXq3OAoC9zFub8U0Uzg2SG092dhV03Cwt1/II4ibJojd6h++aDy6onlQpEGfVYMz1C41qyNdkRM09vrDEo2UvCPO0MlFXKWiB4S9ihbaDn9KB9af/ROpCcGSWOKN2WIDgxs/4uhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792346; c=relaxed/simple;
	bh=HlzF8hsepzs4gWWZe/hsTv+3J/EJQCxhVcqPIbF12tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIj0v3YmQtoJ1Jnd9GXBXZMwASon/8nIeVtNaGIxImXmpTNwYVXrRnli89FFJIlqMNOFva6WsFddbVxpyKTNsX3pdi/alEM/Szxz+unXlJekehMQhUiJwT8W/BHYcNvA4+uDak6YZO1eLPnawaf3Q8Zk8Kn4lEGdwy5r+wWljag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpDJd0pO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpDJd0pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541AE1F000FF;
	Wed, 30 Sep 2026 18:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792344;
	bh=5Fu2ojObzL7FEAUxMCl/BgrErFRQ3qhl5yNdmkwQ4nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LpDJd0pOhu68qgSHuSAJWA8OSIYMsP75uObN70KU0Un3pZimNVjCkTu+w+/L8S8+M
	 6p3qwUQbkz5KPNIzjOb122EuWorv3xd+AMyohoUFz1KJEkrJe4lOj2NA81us7JGy8U
	 9h/Wrd3MAP7oallrUdHSPSY1XpUymWvBC1Iu2u50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 623/752] net/sched: act_ct: dont WARN on benign flow_offload_alloc() failure
Date: Wed, 30 Sep 2026 17:28:13 +0200
Message-ID: <20260930152411.758238015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 47abe7a5c4eb53269aca3506446f851572a059a3 ]

flow_offload_alloc() returns NULL when the conntrack entry is dying
(e.g. raced with a conntrack flush) or when the GFP_ATOMIC allocation
fails; both are expected under load and neither is a kernel bug. This
path runs from softirq on every committed packet, so with
panic_on_warn=1 an unprivileged user can panic the box just by racing
a conntrack flush against a `tc ... action ct commit` classifier.

Reproduced with a custom repro under QEMU: a small, fixed set of UDP
flows through `tc filter ... action ct commit` on lo, raced against
threads flooding bare ctnetlink CT_DELETE (flush) requests. Hits
WARNING: net/sched/act_ct.c:437 (tcf_ct_flow_table_add(), inlined
into tcf_ct_act() in this build) within ~15s on the unpatched kernel;
same setup is clean on the patched kernel. The fix itself is
behavior-preserving: both branches already did `goto err_alloc`
before and after, only the WARN is removed.

Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
Reported-by: syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6cc37aba98dac721c415
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915150816.36487-1-ngocthang2710.1999@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index df31fa7b5064c..25342f03153fb 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -377,11 +377,10 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
 		return;
 
+	/* NULL if ct is dying (raced flush) or the atomic alloc failed. */
 	entry = flow_offload_alloc(ct);
-	if (!entry) {
-		WARN_ON_ONCE(1);
+	if (!entry)
 		goto err_alloc;
-	}
 
 	if (tcp) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-- 
2.53.0



