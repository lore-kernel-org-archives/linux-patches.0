Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A49D29B200;
	Wed,  9 Sep 2026 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962411; cv=none; b=ugptlPcZV8jCki7jPDyv9U87R+XvbXysoaN0EC+Dv20SeI9lsnnnPgdRU5m5NrFrY6VfdLy3kNnzYYB7Kuv72wt7wW6YgsO+GXxhr/pL/TX9kr4nGBHls5630OBoSOv9aaxJB69WgBztcwPcoMd2zSB2IoRTI0W3sQA4NV1ujd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962411; c=relaxed/simple;
	bh=MC3qwBSY4dV6izZDc2VFTlBoeXl2fvig90VZIA66PIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai2N1UBSUXAqpN+x34IaHwz/Xsqx/3tRZKV91yuMQQwwA51Im+HiANPihXOF4wB+4ELQHSASM914/cL8OzjJ8roKORdgfUHHSzpg5XhhaF5hRsDsOwCi7pjbiXoFBQr565Pjf0mYljlZKQ+ER00ylq7ixJBj/9lGyyrPe8sBzSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUE2IPVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUE2IPVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03961F00A3A;
	Wed,  9 Sep 2026 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962410;
	bh=o/S/tZRbwuFz1n8cWk0Bwu+YQFj4INVQG1nklIJB+RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUE2IPVv6VjViDHJDcMhf5OYX0hj7EHFtK+W2olAxTn1P22/q5tDIyrihFcaKoWf0
	 mWgr22h2bnFPKs8v6/AmqYDGyVpdfvu/RCk9MAEGiJpgyNosSg1GYVFJV7d7vYo9H/
	 0njhvPQobUtYVhpMStZVz3BlEt2XKj8VA/IjOWLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 254/556] ASoC: tas2552: sort the register default table
Date: Wed,  9 Sep 2026 15:38:54 +0200
Message-ID: <20260909134239.431626188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


