Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8E65678FC;
	Wed,  9 Sep 2026 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962287; cv=none; b=Lmb+XNvgRznxCkk++q9Ncd+ZjXRfma410An33omKiC/AOw5Iv7yobMEsmkBSJBOY4ms+Ihn7dHkM/x5X951CXMWVNsKaLXN8mfdMnHGiiyq+6whsAtbMS2nB3b7XGnLpL4dUOnroPrgmY0ZfsCKIHQ8gO362XOgvQ056GqK8ru4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962287; c=relaxed/simple;
	bh=LYkxGR6lVocT0UZVP93Gfw0DcM2GlqCrHduAp2b2EpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acf6YFxdjFlf1I3w/FdR7ADTKjU91HIUGdq03TmYzYUpE2Y16hAjxzymzmOsYUv9BVRip1zeKBo63ir2XSdgcPG/vc5yIjCxRUlI7UlCny++eyfM7IW2wfs5+/Ovhy2SLycjNnzzXzDRz4B+D/Zwyf9CemMDCrBCYJoAkeTEbx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuuML0lU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuuML0lU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41791F00A3A;
	Wed,  9 Sep 2026 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962286;
	bh=bSX4xJrntHqaNIQxAjjpqxJW+WoJn4NOfLlb8dbTTAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuuML0lUut57VSiPPfiIDW2Bh6tLS7VY9OwGqD8v9MJ7p3+KGdausHtn2eh8ZgxHu
	 ORbHt+b0EUapG6ZO33DIzXG26EcXvVdowvyMbWaqg+Gr7+i0Rjfj2jy4e+rp1pLRSM
	 iiBlMUuAI2yYstENhT4KxecckQOgsXpVlnUzry84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 238/556] ASoC: rt274: sort the register default table
Date: Wed,  9 Sep 2026 15:38:38 +0200
Message-ID: <20260909134238.783163470@linuxfoundation.org>
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


