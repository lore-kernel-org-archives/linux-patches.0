Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75DF35836E;
	Tue, 21 Jul 2026 16:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649705; cv=none; b=eZI4GsJgghTMDeYKGYQ8YxXhsSg5eM/So4qLDd+/A//TSj8BLYVXPaMbVpabLTP+COVLN3RqzUhhiJhiHeBvbbucvJpFeU13A/g/KeAIpYweg3mThoyv45UTMagXLZHPiYZjtzigWibD0SB8aUDEoClSO5Zrp16agFZb2xwiIco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649705; c=relaxed/simple;
	bh=qzv/jzsxIqHXg5nPeBOOIGIyZJOoqaxCttKk0RRfrNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6ZgT2yP9AWugW7tGcQPkeYWw7NezeoMb5nDhoxmZhPtnL0k4aqmaUkBGkRT0v3bEPmd5TBuETsRMa/nXoN4S68hZJE8P/grzSBmx8UkJE4EKPbcG66pWbLlLY7UnEmcekjfZ6C6gmWj5v3jP8qpb08BJ+xKpGSjJ87Gtm+8ywI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xh0zTZLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xh0zTZLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC8A1F000E9;
	Tue, 21 Jul 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649702;
	bh=J31eirRMC4711xRNtH9DeWR/zfEST/M4joTK28nEfSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xh0zTZLd8KQQZPjOTcz0uKWaXm+yp+493T+rlejUspCBceB/fRFG4ZRDkAH4gNEhq
	 ytvnlsyxD4bYVh8b9EgVDYlY4tN1iBJUhNBMu4qgm9GNCS0Fby/tKmNhpHBDPPfLbt
	 pFItswXNbMCVJxutUwPCSblE5cSve6oateCCXMXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0675/2077] ASoC: cs35l56: Fix possible uninitialized value in cs35l56_spi_system_reset()
Date: Tue, 21 Jul 2026 17:05:48 +0200
Message-ID: <20260721152608.718430091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index e04b114a32b7f2..5405f70b7119d8 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -534,6 +534,7 @@ static void cs35l56_spi_system_reset(struct cs35l56_base *cs35l56_base)
 	 * The regmap must remain in cache-only until the chip has
 	 * booted, so use a bypassed read.
 	 */
+	val = 0;
 	ret = read_poll_timeout(regmap_read_bypassed, read_ret,
 				(val > 0) && (val < 0xffffffff),
 				CS35L56_HALO_STATE_POLL_US,
-- 
2.53.0



