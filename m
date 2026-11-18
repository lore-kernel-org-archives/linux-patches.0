Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036275;
	b=R+fcFkhzIZiW+bzE3cyGGHwiTGweB9M9Vo7FPvGcpl4vu54JdmekzK4B5tqSv9LbkRBs
	 whpIuTzyMh3b96po9wKGshpHSKzI7Jt3kTOvCp32KBiIcskD5SGn6jDc1h6XrtHpLz8F8
	 R38ZNo+nkP7V/cSNLd08O0Agl6SYmOm6rcC59FbXL401r79CfE+X79CiZ4O5XqgDKTWX2
	 dLCOCVjMRhjwcXUGYAQ5pLm7RZJ1V0Tbx5ppuqpB8STEFuQr9CAp/5CiC0x/P8XIVDRqn
	 RsZJ0b5+Doeuq9lniUrrQzYqfdw+D9A2eFupLRbKbUimRB/DcGWIkgipbnbgMn4SiLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LtURPgn5lytlD9DGtWG62IBSuPWVIZ60sZYR24s9iBs=;
	b=momjhJG9z+nqxc/V+6Ijak0CojlS0zGJ6w0vG17ynuOxyvyssSPAiKKBZXOZ2RaHyKWR
	 MMRHxbOK38B4RgzqG+y1Rz/wOEbreRWb0WwF9twBPq26STqaC3rXRYfaRIT/RU3aSDSGF
	 tbmx2tk7i9IU6lPUP7Je1QLs5DO/NAFU05/MJ5pmw/t+bju3lzGIzV6laQrCoNt/RPgiU
	 +Y5/P2SmfMhEV+Fs7VW2XG8D+KQ+VDBLmuqV29AAKGUaQg5q1h0PcwA/UkBWzxeBYLnK/
	 Ny0S4bUANxQMHkMYQuV7Yk7+LqHul1a8Xi4+Xjb3fxCUNFt05olxrkuT3BviBAownbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A44ygU1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B834606A339;
	Wed, 18 Nov 2026 21:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A44ygU1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C315B1F000C5;
	Wed, 18 Nov 2026 21:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036275;
	bh=LtURPgn5lytlD9DGtWG62IBSuPWVIZ60sZYR24s9iBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A44ygU1W8+9uW1R+RTr6ufiL6nQS4aOSFC2DdQDtx39O4jKJWhFGXfiNcPtNRltZb
	 edf0gpn8xi9f5jTMxaMcD4XhTb6Z4koyaGtUJeE8ADVHGBBFE/Mg0AWo832ENU6GBO
	 eAukuzpCdRBmyxk2K/NGcSUsbwZmiyF155/QAN9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1000/3318] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegenc_worker()
Date: Wed, 18 Nov 2026 15:27:02 +0100
Message-ID: <20261118150349.858134806@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 7ec8fd17f3a8059dcf94101065a35d0136031794 ]

pm_runtime_get_sync() leaves the device's runtime PM usage count
incremented even when it fails, and a failed clk_prepare_enable()
drops the reference as well.  mtk_jpegenc_worker() jumps to enc_end
in both cases, which does not call pm_runtime_put(), so the
reference taken by the successful resume is leaked.

Use pm_runtime_resume_and_get() for the resume failure and release
the reference explicitly when the clock cannot be enabled, as
mtk_jpegdec_worker() already does.

Fixes: 5fb1c2361e56 ("mtk-jpegenc: add jpeg encode worker interface")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index ddc74a0da6522..5a1ae5cd44b95 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1634,7 +1634,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, true);
 
 	mtk_jpegenc_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
@@ -1645,6 +1645,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	if (ret) {
 		dev_err(jpeg->dev, "%s : %d, jpegenc clk_prepare_enable fail\n",
 			__func__, __LINE__);
+		pm_runtime_put(comp_jpeg[hw_id]->dev);
 		goto enc_end;
 	}
 
-- 
2.53.0



