Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFE138BF6A;
	Thu, 30 Jul 2026 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427708; cv=none; b=Wr9DxicF17/hI8zCVbccTP9G/w+LAGiNjFBO/PPNh4TMApKh9FWjb6S/6o7V9HivFC88zeC5ydqI8JQt5sSIPkso2KhVRTmhov+g+3HmXn/DA6wP5wnU3phYy89XQMXVAtFlxa69pvIrGc3Eso4RboA89Te0c+ZCXRu8jetuIP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427708; c=relaxed/simple;
	bh=OMs4SVQbUQPQzfboCj+HO5N6X/Yat0na60Bzpm40Qa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmNxO41MZIxJaJUjqHaZpFPF9qvyjF+be1KapjaoZVDo53yjFQ45RgZXDHwZNztceZW3It8X3wZRIwkVToxgQS5i/8pe/bAFoPdqWYp8nt/jxMzFGlmlbZbrMXFz90hvQvKGqD4m2+94Pyme49VkFAtkyKaXl8SidQtxM33ax7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMHvRC9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMHvRC9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B087D1F000E9;
	Thu, 30 Jul 2026 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427707;
	bh=hd3zmYnnr/eJA47A8yU3XyYHFsfZm3MxLIeCNQCT4iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMHvRC9b4RLy2YxJk3PthQib/9RAEhdR6RqsTcbRvukdOijLywPrV43ggZk0+3hb7
	 JLyus79lWstpDoGT6EXU++YGH8Ls+OtIk7ZZFyqMb8s76b1BlbhBiPb2hmOi3q6opk
	 Chx73m0Jf3w+z58imWdHLDx+TitT9wqXo7uuSm3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 264/484] media: vidtv: fix reference leak on failed device registration
Date: Thu, 30 Jul 2026 16:12:41 +0200
Message-ID: <20260730141429.227664820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 9aa21e1549db8882ff77b691e7714153df21dff0 upstream.

When platform_device_register() fails in vidtv_bridge_init(), the
embedded struct device in vidtv_bridge_dev has already been initialized
by device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vidtv_bridge_init()
    -> platform_device_register(&vidtv_bridge_dev)
       -> device_initialize(&vidtv_bridge_dev.dev)
       -> setup_pdev_dma_masks(&vidtv_bridge_dev)
       -> platform_device_add(&vidtv_bridge_dev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -594,8 +594,10 @@ static int __init vidtv_bridge_init(void
 	int ret;
 
 	ret = platform_device_register(&vidtv_bridge_dev);
-	if (ret)
+	if (ret) {
+		platform_device_put(&vidtv_bridge_dev);
 		return ret;
+	}
 
 	ret = platform_driver_register(&vidtv_bridge_driver);
 	if (ret)


