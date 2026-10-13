Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADBD3B059F;
	Tue, 13 Oct 2026 12:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894805; cv=none; b=ieDR1qG2Fnn75WNCuMKrpfQkft1yW8SCH8OyUNjWwQGeARU47DnFpDReqvMLKc1YgQU20H5+hTCxv2WgHpk46eX2gXR+0GZsCiyMrSyMC/L065PCDkE0c0Q2+5rhhYeTJQZm14UEzEz8u34ranpBM5oci9tO7Y1eZVs/801loKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894805; c=relaxed/simple;
	bh=lbbTRo9O/Z4/K2uSDgCQmoA0GdnklfxOgt8XRdCzMVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn/qVedIF1TYtJD2+8IKK31XqeL0xw9wnSUCnEQJ/Im0+ktclzEjuDxTzIkp39J7vySP1pTCg7WW796StNexkFO0pztdxOjhq7P0ZG+IiCbhKxUMkHyZIwueRkQ9PeyuMneVOXlMmIwJsdM/hiw8/05wkKuAteuBv0eRDWVrFBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=af9pmMbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="af9pmMbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA911F00893;
	Tue, 13 Oct 2026 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894804;
	bh=FLyS8t0X1QM0eHHVG7alADgPJ22ElagmYfCWvl6jtTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=af9pmMbSVflB1zfB2DMV6Su9Oe2WAcFsOQOdEGLtnUrzdNJVJGaczIN9MVrFZcy9u
	 B85OENqs6ucP3rbfh28K93imz6208TEBxafsjFlHStenKMoc77F6yBhYPj3uNnDMVV
	 B2/f858qOSVtoOzADvTIDdiuX13pA78qv0PEbcfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manush Prajwal <manushprajwal555@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/497] rtc: mpfs: fix unchecked devm_clk_get() error pointer in probe()
Date: Tue, 13 Oct 2026 13:33:49 +0200
Message-ID: <20261013112909.359173692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Manush Prajwal <manushprajwal555@gmail.com>

[ Upstream commit ac41b05d15db3134e839148290d67415ee0bdb58 ]

devm_clk_get(&pdev->dev, "rtcref")'s return value was passed straight
into clk_get_rate() without checking it for an error first, unlike the
"rtc" clock a few lines above which is correctly checked with
IS_ERR(). clk_get_rate() only guards against a NULL clk, not an error
pointer:

	if (!clk)
		return 0;
	...
	rate = clk_core_get_rate_recalc(clk->core);

so if devm_clk_get() ever returns an error pointer here (for example
ERR_PTR(-EPROBE_DEFER), which is the normal, expected outcome if the
clkcfg clock-provider this RTC depends on has not registered its
clocks yet by the time this driver probes), clk_get_rate() dereferences
that error pointer instead of returning 0, crashing instead of letting
probe defer.

Capture the clock in the existing 'clk' local and check it with
IS_ERR() before calling clk_get_rate(), matching the handling already
used for the "rtc" clock in this same function.

Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>
Fixes: 0b31d703598d ("rtc: Add driver for Microchip PolarFire SoC")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/6a9d4b02.7d74b517.206c4c.75f8@mx.google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mpfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mpfs.c b/drivers/rtc/rtc-mpfs.c
index f4f1b845e23d6..119f37386eb5c 100644
--- a/drivers/rtc/rtc-mpfs.c
+++ b/drivers/rtc/rtc-mpfs.c
@@ -256,8 +256,12 @@ static int mpfs_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	clk = devm_clk_get(&pdev->dev, "rtcref");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	/* prescaler hardware adds 1 to reg value */
-	prescaler = clk_get_rate(devm_clk_get(&pdev->dev, "rtcref")) - 1;
+	prescaler = clk_get_rate(clk) - 1;
 	if (prescaler > MAX_PRESCALER_COUNT) {
 		dev_dbg(&pdev->dev, "invalid prescaler %lu\n", prescaler);
 		return -EINVAL;
-- 
2.53.0



