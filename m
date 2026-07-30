Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452FF2D7DDB;
	Thu, 30 Jul 2026 15:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424576; cv=none; b=KdoyNOFhxq1MEZ+nb484N/efP8Rx6r4vxxPjxsovqQVOAAHICLMD41ymFSl1Ph5v9Eqj9qmKjigHfwFC9QGdFwLQ4bbPQJhZ3wk+vYONwV2lgsSb8Qr+WnQedmmGRIBpe7+qd8JJqeOsBI78csXTmlyc/3robjIIKD56eW+YsVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424576; c=relaxed/simple;
	bh=cDfZygkRusj9hlujP1DP3rk7r2P5692XrvhkLVB7FlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvqEcFSe6kouBIm998u9g7IHgki+ezF5l5bRSC2pJQxif1vjKSCT+XL9bfikJ/QyuZVBLSFLUdU03pYXmeyrReAcKyqgtvcb8j9eG0WOg9nxlgO9dJgULCSVqDPtlv1Xx9X4ithff1UnRBKSXrUv7vKYP6KVmkukwYrwIaV+9VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/1ZAVyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/1ZAVyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A030D1F000E9;
	Thu, 30 Jul 2026 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424575;
	bh=uXGWwh2AkoaDj1m+vEbylVz36brXMZkTx7MvrzVEIa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/1ZAVyR4w/E+yVtHejpn+4yJ5z7vjVcxKQsvllVn3wIuiAxnmgXjXST3e76Wasdz
	 qQKEDTdSR1G1GEKr4v0X+sO08+Q45RFh9tNFxlXhj3amhxUQB5OrDvXBM9PGxZZzEG
	 xTps25DgOsyWC4FOcmgLuLlvKC0UBCDwh1ZP+eEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 441/675] media: vidtv: fix reference leak on failed device registration
Date: Thu, 30 Jul 2026 16:12:51 +0200
Message-ID: <20260730141454.513222712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


