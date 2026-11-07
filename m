Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063092;
	b=lnkLmQ9g9vh3tgrCbE06Rf8zDprgJRUASh+ytFuyU8UttGIW87YxNx/hMIsFH/cvBfah
	 x6mF8vW8yOSIJnn5zdr/VWUvgAnhj9PAVdtlJzmsUyGXLEmoZNr3t4xDHPhcwNCJJAdDB
	 zEyONbwoR40YanE2kpQy+5bpyrJMWB/b7VKRY+NFZRT8QiMWPxMnSFLsLJc8mcsYV0/fV
	 L2RBct58gI5PoigsVpnhplCa3Ajw2DFfcnsNM7R2eP0wosdj9lAhN0XJhdIB2S3iG5gCU
	 ZxhDOay36k3B3trg5Upl5AorzcEySuuGuBSD0cqvPTvEpTJQVQuYR9Uxzk8CTnLAIJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vsLXNQqsBa+iU4SoVwr09HmlZeBD2TekS3R8TBlN3b8=;
	b=d/TC4RiGGhbIjvERmA1GZRzWqgXbRb8UVL75JPhK66LEr2giX+Ztmfdz96Vu7SZ04ne6
	 1RRO7mQfWAhJfGwtmtwUbHekWEevYL60ynS3kLJv5S47xnQSueNgQRU/wILcE/ETwP1qK
	 up7uIuEG3ZCg86q2JQ2goZyBKbArgJOGDmC1YThVvuvQ1qQMhDiAnY2ezHOcee3hQIgLv
	 M2pD75UPcgDwa7ZB3NV1k+iKLYYuoCtSEPiNig9hDHbvHTeVgUCaFDJJ4EYjhcCIW+6O/
	 26at+DjoF0r2HNuqjVbSuPpcN4bRCI0xw09F01AqHvhvV7L+bX5xknKIk6Azw8AW5lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEgK2uD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1084C606D804;
	Sat,  7 Nov 2026 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEgK2uD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21361F0089F;
	Sat,  7 Nov 2026 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063091;
	bh=vsLXNQqsBa+iU4SoVwr09HmlZeBD2TekS3R8TBlN3b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEgK2uD4EVypTqEKJ+ijqq02Cv9j4jbIgpmYohV0qWGkXr/L15ikS2wLsqtmCIDnb
	 RXbu+sWvLHzKRG8HheGd5i53cdEAYP+Okk5Ec/rOc6OkY38xeHm3eETH30tPMB29Nv
	 VnLsiYuSlDT9g9BONZ74L8p2xiZmSqzn83OSJ1GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 311/869] media: pvrusb2: Fix USB parent device leak in class_dev_create()
Date: Sat,  7 Nov 2026 08:49:53 -0500
Message-ID: <20261107134903.059548094@linuxfoundation.org>
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
index 3077399901aa1..dd6fcc6245afc 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -633,6 +633,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp)
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev->parent);
 		put_device(class_dev);
 		return;
 	}
-- 
2.53.0



