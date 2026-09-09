Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2225803A4;
	Wed,  9 Sep 2026 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963781; cv=none; b=TwMioUZGF3Q7L9DspVOfv0S/44xURdldGNbkV9RTFB7NFQ6PQTh/Y52FR8dXZudthfAQn6bcUCrLrzzXmrZQbCU0ykt4EGcXKuoUSJANdr5mQEOjyyGFL1a5b9I48YySq9DaOpuHsduBUuHRC4oL452nlw6ZTZ3sJGKs5LZ0VTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963781; c=relaxed/simple;
	bh=peVaIUa0DfTkbDDP6EeZxrwv3j6jOINEhYTaC2hHNL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPPl3csf+4k56045dDX3UzrRTkJjU8bVW7fqKp+MT8OrXuvhkyF7bgmS1jjfvrpG9cwG17CxycJLKKVlUmnC6urmL1qGZh+Fz8eM/ybeA43b531TAed9K21HmMZorQshFGT0f9CtbuafXIP4YAqmGWyvVqYlOpZnCUdXSsOKic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x130EwUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x130EwUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29EB1F00A3A;
	Wed,  9 Sep 2026 14:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963779;
	bh=UzGZrILvArVLzvrSh6oDOjqZmSiP82zOyR+OOw0g8LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x130EwUS4DWQfx+g50B8hW4u06yRemv623ygsQecc+26xBDmd9k9KvjeafdtOMy+G
	 DmlaV8szExdOzzH5q2PWrer2uk4PjLvCVWVD3c2y8IY21Ho7Tthptt52tros4jj+R6
	 9ULMgVrl9htWoTwXDSe0LbfFVeccKxk9tav3jukQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 196/583] ASoC: tas2783-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:38:01 +0200
Message-ID: <20260909134244.953074927@linuxfoundation.org>
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

commit b45fc97ebcfb27ec250025329a4f79ce5e327ec3 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

tas2783_reg_default[] is grouped by SDCA entity name instead, so the
binary search does not find 120 of its 196 entries.
regcache_reg_needs_sync() then cannot compare those against their default
and reports that a sync is needed, so they are written to the device on
every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 4cc9bd8d7b32 ("ASoc: tas2783A: Add soundwire based codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805091327.23944-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2783-sdw.c |  170 ++++++++++++++++++++---------------------
 1 file changed, 85 insertions(+), 85 deletions(-)

--- a/sound/soc/codecs/tas2783-sdw.c
+++ b/sound/soc/codecs/tas2783-sdw.c
@@ -122,6 +122,7 @@ static const struct reg_default tas2783_
 	{TASDEV_REG_SDW(0, 0, 0x41), 0x14},
 	{TASDEV_REG_SDW(0, 0, 0x5c), 0x19},
 	{TASDEV_REG_SDW(0, 0, 0x5d), 0x80},
+	{TASDEV_REG_SDW(0, 0, 0x60), 0x21},
 	{TASDEV_REG_SDW(0, 0, 0x63), 0x48},
 	{TASDEV_REG_SDW(0, 0, 0x65), 0x08},
 	{TASDEV_REG_SDW(0, 0, 0x66), 0xb2},
@@ -137,7 +138,6 @@ static const struct reg_default tas2783_
 	{TASDEV_REG_SDW(0, 0, 0x73), 0x08},
 	{TASDEV_REG_SDW(0, 0, 0x75), 0xe0},
 	{TASDEV_REG_SDW(0, 0, 0x7a), 0x60},
-	{TASDEV_REG_SDW(0, 0, 0x60), 0x21},
 	{TASDEV_REG_SDW(0, 1, 0x02), 0x00},
 	{TASDEV_REG_SDW(0, 1, 0x17), 0xc0},
 	{TASDEV_REG_SDW(0, 1, 0x19), 0x60},
@@ -156,63 +156,44 @@ static const struct reg_default tas2783_
 	{TASDEV_REG_SDW(0, 0xfd, 0x39), 0x00},
 	{TASDEV_REG_SDW(0, 0xfd, 0x3e), 0x00},
 	{TASDEV_REG_SDW(0, 0xfd, 0x45), 0x00},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS21, 0x02, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS21, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS24, 0x02, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS24, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS26, 0x02, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS26, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS28, 0x02, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS28, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS127, 0x02, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS127, 0x10, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU21, 0x01, 1), 0x1},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU21, 0x02, 1), 0x9c00},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU23, 0x01, 0), 0x1},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU23, 0x01, 1), 0x1},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU23, 0x0b, 1), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU23, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU26, 0x01, 1), 0x1},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU26, 0x01, 0), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU26, 0x01, 1), 0x1},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU26, 0x0b, 1), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU26, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x01, 0), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x01, 1), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x01, 2), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x0b, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x0b, 1), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x0b, 2), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x01, 0), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x06, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x07, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x09, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x0a, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS24, 0x02, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS21, 0x02, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS26, 0x02, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS28, 0x02, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PDE23, 0x1, 0), 0x3},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x05, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x06, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x06, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT21, 0x04, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT21, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT21, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT21, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x08, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT26, 0x04, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT26, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT26, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT26, 0x11, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT28, 0x04, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT28, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT28, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT28, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x01, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x05, 0), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x12, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x01, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x05, 0), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x12, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT24, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT24, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT23, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT23, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT25, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT25, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT28, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT28, 0x08, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MU26, 0x01, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MU26, 0x01, 1), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MU26, 0x01, 2), 0x0},
@@ -222,19 +203,60 @@ static const struct reg_default tas2783_
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MU26, 0x01, 6), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MU26, 0x01, 7), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MU26, 0x06, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT23, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT23, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT24, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT24, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x01, 0), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x01, 1), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x01, 2), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x0b, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x0b, 1), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x0b, 2), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS127, 0x02, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x01, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x05, 0), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x01, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x04, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x05, 0), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x08, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU23, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU26, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x10, 0), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x12, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x13, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x14, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x15, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x16, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS24, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS21, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS26, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS28, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PDE23, 0x10, 0), 0x3},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_UDMPU23, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x10, 0), 0x1},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x12, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x12, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x13, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x12, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x13, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_TG23, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT21, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT21, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT29, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT26, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT26, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT28, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_IT28, 0x11, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT24, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT25, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT25, 0x08, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT25, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT28, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT28, 0x08, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT28, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x04, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x08, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x11, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 1), 0x0},
@@ -244,6 +266,14 @@ static const struct reg_default tas2783_
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 5), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 6), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 7), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_FU127, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_CS127, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU21, 0x12, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x10, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x11, 0), 0x0},
+	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_MFPU26, 0x12, 0), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 8), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 9), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 0xa), 0x0},
@@ -252,36 +282,6 @@ static const struct reg_default tas2783_
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 0xd), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 0xe), 0x0},
 	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_OT127, 0x12, 0xf), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PDE23, 0x1, 0), 0x3},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PDE23, 0x10, 0), 0x3},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x06, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x12, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU21, 0x13, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x06, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x12, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_PPU26, 0x13, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x05, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x10, 0), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x11, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_SAPU29, 0x12, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_TG23, 0x10, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x01, 0), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x06, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x07, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x08, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x09, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x0a, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x10, 0), 0x1},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x12, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x13, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x14, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x15, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_XU22, 0x16, 0), 0x0},
-	{SDW_SDCA_CTL(1, TAS2783_SDCA_ENT_UDMPU23, 0x10, 0), 0x0},
 };
 
 static const struct reg_sequence tas2783_init_seq[] = {


