Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624409;
	b=AY8R2hqL2vTd/VqAxMTl/CNlk5Z+hs0kkrMeTo0MDB3UDkXUl599uNa1u0uXUspRkcdL
	 N2tWtes9pcS0LWIF4CrsnEH+08CQ+IEGAF9yafclolc/LF8OQemJgWtsGMttMT11oY7fd
	 KO/Dsym6MEnSwvewTWU+s304boLYi74dV9ImmWyIfEDs2yqF/Nr9uo+idH3aGHGk3MAtR
	 vYPdA3XjW3J7eIMalGyjmFHrzVe6MxQIX0PuJP5dp8ZT5y1kepUVjiL4HSmMx/zHH7N7T
	 IODwFNBeJolN7eIhW7EMN60V8ykh4jHSr5XaUMJhpxmxajHTYj055C8YpSVIj34D+Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5AobXXsNAuHPAopbR+viaCBKii40axR2AYHOSaXudMQ=;
	b=PXeLzn8oYV7CTH878KBGVfkSwlu2+/+c8A1ThRD5dafEkoCfG2lrZw0kBE7HILJG+MfM
	 99gyNKSh2UMY54Xx/bIjSv8PZ73X8DDaUQph9NBc7aMiwVRd2zR2/KinMmUNM4RSpSKzA
	 PmsfnQvSJjf3pQ6rXcAINvfaBLl2Fg7b9KSi1GRvyZksTJrNAVlO9+k1lpSe3Wix1ooi5
	 4NDKdS/DHQRPjTxXsnbM0cgAOn5f1Q2aVtOda8iVOVG9Lu55MXLF6gto2MDbAeWAwhHzH
	 UsUJiP3Fx2jZKh9CZnCBFXEbN219DR59ViXqCBeqRyW6/Fw/TH+dyPv2VXut7egksFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrlGxKk8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B5F606A332;
	Wed, 25 Nov 2026 16:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrlGxKk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6141F000CA;
	Wed, 25 Nov 2026 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624409;
	bh=5AobXXsNAuHPAopbR+viaCBKii40axR2AYHOSaXudMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrlGxKk8EhK9Qzsc42za2SeIpt2cY5/5jn2GWvuLKaTKKuy+hrfLt/5p2zD49ZIWQ
	 SIlquCy5P9g+S7ys0Micw4Zi7zSn8AvnHAHCU/BNlckaqvsK54/DVIMoLutqS/H0gi
	 YHTtEIEQ/nzImCpt8jrG18P3jyH+18iYM9gh1vDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/816] vhost-scsi: reject delayed virtqueue setup
Date: Wed, 25 Nov 2026 15:28:44 +0100
Message-ID: <20261125143853.265882416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index c0129feba00fe..f072e0f7265cc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1845,6 +1845,9 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 
 		for (i = 0; i < vs->dev.nvqs; i++) {
 			vq = &vs->vqs[i].vq;
+			if (i >= VHOST_SCSI_VQ_IO && !vs->vqs[i].scsi_cmds)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
@@ -2176,10 +2179,16 @@ vhost_scsi_ioctl(struct file *f,
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



