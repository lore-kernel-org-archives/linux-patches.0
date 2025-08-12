Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5357305E2D;
	Tue, 12 Aug 2025 19:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026331; cv=none; b=DS144CCinX1gcK2Nwtyss1sciEzuSUX1v0cYgYPHvz7TBK6uUxfJ4WpyBQKBYdxvfDqMOVSBGTH3ohi2kcZyRWN+IVrV7rADJn13dlgrvhBaXzWiXisui3l0fl+qAvxpZpzB494MkcyRCwsvkyTtF7JRNPkzN2qoTLBa64YcBfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026331; c=relaxed/simple;
	bh=cTHjazoS1GN7JB91g6M1Px2c7ZipRlVZx6EXLJXbiG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc4N20sIHtHTZuPjNhcqBMq2diYeGKz1vJiNloOdpTAq32B54LH46hYOQhilMqikbkWId0DE3LiqGbYrlhc7xtY4K2IqQcPyswJIy2BQMvqXp1nKAe0L+HQnDDrXo5YXlClsvXoVUAr8pFXwDjW3HPRrS/mOQa8fMnrEes/4UXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2HfbJmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2HfbJmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A52C4CEF0;
	Tue, 12 Aug 2025 19:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026330;
	bh=cTHjazoS1GN7JB91g6M1Px2c7ZipRlVZx6EXLJXbiG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2HfbJmp7IGOyb01cJRx/P7Afa1qsk/JVVlSIrmrjMFzQBGKY/Aavt3aNqED98J+U
	 OymKacWW4iYZ73iZfy/IU5J+gxE8Jf7mBSpQ/NpOoZhmC8S//0TdK/QYt/92vWwZa2
	 IM/sDjFdkR1h+BwcXq72e7Z3MVsvw7m3Tpx0FcX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 306/480] ASoC: SDCA: Fix some holes in the regmap readable/writeable helpers
Date: Tue, 12 Aug 2025 19:48:34 +0200
Message-ID: <20250812174410.052469961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 061fade7a67f6cdfe918a675270d84107abbef61 ]

The current regmap readable/writeable helper functions always
allow the Next flag and allows any Control Number. Mask the Next
flag based on SDCA_ACCESS_MODE_DUAL which is the only Mode that
supports it. Also check that the Control Number is valid for
the given control.

Fixes: e3f7caf74b79 ("ASoC: SDCA: Add generic regmap SDCA helpers")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250718135432.1048566-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_regmap.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sdca/sdca_regmap.c b/sound/soc/sdca/sdca_regmap.c
index 4b78188cfceb..394058a0537c 100644
--- a/sound/soc/sdca/sdca_regmap.c
+++ b/sound/soc/sdca/sdca_regmap.c
@@ -72,12 +72,18 @@ bool sdca_regmap_readable(struct sdca_function_data *function, unsigned int reg)
 	if (!control)
 		return false;
 
+	if (!(BIT(SDW_SDCA_CTL_CNUM(reg)) & control->cn_list))
+		return false;
+
 	switch (control->mode) {
 	case SDCA_ACCESS_MODE_RW:
 	case SDCA_ACCESS_MODE_RO:
-	case SDCA_ACCESS_MODE_DUAL:
 	case SDCA_ACCESS_MODE_RW1S:
 	case SDCA_ACCESS_MODE_RW1C:
+		if (SDW_SDCA_NEXT_CTL(0) & reg)
+			return false;
+		fallthrough;
+	case SDCA_ACCESS_MODE_DUAL:
 		/* No access to registers marked solely for device use */
 		return control->layers & ~SDCA_ACCESS_LAYER_DEVICE;
 	default:
@@ -104,11 +110,17 @@ bool sdca_regmap_writeable(struct sdca_function_data *function, unsigned int reg
 	if (!control)
 		return false;
 
+	if (!(BIT(SDW_SDCA_CTL_CNUM(reg)) & control->cn_list))
+		return false;
+
 	switch (control->mode) {
 	case SDCA_ACCESS_MODE_RW:
-	case SDCA_ACCESS_MODE_DUAL:
 	case SDCA_ACCESS_MODE_RW1S:
 	case SDCA_ACCESS_MODE_RW1C:
+		if (SDW_SDCA_NEXT_CTL(0) & reg)
+			return false;
+		fallthrough;
+	case SDCA_ACCESS_MODE_DUAL:
 		/* No access to registers marked solely for device use */
 		return control->layers & ~SDCA_ACCESS_LAYER_DEVICE;
 	default:
-- 
2.39.5



