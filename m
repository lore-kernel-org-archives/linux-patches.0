Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2645964F2;
	Wed,  9 Sep 2026 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963706; cv=none; b=WrDKUe2+YMtl3LmtvfCvGDQ8EaB8yQDDAOP4/lkAsvq6QakCLL5z2xMGEMiIPHDVg94UZtk10ocB6pXY4WU8uSGSXBKHBCqWtTpv/wHc9XLivhBUb+xpppkMZWkLT7bidC8e1u7Hg8l1JwUs/o7+9bR/rngCDJXUkwp79ZUjDtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963706; c=relaxed/simple;
	bh=6le3H2FLjw6B9IsNGb7TX9M5UAD/1+gKJF4HP6YnebM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAqyYikNNzbnGOyc/16eEYt0GEm6wZOtH9ZYODO32mYsdVVaO6INgu9Gokpb+UkkP3VtbTAuCZ1RkV6jqtEFwtO09Oksa2y4Gv1l9TS3zm2g6AJ1/9tqj8Kc+5AOVIIJswZmZYJbi7K/JS5yFino++E8E++EQpZDrmbDXr9FXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMDAvaOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMDAvaOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD051F00A3A;
	Wed,  9 Sep 2026 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963705;
	bh=xfGDn6R1Y3t6FuHC3cDqNuFvRHvKukU7Gnglnv34OD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMDAvaOFeX5ba/KHOra5n6v7anY6RTGLTCIDE+X3jg9REs8DHzqBjIgw/C4sgdh2B
	 TCxBVx10b5v0zBqRtoaYJ6u0Hz2iMzMw7nD91J5irIWxC0j6I2Kl0WyUxGzOzN6XV3
	 fRrh5nCr13C7pNsRkpRs0jSa+TURD+U5GqyQwQwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 168/583] ASoC: max9860: sort the register default table
Date: Wed,  9 Sep 2026 15:37:33 +0200
Message-ID: <20260909134244.023776138@linuxfoundation.org>
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

commit 5c4cf173b7eba9bd1e8824b75380412cae2e026b upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

MAX9860_PWRMAN (0x10) is listed as the first entry, before
MAX9860_INTEN (0x02), which makes MAX9860_INTEN unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 3b2af7f79968 ("ASoC: max9860: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122811.13713-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/max9860.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max9860.c
+++ b/sound/soc/codecs/max9860.c
@@ -48,7 +48,6 @@ static int max9860_dvddio_event(struct n
 }
 
 static const struct reg_default max9860_reg_defaults[] = {
-	{ MAX9860_PWRMAN,       0x00 },
 	{ MAX9860_INTEN,        0x00 },
 	{ MAX9860_SYSCLK,       0x00 },
 	{ MAX9860_AUDIOCLKHIGH, 0x00 },
@@ -62,6 +61,7 @@ static const struct reg_default max9860_
 	{ MAX9860_MICGAIN,      0x00 },
 	{ MAX9860_MICADC,       0x00 },
 	{ MAX9860_NOISEGATE,    0x00 },
+	{ MAX9860_PWRMAN,       0x00 },
 };
 
 static bool max9860_readable(struct device *dev, unsigned int reg)


