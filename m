Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4520151FCB2;
	Wed, 30 Sep 2026 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789682; cv=none; b=YJ2MM4RrhLCym/ysnqUNdrKaLudBMu2nHMnmSl1bUWAlrTRWTj5436tlS7KKWRSFIGoQXv0otjMjMK4jscuwYhzfjyslf5+XGsoQXm63HjwwstAqAyVj5YVaN61zmIDelmhgwbVMaq9+HAl9gv/ejOSSAOC3n1/Qt5YN7RgizPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789682; c=relaxed/simple;
	bh=4oY++FUyMrRBCNkX5QiXvF9y+HCg+oQ8FW439AEdCAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olBL7lmEGxsiZ2vyK4O8BE1Zg1SCUWzMKeYOfeVq1MT1c6WCAdp1z6QGx7GmrvvXG9kp3b1dwitNcBWDO/toTXuC6OJeN7+3ryrIoRHmiJNcQFKdnV8a4PBX6lDP3NGDwLQG5OcxpSQsD8Ps7PEPHlKPic0wkrjni1R7Z/+mebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGBKMwA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGBKMwA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD871F000FF;
	Wed, 30 Sep 2026 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789681;
	bh=A6KYsptTmygIIaczrUh4hqmUsBvcN67mhrv3UNOGTOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGBKMwA+W5QatQ1iUDPCXaOYOKbF46NS9eA2pkvK7Om3OckcGiKWPym0BIGcRnh8k
	 MNntV2be55xKoX009CPGuXPz5Mj1rQQBmpoLXgcVLHo4jxW5r1WBFPvk84hImy4RL5
	 rtWrOGyfG3saUF5ndnQLGBszL5sDl/9MfdfXj+dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 563/877] ASoC: codecs: aw88261: only check PLL and clock state at power-up
Date: Wed, 30 Sep 2026 17:24:34 +0200
Message-ID: <20260930152426.791984848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/aw88261.c |    6 +++---
 sound/soc/codecs/aw88261.h |    6 ------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/sound/soc/codecs/aw88261.c
+++ b/sound/soc/codecs/aw88261.c
@@ -253,10 +253,10 @@ static int aw88261_dev_check_sysst(struc
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


