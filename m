Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF37377A8C;
	Fri,  7 Aug 2026 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114725; cv=none; b=k1eKVqKVspkAEsis+wQTAaXM4OxJZ33bRycbMUeUKWtltNolTezUSr7FxbiVz3xOC6EaNyfyOqvdU/kzTZPFSZtbcxkpEv4f99sTOeohXLm2a+Iy+OvGtxkFGx9+FeTsZYxIwTKpOwZbv91Sr9YxeHNLd/APD2uVrSYKkuwHpBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114725; c=relaxed/simple;
	bh=RMO2kv/RH1+daEIPxVP4t+/MzSVipYohaLwW0h921Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3kuoiFm4CsxlPQ5/TOBoBjtrciOT3bzSky5R6gjyDoqzjz3EPD/UYqhpze5bojqoQ+pa0t571qJcJ92p7XToIk1fP4OxYi47/YTKmqykb2kH+Fb5TSqDXBOBKo4Hfy1yLpl47Hu1H7z54LGsnR8YxXddWAnwXMAit1fZ/UHiWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVoSxMTT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVoSxMTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF6D1F000E9;
	Fri,  7 Aug 2026 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114724;
	bh=xLwAtlK5n6eTRrXELbLTbRiB2+gaPVelCfIMBYhmtsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVoSxMTT+gEEEvHgnipV88ykOnWjAMtEGoboCG0KS6PZJxgUw+hBVhdJL/mwbs/mN
	 GSQUiTRi7IjZysywbEkDuJYlHrFjIxu6QhNRrn+O34/lnsVR9nfaSsmTlHGLLC6yg5
	 QgGO4C/TeUdM62XL41gzV/rkjUJalFFmnExlOEGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/396] ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup
Date: Fri,  7 Aug 2026 16:33:06 +0200
Message-ID: <20260807143424.838304090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit a792ce0fad61a70793ec565743f11d6ca534de59 ]

In max98090_probe(), the -EPROBE_DEFER check after devm_clk_get() is
broken due to a missing IS_ERR() guard.

The code intends to return -EPROBE_DEFER only when the clock lookup
fails with that specific error.  However, without IS_ERR() the check:

    if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)

is called unconditionally, including when devm_clk_get() succeeds and
returns a valid pointer.  Calling PTR_ERR() on a valid pointer
reinterprets its address as a signed long; the result is arbitrary
and is almost never equal to -EPROBE_DEFER, so the check silently
does nothing in the success case.  When devm_clk_get() fails with
any error other than -EPROBE_DEFER the check is also skipped, leaving
max98090->mclk holding an error pointer with no indication to the caller.

This means a deferred probe will never actually be triggered for this
device, and any non-EPROBE_DEFER clock error is silently swallowed with
the error pointer left in the mclk field.

Fix this by adding the missing IS_ERR() guard around the PTR_ERR() call,
matching the pattern already used in the sibling max98088 and wm8960
drivers.

Fixes: b10ab7b838bd ("ASoC: max98090: Add master clock handling")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260720104254.14948-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 5aff5a459a433..830caf62d0fa8 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2390,8 +2390,9 @@ static int max98090_probe(struct snd_soc_component *component)
 	dev_dbg(component->dev, "max98090_probe\n");
 
 	max98090->mclk = devm_clk_get(component->dev, "mclk");
-	if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (IS_ERR(max98090->mclk))
+		if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 
 	max98090->component = component;
 
-- 
2.53.0



