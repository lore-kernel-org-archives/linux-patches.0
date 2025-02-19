Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8871C68A6;
	Wed, 19 Feb 2025 08:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953831; cv=none; b=bcYTRVM6ZXINYVk8NMSJh7xMoh60lliHCFPkyeToH9dq7j7ZlRiuDALrYNbMI+FprMsvfeAF1VluztwVqzniyjOjTw6HPBQvNFUHG0G5Tm21Q0swEVOQWjVsbwm1A/cEJCB0G6y3ML/tHPK4ofJkoh5CZQRYoe/Gjupovf8Qndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953831; c=relaxed/simple;
	bh=6X49ZFJ/HwEpZd+wchp+M41lnRtGnFtz63vnUnwSj8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToZyBls6flgJjNkBYyEvL7j1mKde5Z8Xkjje9IU185npwbsEGSCrgtaoo6orIMQYGzPaS6CSXYFb2/SJNwbeepWaJ3d0u95QHy+XGpswAzx73B7p+SZmN2B3f6oh44u9NaFposPPY9qDW87fT7tX0YrrVCKztUfNNp1rhR84IhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZ72Yqa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZ72Yqa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA06C4CED1;
	Wed, 19 Feb 2025 08:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953831;
	bh=6X49ZFJ/HwEpZd+wchp+M41lnRtGnFtz63vnUnwSj8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZ72Yqa2Rrv2PqZUAXUX258QXm02X94MGDn6nY/njG2G5/o7QnTmZtRb9u3bLT4ur
	 AmP9tjtyG6BkN5hfMDmb3Dn4UYIDuxHBx5N3waSfN0RAfvl7KcpbxkwJRtDNbt1RfB
	 1Ch6mfigOATuCmztjX1hSNoqM2iYuglpbSrgX5l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 012/274] HID: winwing: Add NULL check in winwing_init_led()
Date: Wed, 19 Feb 2025 09:24:26 +0100
Message-ID: <20250219082610.018628377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 45ab5166a82d038c898985b0ad43ead69c1f9573 ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in winwing_init_led() is not checked.
Add NULL check in winwing_init_led(), to handle kernel NULL
pointer dereference error.

Fixes: 266c990debad ("HID: Add WinWing Orion2 throttle support")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-winwing.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-winwing.c b/drivers/hid/hid-winwing.c
index 831b760c66ea7..d4afbbd278079 100644
--- a/drivers/hid/hid-winwing.c
+++ b/drivers/hid/hid-winwing.c
@@ -106,6 +106,8 @@ static int winwing_init_led(struct hid_device *hdev,
 						"%s::%s",
 						dev_name(&input->dev),
 						info->led_name);
+		if (!led->cdev.name)
+			return -ENOMEM;
 
 		ret = devm_led_classdev_register(&hdev->dev, &led->cdev);
 		if (ret)
-- 
2.39.5



