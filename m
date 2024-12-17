Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342941F6661;
	Tue, 17 Dec 2024 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456280; cv=none; b=iSLfZyhmKgrV0s23En5O16xohYnB1mDm+0C1f4Rn1maAsSzdXfw+eGSh+Q3KqkFvbg+Lwt5Kw/KkzVl5yNzLmWuIfJdQOxgXAPWuCevpteE55IxSY+07mK25ZH5iILmUWjrTkY8Tc+x5nzoK2URxMUQ4pJnC7EgqDXnQn8nWgi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456280; c=relaxed/simple;
	bh=s+6cprey8fkprWzCr+rGjhYrteS//Oy/M/Twz68Fz7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeRZJiPcB9BrZn9dBWyx/EfdPUnMzAFf/HFGJdM8mFaB2TucDCP/WwLtrXtUogPcbA5AHxkC/blodSNVWWhv3bCMvpe1vZQYdFXZ/RO/rJK2O+HqCdtEe4A4bg2VWTxXxI/AB+KiqgvhzsQ5PzxpaoMpUadEh+XYgx+aTBtCKhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKeAYVEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKeAYVEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91977C4CEDD;
	Tue, 17 Dec 2024 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456280;
	bh=s+6cprey8fkprWzCr+rGjhYrteS//Oy/M/Twz68Fz7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKeAYVEd5XmF3VhfLg+yOHnxThZ2tDSby3L5wRrN+AS2uSuKhM9BNLhme5CiuaDaR
	 ZQuknfsDUVZthxoR6vJ8dHZamch2gT9uhvVQbMm6vsSGrV9ue/wj2vVNPG62l//MfX
	 bCFoLvksEC8wCgTwA3dbSRfUFHPhl/hKK1xHT/zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 6.12 001/172] usb: misc: onboard_usb_dev: skip suspend/resume sequence for USB5744 SMBus support
Date: Tue, 17 Dec 2024 18:05:57 +0100
Message-ID: <20241217170546.274593605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit ce15d6b3d5c3c6f78290066be0f0a4fd89cdeb5b upstream.

USB5744 SMBus initialization is done once in probe() and doing it in resume
is not supported so avoid going into suspend and reset the HUB.

There is a sysfs property 'always_powered_in_suspend' to implement this
feature but since default state should be set to a working configuration
so override this property value.

It fixes the suspend/resume testcase on Kria KR260 Robotics Starter Kit.

Fixes: 6782311d04df ("usb: misc: onboard_usb_dev: add Microchip usb5744 SMBus programming support")
Cc: stable@vger.kernel.org
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1733165302-1694891-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/onboard_usb_dev.c b/drivers/usb/misc/onboard_usb_dev.c
index 36b11127280f..75ac3c6aa92d 100644
--- a/drivers/usb/misc/onboard_usb_dev.c
+++ b/drivers/usb/misc/onboard_usb_dev.c
@@ -407,8 +407,10 @@ static int onboard_dev_probe(struct platform_device *pdev)
 		}
 
 		if (of_device_is_compatible(pdev->dev.of_node, "usb424,2744") ||
-		    of_device_is_compatible(pdev->dev.of_node, "usb424,5744"))
+		    of_device_is_compatible(pdev->dev.of_node, "usb424,5744")) {
 			err = onboard_dev_5744_i2c_init(client);
+			onboard_dev->always_powered_in_suspend = true;
+		}
 
 		put_device(&client->dev);
 		if (err < 0)
-- 
2.47.1



