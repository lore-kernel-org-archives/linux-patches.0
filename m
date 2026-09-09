Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A362598BE3;
	Wed,  9 Sep 2026 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963709; cv=none; b=CmUc50iwqRFx/T12Czzs6Bpu8yHAKbDkCdqGVOjL83XGoOo/fZ7A/cCVBwUXpKWPoFyXIINmZMLSiAzkIcNdo4qR3SIR5OIA/Ha+3sTaZgZ1rxZDOVAiY8Kr8AmLsHhUlSXJVFrQjKhHo7b/eOJWfgHrQ507TZniyUXOkwQzq0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963709; c=relaxed/simple;
	bh=hVz6IL3dluVbMTTh92xAk5F1Lo1wzrtvtZX2q2o77T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aro4BdmhGFmu8kZov82dXeuWu7LIos36YyHVLpBQttsoUguA2K7sMKVIC+1yKxV+J/ypeOwC1zrB7eu3HXKEq4rFqE98LDGOsWpntb8y6P8IDgC+/b8TuD1DoR/ABd9DI3V4bEOgf9lE4BB2FUfdpSFqwKdcER9yWROMtmbvywM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSAJK/Q4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSAJK/Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08C71F00A3A;
	Wed,  9 Sep 2026 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963708;
	bh=xUZK+/+NedCjDDWI2AJvhOD5A3WvEc8EmQSHdWU7HjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSAJK/Q4PSDWQr2WjkJiElgbl1e2A55KCCJHRkO5rhMlC58BUYbFB0OCwx2RGCVrq
	 V2i1SK01F5x5W8PO1kHLOb8yYI25kFMxEnweWxEhlp+8JAEg7l8smOQ0C2qvUt6SUJ
	 pfa55Nayf0piuycQMtndSBczssfozjT8BLxmEQTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 169/583] ASoC: ml26124: sort the register default table
Date: Wed,  9 Sep 2026 15:37:34 +0200
Message-ID: <20260909134244.058442978@linuxfoundation.org>
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

commit d4d0e6e2355a6fe6517e5a0c3d9a0b8ab073b0b6 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

The Mic Select Control register (0xe8) is listed in the analog path
control group, between 0x5a and 0x60, which makes it unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Move the entry to the end of the table, where it belongs by address.

Fixes: d808fe9f3e7f ("ASoC: Add LAPIS Semiconductor ML26124 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122811.13713-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/ml26124.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/ml26124.c
+++ b/sound/soc/codecs/ml26124.c
@@ -224,7 +224,6 @@ static const struct reg_default ml26124_
 	/* Analog Path Control Register */
 	{0x54, 0x00},	/* Speaker AMP Output Control */
 	{0x5a, 0x00},	/* Mic IF Control */
-	{0xe8, 0x01},	/* Mic Select Control */
 
 	/* Audio Interface Control Register */
 	{0x60, 0x00},	/* SAI-Trans Control */
@@ -287,6 +286,9 @@ static const struct reg_default ml26124_
 	{0xd0, 0x01},	/* VIDEO AMP Gain Control */
 	{0xd2, 0x01},	/* VIDEO AMP Setup 1 */
 	{0xd4, 0x01},	/* VIDEO AMP Control2 */
+
+	/* Analog Path Control Register */
+	{0xe8, 0x01},	/* Mic Select Control */
 };
 
 /* Get sampling rate value of sampling rate setting register (0x0) */


