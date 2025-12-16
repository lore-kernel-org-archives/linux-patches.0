Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC682341065;
	Tue, 16 Dec 2025 11:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886317; cv=none; b=LxfBAeJ3JR1EAEyGNDYo+Lgs0r1g0/C0msRZGHSy35GVXxVOdCmMsr7/v1LmsheEuX0YHcbtDQHAljIWDpoUvQu4VH5C9bgCCbyqAGxeI8tsRjJE99CKA+B3G4KA9MFqCHv/Q6zqBo5Ze6Dp1/3rKbgeU1d49qqbLgdNood03+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886317; c=relaxed/simple;
	bh=d6fXh+5DfEBM0Wcu8FY4iC4xRAaGEX1TZupRPE5O4Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxMAHEzB1dS1nSJhBh+NS53fO5CujkS+E0VtnuWvj7/kGD6XiYzF/jW0qTC6BnBFVJyL8aTMOxP2iBpJKpoSq968KjvZ/BzZg+62zZYwu80MH0zG95tnZpjwuQ9ZnkdWT0MHlDSqeP452vzR+IZI7c6HP1xzhbxe6gP7ngGQ80I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muDCRbzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muDCRbzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC10C4CEF1;
	Tue, 16 Dec 2025 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886316;
	bh=d6fXh+5DfEBM0Wcu8FY4iC4xRAaGEX1TZupRPE5O4Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muDCRbzlBACMDh7Kpef9kZLD0Y6vofXGliVRNri/yHTQ4sZYCUR7ICg2UUopj+DNN
	 F1a4MSA5oW8RX2uZAjuIc4LvMPmqBwcOufvAzL8PwPCS1KdQnOKY5mcYN5oKNIAbQq
	 PvvQ+zZnASTqpnLZHKlI3wOxKqzXTlLBcwQ1+fiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 402/507] net: netpoll: initialize work queue before error checks
Date: Tue, 16 Dec 2025 12:14:03 +0100
Message-ID: <20251216111400.017630632@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit e5235eb6cfe02a51256013a78f7b28779a7740d5 ]

Prevent a kernel warning when netconsole setup fails on devices with
IFF_DISABLE_NETPOLL flag. The warning (at kernel/workqueue.c:4242 in
__flush_work) occurs because the cleanup path tries to cancel an
uninitialized work queue.

When __netpoll_setup() encounters a device with IFF_DISABLE_NETPOLL,
it fails early and calls skb_pool_flush() for cleanup. This function
calls cancel_work_sync(&np->refill_wq), but refill_wq hasn't been
initialized yet, triggering the warning.

Move INIT_WORK() to the beginning of __netpoll_setup(), ensuring the
work queue is properly initialized before any potential failure points.
This allows the cleanup path to safely cancel the work queue regardless
of where the setup fails.

Fixes: 248f6571fd4c5 ("netpoll: Optimize skb refilling on critical path")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20251127-netpoll_fix_init_work-v1-1-65c07806d736@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index be5658ff74ee2..27f573d2c5e36 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -554,6 +554,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 	int err;
 
 	skb_queue_head_init(&np->skb_pool);
+	INIT_WORK(&np->refill_wq, refill_skbs_work_handler);
 
 	if (ndev->priv_flags & IFF_DISABLE_NETPOLL) {
 		np_err(np, "%s doesn't support polling, aborting\n",
@@ -592,7 +593,6 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 
 	/* fill up the skb queue */
 	refill_skbs(np);
-	INIT_WORK(&np->refill_wq, refill_skbs_work_handler);
 
 	/* last thing to do is link it to the net device structure */
 	rcu_assign_pointer(ndev->npinfo, npinfo);
-- 
2.51.0



