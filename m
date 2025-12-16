Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860423277AF;
	Tue, 16 Dec 2025 11:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885536; cv=none; b=Y/EopXaZuHM7M6LW1CAUS1vhAqNEV0zhHxj4JYFulyR0tc81eIdyifTGbEQDacL6iRz+PvpMt3KFIKOHIK4M+j3ilkXwC3+hFzSIIx94JRL4eiiM0r0eVvk8+ia64cxKCIKo5g8JkLUUKp7/EWu/6QxP5P6NkqvhJdP2FVfJYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885536; c=relaxed/simple;
	bh=3XZwB1t+0GuyBIXRgnNUcAy834maW9B057xMI4DO9lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2NzOB2UzVz24V3tnVAFvVl2MZn0vy12KG/73Enjed7dkh4h7i2rWgjwGpJFmhsAIKf9lukufrXE4DnspRjqR40bmK/Cn7NB42YdbuKV+HE58MguReXnmeCLjoA+usu/r0lbrB1aLYrfu3f4RHJ/+V4vcl2x6cAClNBHEDSnLec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuLdYcrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuLdYcrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD605C4CEF1;
	Tue, 16 Dec 2025 11:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885536;
	bh=3XZwB1t+0GuyBIXRgnNUcAy834maW9B057xMI4DO9lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuLdYcrA1Ss8vlfmU5jRRZyW3tTylYfkPpQpwKmITT4nhaV8GxmzgbYYlUt09A06k
	 k0IKg7lIRmg9CPcaKO/I9NJ3Yv5EnUDRJhPnqdAGu2MFT5LhXlBj2OjjuoapqgAWry
	 eeOH2IwNYvTjCLWVoZaW+bqNZgDhkOwbSWerzAj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Thomas Richard (TI.com)" <thomas.richard@bootlin.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 167/507] firmware: ti_sci: Set IO Isolation only if the firmware is capable
Date: Tue, 16 Dec 2025 12:10:08 +0100
Message-ID: <20251216111351.569176549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard (TI.com) <thomas.richard@bootlin.com>

[ Upstream commit 999e9bc953e321651d69556fdd5dfd178f96f128 ]

Prevent calling ti_sci_cmd_set_io_isolation() on firmware
that does not support the IO_ISOLATION capability. Add the
MSG_FLAG_CAPS_IO_ISOLATION capability flag and check it before
attempting to set IO isolation during suspend/resume operations.

Without this check, systems with older firmware may experience
undefined behavior or errors when entering/exiting suspend states.

Fixes: ec24643bdd62 ("firmware: ti_sci: Add system suspend and resume call")
Signed-off-by: Thomas Richard (TI.com) <thomas.richard@bootlin.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Link: https://patch.msgid.link/20251031-ti-sci-io-isolation-v2-1-60d826b65949@bootlin.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/ti_sci.c | 21 +++++++++++++--------
 drivers/firmware/ti_sci.h |  2 ++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/ti_sci.c b/drivers/firmware/ti_sci.c
index 49fd2ae01055d..8d96a3c12b36a 100644
--- a/drivers/firmware/ti_sci.c
+++ b/drivers/firmware/ti_sci.c
@@ -3751,9 +3751,11 @@ static int __maybe_unused ti_sci_suspend_noirq(struct device *dev)
 	struct ti_sci_info *info = dev_get_drvdata(dev);
 	int ret = 0;
 
-	ret = ti_sci_cmd_set_io_isolation(&info->handle, TISCI_MSG_VALUE_IO_ENABLE);
-	if (ret)
-		return ret;
+	if (info->fw_caps & MSG_FLAG_CAPS_IO_ISOLATION) {
+		ret = ti_sci_cmd_set_io_isolation(&info->handle, TISCI_MSG_VALUE_IO_ENABLE);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
@@ -3767,9 +3769,11 @@ static int __maybe_unused ti_sci_resume_noirq(struct device *dev)
 	u8 pin;
 	u8 mode;
 
-	ret = ti_sci_cmd_set_io_isolation(&info->handle, TISCI_MSG_VALUE_IO_DISABLE);
-	if (ret)
-		return ret;
+	if (info->fw_caps & MSG_FLAG_CAPS_IO_ISOLATION) {
+		ret = ti_sci_cmd_set_io_isolation(&info->handle, TISCI_MSG_VALUE_IO_DISABLE);
+		if (ret)
+			return ret;
+	}
 
 	ret = ti_sci_msg_cmd_lpm_wake_reason(&info->handle, &source, &time, &pin, &mode);
 	/* Do not fail to resume on error as the wake reason is not critical */
@@ -3928,11 +3932,12 @@ static int ti_sci_probe(struct platform_device *pdev)
 	}
 
 	ti_sci_msg_cmd_query_fw_caps(&info->handle, &info->fw_caps);
-	dev_dbg(dev, "Detected firmware capabilities: %s%s%s%s\n",
+	dev_dbg(dev, "Detected firmware capabilities: %s%s%s%s%s\n",
 		info->fw_caps & MSG_FLAG_CAPS_GENERIC ? "Generic" : "",
 		info->fw_caps & MSG_FLAG_CAPS_LPM_PARTIAL_IO ? " Partial-IO" : "",
 		info->fw_caps & MSG_FLAG_CAPS_LPM_DM_MANAGED ? " DM-Managed" : "",
-		info->fw_caps & MSG_FLAG_CAPS_LPM_ABORT ? " LPM-Abort" : ""
+		info->fw_caps & MSG_FLAG_CAPS_LPM_ABORT ? " LPM-Abort" : "",
+		info->fw_caps & MSG_FLAG_CAPS_IO_ISOLATION ? " IO-Isolation" : ""
 	);
 
 	ti_sci_setup_ops(info);
diff --git a/drivers/firmware/ti_sci.h b/drivers/firmware/ti_sci.h
index 701c416b2e78f..7559cde17b6cc 100644
--- a/drivers/firmware/ti_sci.h
+++ b/drivers/firmware/ti_sci.h
@@ -149,6 +149,7 @@ struct ti_sci_msg_req_reboot {
  *		MSG_FLAG_CAPS_LPM_PARTIAL_IO: Partial IO in LPM
  *		MSG_FLAG_CAPS_LPM_DM_MANAGED: LPM can be managed by DM
  *		MSG_FLAG_CAPS_LPM_ABORT: Abort entry to LPM
+ *		MSG_FLAG_CAPS_IO_ISOLATION: IO Isolation support
  *
  * Response to a generic message with message type TI_SCI_MSG_QUERY_FW_CAPS
  * providing currently available SOC/firmware capabilities. SoC that don't
@@ -160,6 +161,7 @@ struct ti_sci_msg_resp_query_fw_caps {
 #define MSG_FLAG_CAPS_LPM_PARTIAL_IO	TI_SCI_MSG_FLAG(4)
 #define MSG_FLAG_CAPS_LPM_DM_MANAGED	TI_SCI_MSG_FLAG(5)
 #define MSG_FLAG_CAPS_LPM_ABORT		TI_SCI_MSG_FLAG(9)
+#define MSG_FLAG_CAPS_IO_ISOLATION	TI_SCI_MSG_FLAG(7)
 #define MSG_MASK_CAPS_LPM		GENMASK_ULL(4, 1)
 	u64 fw_caps;
 } __packed;
-- 
2.51.0



