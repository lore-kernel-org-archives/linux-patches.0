Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554741494B8;
	Mon, 12 Aug 2024 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480630; cv=none; b=FpOc32E/XzvMKvzH8vzjy09k2khRycQarN18iKJP4LrhYgqbTJmUs3RXCAmLdZJeX+4Mo5BjYuNBhTMD8YaA55klr1ljf7ysLjsI2WFnc0kKQpPU0BYORDaLBIJNMKUZg+rKbij1cePZsWwyHVt8KJE/F4FxcQPhUWdrhFveCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480630; c=relaxed/simple;
	bh=5BBTj+0Y622aLd7m8V59zRSSRfuEdKFlQeciW4xYLhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUKH6vpD8qJEZHabX58s0v10vg4GDOpeFa5xK6gqIPzrJc3aAiOT5F8tvucQrNSwkXKaHTBbUfkWIma86uxrlvtBHjL/fv3byHjXY2yVrz4eF+YR21ncIATb8gmx1dTHFSqs4rFryFtKxAMl8zFpGi5cVKmF7HPIAqoR6O356dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egT5oMEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egT5oMEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E869C32782;
	Mon, 12 Aug 2024 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480629;
	bh=5BBTj+0Y622aLd7m8V59zRSSRfuEdKFlQeciW4xYLhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egT5oMEajvPLLCDFf/Dj3Cs0IUcv2q85tSnJKS/usJleA5xQ9inC9FoQW0vKLY2uZ
	 BIGTHcKyv9CKbeY03g0U5fSd9vvW3JAGn8Mtr0uQdaVV2Hsdn1s77X30IrsPdvhyKL
	 PXN6IcE3DouteJsPadjQgi4bu3vwThKKrDuTRu/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.10 223/263] power: supply: qcom_battmgr: return EAGAIN when firmware service is not up
Date: Mon, 12 Aug 2024 18:03:44 +0200
Message-ID: <20240812160155.074995657@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

commit bf9d5cb588755ee41ac12a8976dccf44ae18281b upstream.

The driver returns -ENODEV when the firmware battmrg service hasn't
started yet, while per-se -ENODEV is fine, we usually use -EAGAIN to
tell the user to retry again later. And the power supply core uses
-EGAIN when the device isn't initialized, let's use the same return.

This notably causes an infinite spam of:
thermal thermal_zoneXX: failed to read out thermal zone (-19)
because the thermal core doesn't understand -ENODEV, but only
considers -EAGAIN as a non-fatal error.

While it didn't appear until now, commit [1] fixes thermal core
and no more ignores thermal zones returning an error at first
temperature update.

[1] 5725f40698b9 ("thermal: core: Call monitor_thermal_zone() if zone temperature is invalid")

Link: https://lore.kernel.org/all/2ed4c630-204a-4f80-a37f-f2ca838eb455@linaro.org/
Cc: stable@vger.kernel.org
Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20240715-topic-sm8x50-upstream-fix-battmgr-temp-tz-warn-v1-1-16e842ccead7@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/qcom_battmgr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -486,7 +486,7 @@ static int qcom_battmgr_bat_get_property
 	int ret;
 
 	if (!battmgr->service_up)
-		return -ENODEV;
+		return -EAGAIN;
 
 	if (battmgr->variant == QCOM_BATTMGR_SC8280XP)
 		ret = qcom_battmgr_bat_sc8280xp_update(battmgr, psp);
@@ -683,7 +683,7 @@ static int qcom_battmgr_ac_get_property(
 	int ret;
 
 	if (!battmgr->service_up)
-		return -ENODEV;
+		return -EAGAIN;
 
 	ret = qcom_battmgr_bat_sc8280xp_update(battmgr, psp);
 	if (ret)
@@ -748,7 +748,7 @@ static int qcom_battmgr_usb_get_property
 	int ret;
 
 	if (!battmgr->service_up)
-		return -ENODEV;
+		return -EAGAIN;
 
 	if (battmgr->variant == QCOM_BATTMGR_SC8280XP)
 		ret = qcom_battmgr_bat_sc8280xp_update(battmgr, psp);
@@ -867,7 +867,7 @@ static int qcom_battmgr_wls_get_property
 	int ret;
 
 	if (!battmgr->service_up)
-		return -ENODEV;
+		return -EAGAIN;
 
 	if (battmgr->variant == QCOM_BATTMGR_SC8280XP)
 		ret = qcom_battmgr_bat_sc8280xp_update(battmgr, psp);


