Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590135;
	b=pOJKS2wJK60zfUQ9am5L5n7dwhQbsZ2FViSr/MHulJaOPVvuDtcj//FnvNIqKSH/xVxY
	 8IOuf3ZVuv+4IAZVGMfB9w/mGvQlbl5ZZtsGKWqZ7Zzwe4vjnBP0rcd6ytxvZtoLRAswd
	 7a8SaCYJNF9gWVrRaeS30r+LXFClOTMXC8H88HK6++RInmGz1AHt1n2ck4INNHNuWrOY6
	 QfLAhftuor62mB9EDfkGPd654KMOgVUzLO91JgJXU5A18QUD5tdKH7Lrr3c/trL9QZBCc
	 RzUiydRDSmNRu6WC4OtVHJJSMqowfjLydfD+usYWpauxsYOA3hP6SNAjII0enbN6T0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBINVSFMs6wDbrnlqR6r8ms4l3mnSi9xaPfWStXQbgk=;
	b=s5T9EjGOG3HpyajHVEyTnVQx9ys/W4ucOrB8MlUqrLOKICeQomN6fwHbR3t7h8H96IMk
	 lm88bYsC5H4yuUHWymjhde2J8/LvmEtmIwQWzS+inYuZdqWn0+WMNjRwFa4LvIZeOAEPI
	 QdPXKofWwv1vegB2SZ2bUsURNmEy8ALZUcd88JVxnzUXikeQwoQhwNhegZ/fqoDJv5PKl
	 kbkS0CIZSGJCY70Zgf4y3doHRmxObVQj39UQx1C00IlpnxCOmidgeHp3oCgnowa4KffJl
	 mBF1WlGl+gizu3eypLli+69NGjxluEH1n8RokVpOMP9QK4/cMXbEruRHLueDpXeJ3Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMnlRl7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB0E606E200;
	Fri, 13 Nov 2026 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMnlRl7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B3B1F000C7;
	Fri, 13 Nov 2026 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590135;
	bh=HBINVSFMs6wDbrnlqR6r8ms4l3mnSi9xaPfWStXQbgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMnlRl7r2G+Yf6vYPXbqYmUEY/7j1CNgIQAwaEkO9l7S3q0pAS6zfrT8kUBgZqAlv
	 2Ez2xzRch7zhQh1lelFCJJvXzr2vzoR52bd2ct+CSgnABHml7PWxiP+ui6aHY5aVvQ
	 mt72pF3wEwi8OWp+w51ygsIeai8HkFMV0jr/ebZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/686] media: mediatek: jpeg: Avoid context access after job finish
Date: Fri, 13 Nov 2026 10:44:47 -0500
Message-ID: <20261113153826.012498184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Kazuki Hanai <hnkz.64@gmail.com>

[ Upstream commit 7c7f31405b76acd95a628c834ee8a2d6da439782 ]

v4l2_m2m_job_finish() publishes job completion and wakes waiters
before it returns. A concurrent file release can therefore finish
v4l2_m2m_ctx_release() and free the context while the single-core IRQ
handler continues with its tail.

Both handlers only need the device for the matching runtime PM put.
Use the IRQ-owned jpeg pointer instead of dereferencing ctx after
completion has been published. This preserves the get/put pairing and
removes the post-completion context access.

Fixes: 45f13a57d813 ("media: platform: Add jpeg enc feature")
Fixes: 5827e4b14ee7 ("media: platform: Improve power on and power off flow")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 8e52b40e2423b..f4eebd7575493 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1581,7 +1581,7 @@ static irqreturn_t mtk_jpeg_enc_done(struct mtk_jpeg_dev *jpeg)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
@@ -1869,7 +1869,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



