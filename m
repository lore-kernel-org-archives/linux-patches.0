Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705232;
	b=bu5cPAscBNF1eFYJzfI5On+8CdsXxmb9HglCQAPV6WMWMOmM9b0J0Ob2U1JKI9R/VxlN
	 ok7ke3u7HAWgPx0rVKDn6bEJvOTtpR0byG4mvDxCibqpQpKcX7zJ817lCnHZf4ShCgjEX
	 gv19fKlH6xGQqtPH1AB9OMCP+XWk/AVHRp9krTxPk8qC+5y1y+rnu0t1/ufgybeynX9fL
	 gavBNM9yyZNSC1CXliP+pRR/tipSaVbO9mzdHI630wAA0q1pWuvO8i8MQgUvfQcgRlF6D
	 N76o0EhJFSsyGoe9NQ1915hA4IknyRKCiqf5tSElAtvzh9rbCHvUaMzuJvwOOJtaN4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uyMulLh7NiW48soi4r400sf7QwtkAjiU3VS/TDtma44=;
	b=zTOY/bGkujQwNcOJQKhWfDwzBijr+uDKuSarMsx/6T4ZnEqf+uoPei1yf8HYLRD6ZhoL
	 BDP0jfjBt3b5jFGnNibOxxDT4RPdnUHMThUrrqfdoFuOG3JU60g6i19m+vG7WeaXJ1ER6
	 UljiR5O8k+efBAbl53m8BRNVDyYcbGI50hsubl4jQZze8WQtIMsrxpFOQXGJp5KUI3REC
	 pf1GbwNy01McLXvCVKILJwTbXosxA0/HHQ+cETBeZ4xIRV+PHcB3VRbDK+FLKAvF66YdY
	 NnWrtBFv0IbIyqbLQ78SUedi1BL1vfnYOQKLlRQ9XA2zHnP+kJMRdSbPRnbROUIduqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EaYeKyZZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE60606A326;
	Thu, 26 Nov 2026 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EaYeKyZZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B581F000CA;
	Thu, 26 Nov 2026 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705232;
	bh=uyMulLh7NiW48soi4r400sf7QwtkAjiU3VS/TDtma44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaYeKyZZ6dw0dwTlGPf+JVoabctR9JROQJfn9cDKuzdOCpMYxdAFe6ev20XrGE6Pf
	 /WNtBeZM539tlvOXB6vVwy4DfNmypXrEi3y2NxudKoyX4FDta/YoZVNdlImc8Eniiw
	 oAZlTk3npYele6vsnmtTvLgHHLDjFbMuIv1Ec8a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/319] vhost-scsi: reject delayed virtqueue setup
Date: Thu, 26 Nov 2026 15:37:22 +0100
Message-ID: <20261126144008.410759074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f0e259399db9f..fc60b10542689 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1631,6 +1631,9 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
+			if (i >= VHOST_SCSI_VQ_IO && !vs->vqs[i].scsi_cmds)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
@@ -1910,10 +1913,16 @@ vhost_scsi_ioctl(struct file *f,
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



