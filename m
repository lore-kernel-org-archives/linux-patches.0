Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063120;
	b=x6qYGL5Lj24J/YGkMGCX6P6bqbwQl0YRB4A+fcYpwgHx6YMztZQJNikuqNlqLtjCOUkR
	 1KXvM75/Yh70m6z7gWCEx5vaSoqScNEZVXRmp11fk49CiQYKFHcGJ230ypnt7zfqZuqSi
	 FFyBb3eQwV/oqMGqRwJ8n8BF+pFMk/GW8lTD4vGnyDjwiaY1kIC5CVCkS4Ca5Z0onrtCb
	 a7kppw52IFrjKBQAtfEstaffTf28jeiqChl+7LIkPaZNGSak/hMXRqKA39hlU82aSAPyX
	 j0pZKIfnjtnoAMkFZKQz26cU/OVoLUc7C1uY6Qyw9vDwHU2Ql0f62CnMNau7hp1yBwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+q5hpXvUMf7l1tUT9mdqJbzhyTXjYtbLja8yL7awkeU=;
	b=0PVBoSRHbY9ynB+HDZxkKqfXLm8LkX6t2le6JE93zuQAEEGnI6vkBCh/0TARsUHyBSGr
	 SP3fdLXHYypkL43fhwiNIq1304MvNTYc3xnhAihpNvUd/+q5+dUIxcKgvhp0Evo9hpFUI
	 8ZE9UY8T5bIY3LuLHmXEJZRci9rzj4Ah07PxGmReb4MNAmuXzIwqpvk8+f9qrbWtpm0FV
	 4FmofOdM7ME33WVhxfNP1O/t1KQFQxeOD+609aIPHW+af6+88SfeuOUWZqf8pa0p8Vjiu
	 FQo5xgueEme+SE01TGCkWDxYu6d7P37yDqO4+eaVnHRza/0/pKkqG5jTHR7YjB9mdKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ADZq+wQZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E805606A33B;
	Sat,  7 Nov 2026 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ADZq+wQZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE811F0089F;
	Sat,  7 Nov 2026 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063120;
	bh=+q5hpXvUMf7l1tUT9mdqJbzhyTXjYtbLja8yL7awkeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADZq+wQZPsUzksJXlTyYVFhN+wf7HZfklAa/03Mr4jb2wKMWtoGzHe/6S3TMfpBnJ
	 ICpSrw77MLyT2ot9prnOtBDTgx9yNGrNsPlhCWblF+4uhReUk71ruU9CsxGM446M3/
	 CeRbi/u/L3XtRXd1g2YkGFEPCvARXWtDQA/0iWw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 349/869] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegdec_worker()
Date: Sat,  7 Nov 2026 08:50:31 -0500
Message-ID: <20261107134904.218964629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit befd4506174addc5e85641b4ef304c9247b48c55 ]

pm_runtime_get_sync() leaves the device's runtime PM usage count
incremented even when it fails.  mtk_jpegdec_worker() jumps to
dec_end on that failure, which does not call pm_runtime_put(), so
the reference taken by the failed resume is leaked.

Use pm_runtime_resume_and_get() instead, which drops the reference
again when resuming the device fails.

Fixes: dedc21500334 ("media: mtk-jpegdec: add jpeg decode worker interface")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 5a9ba04d3d480..fa47d2fb94aa0 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1740,7 +1740,7 @@ static void mtk_jpegdec_worker(struct work_struct *work)
 	jpeg_dst_buf->frame_num = ctx->total_frame_num;
 
 	mtk_jpegdec_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
-- 
2.53.0



