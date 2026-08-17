Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDA82BE7A7;
	Mon, 17 Aug 2026 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974831; cv=none; b=YZmSGNoA1TsACJx6RH1l/QIZBuraWKYWCsgd8EVWvqIbAJlaie3UtrEbvo+CK6DXx9giUCJt4j7evIDkYjSO8f04STaNvZGHb+2AdMG/AXls5PHu3/RMYCWp9jGWIz0eOahf9SLiGmroHeroEKFJbM1z+kMWRz67WScp4mDsdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974831; c=relaxed/simple;
	bh=cUjSOYEJF1NpLnuCarVJljRb1GewU43BXcAHueXGdN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bciq2nlYDuxWtOvW1c6bQy9WRfACupH5URDYfPT2YXs8/hJ4KJ8uVWn//s2keDbHW7IjamYqehGzgBGPXWiFJxgsQhWfhmIiANSyVy7TZmYAaqQHE7w+jTXwMYk7bvYhCD8xaKjr7/9CEoCJOWLlTh3VjFFzfZvSJuymLJg0FJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+qOc72R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+qOc72R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157531F000E9;
	Mon, 17 Aug 2026 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974824;
	bh=U3q7Y4ZcP6xk/ZSLsixx84XhCFHiReEbLQsyjqHIMvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+qOc72Rd6FYqiq6xPhaRVI5xXKkLHn8AtWryey8ASHGwvlFHmJSHj1GAwhY24UcB
	 a2OgFXEeSI4gvUH01C391iYvWG/ygXyZ0AzYWio2F55b7h20ocW5dl4KHDsD+tyQEd
	 1Oh/qFGy4YRTNIcvqEtJJvF3TEH7L0Zb41lJlfFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/250] drm/bridge: ps8640: propagate AUX transfer register errors
Date: Mon, 17 Aug 2026 15:29:51 +0200
Message-ID: <20260817132537.684219769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 20697ecb299cd77b4cf8b28f655e56606b0472d8 ]

ps8640_aux_transfer_msg() programs the AUX address registers, starts the
AUX transfer, waits for SWAUX_SEND to clear, and reads the AUX status
register. Several of those regmap operations have return values, but the
function only checks a stale ret after the status read.

Propagate failures from the address write, transfer start, completion
poll, and status read. This avoids returning a transfer length when the
bridge register transaction or AUX completion wait failed.

Fixes: 13afcdd7277e ("drm/bridge: parade-ps8640: Add support for AUX channel")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260723103509.2-ps8640-v2-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/parade-ps8640.c | 27 ++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index 825777a5758f6..db8e5889dc7f1 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -257,8 +257,14 @@ static ssize_t ps8640_aux_transfer_msg(struct drm_dp_aux *aux,
 	addr_len[PAGE0_SWAUX_LENGTH - base] = (len == 0) ? SWAUX_NO_PAYLOAD :
 					      ((len - 1) & SWAUX_LENGTH_MASK);
 
-	regmap_bulk_write(map, PAGE0_SWAUX_ADDR_7_0, addr_len,
-			  ARRAY_SIZE(addr_len));
+	ret = regmap_bulk_write(map, PAGE0_SWAUX_ADDR_7_0, addr_len,
+				ARRAY_SIZE(addr_len));
+	if (ret) {
+		DRM_DEV_ERROR(dev,
+			      "failed to write AUX address %#x, len %zu: %d\n",
+			      msg->address, len, ret);
+		return ret;
+	}
 
 	if (len && (request == DP_AUX_NATIVE_WRITE ||
 		    request == DP_AUX_I2C_WRITE)) {
@@ -274,13 +280,22 @@ static ssize_t ps8640_aux_transfer_msg(struct drm_dp_aux *aux,
 		}
 	}
 
-	regmap_write(map, PAGE0_SWAUX_CTRL, SWAUX_SEND);
+	ret = regmap_write(map, PAGE0_SWAUX_CTRL, SWAUX_SEND);
+	if (ret) {
+		DRM_DEV_ERROR(dev, "failed to start AUX transfer: %d\n", ret);
+		return ret;
+	}
 
 	/* Zero delay loop because i2c transactions are slow already */
-	regmap_read_poll_timeout(map, PAGE0_SWAUX_CTRL, data,
-				 !(data & SWAUX_SEND), 0, 50 * 1000);
+	ret = regmap_read_poll_timeout(map, PAGE0_SWAUX_CTRL, data,
+				       !(data & SWAUX_SEND), 0, 50 * 1000);
+	if (ret) {
+		DRM_DEV_ERROR(dev, "failed to complete AUX transfer: %d\n",
+			      ret);
+		return ret;
+	}
 
-	regmap_read(map, PAGE0_SWAUX_STATUS, &data);
+	ret = regmap_read(map, PAGE0_SWAUX_STATUS, &data);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "failed to read PAGE0_SWAUX_STATUS: %d\n",
 			      ret);
-- 
2.53.0



