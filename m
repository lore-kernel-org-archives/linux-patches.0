Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC18857F752;
	Wed,  9 Sep 2026 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964636; cv=none; b=MXVli6MwaC6It48ioBhTVYJxfNDjAQJw/A3fzjx5jLeiqOtp8rOvZzc8vmOoyuckcTbIZ7HP/9t6DdYhbH15t4vHMw+C45K9i04TTnU/PiTIfTacJ2jizr089Gsmhb/kzBON6FGY+1nNHuFq3EnxXFdewCeAah4XH1++xroS1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964636; c=relaxed/simple;
	bh=gzjqNY1fx/cIpkOMU9lVVgtrmkUwiIKWUmNl5VsVYEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nY2Mh4AhR7x8H0YpE2JUAp6WeHeeq4vuFqxszM9cottKx1Kc9hnKALD8Z4sHCthSjcvGS5QusYxr9yvslc1MgyVx7zQvRtlzokTWjojgPojDK2hKqvGf2t8ENQ5NLBsrRkQecIPVBBYZIej61HjjpBBq+tcjG6/6KxIqqPu5Hew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTKKZT9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTKKZT9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300351F00A3D;
	Wed,  9 Sep 2026 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964634;
	bh=M5AAuTHUuNzfiG3WzTqjNxLPD1A16L327zQdcDaVDwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTKKZT9ZCwSvgSaxtCq77n20UoXERPLqtCTsfcR6x+u8vz/XlAXkPMAlpRjQBxggZ
	 pZrrvN3fyW3s7yPu8cIAcEopnK8jYqKpLIRV5rIVL7PHbO+yRp9xzoZ1MLE+mo41oH
	 GmFJQZfAvqB6zPcr1XINwL8PikOAR1vujP7VVhFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 492/583] svcrdma: Release transport resources synchronously
Date: Wed,  9 Sep 2026 15:42:57 +0200
Message-ID: <20260909134254.843879983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bf94dea7fd4e6708d1a784be23db65eff84d82f1 ]

NFSD has always supported added network listeners. The new netlink
protocol now enables the removal of listeners.

Olga noticed that if an RDMA listener is removed and immediately
re-added, the deferred __svc_rdma_free() function might not have
run yet, so some or all of the old listener's RDMA resources
linger, which prevents a new listener on the same address from
being created.

Also, svc_xprt_free() does a module_put() just after calling
->xpo_free(). That means if there is deferred work going on, the
module could be unloaded before that work is even started,
resulting in a UAF.

Neil asks:
> What particular part of __svc_rdma_free() needs to run in order for a
> subsequent registration to succeed?
> Can that bit be run directory from svc_rdma_free() rather than be
> delayed?
> (I know almost nothing about rdma so forgive me if the answers to these
> questions seems obvious)

The reasons I can recall are:

 - Some of the transport tear-down work can sleep
 - Releasing a cm_id is tricky and can deadlock

We might be able to mitigate the second issue with judicious
application of transport reference counting.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Closes: https://lore.kernel.org/linux-nfs/20250821204328.89218-1-okorniev@redhat.com/
Suggested-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 4488e9129737 ("svcrdma: Reorder rpcrdma_rn_unregister before rdma_destroy_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -613,12 +613,18 @@ static void svc_rdma_detach(struct svc_x
 	rdma_disconnect(rdma->sc_cm_id);
 }
 
-static void __svc_rdma_free(struct work_struct *work)
+/**
+ * svc_rdma_free - Release class-specific transport resources
+ * @xprt: Generic svc transport object
+ */
+static void svc_rdma_free(struct svc_xprt *xprt)
 {
 	struct svcxprt_rdma *rdma =
-		container_of(work, struct svcxprt_rdma, sc_work);
+		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 	struct ib_device *device = rdma->sc_cm_id->device;
 
+	might_sleep();
+
 	/* This blocks until the Completion Queues are empty */
 	if (rdma->sc_qp && !IS_ERR(rdma->sc_qp))
 		ib_drain_qp(rdma->sc_qp);
@@ -651,15 +657,6 @@ static void __svc_rdma_free(struct work_
 	kfree(rdma);
 }
 
-static void svc_rdma_free(struct svc_xprt *xprt)
-{
-	struct svcxprt_rdma *rdma =
-		container_of(xprt, struct svcxprt_rdma, sc_xprt);
-
-	INIT_WORK(&rdma->sc_work, __svc_rdma_free);
-	schedule_work(&rdma->sc_work);
-}
-
 static int svc_rdma_has_wspace(struct svc_xprt *xprt)
 {
 	struct svcxprt_rdma *rdma =


