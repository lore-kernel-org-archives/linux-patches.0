Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43315380FD6;
	Thu, 20 Aug 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239252; cv=none; b=Yncagom/HaeOhM3zPvrWdVetw6h/zBPxZBiXY0mzVCy6kPIA2aRNHAdCrTlZl9xABM4LsqHt7r9HXOjXrEilT/hyhJb8R7zLUp8g8Vofp2318hSW2mel7rKIGwrlkFNWEzKvIKigvyxrWxObi6bfLB/XyzeOjs1rpm6QJj84VeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239252; c=relaxed/simple;
	bh=Iplmo2O1VyzzGOD0OWq7o3DPRuN0AUP0od5GckEnEyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Blp9+bLljy5f5NmaOJI28y1MXJn3Iox5uPrcMPdfLeuaBrLvqBoYRhCJK4HpiWX2gblDbl+7NT72U1yxNsUKCt3oSBpxcNHKw4ja2phEZYXFeiN85fdnMih42HIvaARp7pSp+cPxjPpguu9tFxydygxDNbSCcsinNpl9LY/W8yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYwjNCAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYwjNCAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D891F000E9;
	Thu, 20 Aug 2026 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239251;
	bh=lNYIqRZBSmkpw1JehB9LRRbKXgvpgvHo79iwLOkNBg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYwjNCApuXfpH2JAbArRkyofAKxX5Ht9gkAZcUYr6kdB6A8QdHVpMlRjit8kPegfM
	 Mnlr0jx8tI0oHANWtAYJkGZESP5liePSn0us3oVYVvw93i2awJRV3/6QDiWTxvtE3m
	 HnvWsJdZjQHEOKqalqLqe/SX5fPNVdrjX/qAfrfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Golovko <andrey.golovko@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/217] regmap: sdw-mbq: dont call an unset readable_reg callback
Date: Thu, 20 Aug 2026 16:56:08 +0200
Message-ID: <20260820145243.730022191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Andrey Golovko <andrey.golovko@gmail.com>

[ Upstream commit 00268f9452d2a0d660aa9c1bb0ca07a994af6a4f ]

regmap_sdw_mbq_poll_busy() decides whether to poll the Function Busy bit
by calling ctx->readable_reg(), which is a straight copy of
config->readable_reg. That callback is optional: regmap_readable() treats
a NULL ->readable_reg as "every register is readable", and drivers rely on
that. es9356 and tac5xx2-sdw both build an MBQ regmap without one.

Since commit ca1b11b36d82 ("regmap: sdw-mbq: Allow defers on undeferrable
controls") the poll runs on every -ENODATA, not only for Controls the
driver marked deferrable, so any of those devices answering
COMMAND_IGNORED takes the kernel through a NULL function pointer.

Treat a missing callback the way the rest of regmap does and poll.

Fixes: 5bc493bf0c37 ("regmap: sdw-mbq: Add support for SDCA deferred controls")
Signed-off-by: Andrey Golovko <andrey.golovko@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260811184500.5312-1-andrey.golovko@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-sdw-mbq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-sdw-mbq.c b/drivers/base/regmap/regmap-sdw-mbq.c
index 4895f532c806f..fe1a8c442034a 100644
--- a/drivers/base/regmap/regmap-sdw-mbq.c
+++ b/drivers/base/regmap/regmap-sdw-mbq.c
@@ -54,7 +54,7 @@ static int regmap_sdw_mbq_poll_busy(struct sdw_slave *slave, unsigned int reg,
 	reg = SDW_SDCA_CTL(SDW_SDCA_CTL_FUNC(reg), 0,
 			   SDCA_CTL_ENTITY_0_FUNCTION_STATUS, 0);
 
-	if (ctx->readable_reg(dev, reg)) {
+	if (!ctx->readable_reg || ctx->readable_reg(dev, reg)) {
 		ret = read_poll_timeout(sdw_read_no_pm, val,
 					val < 0 || !(val & SDCA_CTL_ENTITY_0_FUNCTION_BUSY),
 					ctx->cfg.retry_us, ctx->cfg.timeout_us,
-- 
2.53.0



