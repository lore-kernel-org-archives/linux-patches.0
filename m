Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045221;
	b=slRZbXxxuLgMneZTiAeJ/Tu9pptULle0Xz3jPDOUlS3yaIwiG0vt1+d05LGy3b5E1gZv
	 wu2E3UsSILY+AbInJ90SKrw+XZbuymnedN4AQqBwAXb36hL7XTdljs5NqylrFjfo17Ymp
	 fFOdQTBzm+1YfsqT/Risl1I38PYPKOnVOaesc8ZdIbySeUYfujcCD3l0D5CBEF1gT8DxV
	 1/cBP0o/MpIFuXTjo87f7JP9kVrNhppu55ilnAgOBDZt0WhKLuIkzF9/6BjcKx9bfIc3e
	 6vSGFGfqPBCTFDHSmvhop3DYus7KlgceBRlojwS1Dx3DLZ4PExGNz495HXdWMMULvNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+trRirLLYc4cuCNeDYSGqasz5y1SlvIZ+2K2cMXHIZM=;
	b=bamNrJBHt+s3YsH7dR5vfuOtEHC90Ke6Qa/Dug1tyu/VeBxoy7ODGeJrvmLNS+y6onsD
	 V8dMZRyOBoBJvr12RPynOSh+T+33H5N60jlzqBwUakRC+d2/kd7QXTXz3M8d59PMTpxas
	 k8daD/wObjSRR2H1vH9rfe5oHbNCumvJNlqg2bMo58TKOxwyW5gPOUI4m+KpJc4F84SSt
	 ICxA/6cdaab1oMgN9ZyX0ommZTppZvLHGYej7/fnzRsISYIEpCnO54lEbkrrSODDUvFZJ
	 K/WqRSEkL15MUeeMG8BAjQXWJWXxkhklmgbIBuO9mgcwGWajJN/1CNMa9tQW9mUK9mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cufbf5Vk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF2606A31C;
	Wed, 18 Nov 2026 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cufbf5Vk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCF41F000C4;
	Wed, 18 Nov 2026 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045221;
	bh=+trRirLLYc4cuCNeDYSGqasz5y1SlvIZ+2K2cMXHIZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cufbf5Vkq/6muW71N7okfks9dEOkJHc8BLzbjety0oJOT+CqmD4P7JIcadt5h5qQ7
	 gP39bX7oCFIgzkVIFwu0uAoU9/HS0sXvCmSPqaPz6lFUOX0Faqo2CqrV+nMoqGFpcK
	 EROhtpCSs9fujjBGsFk2SKsX8xaQVRW4WmuDKX4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0847/2857] media: pvrusb2: Fix USB parent device leak in class_dev_create()
Date: Wed, 18 Nov 2026 15:31:21 +0100
Message-ID: <20261118150232.070413735@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 02421d7278e4a62c3daf37ad6c45d4af96ee4252 ]

class_dev_create() stores a reference to the USB device obtained with
get_device() in class_dev->parent, which class_dev_destroy() releases.
When device_register() fails the function only drops class_dev, so the
reference to the USB parent device is never released.

Drop the parent reference on the failure path as well.

Fixes: 28c4a5e6d324 ("V4L/DVB: pvrusb2: Fix USB parent device reference count")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 3e42e209be374..e638c49b77b2a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -641,6 +641,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev->parent);
 		put_device(class_dev);
 		return;
 	}
-- 
2.53.0



