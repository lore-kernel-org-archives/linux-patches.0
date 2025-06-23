Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2B2C9D;
	Mon, 23 Jun 2025 21:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713643; cv=none; b=lQTSP1yuvof0KLjZ3YmLIZT1O1HAaKCpiI2Z4bt2gMy4IiZiSUmCbGKpxTQIni9/GNRTggpcEQtVCIw/wT43Es6Tq5kmHXMYGPx3x7ERRGuzPWohromhzL8gm22uiyqdSDEQJkuB5DRY4khfIuj/8Qtn4v3wFMqaPopk7+WdQzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713643; c=relaxed/simple;
	bh=e5DjP0BFvxnZWVGKYZAOoweyqRhk+4fSKJOutSrDvtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbPxvBg0hBypwoATMrPkZM8z8Yperg382qPQ5eTqEnpNIs35qm/8k7sGZ+qznPbeXBASculx9NWxzKpY+i79o8NGjInKtJR1oQe2EJ8Lo7fA1I6JsegObiynUmcjUwysxHtqFoM+MOHBrqNYOPtmWJfagYbnOJl4GB+YwH8UrU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2S/ZFO29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S/ZFO29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10362C4CEEA;
	Mon, 23 Jun 2025 21:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713643;
	bh=e5DjP0BFvxnZWVGKYZAOoweyqRhk+4fSKJOutSrDvtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2S/ZFO292LkF29wAwOfJK2kn4r+6mTHs/jEwfPI8/aYeVy1Q2X6vDw0xDGDfqDJ0j
	 55XfoONT+Yj6YHuBBBuILlM8871ggbUP0KCjELUmKx2FfZQwWcywBQRJ81xqvuz0Dy
	 V52EvE8eldYEs6GyqvhzPmiwu+gIo3IaqIA3tUVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 055/414] media: imagination: fix a potential memory leak in e5010_probe()
Date: Mon, 23 Jun 2025 15:03:12 +0200
Message-ID: <20250623130643.437833838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 609ba05b9484856b08869f827a6edee51d51b5f3 upstream.

Add video_device_release() to release the memory allocated by
video_device_alloc() if something goes wrong.

Fixes: a1e294045885 ("media: imagination: Add E5010 JPEG Encoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/imagination/e5010-jpeg-enc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/imagination/e5010-jpeg-enc.c b/drivers/media/platform/imagination/e5010-jpeg-enc.c
index c194f830577f..ae868d9f73e1 100644
--- a/drivers/media/platform/imagination/e5010-jpeg-enc.c
+++ b/drivers/media/platform/imagination/e5010-jpeg-enc.c
@@ -1057,8 +1057,11 @@ static int e5010_probe(struct platform_device *pdev)
 	e5010->vdev->lock = &e5010->mutex;
 
 	ret = v4l2_device_register(dev, &e5010->v4l2_dev);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to register v4l2 device\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to register v4l2 device\n");
+		goto fail_after_video_device_alloc;
+	}
+
 
 	e5010->m2m_dev = v4l2_m2m_init(&e5010_m2m_ops);
 	if (IS_ERR(e5010->m2m_dev)) {
@@ -1118,6 +1121,8 @@ static int e5010_probe(struct platform_device *pdev)
 	v4l2_m2m_release(e5010->m2m_dev);
 fail_after_v4l2_register:
 	v4l2_device_unregister(&e5010->v4l2_dev);
+fail_after_video_device_alloc:
+	video_device_release(e5010->vdev);
 	return ret;
 }
 
-- 
2.50.0



