Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AAB281379;
	Thu, 13 Feb 2025 14:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457198; cv=none; b=jPM+2i6IL6oWq2qyFKk0ELf2bUXHXJzCnDHgBQxolR4Twa1Akqe9IeUi+d0nHqq1aFQe9eKJ3NvIbo34Zo5jaVB2AVNiEND+5DUJ+3Fx9sIsN2YP1vSas8figtgYqJwLIWGl53kFpCEXNznTB4T6gDaqnEPh4F3XYDA2f1QdSQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457198; c=relaxed/simple;
	bh=6TWqF2JIbovxKb34tVe9BwbczQD6UUO18SgcwRapDCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GILQi7H4VvMl8Qi9S/VPZFyx2ZHufFDDdUGCMhq8AbGDgHizyWv5Rgf7jNvWIlk6x0cV2kOUC5zVV7Jde0yb5iEOGjuahp+nwUF+YBGGE5tHJt2gmRK2mTp5mds/DmSB9ceSNSyD2PVdyMDJVBAXxQdUyD9rpHRFHWkglGN29J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLJJxBbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLJJxBbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45397C4CED1;
	Thu, 13 Feb 2025 14:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457197;
	bh=6TWqF2JIbovxKb34tVe9BwbczQD6UUO18SgcwRapDCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLJJxBbLoNm77LWGIqGc5WOheDtOxntH911plYxmDHF97WOoXvdY61LUGnRqhambQ
	 339lgW9xjbWjDDYcMqN52UsN7Lf2jdD4J2/jW/vMGwP8lqqKHY09ThvxoZGDiHZFZW
	 1YK7RIR/omQI7xlwOjN86r0Cxy4Pz2tSkR0g+8/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/422] drm/bridge: it6505: fix HDCP CTS KSV list wait timer
Date: Thu, 13 Feb 2025 15:23:12 +0100
Message-ID: <20250213142438.225296739@linuxfoundation.org>
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

[ Upstream commit 9f9eef9ec1a2b57d95a86fe81df758e8253a7766 ]

HDCP must disabled encryption and restart authentication after
waiting KSV for 5s.
The original method uses a counter in a waitting loop that may
wait much longer than it is supposed to.
Use time_after() for KSV wait timeout.

Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-9-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 029755ee21e23..faee8e2e82a05 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2061,12 +2061,13 @@ static void it6505_hdcp_wait_ksv_list(struct work_struct *work)
 	struct it6505 *it6505 = container_of(work, struct it6505,
 					     hdcp_wait_ksv_list);
 	struct device *dev = it6505->dev;
-	unsigned int timeout = 5000;
-	u8 bstatus = 0;
+	u8 bstatus;
 	bool ksv_list_check;
+	/* 1B-04 wait ksv list for 5s */
+	unsigned long timeout = jiffies +
+				msecs_to_jiffies(5000) + 1;
 
-	timeout /= 20;
-	while (timeout > 0) {
+	for (;;) {
 		if (!it6505_get_sink_hpd_status(it6505))
 			return;
 
@@ -2075,13 +2076,12 @@ static void it6505_hdcp_wait_ksv_list(struct work_struct *work)
 		if (bstatus & DP_BSTATUS_READY)
 			break;
 
-		msleep(20);
-		timeout--;
-	}
+		if (time_after(jiffies, timeout)) {
+			DRM_DEV_DEBUG_DRIVER(dev, "KSV list wait timeout");
+			goto timeout;
+		}
 
-	if (timeout == 0) {
-		DRM_DEV_DEBUG_DRIVER(dev, "timeout and ksv list wait failed");
-		goto timeout;
+		msleep(20);
 	}
 
 	ksv_list_check = it6505_hdcp_part2_ksvlist_check(it6505);
-- 
2.39.5



