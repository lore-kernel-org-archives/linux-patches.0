Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32BF42E001;
	Thu, 16 Jul 2026 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212488; cv=none; b=cPRV2hbXTo/DOmOrPL3lVi22VDXMJJPZ1HD11XV4KwjUjOn0MN5qPdG+h62KdcnyxzVhUF1NxalBaFhbO07XcwCB/4Cxt5Ig/0P6iSxqb05YsKtmY8Vp1fhN+B5SMy0U0yrS9OxElu7bfI34TFolyd1JJZIMOha5+om2K2k6GxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212488; c=relaxed/simple;
	bh=GNPp4S+PkcXbGlAGvqa03iGg+M8sNybReO4Ay034TEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r86Lrcd5vcq2/ECMuk7C5zRLj6NqAnr/23EvIFFGPntBIr4H+k2v0be0GPdVB+4rcdKrxoKmd+Hz1o9Yd241bOlBZ/Xp5BfBnUCfGxNrXwB80dU2sKk0LHgCOqc96n7zhMvOA+NbuXRRMnb2/nsY24EPREjt75PasgNicRbpeGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc6l+Eue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc6l+Eue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343AF1F000E9;
	Thu, 16 Jul 2026 14:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212486;
	bh=4jSBc8lgk3ysjvg5gAhe3AN/rqNMVktmM70Bq+foOj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lc6l+EueMdeddKBA47hFFKh3AeMjTIxeEZeeycHjpBIsY72QZOTVNTy7Cfaf+H42D
	 CI8wJ22st5HgHCcmRT7an+3O4l9zd7wP7kmvAYKemlPJZvYrzWuHuNv46PEsSc/u5k
	 F83t/Td+irvKT305JYKrNVl1v5RygApWuYRft5CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Guillermo=20Rodr=C3=ADguez?= <guille.rodriguez@gmail.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 329/349] i2c: stm32f7: truncate clock period instead of rounding it
Date: Thu, 16 Jul 2026 15:34:23 +0200
Message-ID: <20260716133040.678130845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillermo Rodríguez <guille.rodriguez@gmail.com>

commit 111bb7f9f4a90b32e495d70a607c67b137f3074a upstream.

stm32f7_i2c_compute_timing() derives the I2C clock source period
(i2cclk) with DIV_ROUND_CLOSEST, which may round it up. When the
period is overestimated, all timings computed from it (SCLDEL,
SDADEL, SCLL, SCLH) come out shorter on the wire than calculated,
and the resulting bus rate can exceed the requested speed, violating
the I2C specification minimums for tLOW and tHIGH.

For example, with a 104.45 MHz clock source (e.g. PCLK1, the
reset-default I2C clock source on STM32MP1), i2cclk is rounded from
9.574 ns up to 10 ns. Requesting a 400 kHz fast mode bus with
72/27 ns rise/fall times and no analog/digital filters then produces
an actual bus rate of 415.6 kHz with tLOW = 1254 ns, violating both
the 400 kHz maximum rate and the 1300 ns tLOW minimum of the
specification.

Truncate the period instead, so that it can only be underestimated.
The error then falls on the safe side: the programmed timings come
out slightly longer than computed and the bus runs marginally below
the target rate (375.3 kHz in the example above) while meeting the
specification.

i2cbus is left rounded-to-closest: it is only used as the target of
the clk_error comparison and is never multiplied into the programmed
timings, so nearest rounding remains accurate there.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Signed-off-by: Guillermo Rodríguez <guille.rodriguez@gmail.com>
Cc: <stable@vger.kernel.org> # v4.14+
Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260611104857.242153-1-guille.rodriguez@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -463,8 +463,13 @@ static int stm32f7_i2c_compute_timing(st
 {
 	struct stm32f7_i2c_spec *specs;
 	u32 p_prev = STM32F7_PRESC_MAX;
-	u32 i2cclk = DIV_ROUND_CLOSEST(NSEC_PER_SEC,
-				       setup->clock_src);
+	/*
+	 * Truncate instead of rounding to closest: if the clock period is
+	 * overestimated, the computed SCL timings will come out shorter on
+	 * the wire, which can push the bus above the target rate and below
+	 * the spec's tLOW/tHIGH minimums.
+	 */
+	u32 i2cclk = NSEC_PER_SEC / setup->clock_src;
 	u32 i2cbus = DIV_ROUND_CLOSEST(NSEC_PER_SEC,
 				       setup->speed_freq);
 	u32 clk_error_prev = i2cbus;


