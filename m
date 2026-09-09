Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0BC5678C1;
	Wed,  9 Sep 2026 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963729; cv=none; b=QiNH2MoURiXcwF74r14a5z4dzM9dfXp4b5wvP9bkdMMI97ygurnhO9QhEBTYewdc8op8JftEFkyJghusAQ+XSWc8+2mkpSz1NzbDGd5mJPKaVWfPeXow2Q+apUtpHi8PTk+n7e7h1lR7F3SwBe965ejDmZIl+TgHlWTyfKesEgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963729; c=relaxed/simple;
	bh=87BCPexEwbXD07PlpfS9QjpMRFqdglS/nylq3zDt5Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRS1Hwu8YeGSJxjH9Wa9Cxum7uEjXBvHG3wrYjbZR/umG14LyI9SICoUf1OU5cWxONbO/ESITdzdR9sviyVufjCaiYzVUTA8mGryZQ9MCVdsWbWf8dqUC5t3hevo1ZsA2wfxjCOr6OwUgBlziIqDflQPSuGaM3oghwNXNIeEnes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvYUaBcl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvYUaBcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44331F00A3A;
	Wed,  9 Sep 2026 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963728;
	bh=JpqeO/DyTkYwtd1tzGBxsWpZcFGaeKGmBTlPAL1SzmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvYUaBclo3JFH/HErxzhuJHsM2Lmmd9pVBJvmsFzWjjO5xhN16jEPthdFfCyrqf0q
	 /qOyF6Y5dIdByJYZy254H03fPMaBVj1eDixo2uF8GZ7FrE/G6xVO/vbxrDHfJygjwK
	 ZwBTsCK5igSGMsrM/r4ZUieH2wnceRZzhS/1ws3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 180/583] ASoC: rt700: sort the register default table
Date: Wed,  9 Sep 2026 15:37:45 +0200
Message-ID: <20260909134244.419063358@linuxfoundation.org>
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

commit 18f21e34493b812d9c8ab9f083871470b016bed4 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

At the end of rt700_reg_defaults[] the 0x83xx entries are interleaved with
the 0x73xx entries they belong to, which leaves 6 of the entries
unreachable for the binary search.  regcache_reg_needs_sync() then cannot
compare them against their default and reports that a sync is needed, so
they are written to the device on every regcache_sync() even when they were
never touched.

Sort the table by register address.

Fixes: 7d2a5f9ae41e ("ASoC: rt700: add rt700 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-6-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt700-sdw.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/rt700-sdw.h
+++ b/sound/soc/codecs/rt700-sdw.h
@@ -313,16 +313,16 @@ static const struct reg_default rt700_re
 	{ 0x3122, 0x0000 },
 	{ 0x3123, 0x0000 },
 	{ 0x7303, 0x0057 },
-	{ 0x8383, 0x0057 },
 	{ 0x7308, 0x0097 },
-	{ 0x8388, 0x0097 },
 	{ 0x7309, 0x0097 },
-	{ 0x8389, 0x0097 },
 	{ 0x7312, 0x0000 },
-	{ 0x8392, 0x0000 },
 	{ 0x7313, 0x0000 },
-	{ 0x8393, 0x0000 },
 	{ 0x7319, 0x0000 },
+	{ 0x8383, 0x0057 },
+	{ 0x8388, 0x0097 },
+	{ 0x8389, 0x0097 },
+	{ 0x8392, 0x0000 },
+	{ 0x8393, 0x0000 },
 	{ 0x8399, 0x0000 },
 	{ 0x75201a, 0x8003 },
 	{ 0x752045, 0x5289 },


