Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B21B58B6A8;
	Wed,  9 Sep 2026 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963867; cv=none; b=aPSqKRTqyY3o7VN1yIzhrUVyojW6LoU4lpR/y2oo9y26wlKLB+nAqSktmpLCyqHnU+EDUyh1yqBGzvvtdGRgZXDkAPe1ocF1RcApr7GmFS6otziGcLsDFUNNG4Rxs/PoyeLgFbbMLtdmAcQo7rMraaUtZtWiFuZnw+0BQ3Swmo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963867; c=relaxed/simple;
	bh=43rVC7fTDN7MZi9nMJKmERLH29vHdzdVYJZniGpuqwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4oAdVBu/ztNA/g6XlIAwgtj34hS+zERhJ17LQ681jvzCJ/aBf85mwWPDUS10u7gbHdMppWFFuA0DvnQyEaONejMksjSfNnWdNfB+qgWJtEBlCc2eUPEPDXYCwZE+CasKX8grn6q9xIk0yyIOL39kAYytc2svPkoofC3KU0dh8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xD8NP4nH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xD8NP4nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960581F00A3A;
	Wed,  9 Sep 2026 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963866;
	bh=7onfxtR2Bc5178SDZavLhtOPV8KLhasQUgUUgQsDOfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xD8NP4nHk/gfpn/TvCPr6C6JNcPoaDytDue1wtW+umNDNJXqX2fWQkAqTO3afvTi9
	 tSgPXAN96Ae3hl+QdQuuVUiGTB1USVa4DMw2TAyjektuuZ3aKEa8xeN2Y1l8gdMFxv
	 sgoGmemVeXLSxOo/0h7ycwd+AzLdL4utfceoeGAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 176/583] ASoC: rt274: sort the register default table
Date: Wed,  9 Sep 2026 15:37:41 +0200
Message-ID: <20260909134244.289147601@linuxfoundation.org>
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

commit 6a147d177819b0d831831d19fbb9c23f08a03734 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

Four entries were appended to the end of rt274_reg[] instead of being
inserted at their sorted position, which leaves 7 of the 33 entries
unreachable for the binary search.  regcache_reg_needs_sync() then cannot
compare them against their default and reports that a sync is needed, so
they are written to the device on every regcache_sync() even when they were
never touched.

Sort the table by register address.

Fixes: c7e79b2b2d2d ("ASoC: rt274: add rt274 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt274.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -184,8 +184,10 @@ static const struct reg_default rt274_re
 	{ 0x0023a000, 0x00000057 },
 	{ 0x00270500, 0x00000400 },
 	{ 0x00370500, 0x00000400 },
+	{ 0x00830000, 0x00000097 },
 	{ 0x00870500, 0x00000400 },
 	{ 0x00920000, 0x00000031 },
+	{ 0x00930000, 0x00000097 },
 	{ 0x00935000, 0x00000097 },
 	{ 0x00936000, 0x00000097 },
 	{ 0x00970500, 0x00000400 },
@@ -195,10 +197,12 @@ static const struct reg_default rt274_re
 	{ 0x00c37000, 0x00000400 },
 	{ 0x00c37100, 0x00000400 },
 	{ 0x01270500, 0x00000400 },
+	{ 0x01270700, 0x00000000 },
 	{ 0x01370500, 0x00000400 },
 	{ 0x01371f00, 0x411111f0 },
 	{ 0x01937000, 0x00000000 },
 	{ 0x01970500, 0x00000400 },
+	{ 0x01970700, 0x00000020 },
 	{ 0x02050000, 0x0000001b },
 	{ 0x02139000, 0x00000080 },
 	{ 0x0213a000, 0x00000080 },
@@ -207,10 +211,6 @@ static const struct reg_default rt274_re
 	{ 0x02170700, 0x00000000 },
 	{ 0x02270100, 0x00000000 },
 	{ 0x02370100, 0x00000000 },
-	{ 0x01970700, 0x00000020 },
-	{ 0x00830000, 0x00000097 },
-	{ 0x00930000, 0x00000097 },
-	{ 0x01270700, 0x00000000 },
 };
 
 static bool rt274_volatile_register(struct device *dev, unsigned int reg)


