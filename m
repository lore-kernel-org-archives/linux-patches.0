Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B6C37B012;
	Thu, 30 Jul 2026 15:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426202; cv=none; b=I3+Ji74rZFOCgj+EmW9nFb9yjYjrgHqnihTHuuqMQL8WgxkD0d49htFPLS3CaYaE1L2i34yjebmLPSWIOFZ6KIiFroIFhLPzK2g6135hnR/nS6I9LtjqoZrkYw8cXTpGIfD0eXJLfuRDGZOGHSJpnZWmF0TWTtFrNoPQ6yH0nss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426202; c=relaxed/simple;
	bh=OpMGE5I6U7/lp+YSTGTZKQbc1zQnnXOYxF+8pA/12dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7iA79Fz9u8l0NziVaBYBreV9xsa2s9zhE7Fn17Xpsr4zOdVyubqFs98vyfijdIaaI2LWPuS03cChMt9qsRv1dC7SAQMWjthm/fnOad4JXbgvQ25V0uWaLhFU39ia2pLv6AMQ9yISVkoMLO89olX8FI12CVbKxejpgVFcEEVY3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocuHp91/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocuHp91/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A250C1F000E9;
	Thu, 30 Jul 2026 15:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426201;
	bh=gIcVqgAoEkExyDPC1gfl4p+tR2p1OFvqdcEDj/Qy90M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocuHp91/516yN5XWC6ZjzcBtly4A70wCCbL5cqF0OrvnySmhzeXcpQOw65ToG8qJ0
	 K0yBba7jTmq8YnbdNfgUAo8izUFpd3SaeKXZH1/C3A+XIFas0DVJmlNKYIXl6JYXaW
	 NgmZCk2Sv4oBuj7L3fXdMjfZGG9fY2Lm6OdBYwew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 337/602] media: vidtv: fix reference leak on failed device registration
Date: Thu, 30 Jul 2026 16:12:09 +0200
Message-ID: <20260730141443.043212819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


