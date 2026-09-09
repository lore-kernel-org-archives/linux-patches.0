Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE01357F754;
	Wed,  9 Sep 2026 14:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963769; cv=none; b=RvDDHbp496DSM6cL+WyHpH127iKdesLj+7e9/hl1FFw+brtL9UR0bR9zi6qUtcxrcv7AJKP6Sl8jVyDAd7PDB+v0Q0RM56y/9gnGJXjrxO1r2ul7AT7PRBrLqwhxBkpPaChaOudFq2yz/0FcLk2YG2OYKULpJIcbfbZg6r9kt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963769; c=relaxed/simple;
	bh=P30gPsVGuRIZOJoe/QfgsmCWfBDJ40gfrsn92TAEjWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoBm6HWdu886/rnHdCeKhU7vk+ZqhjQQlTTfF3+ylhc4VO5/z3fG4irDvQGwTsbwuZKBrxtrhmEZ3SVy27y8aYQ6w7uCray3VcZtGLbYCoMxzX+MAPOm465IyQLOCkZ60BXdtZHD6ZIcV5MmQXFTV6SGtFTVBQZBIlTAqIZqYjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lg2UpXAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lg2UpXAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424C31F00A3A;
	Wed,  9 Sep 2026 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963767;
	bh=Re4ktnuOvfmgrd5HYcQDIpwLMFaAnjGNH6dtjkccgHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lg2UpXAolj7tb36jBOhw6f2fuGj/pxxK+UXYtR/An192D3p6LIRtLD+26QWLA9kY7
	 4/gJ8M2a8zcMUw658LXsZgZ5gZ1gRkdkbk0uhFnGKfmgSiCZrQari/7P6gmkk8UQNR
	 I5ho0JbLzcsz03Qpp8xeNny0JtRuAb5uDRJd9jSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 192/583] ASoC: tas2552: sort the register default table
Date: Wed,  9 Sep 2026 15:37:57 +0200
Message-ID: <20260909134244.821153817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 1cc0cb62d306bb7c42e3d4649863df7c279ac850 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TAS2552_OUTPUT_DATA (0x07), TAS2552_PDM_CFG (0x11), TAS2552_PGA_GAIN
(0x12) and TAS2552_BOOST_APT_CTRL (0x14) are listed before
TAS2552_RESERVED_0D (0x0d), TAS2552_LIMIT_RATE_HYS (0x0e) and
TAS2552_CFG_2 (0x02), which leaves 7 of the 21 entries unreachable.
regcache_reg_needs_sync() then cannot compare them against their
default and reports that a sync is needed, so they are written to the
device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 5df7f71d5cdf ("ASoC: tas2552: Support TI TAS2552 Amplifier")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805104149.9795-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2552.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/sound/soc/codecs/tas2552.c
+++ b/sound/soc/codecs/tas2552.c
@@ -31,25 +31,25 @@
 
 static const struct reg_default tas2552_reg_defs[] = {
 	{TAS2552_CFG_1, 0x22},
+	{TAS2552_CFG_2, 0xef},
 	{TAS2552_CFG_3, 0x80},
 	{TAS2552_DOUT, 0x00},
-	{TAS2552_OUTPUT_DATA, 0xc0},
-	{TAS2552_PDM_CFG, 0x01},
-	{TAS2552_PGA_GAIN, 0x00},
-	{TAS2552_BOOST_APT_CTRL, 0x0f},
-	{TAS2552_RESERVED_0D, 0xbe},
-	{TAS2552_LIMIT_RATE_HYS, 0x08},
-	{TAS2552_CFG_2, 0xef},
 	{TAS2552_SER_CTRL_1, 0x00},
 	{TAS2552_SER_CTRL_2, 0x00},
+	{TAS2552_OUTPUT_DATA, 0xc0},
 	{TAS2552_PLL_CTRL_1, 0x10},
 	{TAS2552_PLL_CTRL_2, 0x00},
 	{TAS2552_PLL_CTRL_3, 0x00},
 	{TAS2552_BTIP, 0x8f},
 	{TAS2552_BTS_CTRL, 0x80},
+	{TAS2552_RESERVED_0D, 0xbe},
+	{TAS2552_LIMIT_RATE_HYS, 0x08},
 	{TAS2552_LIMIT_RELEASE, 0x04},
 	{TAS2552_LIMIT_INT_COUNT, 0x00},
+	{TAS2552_PDM_CFG, 0x01},
+	{TAS2552_PGA_GAIN, 0x00},
 	{TAS2552_EDGE_RATE_CTRL, 0x40},
+	{TAS2552_BOOST_APT_CTRL, 0x0f},
 	{TAS2552_VBAT_DATA, 0x00},
 };
 


