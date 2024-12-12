Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77D313792B;
	Thu, 12 Dec 2024 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017196; cv=none; b=oNPoAVWTEpaaB3Txemnou0p3ohHvmlTU5vT10XmWMFECHawkpR1kLl3px3AgdEnqqnB/4SKGvxm+ACdmuP9mTS7UuYTnF8knKG2dKS1b1Ecjg5jYjT9ffJFYrKTuX0ehYUPiVFMcBl71/xBG+Ds/f3HTIVQ+9zW5UJ4zh2kSzos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017196; c=relaxed/simple;
	bh=na7IUs3I37T4cnZXCtAan/E6JJ5nhQNmEoKmR1As9Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx3XZ3n3YEraLxFvNQg0337+8ce5XTsZ4k9ThNUFQS8LVLQJVNsvwMoV50Wge0+u0gkL0uTcVbBS+0ifIWeirru5jP/bf1cOyEnvq9GgCMEChPmAEW6Egdiuy3NHlIni8aMWV+XJ/Bd2bqkH26K6XR1tslEjdASU0rmVZo2fvG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7ndLwUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7ndLwUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CB5C4CECE;
	Thu, 12 Dec 2024 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017196;
	bh=na7IUs3I37T4cnZXCtAan/E6JJ5nhQNmEoKmR1As9Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7ndLwUPZZqeI6moYQR/nEXXy717vmoK44Ao2avgSpvsDkXrk/RQx/NC8J3TBGXNF
	 OhnaJL/Gtgy8t2CvIekpTWd7saLCW4vhXaZmXJtI54IOowwq+/Q1i5th2Hd7P5Zltt
	 NYjhDF/1kNwIHD+fg95X4BTQQFlF4M1UZRWwStI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 409/466] usb: chipidea: add CI_HDRC_HAS_SHORT_PKT_LIMIT flag
Date: Thu, 12 Dec 2024 15:59:38 +0100
Message-ID: <20241212144322.913056962@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit ec841b8d73cff37f8960e209017efe1eb2fb21f2 ]

Currently, the imx deivice controller has below limitations:

1. can't generate short packet interrupt if IOC not set in dTD. So if one
   request span more than one dTDs and only the last dTD set IOC, the usb
   request will pending there if no more data comes.
2. the controller can't accurately deliver data to differtent usb requests
   in some cases due to short packet. For example: one usb request span 3
   dTDs, then if the controller received a short packet the next packet
   will go to 2nd dTD of current request rather than the first dTD of next
   request.
3. can't build a bus packet use multiple dTDs. For example: controller
   needs to send one packet of 512 bytes use dTD1 (200 bytes) + dTD2
   (312 bytes), actually the host side will see 200 bytes short packet.

Based on these limits, add CI_HDRC_HAS_SHORT_PKT_LIMIT flag and use it on
imx platforms.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20240923081203.2851768-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci.h          | 1 +
 drivers/usb/chipidea/ci_hdrc_imx.c | 1 +
 drivers/usb/chipidea/core.c        | 2 ++
 include/linux/usb/chipidea.h       | 1 +
 4 files changed, 5 insertions(+)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 2a38e1eb65466..e4b003d060c26 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -260,6 +260,7 @@ struct ci_hdrc {
 	bool				b_sess_valid_event;
 	bool				imx28_write_fix;
 	bool				has_portsc_pec_bug;
+	bool				has_short_pkt_limit;
 	bool				supports_runtime_pm;
 	bool				in_lpm;
 	bool				wakeup_int;
diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index c64ab0e07ea03..17b3ac2ac8a1e 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -342,6 +342,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	struct ci_hdrc_platform_data pdata = {
 		.name		= dev_name(&pdev->dev),
 		.capoffset	= DEF_CAPOFFSET,
+		.flags		= CI_HDRC_HAS_SHORT_PKT_LIMIT,
 		.notify_event	= ci_hdrc_imx_notify_event,
 	};
 	int ret;
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 835bf2428dc6e..5aa16dbfc289c 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1076,6 +1076,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		CI_HDRC_SUPPORTS_RUNTIME_PM);
 	ci->has_portsc_pec_bug = !!(ci->platdata->flags &
 		CI_HDRC_HAS_PORTSC_PEC_MISSED);
+	ci->has_short_pkt_limit = !!(ci->platdata->flags &
+		CI_HDRC_HAS_SHORT_PKT_LIMIT);
 	platform_set_drvdata(pdev, ci);
 
 	ret = hw_device_init(ci, base);
diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
index 5a7f96684ea22..ebdfef124b2bc 100644
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -65,6 +65,7 @@ struct ci_hdrc_platform_data {
 #define CI_HDRC_PHY_VBUS_CONTROL	BIT(16)
 #define CI_HDRC_HAS_PORTSC_PEC_MISSED	BIT(17)
 #define CI_HDRC_FORCE_VBUS_ACTIVE_ALWAYS	BIT(18)
+#define	CI_HDRC_HAS_SHORT_PKT_LIMIT	BIT(19)
 	enum usb_dr_mode	dr_mode;
 #define CI_HDRC_CONTROLLER_RESET_EVENT		0
 #define CI_HDRC_CONTROLLER_STOPPED_EVENT	1
-- 
2.43.0



