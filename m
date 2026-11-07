Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062191;
	b=u6S80ASREwPWluMWixR+GsY33N2VgzpBg/S3uTmVgKfjSvT7n1tBVAqRD2gYEI4OQaAf
	 HCr0GfwezsZ9Td7yHlcNtDZXu+gV2hxa9tvdC8lCvlNBUz7dipSMZPASG7zGpvYE7Xo+4
	 obRZWdB1ShxIUktsZiDaK6g1D77ZVVoutftKvZ1lMKzpblelr2ZD7zdGuisNnbXMD0JZe
	 dUUq8+SPHtt/6Bc/S+3IFD9+AysN8tTUOtTLJLHv9wsz4tcFhbf20AZABttAWwS61rdck
	 1Vsfcbo1LGJoNgKGIFQh5D6UJMfIeBNUcZl/uz5I5WNriG6VxlclGyODuZ90RWhLGDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uq338aoCdBuG81DXQhDYN1nJyNsrUwCmDwck/EH05Qk=;
	b=KLFWYcDCTZiAPLNYz46gF1+nhAA7janju4KnF6Y4rfgkdYX5HwUX2R8WOFttKhBcHa5U
	 oKn4LzkdOO/kacm21Ef9IEww4i5V81SQ/pTYoSBmrFdsfzsjugYi7WjIHMLLxIHFknOAL
	 kkJpVE67xWEbuEaCfbmrwy5M4gBPbwGJafGD8bakQgrpuawptlT3WkNtlIFE3WjWzSqp3
	 DiCmL0Ili2Z46SsQNT8T2CgipEca44BC2BUUvcDlA4ZfwlY1aOXjy2ZyqfdP9rQWBPpKy
	 xGAh4tWe7o/Lx+DcqgRarqXrNkyqRohYUTYtK/3lX+odUMlDOx37hH2Wq836O2qnsoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLts7o+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE0B606A326;
	Sat,  7 Nov 2026 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLts7o+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4D41F008A6;
	Sat,  7 Nov 2026 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062190;
	bh=uq338aoCdBuG81DXQhDYN1nJyNsrUwCmDwck/EH05Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLts7o+jN7C/RfoLfNkDvSh1eq2rRao26PBZToI6weyOFgd8l6fNuDZc9mdJOc7Z3
	 xDie8MnX0qLvTC7td8IvuvcWq0+CphOm07ER8WQkXV1/vPhKuugDREzBj32GSbkn65
	 SdthO+Ycn+hYgIAUu5Z1YYp+LIs9ktkQOTf/YjZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1147/1536] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegenc_worker()
Date: Sat,  7 Nov 2026 08:52:43 -0500
Message-ID: <20261107135029.938819300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 9d0244b52baed..2bb86ce85109b 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1633,7 +1633,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, true);
 
 	mtk_jpegenc_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
@@ -1644,6 +1644,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	if (ret) {
 		dev_err(jpeg->dev, "%s : %d, jpegenc clk_prepare_enable fail\n",
 			__func__, __LINE__);
+		pm_runtime_put(comp_jpeg[hw_id]->dev);
 		goto enc_end;
 	}
 
-- 
2.53.0



