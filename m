Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8876E480961;
	Thu, 20 Aug 2026 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247975; cv=none; b=X1A+lCmv7pWWBOl3iR3OM3FrZk+rRTaT6K/6yenHfVOynLvP7mKITDNctl9Zv07R56ruzA0+iNRrvZV+5eLzVhu7t1Y+2GBqHiaDfrN/l02kICL+ds8PsDshOGlk1FAoKGFuopkgVNIM/oJZZOVnS6WKRl++slO7IPkxhsoTEDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247975; c=relaxed/simple;
	bh=P73fxV7C/NHv1W1jzlEVQhMvIT0prRaLxeHdpzKliSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpeF5Xjlm0vvftttV2nPeaDbtY8u4BRo0Vm39S/2CSJB95itsXQZAR3hPczavZdqhtuIxzyqRtGE9Rv+aS6Udz4nRW0EoEy3nQ/9XNQ2zftC4n0WL1YH5Ng414Ja4IAez4P0jFacjtbCQyKoX7UqTkSPRrrcvs/NNH6Z+teTHK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+wOJnFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+wOJnFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E237C1F00A3A;
	Thu, 20 Aug 2026 17:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247974;
	bh=ylkMqzGiDlxThncA70PAGHfjuoGc6xowBfqPa6DUk1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+wOJnFW7tt/6+SVSD+wHa5kzpTD06egTXOWDIunBLrLveslndyRXg1bLOkaFiKYg
	 YJm3YFPzvwISYFPFymwpUGSR1IoBfRWl0z1S9fGuiJp4ayDhVhCXTW6QdIQ/7GBoR2
	 6Od3KWZrwUxT26WTjmGj5O30I8FfDispCMKhFXkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 017/303] ASoC: cs35l41: sort the register default table
Date: Thu, 20 Aug 2026 16:52:33 +0200
Message-ID: <20260820145253.702254872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit d74aac116cfb2058b15df53996d23232b310f7ff upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

cs35l41_reg[] lists CS35L41_BSTCVRT_PEAK_CUR (0x3808) after
CS35L41_BSTCVRT_COEFF (0x3810) and CS35L41_BSTCVRT_SLOPE_LBST (0x3814), so
the binary search does not find those two entries.
regcache_reg_needs_sync() then cannot compare them against their default
and reports that a sync is needed, so they are written to the device on
every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 5f2f539901b0 ("ASoC: cs35l41: Correct handling of some registers in the cache")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260805082413.26174-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l41-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/cs35l41-lib.c
+++ b/sound/soc/codecs/cs35l41-lib.c
@@ -23,9 +23,9 @@ static const struct reg_default cs35l41_
 	{ CS35L41_GPIO_PAD_CONTROL,		0x00000000 },
 	{ CS35L41_GLOBAL_CLK_CTRL,		0x00000003 },
 	{ CS35L41_TST_FS_MON0,			0x00020016 },
+	{ CS35L41_BSTCVRT_PEAK_CUR,		0x0000004A },
 	{ CS35L41_BSTCVRT_COEFF,		0x00002424 },
 	{ CS35L41_BSTCVRT_SLOPE_LBST,		0x00007500 },
-	{ CS35L41_BSTCVRT_PEAK_CUR,		0x0000004A },
 	{ CS35L41_SP_ENABLES,			0x00000000 },
 	{ CS35L41_SP_RATE_CTRL,			0x00000028 },
 	{ CS35L41_SP_FORMAT,			0x18180200 },


