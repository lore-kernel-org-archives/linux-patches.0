Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC8323C51D;
	Mon, 17 Aug 2026 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977835; cv=none; b=SUtZf5oBaWf46HjvLmO7RIvpf4zNC7p010DAh+6MEmzuJzTC1Lffd7ww1O6o5MZ1v0dmFqergIrnhGRlQwubtdxpuyjEnS36QkyORytl9OUsAOn8pnLSFWf/bE9bPEHV/L896rpV/LHjlD0XkSQVtGTciTO0LuCyGnZbFAGOX38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977835; c=relaxed/simple;
	bh=OjEXrggkXzRGYWBYNMW2hvPnzvEOQslX5GJs/NJHKaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdvr8aIeDMQq/ECSAr0Yv0zCIVWZyT5yfsfnHSMIArtVEZ3h1Rq0QA8KUwPGjfsEn1Wtvj4l62Jcm+84a/u8jOsRqa1/z0YaF3o0pVT9QQqSVdcadhlL6eQoSM/sn4ywB5c0KWvWoMaOP1kuNTZjMJyzWPbzkrPJ3fH69i50g/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq7WDkji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq7WDkji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8C01F000E9;
	Mon, 17 Aug 2026 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977833;
	bh=hxdWxUwk/d+cqo2FH9tBHUaD9yVM5KUwMo/42wjo5Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq7WDkjiHgNEzXYh+IqLuOmmFgEl/fbKW9LMmmEykgx/84RR6xgh/eeicaIQyLJ/7
	 qgEEkpA1qGF/LtvTqC6ITTpSjOo4oQViJ9ho7U5XOGpMAe4q6dejhikjDu6qptFixG
	 tDVS0eZ+TFHplfsbecbil2tCGrNkLNTjudZzp4qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/181] drm/bridge: ps8640: propagate AUX transfer register errors
Date: Mon, 17 Aug 2026 15:31:44 +0200
Message-ID: <20260817132535.804668538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 14d4dcf239da8..61ea855e55d87 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -258,8 +258,14 @@ static ssize_t ps8640_aux_transfer_msg(struct drm_dp_aux *aux,
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
@@ -275,13 +281,22 @@ static ssize_t ps8640_aux_transfer_msg(struct drm_dp_aux *aux,
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



