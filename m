Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046148;
	b=mCsCZQQqVnFO0qVp6b7XPf6nvasjUwCRRwsSEd5XccIWTadljEoFsttLxrlsC8muHikk
	 aTnHr/YAilb+lKQTKEaQFYACB7G8mK5+zK2Vm7O8wNFntGPF2gzDbJIg3KhjZ6RbzEJuH
	 WlEcyhidEyKtYoxi8KCw+UpfjDiRCO/WjIj4LZBegpblzO7fNpGy4tCIQfrVcAzyoIwb8
	 4nSIL58vFaNJn6XpgMRFrdSQFrxsOubgJPg+oTnkntelft3NMf24d97wqadNlJ5Q/JG87
	 jGxvqntOzLwT2ByNewSSNQ/ILufWDcmB/3Xn68qbNFo0KDl89WZ3oSjX3VDpVJq/QmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dCNc2TWJGy2djNKNBMAWrQMLZYmJfROR+j4PnufKUi4=;
	b=ak985mE+ycvBFys1zm9QeIacqkmB70PO0Jo44Q9no52XyWk/EEQoJtjWNgyv9hHSiUaB
	 P/BCbaKY0AuvRY/FqWKD9+7viUyLs7gHRn8gmuMvRzsnrg7KZOdKIH5DehYn/oEf4Piaf
	 Ytsta1HFnahsoRApviB7I//Eq2hz7t93HQrd9xBorSGNdOPpdZ/aZCJob9TEXr34MU/PW
	 LkUGonI/qwMtfxPqGxGY5s0P6ymaKGduiXdanPU9NEhQujgPwFsIfDzZBTWcTag/x1GxE
	 mqY37BCQbCLwtUF+BriYy0HRkSrmNN4CrBcE14Srbtrk66AQ4SDZ3AoAscTbaYS0Lmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdv0Nt7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3A9606A320;
	Wed, 18 Nov 2026 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdv0Nt7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0B61F000C5;
	Wed, 18 Nov 2026 23:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046147;
	bh=dCNc2TWJGy2djNKNBMAWrQMLZYmJfROR+j4PnufKUi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdv0Nt7lzM/CtHmqvBi4l+xgy5j1b9P54bbpxbBqchAExrdFkjoxXpMGTuarod23V
	 gNkYE/oKi1aKKviqHbzPH4+Xh9UxZOlQuZS5b0obcFuVFLoLQBm7GFxW+hCDEsdVbN
	 9A1tJwiNHhxYHfV9XEGFI0Ul21q9aDnIK1+iw26I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1178/2857] media: mediatek: jpeg: Avoid context access after job finish
Date: Wed, 18 Nov 2026 15:36:52 +0100
Message-ID: <20261118150244.018683901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f911d3c7dd862..06332f06d74ec 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1088,7 +1088,7 @@ static irqreturn_t mtk_jpeg_enc_done(struct mtk_jpeg_dev *jpeg)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
@@ -1155,7 +1155,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



