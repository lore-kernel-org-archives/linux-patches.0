Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20293E928B;
	Fri,  7 Aug 2026 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113836; cv=none; b=qpgXDbNq+o/HdwKtL3EBLhIrsEE2O8TjnioUqbu4heIqXZzT14MrPM955TQfg5yd5ccP+F7oGvItLAU3Q4VuhPQ1qDzM/ySRRy6uPsiFx0UOG1UgCdWLndq/NECRx+2tHgC+LInWAkAg0spwZmKrqq43Lr+0K1529lZfgB2SeO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113836; c=relaxed/simple;
	bh=lEKBIEWDplUc7shNwESpAL4VfewMWWBcTphHnaLZPzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb1hIwq2jCpQ44LwewBWdmYZqnvfMYBCcmzgE3ilO55p4pwi/MXAuIwHax31blDeS/xMcTdBS96m2XyIvns8jqtoRaIVHE6diMSIGzPxAWwqF6Xq5Mo+DG3/NChlHn4DZS6zOppTwV5Hoc4j88JYTZHggoET6b05C7scn5YHDdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toLN4DA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toLN4DA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514501F00AC4;
	Fri,  7 Aug 2026 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113819;
	bh=q5YQyV/BlFsH74JgN4rkN+YH/Z7YK0/He0sc6qBqmbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toLN4DA2pGAyI9s5N4qlqgFSrfCp2Y0FoR7f8/+dBN30rQ2Yj7KHJRbAQ/iAEZ4Pc
	 ihQHt6c0UCK8Izrzx3/PF8CixvVkt6yUFg2IGSIlrPF0ToMjNf/iN7S7GGbW3t70dA
	 apwMH785mobcPm8ijvlCSBEcACmJIPt9QoQRCKPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/337] ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup
Date: Fri,  7 Aug 2026 16:33:52 +0200
Message-ID: <20260807143419.150774070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 317e21532e6ffa1de026bdbce5ba98e1b70ca5c6 ]

In max98095_probe(), the -EPROBE_DEFER check after devm_clk_get() is
broken due to a missing IS_ERR() guard.

The code intends to return -EPROBE_DEFER only when the clock lookup
fails with that specific error.  However, without IS_ERR() the check:

    if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)

is called unconditionally, including when devm_clk_get() succeeds and
returns a valid pointer.  Calling PTR_ERR() on a valid pointer
reinterprets its address as a signed long; the result is arbitrary
and is almost never equal to -EPROBE_DEFER, so the check silently
does nothing in the success case.  When devm_clk_get() fails with
any error other than -EPROBE_DEFER the check is also skipped, leaving
max98095->mclk holding an error pointer with no indication to the caller.

This means a deferred probe will never actually be triggered for this
device, and any non-EPROBE_DEFER clock error is silently swallowed with
the error pointer left in the mclk field.

Fix this by adding the missing IS_ERR() guard around the PTR_ERR() call,
matching the pattern already used in the sibling max98088 and wm8960
drivers.

Fixes: e3048c3d2be5 ("ASoC: max98095: Add master clock handling")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260720103950.14474-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98095.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 7e525d49328d2..3b37f4c4235e6 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1984,8 +1984,9 @@ static int max98095_probe(struct snd_soc_component *component)
 	int ret = 0;
 
 	max98095->mclk = devm_clk_get(component->dev, "mclk");
-	if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (IS_ERR(max98095->mclk))
+		if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 
 	/* reset the codec, the DSP core, and disable all interrupts */
 	max98095_reset(component);
-- 
2.53.0



