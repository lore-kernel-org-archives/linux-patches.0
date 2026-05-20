Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5DB372EDE;
	Wed, 20 May 2026 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296921; cv=none; b=GPfGshbKnQrr853LSasggijMebPWr5IT54hRXLCaoNUZMFRSaK1Ev3EKaj+UW8SQ9XQ6l6htJKUwDOJsD2qoc9CIEBFx78h75tE6F9RQsTAalo0rdl7LzMVJJOymVxs+H0zXznxH44SBh195xg9WK2nhCxhanHhL/6JcPqucsPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296921; c=relaxed/simple;
	bh=mRR8o8S9ajFHXUBF+CPDoe9mMVSnp/WYf7P7d4CxMPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgEcEZV06mneMpTtdw//iYCQg8+GsPNMjqqWqKjUc1hA50El3YA94/L6NhMUWUkTKrj6km/J2JWVNHi4exKft3Wn5/l9q8+C6i3aAYg/2SDjy0VeFYC9EtxPbym5PrE9wnVH8+Iuos7sEJnzH21cNSoRV2UmPmGJJe2cc1GXryE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2fB6PgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2fB6PgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF0C1F00894;
	Wed, 20 May 2026 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296919;
	bh=pcGOw+FYt26YkCg1jmsw2HEyA1wkoA3xAOM203fBMgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2fB6PgFUkBdI6QLIByromyUuAHkLKzTilIzXELx20txsCXucr5uj57Rin+/ghh2g
	 Bz+QGmFukRhu9iTMhQyTSApy4CBpE1ya1SDEtfsLEEau7zcckrTan5puZ0cWgwzRv0
	 Vk+nCb0LkT5ot93gIc1aQ3cN/FSSWjDwrN4Pmzks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0982/1146] ASoC: cs35l56: Fix illegal writes to OTP_MEM registers
Date: Wed, 20 May 2026 18:20:32 +0200
Message-ID: <20260520162210.455087659@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit be102efb832ef7e30e4cd4c2edf22bbf64ddf35a ]

Mark the OTP_MEM registers as volatile so that regcache_sync() will not
attempt to write to them.

These registers hold a constant, and originally they were marked as
readable non-volatile so that this value would be read into the regmap
cache. The problem with this is regcache_sync() issues a write for any
cached register that does not have a reg_default.

Though these registers are constants and writing them in normal use
cannot change OTP, it is illegal for the host to write to them.

Fixes: e1830f66f6c6 ("ASoC: cs35l56: Add helper functions for amp calibration")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260428115228.158252-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index af87ebae98cb0..0ddf9a8d39a07 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -108,8 +108,6 @@ int cs35l56_set_patch(struct cs35l56_base *cs35l56_base)
 EXPORT_SYMBOL_NS_GPL(cs35l56_set_patch, "SND_SOC_CS35L56_SHARED");
 
 static const struct reg_default cs35l56_reg_defaults[] = {
-	/* no defaults for OTP_MEM - first read populates cache */
-
 	{ CS35L56_ASP1_ENABLES1,		0x00000000 },
 	{ CS35L56_ASP1_CONTROL1,		0x00000028 },
 	{ CS35L56_ASP1_CONTROL2,		0x18180200 },
@@ -138,8 +136,6 @@ static const struct reg_default cs35l56_reg_defaults[] = {
 };
 
 static const struct reg_default cs35l63_reg_defaults[] = {
-	/* no defaults for OTP_MEM - first read populates cache */
-
 	{ CS35L56_ASP1_ENABLES1,		0x00000000 },
 	{ CS35L56_ASP1_CONTROL1,		0x00000028 },
 	{ CS35L56_ASP1_CONTROL2,		0x18180200 },
@@ -282,6 +278,9 @@ static bool cs35l56_common_volatile_reg(unsigned int reg)
 	case CS35L56_GLOBAL_ENABLES:		   /* owned by firmware */
 	case CS35L56_BLOCK_ENABLES:		   /* owned by firmware */
 	case CS35L56_BLOCK_ENABLES2:		   /* owned by firmware */
+	case CS35L56_OTP_MEM_53:
+	case CS35L56_OTP_MEM_54:
+	case CS35L56_OTP_MEM_55:
 	case CS35L56_SYNC_GPIO1_CFG ... CS35L56_ASP2_DIO_GPIO13_CFG:
 	case CS35L56_UPDATE_REGS:
 	case CS35L56_REFCLK_INPUT:		   /* owned by firmware */
-- 
2.53.0



