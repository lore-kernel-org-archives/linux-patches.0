Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2272456855A;
	Wed,  9 Sep 2026 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962293; cv=none; b=HfX9J6k8ZhG//Rs0zTvocnHz6Gb0o/KNK6KBWgXRfb2r5o3NkmSjw9YzESrljm8W3OmOEZUeWsA3gfVVzfjGsU+4cEQlh8Nx+0+c37InlWjM0aCJN89PVm0fw9n/QTW18Gj88AhJtxzfCtzV88thvVOV67cGJ0nWf7Aa1Vt5aCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962293; c=relaxed/simple;
	bh=1lSPjvZSzgSwJf5zfAjAIxg2tyU+nJQEf3gE9bPyXy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TK6hlDvQtwqRXlPcvYIN3wl0qYCANlOA56f7nuJjkRQ2E48Nz22XmtUWDI1q3M/CSiomeZSCv8MFmTlzsfBjiCeV43FoZJxnyxhLHtj12U/cTmJlRxWQxUiRKXv28sENxbz7hVxiJYHAVW2ygtAd095Rhu6PqRGHa4pK5ntmP4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PecGpymS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PecGpymS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5821F00A3A;
	Wed,  9 Sep 2026 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962291;
	bh=q32NE3e+yoiCnbGnT/idpB+WGRJRLJF7H4k8YpOk2/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PecGpymS9jstN0CWsI+Ilgco73G9pqgfA8l/B4PF7jQnbkeBC6QnRFBkNt+y0Qz8E
	 eJip7bJoDXQjp5TIPg/K2Jthw0hq3B8hdF2QYtF8WhBtLgvVxg4wILklaA15Zw+SU3
	 MkSfSo4b3g3xwGo1PGPkIWF7GAgKzWhOM1XtL4NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 239/556] ASoC: rt286: sort the register default table
Date: Wed,  9 Sep 2026 15:38:39 +0200
Message-ID: <20260909134238.829884985@linuxfoundation.org>
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

commit c30771968b5355617843a0ddfa0b9dcbcfd3ea84 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

Four entries were appended to the end of rt286_reg[] instead of being
inserted at their sorted position and the 0x01470100 entry is listed after
0x01470c00, which leaves 7 of the 39 entries unreachable for the binary
search.  regcache_reg_needs_sync() then cannot compare them against their
default and reports that a sync is needed, so they are written to the
device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 07cf7cbadb4d ("ASoC: add RT286 CODEC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt286.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -77,8 +77,10 @@ static const struct reg_default rt286_re
 	{ 0x0023a000, 0x0000007f },
 	{ 0x00270500, 0x00000400 },
 	{ 0x00370500, 0x00000400 },
+	{ 0x00830000, 0x000000c3 },
 	{ 0x00870500, 0x00000400 },
 	{ 0x00920000, 0x00000031 },
+	{ 0x00930000, 0x000000c3 },
 	{ 0x00935000, 0x000000c3 },
 	{ 0x00936000, 0x000000c3 },
 	{ 0x00970500, 0x00000400 },
@@ -88,16 +90,18 @@ static const struct reg_default rt286_re
 	{ 0x00c37000, 0x00000000 },
 	{ 0x00c37100, 0x00000080 },
 	{ 0x01270500, 0x00000400 },
+	{ 0x01270700, 0x00000000 },
 	{ 0x01370500, 0x00000400 },
 	{ 0x01371f00, 0x411111f0 },
 	{ 0x01439000, 0x00000080 },
 	{ 0x0143a000, 0x00000080 },
-	{ 0x01470700, 0x00000000 },
+	{ 0x01470100, 0x00000000 },
 	{ 0x01470500, 0x00000400 },
+	{ 0x01470700, 0x00000000 },
 	{ 0x01470c00, 0x00000000 },
-	{ 0x01470100, 0x00000000 },
 	{ 0x01837000, 0x00000000 },
 	{ 0x01870500, 0x00000400 },
+	{ 0x01870700, 0x00000020 },
 	{ 0x02050000, 0x00000000 },
 	{ 0x02139000, 0x00000080 },
 	{ 0x0213a000, 0x00000080 },
@@ -106,10 +110,6 @@ static const struct reg_default rt286_re
 	{ 0x02170700, 0x00000000 },
 	{ 0x02270100, 0x00000000 },
 	{ 0x02370100, 0x00000000 },
-	{ 0x01870700, 0x00000020 },
-	{ 0x00830000, 0x000000c3 },
-	{ 0x00930000, 0x000000c3 },
-	{ 0x01270700, 0x00000000 },
 };
 
 static bool rt286_volatile_register(struct device *dev, unsigned int reg)


