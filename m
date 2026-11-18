Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037521;
	b=sym8fEFzgEnhFkG1KjqhLh8+LCrMdPMFyAEsc/2p+50f1qeE0gL8JkizRr61/BusOp1D
	 KvARbzUZtnMJ7DMLtWKvVG3n1P6KNFVQs9eAqYnz43MBpggzXOKKg/x0/sHd02H1pdMHP
	 6PTNS3jO62DXh+2JPkSyKKG2+M9Eol1WV2Ak2deUFIyx+BBz3OHKB0dFHXkIAgYK0at9O
	 x5sDmOOwIClHBDfKoM9XwuG9lAszB0twRHx92v+v9b+42Ll7UDoLIMbso1hiaKUkZEr+q
	 zLA0qncKSAXAoz/8ssrwqx0VjsYHKJDIpbDsKm8UwWGb+J+P9+4CLaDB0Ctw0mCxOcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aM4aA8nQS57397R6tUIrl285cSurfwZIi/Pn8m0OPOQ=;
	b=sgOSPvZ2lGua8XJZWQqMIciuvVLJvgMIu6O+4/knH7/+g42czDD9HIZnL1WIF5B0Pi5E
	 DUHV31uNCY/meUGV0VHhkouJc7mY8allNVC2990AebvOJp6swPZiUmsHf78IWuaCfgTIf
	 RVj+c7eIeXLEeu89klOyEcJxwCYBYSvT7sXBO0hyuiEXMFZW8p+1ddMJneaCwNR7Y9WOK
	 B90/zPbQsrs3LfMb/oTHRy7KsleFJYTW0nkoorDi34EaqZLcPUlnZOsVvgpHVMQQOk3Sk
	 Ho3Kx7otQz27XMNS003Z4KgVyBHoRbYTUvyEulTpORc1K9iPS+DGZkp6gj2ABAorUpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N50RMfYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5B6606A325;
	Wed, 18 Nov 2026 21:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N50RMfYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9181F000C4;
	Wed, 18 Nov 2026 21:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037521;
	bh=aM4aA8nQS57397R6tUIrl285cSurfwZIi/Pn8m0OPOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N50RMfYDMt9awcuSPws/Cp2ZXS/T4FIOboFp5iBEEbU8GJJVl/GrA7NdkX2LpmU/d
	 HqCjKTCGqBTjyw9o/SlWJU9rmJtkThAWhs3DLSOsGXbl5WvbBPNrezbT1OVU/9g83d
	 7pXXF/Ybcy9ruC2buEzes8R/MbCEbxsW6aHx8VB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1385/3318] media: mediatek: jpeg: Avoid context access after job finish
Date: Wed, 18 Nov 2026 15:33:27 +0100
Message-ID: <20261118150402.106978812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48ed4e3ae633c..8dc02630cf6ca 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1585,7 +1585,7 @@ static irqreturn_t mtk_jpeg_enc_done(struct mtk_jpeg_dev *jpeg)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
@@ -1872,7 +1872,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



