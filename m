Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704255;
	b=FrnjzAOaxkMsFEGSPDCOUOuVzrxNW+p6//OIFe/1r+2O3/EPAdP0I7NMJRMO0RLx9Hah
	 rnRGwlyOEKIKBp/bjJvwqYyCGtyDQHYsqFIRq5v9kddws/3PKq/LZ47lIgHLY40hHAT3S
	 sLOk/1RDZbHigydHutkD75RkkIuqG+J57gE2/Yo5PzVeZJuPRy5hYiUw5Hid7zAOgiXhu
	 r9z627AJW4edSxlNg/ZZYeOiTmplHODD9RLGaYRVLOXRN54CAhSS8+XKdFDvJ2/i7Erfp
	 23o7ustmcOBAtnvDokKc27sx9XHmmqJpP9s6f5ukGjJuPWdGOz+dEKTA7p42CJEtabg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ylaw+ui0OP+iIFcUITHHRbJkogXDkpYC5Adj5zSg3rQ=;
	b=kFXNUgxBKaKCETHE6xAGG+R4xDzzoYZ82hDBLJIWA3eHn3hwyxZx4YvqOJ9DU/dnY2i+
	 up9SytElQ2fg7FxIyGu+fe9rXhFrA/JOdBYUZf1trrsmbjDiwNEW+88aesaNAyaVijTm4
	 pboEBj5un3ITQjaY2zuD/Cii+0QW2pWN/sclNmrgmZGQp9CvpIywSpV+PY+IxK2V/2EEW
	 StxZJBbfV1Sz6Fk7oFavE9OVB6vvRxomJ+407uX/ADudNSOyNevQ0lvhG4Wz4Vf3/0K/W
	 s/DAQiZyylHqaMHPz19I8+JfmM3m/VYXmu9SXTpxW0mC5r2GDWYtrN/8tRbeXam/L0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQKypfRx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B57A606A31C;
	Thu, 26 Nov 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQKypfRx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB841F000C4;
	Thu, 26 Nov 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704255;
	bh=Ylaw+ui0OP+iIFcUITHHRbJkogXDkpYC5Adj5zSg3rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQKypfRxrb6rnuAxJDlkUsQ+JTpiq8zN4809gKSRVl2HOK7ld9WfjPse1+PMfKFNx
	 yfDzv9mS10Dl4n4LaNFD/2qLYqML8JCIZuPi/KJJCbKaRh0M9TkjNHjXoy+1zb7P5S
	 HuRwcFRYraZhO8bkB79vUR6ooJtmBvEfBg5VkmNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/265] vhost-scsi: reject delayed virtqueue setup
Date: Thu, 26 Nov 2026 15:36:31 +0100
Message-ID: <20261126143609.349791784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit a543346b96a174fcee6812ac2764acc8dc993358 ]

vhost_scsi_set_endpoint() allocates command pools only for I/O
virtqueues that are already set up, but publishes the backend for every
virtqueue. Userspace can complete a skipped queue after attaching the
endpoint, then kick it with scsi_tags uninitialized and trigger the
alloc_hint warning in sbitmap_get().

Delayed virtqueue setup is not supported. Leave skipped I/O virtqueues
inactive and reject changes to the vring size or addresses while an
endpoint is attached. Userspace must clear the endpoint before changing
the vring configuration.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261010-fix-warning-in-sbitmap_get-v3-1-33de562d1359@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 91d07c2224ef4..7a6a4e0f36df3 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1666,6 +1666,9 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
+			if (i >= VHOST_SCSI_VQ_IO && !vs->vqs[i].scsi_cmds)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
@@ -1947,10 +1950,16 @@ vhost_scsi_ioctl(struct file *f,
 	default:
 		mutex_lock(&vs->dev.mutex);
 		r = vhost_dev_ioctl(&vs->dev, ioctl, argp);
-		if (r == -ENOIOCTLCMD)
-			r = vhost_vring_ioctl(&vs->dev, ioctl, argp);
-		else
+		if (r == -ENOIOCTLCMD) {
+			if (vs->vs_tpg &&
+			    (ioctl == VHOST_SET_VRING_NUM ||
+			     ioctl == VHOST_SET_VRING_ADDR))
+				r = -EBUSY;
+			else
+				r = vhost_vring_ioctl(&vs->dev, ioctl, argp);
+		} else {
 			vhost_scsi_flush(vs);
+		}
 		mutex_unlock(&vs->dev.mutex);
 		return r;
 	}
-- 
2.53.0



