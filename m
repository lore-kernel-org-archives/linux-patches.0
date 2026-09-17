Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B955E4DEC22;
	Thu, 17 Sep 2026 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671843; cv=none; b=E1XYtvnT34fBCAHWDYLcCmvaJBISb0RTi4M+XZnmsn3HT05mNQwzEGf9KyCGzDIcYxaejAmu9DPJHfaO0D6EDGZzJosQDa5pKvcKWVJock0hYl0uehK2QhcigqcohyByiW6b0WhBpgYlCFAbkEJ0+ZhXoANX8plk5ol/VpBMw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671843; c=relaxed/simple;
	bh=LOPVSwy0+AOJ+MP4hlkyXGraN3AUiCLLGpjYTsFdqcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD6ZQSw4b2nd4yhvaA24k/I8XjakG3STwUodNjZ+F8z3/0x+WwChxslEUbQ8B7z7qkPdFHRBHjWFGDJVAYoDi7jqRqReHDa8opLSVA67YxQZjm3eMxAawBNenuC2XIeKOdnoWrLbkG0o7erU4ESzOpZxmOtDXh29U9BvTtc2Jgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNqFaLbV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNqFaLbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3501F000FF;
	Thu, 17 Sep 2026 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671841;
	bh=eSVgswO3Kw1J5W5wwZgm67E2oLKUjoegkQnuqQkGVco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNqFaLbVCARrnKrHPwp3wooNVOC6gvCI1djC79PiEFSqXMGdMpZaDLIQRGB189g4H
	 K3ap6xoKez2UgmVoZDnL5Bdz2mOEPc5zLCPGj/n9d+LkDncxVwCtTysjmKMT357hTm
	 LUMdG1DpxZRvqRmB6wTn0l9MNAeL7+CZknw2GalY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1090/1102] svcrdma: Release transport resources synchronously
Date: Thu, 17 Sep 2026 16:17:13 +0100
Message-ID: <20260917151608.224053310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


