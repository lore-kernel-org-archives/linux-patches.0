Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B16949890A;
	Wed,  9 Sep 2026 13:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962267; cv=none; b=D2D8IpNj9ma0UmkDaPd4AxT48y1Yjey5YXrcYIUn1HiICArXe3dJwstooA0uhBNddq420r80PXFDnrcDgKsvL0PpHePWcm+K9nDNeJAyS+7HM9R+ArYauzkJ1kWyRUrCFGUe62lsvHpXlcqhG1GinOUHxnMGCSCKvf4Y5NC8ABo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962267; c=relaxed/simple;
	bh=8fMtm2yhfYrv7kK5Zqal7IeZqoZRH2CKd3ZBVJUMASg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjjFjDTThKivbGlXuszkqB2PvZu8JI2JQeYYy7FN3pOYUBb7wtBbDmFuw1MHVxHOJ5m23Dp6AAzCndxibW7YycMhBjQFxh/bpKGpA4SxhmAUPxNP+TmNX40sLdlJSKl8KZOpK7hpHmhbXYR8a4qJgSqfqFJkbGQ1DmX8RVMdTLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wzYZoIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wzYZoIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788311F00A3F;
	Wed,  9 Sep 2026 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962266;
	bh=lEkSkrV7wdnWXn1206fY8cZCWXnUL68n4DEQ5SPq+3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wzYZoIhxrsqJneonkiAriPBk3phR/aoT1BBPfxTFOiVvncNa+R++olJ1tYdS1mLh
	 qaMz+Pde0punDhDVEm88kNwnh5cHOHNJ8ByJm42muD0Yx1jBuiD4h7vNvTkbLGT+4A
	 HLZ6gJxJHTQSXhOI4NbwXs/Vu0TFcfum58qnjlnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 231/556] ASoC: ml26124: sort the register default table
Date: Wed,  9 Sep 2026 15:38:31 +0200
Message-ID: <20260909134238.542946183@linuxfoundation.org>
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


