Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9156BB5B;
	Tue, 12 Aug 2025 18:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024707; cv=none; b=eTsVxQ8JGbmN1ZdS4dEn/dDLrXtdIe0e+SpLo2ua1ClutdWS+odSbX+0lMH2EhqyNyR9AEV3mPAKmn64NDU8EFZBFWBBuzWcurDsr00AzAmHfywCbMTpSHXMV0SGej7xfXNCJNbVCSUv7UVznIjlZGEAfpDJj8uhKliPfjWmON8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024707; c=relaxed/simple;
	bh=SxfIdz6kn+fobqItbtBxpNUmNrPbv9/hvqU/KbP9N6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQyr8yteyIS6bh5G3KnBvBjKlUORxcVUZ37xDJfXN29FvKDH6JMuyb6cnSVfhGpMTC99mDkmtsCfp4V2X3DB3+SlyG0OQYOhanh+rnEdN66pnMX46M0T0lL2brsF2/PuCm63UqLb9mzToWOtmyrmQ/imbtqkq9yTo9bfNFhu83k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSjyg7c4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSjyg7c4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249D8C4CEF0;
	Tue, 12 Aug 2025 18:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024707;
	bh=SxfIdz6kn+fobqItbtBxpNUmNrPbv9/hvqU/KbP9N6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSjyg7c43Cn284NGFjzkbr2joZTDtSFqBNjge6f+SdhlY2aRy2SOuzcms3hVOixub
	 qPy1+rYwZnP4ICTwTiXXX38ostlA9GMWcZUCsy3GcJWhlj/eWb4uNXUCeJQWAD4hkg
	 OwOGi3eFyIqHC/N0FzUNxtXYH7Wc/wLGJql9hvpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 420/627] ASoC: SDCA: Fix some holes in the regmap readable/writeable helpers
Date: Tue, 12 Aug 2025 19:31:55 +0200
Message-ID: <20250812173435.255456419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 66e7eee7d7f4..c41c67c2204a 100644
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



