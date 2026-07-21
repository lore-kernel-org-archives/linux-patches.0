Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C6A46D08F;
	Tue, 21 Jul 2026 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662106; cv=none; b=OBiqfksvDNA8qmKpD1jGe1q7UlbmQlRBGNYAApTZ4F1Nnmf5yO6Y8dWWI+Syo+1+o45gSDkTqcgAc2mHoEgd3hxyFCMATbQNGCA4NtuH9DzApgKPvTKpM9IpBY7lEZxGGuLcYNo77IaMLoGk0vx4PZbSnI82PloCzZX1u1+WIK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662106; c=relaxed/simple;
	bh=P6cCu0NTNIh4Tnm4ousUNEp2mLefw4eMpKk446OaTSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLbxEH/IcrcsZyRdopahUf+5sqdIFfopyAxdBVR3W759nxLatT/ZNkDLK2Zg9K2C4TbqEpJdu+SYhloLmlJGMU5mVkzpRXhp0jO/SeCwi5FU75dXlFBmWaW1OpdkXr48sLd/A1bE/ylXYF0yFGkpTr9RmQUgv7G7AcldNemcWAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4DeA3wb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4DeA3wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BFF1F00A3F;
	Tue, 21 Jul 2026 19:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662103;
	bh=BbxT5bSvEbFJtB7u7RCFOPWY8xVMZgILKCplbm4g4aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4DeA3wba0M8xRdCPAeLdvMGlbi44zeCB3k8mOvQpMzYmX58O8t6XpKZrW7Bv92AW
	 88kcTFewXWFGO89Rjn1P3KtpXe13AOiRlHtIB8K38LYtwpv5eUPXXJGapUnPDHKBDU
	 vVgVXa1uIhQ+G4ZWpxwbZ9/AQEo1yMLDnFL7DWJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0316/1276] ASoC: cs35l56: Fix possible uninitialized value in cs35l56_spi_system_reset()
Date: Tue, 21 Jul 2026 17:12:39 +0200
Message-ID: <20260721152453.172205983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 007699d278a655871b07d45a1268761260d03124 ]

In cs35l56_spi_system_reset() initialize val to zero before using it in
the read_poll_timeout(). This prevents testing an uninitialized value if
the regmap_read_bypassed() returns an error.

Read errors are intentionally ignored during this loop because the
device is resetting (though SPI can't really detect that so shouldn't
fail because of that, it's safer to ignore errors and keep polling).
Because of this, val must be initialized to something in case the first
read fails. The polling loop is looking for a non-zero value, so
initializing val to 0 will ensure that the loop continues until a valid
state is read from the device or it times out.

Fixes: 769c1b79295c ("ASoC: cs35l56: Prevent races when soft-resetting using SPI control")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260611132221.1100497-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 9007484b31c71f..6a49e01ef09814 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -363,6 +363,7 @@ static void cs35l56_spi_system_reset(struct cs35l56_base *cs35l56_base)
 	 * The regmap must remain in cache-only until the chip has
 	 * booted, so use a bypassed read.
 	 */
+	val = 0;
 	ret = read_poll_timeout(regmap_read_bypassed, read_ret,
 				(val > 0) && (val < 0xffffffff),
 				CS35L56_HALO_STATE_POLL_US,
-- 
2.53.0



