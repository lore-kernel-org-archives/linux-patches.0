Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033315;
	b=LS8xYjVUVlppUbbB4bViXqck8hEQ1UAJxqaro8qYk37D1t0/i3j+RRtLHcMMiuxFwIK9
	 n5ATRdujYtCo2sdgg7Dio4XMURmgZLFe2NfLWGUcsCVmxVNF8/uM6HDufa78u+1qkRlIL
	 6qwE/2Rh/kV0QS6HOL1ywkvlHVKBWwvoxIS7DnKiDeVcu9JnwwzxkWFU0VS0wfA2+BnqC
	 y4mhaDPo+mBJGFo9UIYpyy709zROELsW7SVkTgZKyBYpnWP61Xvo1cF/XbAVvT/RdGurY
	 rFzT/3kTaV9oCPBdSSCTlmqxyygbHBPL/SMoFVoaTOM8V5jdIE0rOTa+i1ICbrY1aaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BuCP6V6ObGYq/P6JT5evuETJSDX3cWvDyHzUnoTxw00=;
	b=05jUtEoambIBQ2dc5sNmQv89xnOj/ygHmOBL5XVSlT1VjuX5ce3DlVCrYzZ+tQWJijKJ
	 zErUu98W11cKil3BGbhkqcEFMaugzXHvZgZmafcTqseZ2hRpHV40aU7JuzukJD7G3ou0l
	 2Z16zYPxTIfYWQcZMcsRpBDq/5mTKVNV/cQRIJNHi4GWseLMGyAL4lMMdX81gy3mf4i3s
	 5Jg9vr2mVj7CIeiYHR2Hry+d5e9y0A49L3tFodfpiiRg40WzFLvrh1eQco6kWfddGBXLq
	 t5uD05jJncLzbVnveJR4JXf2IlQDuuv/Zr+68jbAMIxmiVSvkogrMWgmnHbb9Y5pB+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btcD7wlX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D5C606A320;
	Wed, 18 Nov 2026 20:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btcD7wlX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767331F000C5;
	Wed, 18 Nov 2026 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033315;
	bh=BuCP6V6ObGYq/P6JT5evuETJSDX3cWvDyHzUnoTxw00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btcD7wlX1d1XOd4RiIPtzYOA1fy2dvvF2qA5PqxBhLDZqfmRvN8b3oUp2g9gbYL71
	 FATeettJ+J6cHfeoB4BXpYrq0YCgjnncty6GNGynGdnMpIytLsCsPkQFaxcTBerurz
	 JE3skZc7jZPWTwAke6rQSU7whUXtQKvTP8MjAzvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.12 1724/1756] vdpa_sim: disable page faults around vringh_need_notify_iotlb()
Date: Wed, 18 Nov 2026 16:04:11 +0100
Message-ID: <20261118150118.219608752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



