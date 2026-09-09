Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5C2568542;
	Wed,  9 Sep 2026 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963692; cv=none; b=R25VK0d2YsdjZmo52cxZDrc6D3tU4VouZDjV31LRtWYe25VJN4lWqCkmFrCHm3TD0W2aqWIGF3uoQwEsEtp7pwY1S1zUuG7xeMHpyQ4Vqu7AGo3jjflzC2FPpC9x4qpYyV8LKkq7GOdvS3WTWWA60HjV2xhtizbOA2WGBsvxRnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963692; c=relaxed/simple;
	bh=row1DNRvcRe0/iLALJ+ROjeiGMC3XABu3PhjhNKFbmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGKrzOJLX4kDaj1OoVk4zOBMbYeCRDhxEEOe6H3qj93Kqh9kCrXSrmCTwB5feXzULoja4ZGXsRQc1qOREg9hI8n9ztCxTm+SugRBuAGqVfxClDVkHut+W49sNgoOF3II2mnSz3Ykg/5t8ZTwYfpnCDmxKI1vMPZ7UtlhIJVDHVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZf5eDrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZf5eDrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508BB1F00A3A;
	Wed,  9 Sep 2026 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963690;
	bh=CIJYVwKX8JAPKtkWemj+EfwMHCynjBRSuM2hdwiRNL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZf5eDrIYehTCcdecioiS5QOwAM6CVkDgZ7vBYP6IohdsOLQJH35fTj8ou+l5RoWZ
	 MlYbje3IC2mU/Hj7Eim3XsAzqtjryHw8WKgLV37HuTNz/ozA6B0MB/jc3tWGA1pOz0
	 S36eG/L1Qnq3qSqM5H/pLXXG70J4R+FoL4pv5XOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 164/583] ASoC: fsl_easrc: sort the register default table
Date: Wed,  9 Sep 2026 15:37:29 +0200
Message-ID: <20260909134243.884490195@linuxfoundation.org>
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

commit 84c5d79aebe6c45e12e3112d14e68972f33c210a upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

The four REG_EASRC_RRL() entries are listed as a block before the four
REG_EASRC_RRH() ones, but the two registers of a context alternate in
the address map (RRL(n) at 0x110 + 8 * n, RRH(n) at 0x114 + 8 * n).
This leaves REG_EASRC_RRL(1), REG_EASRC_RRL(2) and REG_EASRC_RRL(3)
unreachable.  regcache_reg_needs_sync() then cannot compare them against
their default and reports that a sync is needed, so they are written to
the device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122728.12362-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -1708,12 +1708,12 @@ static const struct reg_default fsl_easr
 	{REG_EASRC_SFS(2),	0x00000000},
 	{REG_EASRC_SFS(3),	0x00000000},
 	{REG_EASRC_RRL(0),	0x00000000},
-	{REG_EASRC_RRL(1),	0x00000000},
-	{REG_EASRC_RRL(2),	0x00000000},
-	{REG_EASRC_RRL(3),	0x00000000},
 	{REG_EASRC_RRH(0),	0x00000000},
+	{REG_EASRC_RRL(1),	0x00000000},
 	{REG_EASRC_RRH(1),	0x00000000},
+	{REG_EASRC_RRL(2),	0x00000000},
 	{REG_EASRC_RRH(2),	0x00000000},
+	{REG_EASRC_RRL(3),	0x00000000},
 	{REG_EASRC_RRH(3),	0x00000000},
 	{REG_EASRC_RUC(0),	0x00000000},
 	{REG_EASRC_RUC(1),	0x00000000},


