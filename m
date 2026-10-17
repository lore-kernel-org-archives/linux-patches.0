Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A72E352C35;
	Sat, 17 Oct 2026 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255793; cv=none; b=ToE5AUHcaenXbvccvxt5J6ONZqNqVv60gpgt5xL1o+J5oZRr3XdjJKgzPiDFgR+B0srFgNHhf5YYkCRLuCIvRelnMdmRYmS0HIDnGH6keoITzxaLa9v/GHfMIvyIyogA5vW+Bc7s40IK3LMhGuDK7cZ5EGKKngd3zhffthXVaVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255793; c=relaxed/simple;
	bh=xOmoHlAj/NA7wJIkdz3CVJXEhmw2/zyRVRH+VpZwEEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCODCjM8B2QuMY1q+LCSVDOH4HcgEOcAfsvz8c9AKn0Ai/Odh/nZXzSPSXK1Iu9Nv/X/WZ7vUTyLNnaGsJrjLYF1f1y/VIyL5YO1c/kP7Z2mLkKOqU88kKJaC58OYTRIH1Woo17ACz9Bh/SGdAt0bWkg9v1TuLgFQat9ADWi5hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sctv0wYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sctv0wYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07051F000C4;
	Sat, 17 Oct 2026 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255792;
	bh=o66qFpPF4HlGepwxVe82EYm8dZd9q+9dubSnRPK07Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sctv0wYTZ9gEWHWiNj1DRFBsqu6hVR5CW+usVCSBPaPhsNWYTLkeJQKfzRgVFJBX+
	 9ex/3wrYOOnZfgNaHZLWtDQ4F5pCKgPZW0LUsusP4al5TZ0sr0ZuTYF8PFTOgpREQu
	 FaTvAb66oqzraxJ4IEqfcRnOy69xiNCU0kevUdSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tahera Fahimi <taherafahimi@linux.microsoft.com>,
	Allen Pais <apais@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0003/1674] xfrm: prevent policy_hthresh.work from racing with netns teardown
Date: Sat, 17 Oct 2026 17:37:55 +0200
Message-ID: <20261017160431.228750053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tahera Fahimi <taherafahimi@linux.microsoft.com>

An XFRM_MSG_NEWSPDINFO request can queue the per-net work item
policy_hthresh.work onto the system workqueue. xfrm_hash_rebuild()
retrieves the enclosing struct net from the work item, so the callback
can dereference freed memory if it runs after net namespace teardown.

Mainline commit 29fe3a61bcdc ("xfrm: prevent policy_hthresh.work
from racing with netns teardown") fixes this issue using
disable_work_sync(). That API is not available in Linux 6.6, so the
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
index 7922ec72eaa68..eb9edddd73092 100644
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
index 00d9693c13ae7..cc8f4d4b70875 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1384,7 +1384,10 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 
 void xfrm_policy_hash_rebuild(struct net *net)
 {
-	schedule_work(&net->xfrm.policy_hthresh.work);
+	write_seqlock(&net->xfrm.policy_hthresh.lock);
+	if (!net->xfrm.policy_hthresh.work_disabled)
+		schedule_work(&net->xfrm.policy_hthresh.work);
+	write_sequnlock(&net->xfrm.policy_hthresh.lock);
 }
 EXPORT_SYMBOL(xfrm_policy_hash_rebuild);
 
@@ -4181,6 +4184,7 @@ static int __net_init xfrm_policy_init(struct net *net)
 	net->xfrm.policy_hthresh.rbits6 = 128;
 
 	seqlock_init(&net->xfrm.policy_hthresh.lock);
+	net->xfrm.policy_hthresh.work_disabled = false;
 
 	INIT_LIST_HEAD(&net->xfrm.policy_all);
 	INIT_LIST_HEAD(&net->xfrm.inexact_bins);
@@ -4206,6 +4210,19 @@ static void xfrm_policy_fini(struct net *net)
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



