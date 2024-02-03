Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A558D50263;
	Sat,  3 Feb 2024 04:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933878; cv=none; b=lpZCWY83P3FfiQg0DU9Yv1pkZCexrhsER9Go2V02PGHJZi8o2LF1sXPt04ACpI/5jqtxtH4Oubnh/wAx1L1xtTIF5csY/sMUPY1AX7oS7bU1Ml/iCC379SRYCh5+XDnzJjeP5JvO++ndOA3Dn46ZUdmrALUw4FOMg1SmxNqQOq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933878; c=relaxed/simple;
	bh=XK7ZfO29UEYr9CGL2JjY5lQGl1ibOHLcjjggwt/olOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWOFyRKZ5v/tRxWK4zlF7cuOoV7uUthaBZ9DWWmLnlVYxcC5184QpYp077KRUHazBV+pVWW/Ln2c1O+ytuT0FZTltFTChiwmWQLPxvFlsospd707+a/KtwNSmk+qMmSgTCGznscgT8SKEAHjZ/eBlpmZw4++ZBpH07hc+DCBzzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuUcaH1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuUcaH1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D313C43390;
	Sat,  3 Feb 2024 04:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933878;
	bh=XK7ZfO29UEYr9CGL2JjY5lQGl1ibOHLcjjggwt/olOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuUcaH1JfKU9VhL6gj302kTOpINj0gScl1cIQ/Yq/UKuYAioDux8QiWlNLmwzEusC
	 pVGALzqrmuJCeEZUKXL3V4NA8uEqV11pQ4FF+S8gyx92wUH7CKkbAS33B/9iLyjoMA
	 L83SlOuzi0+NzDqIIRvMfgLd3jjrJXvQ7f9iAFR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farah Kassabri <fkassabri@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 218/353] accel/habanalabs: fix EQ heartbeat mechanism
Date: Fri,  2 Feb 2024 20:05:36 -0800
Message-ID: <20240203035410.579133708@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farah Kassabri <fkassabri@habana.ai>

[ Upstream commit d1958dce5ab6a3e089c60cf474e8c9b7e96e70ad ]

Stop rescheduling another heartbeat check when EQ heartbeat check fails
as it generates confusing logs in dmesg that the heartbeat fails.

Signed-off-by: Farah Kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/device.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/accel/habanalabs/common/device.c b/drivers/accel/habanalabs/common/device.c
index 9e461c03e705..9290d4374551 100644
--- a/drivers/accel/habanalabs/common/device.c
+++ b/drivers/accel/habanalabs/common/device.c
@@ -1044,18 +1044,19 @@ static bool is_pci_link_healthy(struct hl_device *hdev)
 	return (vendor_id == PCI_VENDOR_ID_HABANALABS);
 }
 
-static void hl_device_eq_heartbeat(struct hl_device *hdev)
+static int hl_device_eq_heartbeat_check(struct hl_device *hdev)
 {
-	u64 event_mask = HL_NOTIFIER_EVENT_DEVICE_RESET | HL_NOTIFIER_EVENT_DEVICE_UNAVAILABLE;
 	struct asic_fixed_properties *prop = &hdev->asic_prop;
 
 	if (!prop->cpucp_info.eq_health_check_supported)
-		return;
+		return 0;
 
 	if (hdev->eq_heartbeat_received)
 		hdev->eq_heartbeat_received = false;
 	else
-		hl_device_cond_reset(hdev, HL_DRV_RESET_HARD, event_mask);
+		return -EIO;
+
+	return 0;
 }
 
 static void hl_device_heartbeat(struct work_struct *work)
@@ -1072,10 +1073,9 @@ static void hl_device_heartbeat(struct work_struct *work)
 	/*
 	 * For EQ health check need to check if driver received the heartbeat eq event
 	 * in order to validate the eq is working.
+	 * Only if both the EQ is healthy and we managed to send the next heartbeat reschedule.
 	 */
-	hl_device_eq_heartbeat(hdev);
-
-	if (!hdev->asic_funcs->send_heartbeat(hdev))
+	if ((!hl_device_eq_heartbeat_check(hdev)) && (!hdev->asic_funcs->send_heartbeat(hdev)))
 		goto reschedule;
 
 	if (hl_device_operational(hdev, NULL))
-- 
2.43.0



