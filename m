Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFEF253334;
	Tue, 29 Apr 2025 17:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949333; cv=none; b=hP6amRTdfxEdyxSrkeEyOQfXCOdN2sSQkYRISVePN7P6xR4b5WHQWLUE5k/ixNoa7bxTyUSm+m4PTth9lAWWasEnCRERQr4pBK7WkscOW1jpKg2SDXK7qPcAfKWItroHf52YZJiDvv/mF6cUPIU8z3IKVuwcWbFD8whJGQLRKak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949333; c=relaxed/simple;
	bh=n7pB6EHK60zlGNN+U6nehAk1V1mL8PjWaL5rBv/as/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOsBgzi/zCw8bZW5csNejNiA8gXfQpbE92m6HdUQIBzZrk2rdFhXPVEO83nduChH1q+UGmn6DhNj5vNB2eIFue+8856mWgJUWWorn7uMxgmFsj4ZpBp5+ck8TzOn7yG41+KOlnxFHtBg93GtfPfBRHodIx0zDDfckkZmGlqNIEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8IfjrFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8IfjrFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF71C4CEE3;
	Tue, 29 Apr 2025 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949333;
	bh=n7pB6EHK60zlGNN+U6nehAk1V1mL8PjWaL5rBv/as/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8IfjrFawHI0eBY90a8RxyUZxMpkBUyPIF70Onz0qqdcxd9vK44i580+2P8OwbBFf
	 uUA42Yzs13nZVQwWBb/i7Jtjh0gnmXC1igY1ODFUssCEqj0k6kjtcN9yqI/k7sOvo2
	 lVDSI+l1Vo0LDoAhxRnsHhbHLYRQ4Y2pqHD2XhVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/373] media: streamzap: no need for usb pid/vid in device name
Date: Tue, 29 Apr 2025 18:42:13 +0200
Message-ID: <20250429161133.655447044@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 7a25e6849ad73de5aa01d62da43071bc02b8530c ]

The usb pid/vid can be found elsewhere, the idVendor/idProduct usb sysfs
files for example.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f656cfbc7a29 ("media: streamzap: fix race between device disconnection and urb callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 938fbc569f505..9ef6260d2dfd2 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -88,7 +88,6 @@ struct streamzap_ir {
 	ktime_t			signal_start;
 	bool			timeout_enabled;
 
-	char			name[128];
 	char			phys[64];
 };
 
@@ -285,13 +284,10 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 		goto out;
 	}
 
-	snprintf(sz->name, sizeof(sz->name), "Streamzap PC Remote Infrared Receiver (%04x:%04x)",
-		 le16_to_cpu(sz->usbdev->descriptor.idVendor),
-		 le16_to_cpu(sz->usbdev->descriptor.idProduct));
 	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
 	strlcat(sz->phys, "/input0", sizeof(sz->phys));
 
-	rdev->device_name = sz->name;
+	rdev->device_name = "Streamzap PC Remote Infrared Receiver";
 	rdev->input_phys = sz->phys;
 	usb_to_input_id(sz->usbdev, &rdev->input_id);
 	rdev->dev.parent = dev;
-- 
2.39.5



