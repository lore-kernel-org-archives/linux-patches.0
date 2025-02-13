Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4874335BA;
	Thu, 13 Feb 2025 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460133; cv=none; b=T9DW76i502pEcQxgNMWwSqNjfWbHvUIz1M6z4w4HeyZ+Es51vVg9N0yDjQQqmpQSOeM46lU2PFCql+PhQDQAx/J997LVe3hvFnwY/c0drnMbdWxn40Uvs6P0E4SocHyY/8EsketxQzl+l94SL9w9XBm/2YXETLzk0tEDkvtVqhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460133; c=relaxed/simple;
	bh=t37eusKYHxYDC1P04O45UQUJN4GkoB7kHA5cFwARN68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcVWUzWicpWydG8sCx7IKq/20qRflnQoN6C53D0DOPELjwpzle03p1uineZ6LjE7hfBMu0+QNMQMjuP7HlvgYLNmBToyr2yMRmIvUA4z9kTB81GzxiwFczPSAi7biV/LMt+PuSzUGpPRPchMbwQEr3AlS9jMxQgzgNGIZwQmmvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw+8h6L9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw+8h6L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE1DC4CED1;
	Thu, 13 Feb 2025 15:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460133;
	bh=t37eusKYHxYDC1P04O45UQUJN4GkoB7kHA5cFwARN68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw+8h6L9UZDE0QweuQFfiDQPUEfhNVyePcuzp4hPfbTwwnQAa75gmdqUsVWVN1B8C
	 CJ5oPeXdtqi778UsoVxSKREqCgn9cq+1Icv+FVD8TD7KzpBKE4y0a2B6wO9w9V1+PG
	 xF/+KRVFSIjXdQuGiWZbnCIGQJxrW8AGNuHg7qP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/273] drm/bridge: it6505: fix HDCP encryption when R0 ready
Date: Thu, 13 Feb 2025 15:26:36 +0100
Message-ID: <20250213142408.316768429@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f037288e841ac..f9f67e172eeee 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2078,15 +2078,12 @@ static void it6505_hdcp_wait_ksv_list(struct work_struct *work)
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
@@ -2459,7 +2456,11 @@ static void it6505_irq_hdcp_ksv_check(struct it6505 *it6505)
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



