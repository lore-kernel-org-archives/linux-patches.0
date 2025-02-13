Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65508281377;
	Thu, 13 Feb 2025 14:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457194; cv=none; b=bAOIXGwkKz6QqbqQwQN4XtU6nKQwHN+cCay9+HkiV2k4KCWRTjSeMRLDDuw/P2vIGvTBPt1rso73djkn8Qc//r+RQsHSjTaYc4nTn/bkSCgdchqxOfbCI2CjMWGhx8oVcOI+iH5qkwDFn0Emsm+/gGkWWhSYarWaDXM/BdQIgV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457194; c=relaxed/simple;
	bh=59P5YlTc7ohR6mR1NwcyEoWG8eMAgwE5yoVdr01RjIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHmxu7e9nDf3Cjjf2hjerf0D4qEV1NAWKGoqdEXFQrBLzGoLwpvYhZwTm+P7ibHw35JmQIXm+74ahjB8t7FikHQs/3AUYRVynrdpVfoD8TeaK5JGfCK9xYFUZk75/4fCSTDNUcrgP/JFoPiRB0BXTljhM3rk3Mp/qy06ukup2uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcY2svMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcY2svMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AF8C4CED1;
	Thu, 13 Feb 2025 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457194;
	bh=59P5YlTc7ohR6mR1NwcyEoWG8eMAgwE5yoVdr01RjIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcY2svMv2Cwh49kgii1faf8mDZM/nC2Ry5c873X+jCgBRNU995vKlQcXUj7CapMfX
	 AvjZ4CJ/6s856piJZ7oJM2gPxk7VFKZkS6zTptjJsTgVuYUeR4OQ7/+wlQuSgp2UuE
	 7qkqvtFUcaRRuLU7Lsn9A9VfLwlZ1Q7ptJMuJ1pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/422] drm/bridge: it6505: fix HDCP CTS compare V matching
Date: Thu, 13 Feb 2025 15:23:11 +0100
Message-ID: <20250213142438.187837035@linuxfoundation.org>
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

[ Upstream commit 0989c02c7a5c887c70afeae80c64d0291624e1a7 ]

When HDCP negotiation with a repeater device.
Checking SHA V' matching must retry 3 times before restarting HDCP.

Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-8-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 32 +++++++++++++++++------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 15873e7f07626..029755ee21e23 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2023,7 +2023,7 @@ static bool it6505_hdcp_part2_ksvlist_check(struct it6505 *it6505)
 {
 	struct device *dev = it6505->dev;
 	u8 av[5][4], bv[5][4];
-	int i, err;
+	int i, err, retry;
 
 	i = it6505_setup_sha1_input(it6505, it6505->sha1_input);
 	if (i <= 0) {
@@ -2032,22 +2032,28 @@ static bool it6505_hdcp_part2_ksvlist_check(struct it6505 *it6505)
 	}
 
 	it6505_sha1_digest(it6505, it6505->sha1_input, i, (u8 *)av);
+	/*1B-05 V' must retry 3 times */
+	for (retry = 0; retry < 3; retry++) {
+		err = it6505_get_dpcd(it6505, DP_AUX_HDCP_V_PRIME(0), (u8 *)bv,
+				      sizeof(bv));
 
-	err = it6505_get_dpcd(it6505, DP_AUX_HDCP_V_PRIME(0), (u8 *)bv,
-			      sizeof(bv));
+		if (err < 0) {
+			dev_err(dev, "Read V' value Fail %d", retry);
+			continue;
+		}
 
-	if (err < 0) {
-		dev_err(dev, "Read V' value Fail");
-		return false;
-	}
+		for (i = 0; i < 5; i++) {
+			if (bv[i][3] != av[i][0] || bv[i][2] != av[i][1] ||
+			    av[i][1] != av[i][2] || bv[i][0] != av[i][3])
+				break;
 
-	for (i = 0; i < 5; i++)
-		if (bv[i][3] != av[i][0] || bv[i][2] != av[i][1] ||
-		    bv[i][1] != av[i][2] || bv[i][0] != av[i][3])
-			return false;
+			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d, %d", retry, i);
+			return true;
+		}
+	}
 
-	DRM_DEV_DEBUG_DRIVER(dev, "V' all match!!");
-	return true;
+	DRM_DEV_DEBUG_DRIVER(dev, "V' NOT match!! %d", retry);
+	return false;
 }
 
 static void it6505_hdcp_wait_ksv_list(struct work_struct *work)
-- 
2.39.5



