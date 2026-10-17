Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F605385D7B;
	Sat, 17 Oct 2026 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255988; cv=none; b=o9xww9OSovn5u2hazcSrRT4QyZ3zjri7ngJU2KDYxGdG/hZFhqHV2g0pVkLCOo6Q2JSS74zXw72gAMeW7LonVTw7L79cfIvpaeDyfmw7BXVNxsbl83Qx7KphW3xvxzhEHqxEzReonYXmXKY2Z11KBfonf/nFo3YXIEu7nE6uDtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255988; c=relaxed/simple;
	bh=NL0oG9XCGgCucsjNoz7sxLiJMaSxjORCz680ZpFjA+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZIxpa7MJko4PxZla4qH7z2kMk7zEgzkiEaRf4xCJUaDYArQbY/URrxqWpTcasYsN3uOr2TIoLsglTIGpzvvpsMxP9kCml3b3+3FqhOmSG9YkwIFR/nbHYLIMbHKQp0/DsfMeCi76RMEw3VCS65QZLtdxt1aM6Sy41vOce+to0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzszzHA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzszzHA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E54A1F000C4;
	Sat, 17 Oct 2026 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255987;
	bh=VBhOQMpOFsCuOEywwsvRUKDE+qFtWoykDrbibfj5xNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzszzHA6EArYyoQE8O+AHl0ez2VCadn9ygKf5gM2flE5OPwfRbXI9dmuIgU0JlbKq
	 d5soPIvCtdpH7dhYf+oVmG7IFVbpdOCgM8X/u7WPPFZR4TDAYAxGQDuPAJoVAOl8LS
	 YImQcB5L/JoU9mHl20z/mwUo3gSQrZnIJ+0PRDlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0070/1674] ASoC: codecs: aw88261: only check PLL and clock state at power-up
Date: Sat, 17 Oct 2026 17:39:02 +0200
Message-ID: <20261017160432.931770663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>

[ Upstream commit 06b6f1245567a4be862c3e1cc74577922ceb05fb ]

The SYSST check performed during device start requires SWS (amplifier
switching, bit 8) and BSTS (boost finished, bit 9) on top of PLL lock
and clock stability. Those bits cannot be asserted at this point in the
sequence: the check runs after amppd release but before the
hmute/ULS-hmute release, and the amplifier neither switches nor
finishes ramping its boost converter while it is still muted. With the
Fairphone (Gen. 6) firmware profile, aw88261_dev_start() therefore
always fails with

  check sysst fail, reg_val=0x0011, check:0x311

and playback aborts, even though the amplifier is fine and PLL lock
and stable clocks are present.

Check only PLL lock and clock stability, for which a definition
already exists; this still re-validates the clocks after amppd release
(aw88261_dev_check_syspll() checked them before it). This matches the
vendor aw882xx driver, which only validates PLL lock and clock
stability at this stage, and the in-tree aw88399 driver, which skips
the SWS check whenever the amplifier may legitimately not be switching
(AW88399_BIT_SYSST_NOSWS_CHECK).

Fixes: 028a2ae25691 ("ASoC: codecs: Add aw88261 amplifier driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
Link: https://patch.msgid.link/20260704192857.88366-1-jorijnvdgraaf@catcrafts.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/aw88261.c | 6 +++---
 sound/soc/codecs/aw88261.h | 6 ------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/aw88261.c b/sound/soc/codecs/aw88261.c
index 9019a12cd0f03..7fe486b707b2b 100644
--- a/sound/soc/codecs/aw88261.c
+++ b/sound/soc/codecs/aw88261.c
@@ -254,10 +254,10 @@ static int aw88261_dev_check_sysst(struct aw_device *aw_dev)
 			return ret;
 
 		check_val = reg_val & (~AW88261_BIT_SYSST_CHECK_MASK)
-							& AW88261_BIT_SYSST_CHECK;
-		if (check_val != AW88261_BIT_SYSST_CHECK) {
+							& AW88261_BIT_PLL_CHECK;
+		if (check_val != AW88261_BIT_PLL_CHECK) {
 			dev_dbg(aw_dev->dev, "check sysst fail, reg_val=0x%04x, check:0x%x",
-				reg_val, AW88261_BIT_SYSST_CHECK);
+				reg_val, AW88261_BIT_PLL_CHECK);
 			usleep_range(AW88261_2000_US, AW88261_2000_US + 10);
 		} else {
 			return 0;
diff --git a/sound/soc/codecs/aw88261.h b/sound/soc/codecs/aw88261.h
index 4f3dbf438510d..79ce52f602838 100644
--- a/sound/soc/codecs/aw88261.h
+++ b/sound/soc/codecs/aw88261.h
@@ -181,12 +181,6 @@
 		AW88261_OTHS_OT_VALUE | \
 		AW88261_PLLS_LOCKED_VALUE))
 
-#define AW88261_BIT_SYSST_CHECK \
-		(AW88261_BSTS_FINISHED_VALUE | \
-		AW88261_SWS_SWITCHING_VALUE | \
-		AW88261_CLKS_STABLE_VALUE | \
-		AW88261_PLLS_LOCKED_VALUE)
-
 #define AW88261_ULS_HMUTE_START_BIT	(14)
 #define AW88261_ULS_HMUTE_BITS_LEN	(1)
 #define AW88261_ULS_HMUTE_MASK		\
-- 
2.53.0



