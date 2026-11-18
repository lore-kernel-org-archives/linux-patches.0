Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028480;
	b=vRszjOk9qALctJg3y0zFtQxOaI6JbIGhxpcb+tbkngqCbiGmuzakbA+A2NiPVlbYVsuf
	 mAp1Zp6QBhQncTYroB7MGGMvJJTLwDPPcqQuJ//fmBo+CGVUI+CNaq4clB/SA6713XMyw
	 s/ErPSoiJr8+lxksLbTZAyXXOh6TItKrWqS+5v7YTK2EP49ucyDEblGk+3NBhIJBombRH
	 caozTZnp8NWvMdWzxrp8D0q7T9jT73pMRK5j2sI1Q7mDXdUHOLPLvf9cTU4Ud0c6NN/dF
	 lK336wivbj5IZ17b9C/5IN4x7InDxb6I8m3uVRG193O5FCmo59Lunvt18EKxnkvihtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4O4lt0ChGx1z+GBwCokBHKtdxpqKSVFWFhYRs2WzLjY=;
	b=EzuPCnyA64qOD9zh8XJBOavNFdr+Vqwo1u0UFX9msyANcTE3gqDjakUfg7zSembqDl3f
	 rkMJd0no0yFXiRRbelwIyQlAujnGYGxHPg2WB+HNcJjQJ+AVjh9Y3/Jzvssmc1jE+qL+9
	 6e8gDUfv9dCGkTtvgH8xHX0ZOviTA9jvV2lwi11cNDCLElCJKXhtcVID/h9XidIFwwy9U
	 YG9GpIawa5ALlEJNNWjA8RZ7fx4P4LiMqcAgbcjlNkP7ox06ZeYBMlDS0Hh5MzSsYMARa
	 ZJIaJbIb2Z076EoKDp9HcDHMRU0j7BojMHJwTptjlrBnPcKc/guVuDxQa1hfIxl/gZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvlm5RC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96354606A32C;
	Wed, 18 Nov 2026 19:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvlm5RC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56161F000C5;
	Wed, 18 Nov 2026 19:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028480;
	bh=4O4lt0ChGx1z+GBwCokBHKtdxpqKSVFWFhYRs2WzLjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvlm5RC9J4/pHICW1LuPHPmbOG+WkSRQKIl0a/jZncxTtIJHMFRDUloHKAwSAE/Gd
	 ssE+cRCxElSnU+OtPYeVP7716w0xAMaPSQg6G0bUQopaRUtklNgqR4OSDVG9jZGyrY
	 BhmKgjkp5vxUqv8i3iYwqH54HbNllezNlhqZZBW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.18 2131/2151] vdpa_sim: disable page faults around vringh_need_notify_iotlb()
Date: Wed, 18 Nov 2026 16:04:26 +0100
Message-ID: <20261118150239.309339076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 770a40a20be9d..0d5922ba05bcb 100644
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
index b596d4a532d01..2271dd26da127 100644
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



