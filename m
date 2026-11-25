Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621380;
	b=1BTFHjgT6NyOCtGhbNRrxS4zs0O7mxqjUMae9PVDa4039IkyRk239e7O1MbFt7+tRQYD
	 TGOL2Fr5rz6eZ/ny6mIIRX8TbXXgdouYoStuRVdG7GW6OhmcPlZD2RIsGJ1h/wQwOsp1K
	 XMcvlunSjZeFoa+o0ntJDFdcVtatznQtKXPwBEACW0E8wTkceM8Bi/88AhYzCZ6yD/ZVf
	 PCfxDcWMHCL/EHywJiah9Q4088eZNC1pafipt/POogKKU/YHewNadXY4b0/NJo7iS38ip
	 wFg5RBJ02FhRKmCDp4WoQKXx10RpFfNXa+cmSXxQAW/fVP20kxje7iRMeO3y+mh5dYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3RQTcLIAlXOexf0eY+ClqUrbMqj6mh7DHf5pzsMjqCc=;
	b=3NLP+8U+KvTtQw0Xd+IppK9beLY7AQymgNPUyDdcB0PJNgS3gP4TOgfzFZPPMP9XKL7l
	 3aJ/IkJYp/nmCKJUBS3O3uyLyzXytD20RgbZ2sGHIoZJFZ7aVojBLQXhMO8gsCFyvmywE
	 nYzlFh7FhbSCpBZZKgsm6CJTToktioXMfCkOCXg5K4yk+vrPvpcMI+sPvxeKhw4kmpwmH
	 JGAl2OjAvhuSHgTXlyMlG2CkWCYUNMi1J4v+bcojjpINlzdRigMZMg2OUveS1q0B6wwFP
	 U54isbR8PnkdLkrAe3agzIj6nNaUf1Mkp2bw4COOhwOAUEFyZou4/0RjVlUVfdjchTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMKNIEJC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FB7606BF77;
	Wed, 25 Nov 2026 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMKNIEJC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBA51F00A3E;
	Wed, 25 Nov 2026 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621379;
	bh=3RQTcLIAlXOexf0eY+ClqUrbMqj6mh7DHf5pzsMjqCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMKNIEJCKrNImjilMZtVvssVw9j7c3KW+ep/gdRu1t2MlTYUq+hsOzalWY025OXkj
	 cLrGwLtaTaydn5QPA/HL3JDl1yMPeYZcnQMCm1i4t2PRjpznZU6FNVDgwYz3KmR+hK
	 XxBxImnSGllmyBpiozWsjNtdVGcHoulg4yUKnUGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 205/990] vhost-scsi: reject delayed virtqueue setup
Date: Wed, 25 Nov 2026 15:26:12 +0100
Message-ID: <20261125143826.894862840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index ba5e454ef2667..cec46ed853572 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2109,6 +2109,9 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 
 		for (i = 0; i < vs->dev.nvqs; i++) {
 			vq = &vs->vqs[i].vq;
+			if (i >= VHOST_SCSI_VQ_IO && !vs->vqs[i].scsi_cmds)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
@@ -2478,10 +2481,16 @@ vhost_scsi_ioctl(struct file *f,
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



