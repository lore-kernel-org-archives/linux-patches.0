Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC1E29CA;
	Mon, 12 Aug 2024 16:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479627; cv=none; b=TB5cNfIiv+kaFScQOTFYfhaHUqbtSlA4nw1nfpZ/BA7FU0vuS0Wa7OMBOowVw0n1rOkrITLMQFojK3/lfHLJjL6NHtHbDFqzNMmVXoy0OYyUqJ3Hd7bwGnIRTfIEODKlxPt7XQbXEwfE/LzDxmO7lq8/t9twW0qGC2Ax5zxpe3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479627; c=relaxed/simple;
	bh=KlT/s5i/q6M7oWa9lopUxeOe0fTKDTygzdxGpQ6JFd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfKdBg0WujGqii0ZA441rSlkxPKS0CU9G9D5lFQvR/iGZcMPfhZsHYZjtjrDB01+dxgPrvyXc39Bg/zgRbudgywkSs0jEeljWWwWR6yP2EzMDWhRN1I11OlPehzgS/26SnAGIRAVJawb1WoyIISAXA/NPA39jpxunkoYPRRYiAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9ChXCEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9ChXCEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D830C4AF0C;
	Mon, 12 Aug 2024 16:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479627;
	bh=KlT/s5i/q6M7oWa9lopUxeOe0fTKDTygzdxGpQ6JFd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9ChXCEMv9y2dIeIecJIxGrsM+APVmx/I/1PblwZal5VxeogN73ozaa5dfOhkklZK
	 AdmYCX16IDVwmxv1AVxe2xRtU6uBIJRF4/JC/Hg+5Ed0T6zNhvPD1u+VjwWo4QiwKm
	 RojadxFud3DWgVW81m1RpES/CJtQ+f+a0y6zrkAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 145/189] power: supply: qcom_battmgr: return EAGAIN when firmware service is not up
Date: Mon, 12 Aug 2024 18:03:21 +0200
Message-ID: <20240812160137.724250707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


