Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6163F13B7A3;
	Wed, 28 Jan 2026 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614256; cv=none; b=OIKXnPiqqLF5zTy8c527WDr+K5DKdbDxVJFmTcZ/lPb8LvhQ81WlhNdaBrAZLdqEiqfyEKQxeqCiTKry7UfAN/vtnAzchlRCzffT/8Xw57NQ16Jyx/qlfk1XrmqgqBhPLVBTTQiRr4rk1wv4o1MQgsN5T7QsTmZlD2FT4aUCW/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614256; c=relaxed/simple;
	bh=L4YNzQKWIsPyjbmwqN6RJ6kpKOYdwk97TIHFLLs7kTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxtZYFmj1vqOvjko8jqZADfc5hUit16U0y/5RmZ/4M1dOqQyzM0INQFxghjoMgE8gka3o0UtssvLilMNAzHP44uEZqNElhij+M6d4EcA3lBu7wr81713llRlwnmfnEr2kSYA+t+XxPL14a/oYPOb8y/OOLquZbpUmXIurqkWsZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJit6et6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJit6et6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB7DC4CEF1;
	Wed, 28 Jan 2026 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614256;
	bh=L4YNzQKWIsPyjbmwqN6RJ6kpKOYdwk97TIHFLLs7kTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJit6et6UNW1l/3ZR88jn6KmMKGIi+0Gq6gSCGv0O8jJZS7AIjrdLQsU2fa15JvEO
	 ZUYxeSQ1KdrVn5/fsdT3hGaiSRQb9NeCxlkE8WYF5hI8dC4donsQRcS1Fbfo5hZYwN
	 bc1JwryzQboR3cAo4e8qL3qm8GZkewuAZO/yjoy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 082/254] dmaengine: idxd: fix device leaks on compat bind and unbind
Date: Wed, 28 Jan 2026 16:20:58 +0100
Message-ID: <20260128145347.646244928@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 799900f01792cf8b525a44764f065f83fcafd468 upstream.

Make sure to drop the reference taken when looking up the idxd device as
part of the compat bind and unbind sysfs interface.

Fixes: 6e7f3ee97bbe ("dmaengine: idxd: move dsa_drv support to compatible mode")
Cc: stable@vger.kernel.org	# 5.15
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-7-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/compat.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/dma/idxd/compat.c
+++ b/drivers/dma/idxd/compat.c
@@ -21,11 +21,16 @@ static ssize_t unbind_store(struct devic
 	int rc = -ENODEV;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (dev && dev->driver) {
+	if (!dev)
+		return -ENODEV;
+
+	if (dev->driver) {
 		device_driver_detach(dev);
 		rc = count;
 	}
 
+	put_device(dev);
+
 	return rc;
 }
 static DRIVER_ATTR_IGNORE_LOCKDEP(unbind, 0200, NULL, unbind_store);
@@ -39,9 +44,12 @@ static ssize_t bind_store(struct device_
 	struct idxd_dev *idxd_dev;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (!dev || dev->driver || drv != &dsa_drv.drv)
+	if (!dev)
 		return -ENODEV;
 
+	if (dev->driver || drv != &dsa_drv.drv)
+		goto err_put_dev;
+
 	idxd_dev = confdev_to_idxd_dev(dev);
 	if (is_idxd_dev(idxd_dev)) {
 		alt_drv = driver_find("idxd", bus);
@@ -54,13 +62,20 @@ static ssize_t bind_store(struct device_
 			alt_drv = driver_find("user", bus);
 	}
 	if (!alt_drv)
-		return -ENODEV;
+		goto err_put_dev;
 
 	rc = device_driver_attach(alt_drv, dev);
 	if (rc < 0)
-		return rc;
+		goto err_put_dev;
+
+	put_device(dev);
 
 	return count;
+
+err_put_dev:
+	put_device(dev);
+
+	return rc;
 }
 static DRIVER_ATTR_IGNORE_LOCKDEP(bind, 0200, NULL, bind_store);
 


