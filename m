Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5055A313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301009; cv=none; b=DtUX/W7OxSKe31CmTCLlZBB/Qc8rDTjjRzVUcfuIp1erQ6sGSy90UwuRSQUClUea5FTTB+eQZ96zweG7gurZ7cUMIulSgoX5plP2yC09wR+kJgnwUiuJQqhVEmPYXbOoTj8B7M7RWZhBUkkXpC2r3fdTe00NAGGbDhMOBa/bDZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301009; c=relaxed/simple;
	bh=SV+RUt3egBAGzwVZAjSIayxnq11Eu6kohGuhg3MCPiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iipiiMedBN+cPFVX0i0zyimyPk5ymGraQEPXrUrL7vOUhw/UpC6nNd+wwhOHMmciJw0vHnm7XoKFalrsi55PHRLYE7t7DmMh9EkTAsYU+HX/KYy5JiGWT4ga417u7ZBcTLM+BcC5ce79OPYOhlIlQH2sbpyPa6kwebwSIm5LrVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qtg5WWGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qtg5WWGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A3EC19423;
	Sat, 28 Feb 2026 17:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301009;
	bh=SV+RUt3egBAGzwVZAjSIayxnq11Eu6kohGuhg3MCPiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtg5WWGGtT8iRd6HjKpWoXBpca4cKUh3GJlvtkBdmnzMCmUBW04XjMZIlLx9u2OTL
	 wn43sZmeT4kJieZSJ9OEoMVI1LsnF49qrPHpfDew0BaPr5wYOWIylOSlLmGTkVHSC+
	 /8ylkZwMzZWQ8XPREawbENQ7nRYiBANXTsWFHP7nauWIK/LC0Zem1wjvHIgBeMStE/
	 31BrNk84xcWalngHtyTkPcaVLY1ifekR4CwxGy0psKDWbNrHRSVDTG7WERu7IgXuLT
	 NVTAtzjowTA2eAHFAWzHCOo0jaXhvvcKWax+xhVXT39xELJxhfi4C1sIP3ipR/oyJM
	 AXeP9q1Bp/Xsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/752] HID: pidff: Do not set out of range trigger button
Date: Sat, 28 Feb 2026 12:37:34 -0500
Message-ID: <20260228174750.1542406-143-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit e01a029654f7fb67d7151365410aa22be4e63dbe ]

Some games (mainly observed with Kylotonn's WRC Serises) set trigger
button to a random value, or always the same one, out of range.
I observed 307 and other values but, for example, my Moza R9 only
exposes 128 buttons AND it's trigger button field is 8-bit. This causes
errors to appear in dmesg.

Only set the trigger button and trigger interval in the trigger button
is in range of the field.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 95377c5f63356..a4e700b40ba9b 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -523,9 +523,19 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 	pidff_set_duration(&pidff->set_effect[PID_DURATION],
 			   effect->replay.length);
 
-	pidff->set_effect[PID_TRIGGER_BUTTON].value[0] = effect->trigger.button;
-	pidff_set_time(&pidff->set_effect[PID_TRIGGER_REPEAT_INT],
-		       effect->trigger.interval);
+	/* Some games set this to random values that can be out of range */
+	s32 trigger_button_max =
+		pidff->set_effect[PID_TRIGGER_BUTTON].field->logical_maximum;
+	if (effect->trigger.button <= trigger_button_max) {
+		pidff->set_effect[PID_TRIGGER_BUTTON].value[0] =
+			effect->trigger.button;
+		pidff_set_time(&pidff->set_effect[PID_TRIGGER_REPEAT_INT],
+			       effect->trigger.interval);
+	} else {
+		pidff->set_effect[PID_TRIGGER_BUTTON].value[0] = 0;
+		pidff->set_effect[PID_TRIGGER_REPEAT_INT].value[0] = 0;
+	}
+
 	pidff->set_effect[PID_GAIN].value[0] =
 		pidff->set_effect[PID_GAIN].field->logical_maximum;
 
-- 
2.51.0

