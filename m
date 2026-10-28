Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209244;
	b=H44Mbl0ko1JRq3oprgs1FGudYGdx4NxAdmuvifxQCd7ZrXYjRhO3kHhTM/Az/jyXsm8T
	 /OiFAKXP2P+eLsUDBQL09yfAi+a9dJvoZgcWMIoJ5DDwAuO0n3E5EojOTIp8KOzYcuBTu
	 Exr+W4SsfkCZYZc+s20BSn1LlG0mKnX03r11JCqdS6unQ9IyxMZBzqCu3ENBC5NohyHsV
	 iEsimGb20NwF7J6LIYMsoz9eGPcw/zzKgnFvytx91ZcJ0eF2qvKAHvvt9dPxQabPjVfsh
	 vC51IZmWc5wqXIrRbZhISb9WduGABDtKruRBUAKTLbpNnVhNCfCQNLt6FA/gz6eKzDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g3JGb6xhq+pZPqrqwPMn04wFKN8yHOxci+QJigy0/wA=;
	b=CgWn04vdXP9vqWA4Pt1GhgWGJSjSlc7oou9GWeylT4w6Kwx3C4znYjgUftNTiii603tv
	 e/KPEvng6dolKqZGy2c4Vn1i14O9RLhVg1+xyZmBxtTujqopEehjM69bLhFVNSq+EFyCD
	 QxIJRs8KIraOYtERrKf8FE9qkdRI1clURzyXGqDqLo2p3KaIO8P1sxnhE30bZTbskQYFg
	 0/Bqnl9iE/Ie6HGfkU2vFDV/nfy8zo4qMc5yyvCD/p4GwMvRDsIqCockudecC+Tw6EB2B
	 YNbsPGSCAtLjh5szm3gN480XowY74Pntp/WeZFKic0ZNOTWihjKdRfsAb1i6zmZ+JRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ekg/VKPc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BF4606A31A;
	Wed, 28 Oct 2026 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ekg/VKPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BE01F01825;
	Wed, 28 Oct 2026 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209244;
	bh=g3JGb6xhq+pZPqrqwPMn04wFKN8yHOxci+QJigy0/wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ekg/VKPcF1+AtR8zVFvJLOVANZS1HGrrgGXrjchb52HNylix0KMv5J+yjajVZRubC
	 H6VgVujmAfOjXpo6yO2opsG0Tu0Zd/w2S/OFtVzqLmatdhFYPMX6IBKlWkM6+68lh9
	 H/0GRYWX4j7DR1v0G6Q3pXcc/sTq8JvxYVEl1aJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tahera Fahimi <taherafahimi@linux.microsoft.com>,
	Allen Pais <apais@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/516] xfrm: prevent policy_hthresh.work from racing with netns teardown
Date: Wed, 28 Oct 2026 17:59:14 +0100
Message-ID: <20261028170013.004167701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tahera Fahimi <taherafahimi@linux.microsoft.com>

An XFRM_MSG_NEWSPDINFO request can queue the per-net work item
policy_hthresh.work onto the system workqueue. xfrm_hash_rebuild()
retrieves the enclosing struct net from the work item, so the callback
can dereference freed memory if it runs after net namespace teardown.

Mainline commit 29fe3a61bcdc ("xfrm: prevent policy_hthresh.work
from racing with netns teardown") fixes this issue using
disable_work_sync(). That API is not available in Linux 5.10, so the
mainline change cannot be directly backported.

Provide the same guarantee with an XFRM-local work_disabled flag. Protect
the flag and schedule_work() with the existing policy_hthresh seqlock so
teardown can atomically stop new queueing attempts. Then use
cancel_work_sync() to synchronize work that was queued before the flag was
set. This ensures policy_hthresh.work cannot outlive its struct net.

Fixes: 880a6fab8f6b ("xfrm: configure policy hash table thresholds by netlink")
Assisted-by: GitHub-Copilot:GPT-5.6 Sol
Signed-off-by: Tahera Fahimi <taherafahimi@linux.microsoft.com>
Reviewed-by: Allen Pais <apais@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/xfrm.h |  1 +
 net/xfrm/xfrm_policy.c   | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 47bc0ec051eb5..bafdfdccbd954 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -23,6 +23,7 @@ struct xfrm_policy_hash {
 struct xfrm_policy_hthresh {
 	struct work_struct	work;
 	seqlock_t		lock;
+	bool			work_disabled;
 	u8			lbits4;
 	u8			rbits4;
 	u8			lbits6;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 26bc082139550..c14f495f62b80 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1378,7 +1378,10 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 
 void xfrm_policy_hash_rebuild(struct net *net)
 {
-	schedule_work(&net->xfrm.policy_hthresh.work);
+	write_seqlock(&net->xfrm.policy_hthresh.lock);
+	if (!net->xfrm.policy_hthresh.work_disabled)
+		schedule_work(&net->xfrm.policy_hthresh.work);
+	write_sequnlock(&net->xfrm.policy_hthresh.lock);
 }
 EXPORT_SYMBOL(xfrm_policy_hash_rebuild);
 
@@ -4129,6 +4132,7 @@ static int __net_init xfrm_policy_init(struct net *net)
 	net->xfrm.policy_hthresh.rbits6 = 128;
 
 	seqlock_init(&net->xfrm.policy_hthresh.lock);
+	net->xfrm.policy_hthresh.work_disabled = false;
 
 	INIT_LIST_HEAD(&net->xfrm.policy_all);
 	INIT_LIST_HEAD(&net->xfrm.inexact_bins);
@@ -4154,6 +4158,19 @@ static void xfrm_policy_fini(struct net *net)
 	unsigned int sz;
 	int dir;
 
+	/* Prevent new policy hash rebuilds before draining the work item.
+	 *
+	 * The upstream fix uses disable_work_sync(), which is unavailable
+	 * in v6.6. Protecting work_disabled and schedule_work() with the
+	 * same seqlock closes the check-to-queue race, while the subsequent
+	 * cancel_work_sync() drains work that was queued or running before
+	 * teardown disabled it.
+	 */
+	write_seqlock(&net->xfrm.policy_hthresh.lock);
+	net->xfrm.policy_hthresh.work_disabled = true;
+	write_sequnlock(&net->xfrm.policy_hthresh.lock);
+	cancel_work_sync(&net->xfrm.policy_hthresh.work);
+
 	flush_work(&net->xfrm.policy_hash_work);
 #ifdef CONFIG_XFRM_SUB_POLICY
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_SUB, false);
-- 
2.53.0



