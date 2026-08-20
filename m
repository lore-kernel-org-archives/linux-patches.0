Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F74936A37A;
	Thu, 20 Aug 2026 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238630; cv=none; b=Au8d4+BitSiPMR0XqTrU+r9kdtzKsklGQcmwenKjIma29KpJhqpCj6rhgq4MtavU0L+AXmSa/69L+Pvz92ypherLv7uMqL78CZmsKcFn8XJhQJRRZRdR0A2qlv2nFKiB5v/Nb+3P/SaoLEoSYcXYNbuFeUEr456A9mzE8hhq8ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238630; c=relaxed/simple;
	bh=WDTaEoYMfDVBUEVIs5APe211kmGQLA8htRHDuSVM77Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+V3uVTi2Fed4czbP6hCAOglD9CwHd/ncmPgCT8FgvMe0JTodqSiWLFnPZeLBS6zYxV6EDUKfR4HnQ+GLkfP9MjFU3oFnmQXmDoVC8UvKmInsdk8m8KMzAGkHRjPt/pk+JCOaKzzIxOLTFDOTmHYCkJuZYPH8XxumGIPokm+280=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7g/D07F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7g/D07F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE0D1F000E9;
	Thu, 20 Aug 2026 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238629;
	bh=YPbmcyhds+NBwbwq3SR21aMfg/U92cjy+IExTK6Igis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B7g/D07FQ5UTG4rKNY/ZhEu/19HrXlvsj99RgIs6GM5oBoOL60VzC1niM6ALFqVzk
	 U7BoFojVDUnmrsBX4aVkIDovPI0d6F35E9cCLdP+4Zid/eEHr6dgYdPiGYbzH+WlPD
	 S2bGl+mrKH/YOQjiJnOWPSGt8E1BT5n7FVqeTqvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Golovko <andrey.golovko@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 213/228] regmap: sdw-mbq: dont call an unset readable_reg callback
Date: Thu, 20 Aug 2026 16:55:55 +0200
Message-ID: <20260820145251.509908099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6d7c760cbef2b..b0312f57c9800 100644
--- a/drivers/base/regmap/regmap-sdw-mbq.c
+++ b/drivers/base/regmap/regmap-sdw-mbq.c
@@ -56,7 +56,7 @@ static int regmap_sdw_mbq_poll_busy(struct sdw_slave *slave, unsigned int reg,
 	reg = SDW_SDCA_CTL(SDW_SDCA_CTL_FUNC(reg), 0,
 			   SDCA_CTL_ENTITY_0_FUNCTION_STATUS, 0);
 
-	if (ctx->readable_reg(dev, reg)) {
+	if (!ctx->readable_reg || ctx->readable_reg(dev, reg)) {
 		ret = read_poll_timeout(sdw_read_no_pm, val,
 					val < 0 || !(val & SDCA_CTL_ENTITY_0_FUNCTION_BUSY),
 					ctx->cfg.retry_us, ctx->cfg.timeout_us,
-- 
2.53.0



