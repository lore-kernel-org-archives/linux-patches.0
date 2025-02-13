Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09535281360;
	Thu, 13 Feb 2025 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457191; cv=none; b=fupsar0EzpHeJUpp+7h0v/yLz6R0gikr1nwyT5ZOem1K0gz6swaaKNOZ44hWtdhSxFmdeag1cB4HYqR0agWj8moPChCXigcQfAr1z9kA0pQr5rpo3w6T7FtaLzK4kUbc5BJgwfb4Pb//ngCFQQDJ2+WZgnv20zwAFaOL5IfkvoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457191; c=relaxed/simple;
	bh=bLR4dx9y65rtegQWqgq74kedIz74dqDPU0Lz1y/ZIec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQjn57WkaIxDf66dltyp/ONmKq5oTT/Gg3q3nmcIPvvWqwPtx9u+Yp6QOAwgPuHsZ2uqEPmdu7+uvrcm7fy3uq89OLch3rISnJ695jtPoMNVGZFjoUaBGUSLEdKLlvjljzeCstUUC/FNM6lzZ1IDuWH9DYkcPe2zrK+uL2Gy1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiIHnmF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiIHnmF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D81C4CED1;
	Thu, 13 Feb 2025 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457190;
	bh=bLR4dx9y65rtegQWqgq74kedIz74dqDPU0Lz1y/ZIec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiIHnmF04a/4WCNQaWfQe8Rh9+EexCmRp6DsQM6I0yacGwMd+ckc4r1l8cyDzdKLg
	 dWVPijSkF4ahjDkuQdDVnBx1sobNSjPdOP8Eypmz9oXkwXcjZ5sN0Lf/oXNFwqlKgC
	 R7wf55S1Wih18g86qOSyz6IBvfOqk13Ve161OM5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/422] drm/bridge: it6505: fix HDCP encryption when R0 ready
Date: Thu, 13 Feb 2025 15:23:10 +0100
Message-ID: <20250213142438.149632915@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit 8c01b0bae2f9e58f2fee0e811cb90d8331986554 ]

When starting HDCP authentication, HDCP encryption should be enabled
when R0'is checked.

Change encryption enables time at R0' ready.
The hardware HDCP engine trigger is changed and the repeater KSV fails
will restart HDCP.

Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-6-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 0f7d50da56835..15873e7f07626 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2081,15 +2081,12 @@ static void it6505_hdcp_wait_ksv_list(struct work_struct *work)
 	ksv_list_check = it6505_hdcp_part2_ksvlist_check(it6505);
 	DRM_DEV_DEBUG_DRIVER(dev, "ksv list ready, ksv list check %s",
 			     ksv_list_check ? "pass" : "fail");
-	if (ksv_list_check) {
-		it6505_set_bits(it6505, REG_HDCP_TRIGGER,
-				HDCP_TRIGGER_KSV_DONE, HDCP_TRIGGER_KSV_DONE);
+
+	if (ksv_list_check)
 		return;
-	}
+
 timeout:
-	it6505_set_bits(it6505, REG_HDCP_TRIGGER,
-			HDCP_TRIGGER_KSV_DONE | HDCP_TRIGGER_KSV_FAIL,
-			HDCP_TRIGGER_KSV_DONE | HDCP_TRIGGER_KSV_FAIL);
+	it6505_start_hdcp(it6505);
 }
 
 static void it6505_hdcp_work(struct work_struct *work)
@@ -2462,7 +2459,11 @@ static void it6505_irq_hdcp_ksv_check(struct it6505 *it6505)
 {
 	struct device *dev = it6505->dev;
 
-	DRM_DEV_DEBUG_DRIVER(dev, "HDCP event Interrupt");
+	DRM_DEV_DEBUG_DRIVER(dev, "HDCP repeater R0 event Interrupt");
+	/* 1B01 HDCP encription should start when R0 is ready*/
+	it6505_set_bits(it6505, REG_HDCP_TRIGGER,
+			HDCP_TRIGGER_KSV_DONE, HDCP_TRIGGER_KSV_DONE);
+
 	schedule_work(&it6505->hdcp_wait_ksv_list);
 }
 
-- 
2.39.5



