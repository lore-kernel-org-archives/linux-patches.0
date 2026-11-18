Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014368;
	b=Kgm44NwEvOE0EP7TlBp6QdAjn1i898n2Y6L4jB2/kMVoBobgHCXXSha/wHi+iFgOUlg1
	 oEOqDOjqqhH8EL0l44lN/inRW5asshAtaZ3y7NHLGngn2ifLpgezdLsUvh8h86rqokkps
	 zSQC90pcaLcr1tm/fdqnOA+45pJ7W3CsVfqSnf+0yyoyGGbIrF+LJp22S9DAJL9lbaQxE
	 B8iOpfaYk77oRWdOIJvTipiahDRDCDfd16drNAewcKiVkzj3Y+4PjayA3eJBDlpPmn0IY
	 ii75HYtFK3Xr2HtdiOymORTsE1ITnA77EflrTuKSflT/HX6fu3gBkeXOPJdtYMRSR3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ny2tIhslY9UknOoWFFp4Z/ibcFp8PRejUugPwRMttuU=;
	b=hCqTL0g5iapAr7wRmLZ10IAYfBCgh734yI3BkrCGUx5sSyzMDLAK4RydEjA4DlZrryCx
	 lGFP9lahhqnQWEZfEGz/kZbCxX6u2FkUPIfbZr7nsf5YHuQilqMHaSIS504b/VRc7blOt
	 075oBA3+NCK6V38J2TlV8LnvL0JomwRlS1PMrGcalouo/NNPR4N0bH+aVwJvQxukuZS3k
	 RKDze86AsPEsnCUyvwUeH451zKL7Y+0pY6gk86P3L8Jd2EL/D/Q3hkdpnpY/Rc9Dimr6e
	 Q7wNCfn73Bl112SLB135IQN83AGSJzUc3c/VaVvEZiw+5U1FlF6ARDx4a3AfeBZUIJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CCrSViX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4B3606A320;
	Wed, 18 Nov 2026 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CCrSViX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF371F000C4;
	Wed, 18 Nov 2026 15:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014367;
	bh=ny2tIhslY9UknOoWFFp4Z/ibcFp8PRejUugPwRMttuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2CCrSViXth03UJy8GEi5WV7bCkGqMLizCHg0zqIN1HTTCNm/qYQg6F9SPwWSFPO+D
	 KUWKgC1SQI35JJ2IeAEy1/Oz7x3BZpH3nto84BuFTwmIJnrTTcFckWcRfNfhTE+c/l
	 I5I8t8n3P1Xy3fSvR6+Cd9qxX7DdpNHp6o29zS20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>
Subject: [PATCH 5.10 0001/1848] xen-netback: Fix XenBus connection failure cleanup
Date: Wed, 18 Nov 2026 15:33:59 +0100
Message-ID: <20261118145911.280788727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Tu Dinh <ngoc-tu.dinh@vates.tech>

commit dc6d814562b65813556933dbda1015cef61dabf8 upstream.

xenvif_get_stats and xenvif_get_ethtool_stats capture vif->num_queues
under rcu_read_lock. We need to unpublish vif->num_queues before
synchronize_net to ensure that readers that come afterwards will not
read a non-zero vif->num_queues and attempt to access invalid queues.

This is the same cleanup algorithm as used in backend_disconnect and
added in commit b17075d5c198 ("xen-netback: fix race condition on XenBus
disconnect").

This is XSA-531

Fixes: 5fb756f1bbec ("xen-netback: Fix UAF when reading statistics data")
Signed-off-by: Tu Dinh <ngoc-tu.dinh@vates.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/xenbus.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -731,6 +731,7 @@ static void connect(struct backend_info
 	unsigned int queue_index;
 	unsigned int requested_num_queues;
 	struct xenvif_queue *queue;
+	unsigned int num_queues;
 
 	/* Check whether the frontend requested multiple queues
 	 * and read the number requested.
@@ -837,14 +838,15 @@ static void connect(struct backend_info
 	return;
 
 err:
-	if (be->vif->num_queues > 0)
+	num_queues = be->vif->num_queues;
+	if (num_queues > 0)
 		xenvif_disconnect_data(be->vif); /* Clean up existing queues */
+	be->vif->num_queues = 0;
 	synchronize_net();
-	for (queue_index = 0; queue_index < be->vif->num_queues; ++queue_index)
+	for (queue_index = 0; queue_index < num_queues; ++queue_index)
 		xenvif_deinit_queue(&be->vif->queues[queue_index]);
 	vfree(be->vif->queues);
 	be->vif->queues = NULL;
-	be->vif->num_queues = 0;
 	xenvif_disconnect_ctrl(be->vif);
 	return;
 }


