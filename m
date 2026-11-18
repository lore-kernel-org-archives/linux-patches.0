Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022380;
	b=KX/5qlrZD21r5veWRNmp8nQKP6nEBwmsauAkULcRSEjOEpHSIySouSjJo+X3617DqynQ
	 W8/tyIZY8WulJmnpcAie6RJU1sMNDQV6qARxDvrOTO1dxwMGj+bTXi95BJilBCCi+RUCK
	 2g02K4ovY4AuTtdM3bm6Odb1wXI+l9Ow94tOfJ2cPjiSHzunK191b35nMQLGG/eQumU/j
	 UfaUH56AI7lrlvv713ArR1Z3oSz/kR7QiNYJLh1My6JgbDf4cW8GNXBu8iqf+ug7Bfb2b
	 PlNbMsNAh1XAMfc257QLV374iHxixzHw9gFHsAStg+37w/GNWaUg3cwMa5O9zQ/mzig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rh/OnJ/4fu6O5KMn7GwxlXQ+Aq9JBiJ7H0q2XZvfF+8=;
	b=KQIsw+G9NhoDXIvFyWElSzIQCRs/6UCei08I0zTyzKpcpzup9lG3EWAXI43gCMQeMcwz
	 /0i24yi9eYFBpZvz07Yj43sWIS4D2txUmVjt2o0LixfJ+3Bd68qomPYtktuUL0PhiX54O
	 Pe72lesRUIAStMhrzuNhlOpu4HSjN+icnYox+jB7XSzsCtlOdFG+SCXgQuKt6b6bJ202i
	 PjnO6HsjKf6B0vHZC98ilIRvCofSouCdFs2PFcnJo+sYqAxnDBQl56O+JAGII1xtwZV3x
	 e8B4p20Vomx5xJxvcU/rDqsnTRkY8+vuHFLzY8yj0OMsJ58cGXg0fQl8eZI9tGyo2cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=St4LA72a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B686606A31C;
	Wed, 18 Nov 2026 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=St4LA72a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBAD1F000C4;
	Wed, 18 Nov 2026 17:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022380;
	bh=Rh/OnJ/4fu6O5KMn7GwxlXQ+Aq9JBiJ7H0q2XZvfF+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=St4LA72aA4CEsXbYLGzWvEmNNttZm4NxChNxw2GI9jrp9yG+AsfyKdjND2/1KOrBW
	 GHFW7ZHZAOF+LsdsRwUN9O7Wtu5EQokdKNLQ0VAdIl77McvdJlwgz0UH2gIF604uOC
	 KV2r1EPujngQgiUOrRjJ+fcUWmIoCGDJ85lCDEeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.3 2641/2651] vdpa_sim: disable page faults around vringh_need_notify_iotlb()
Date: Wed, 18 Nov 2026 16:04:41 +0100
Message-ID: <20261118150419.186360771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 05fb07c40e0013ba5ae373c6ea1bcc622eaea7f0 ]

When vdpa_sim runs with use_va (the default), its rings live in user
memory, and vringh reads the ring's flags and event index with
__get_user() through the user address.  The net and block simulators
call vringh_need_notify_iotlb() with bottom halves disabled, so those
reads happen in atomic context.

That only works today because __get_user() has no might_fault() check: a
fault is not handled in atomic context and simply comes back as -EFAULT.
Make that explicit with pagefault_disable() around the call, so vringh
can use the normal user accessors without complaint.  Only the
notification check needs this: the rest of the ring processing runs in
the same kthread without bottom halves disabled, and can fault normally.

Tested-and-acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 9 ++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 76dd5b0828d7a..4d3e36fb59d50 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/uaccess.h>
 #include <linux/blkdev.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -343,11 +344,17 @@ static void vdpasim_blk_work(struct vdpasim *vdpasim)
 			continue;
 
 		while (vdpasim_blk_handle_req(vdpasim, vq)) {
+			bool notify;
+
 			/* Make sure used is visible before rasing the interrupt. */
 			smp_wmb();
 
 			local_bh_disable();
-			if (vringh_need_notify_iotlb(&vq->vring) > 0)
+			/* The ring may be in user memory, and we can't take faults here */
+			pagefault_disable();
+			notify = vringh_need_notify_iotlb(&vq->vring) > 0;
+			pagefault_enable();
+			if (notify)
 				vringh_notify(&vq->vring);
 			local_bh_enable();
 
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index a6514b5ccd865..543a58abcdb8c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/uaccess.h>
 #include <linux/etherdevice.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -68,6 +69,8 @@ static struct vdpasim_net *sim_to_net(struct vdpasim *vdpasim)
 
 static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
 {
+	bool notify;
+
 	/* Make sure data is wrote before advancing index */
 	smp_wmb();
 
@@ -77,7 +80,11 @@ static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
 	smp_wmb();
 
 	local_bh_disable();
-	if (vringh_need_notify_iotlb(&vq->vring) > 0)
+	/* The ring may be in user memory, and we can't take faults here */
+	pagefault_disable();
+	notify = vringh_need_notify_iotlb(&vq->vring) > 0;
+	pagefault_enable();
+	if (notify)
 		vringh_notify(&vq->vring);
 	local_bh_enable();
 }
-- 
2.53.0



