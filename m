Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2052D56E052;
	Wed,  9 Sep 2026 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963763; cv=none; b=MyJUdKS5RAreQ58yXrqG23WOQiaSvtngCgasyLhoWI3WLO18Ftv4lVWIQxyopr1613PKlX638g8q/WBpvdxiXNX2gMgpUgXBtsPEbKmTGaAXuqjpVfq5vkWAIkmANVdPs5VDi7IWYjVsCoOARrj+37d9rixySFLNL3m28N7RN64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963763; c=relaxed/simple;
	bh=8A9dCtmibB9SdG8xi4gxT9UBzekEo4z9/7r5MFxnw34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1TfEQRZ4s6qa9U/Irz/XCQGMBnTHUiEwGI0NnQuJUJBI407JdOQG3+4tnlP+jCGliAWTO0HG6xo0IZtCht6TnqI2NxNzhQ1+Y3nV1kJYA0Ce5c7DVw5v7tuhyS3QawOWUKTCtpLYaMoHqVH8zFgLVvR/1XgtIWx1/M6UqO7Mwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3OLTcO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3OLTcO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716151F00A3A;
	Wed,  9 Sep 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963762;
	bh=MHo9n12E7FYV1SiCXRQor/58n4XY/GWZn4DUe+KhAk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3OLTcO7v7dwG6ClVxZherTGyJ9iHHrVBoyr06HCRtr4GZadNLfIiMrFKrCTxFFwM
	 sLKX/TM3WrSylw+4gZ74FisUH0wKD3K/58+Ha76nX+2trdOSxjbl2qIRmvqEppIpXX
	 Bt7a+tACX3dXu4spfJlE01ZAj/1ZYfU3zbXLbw88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 190/583] ASoC: sgtl5000: sort the register default table
Date: Wed,  9 Sep 2026 15:37:55 +0200
Message-ID: <20260909134244.754026145@linuxfoundation.org>
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

commit 437fbdeb60693b8f2e8250d44d29e513a95df298 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

SGTL5000_CHIP_SHORT_CTRL (0x003c) is listed before
SGTL5000_CHIP_ANA_TEST2 (0x003a), which makes the former unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 29aa37cddfb9 ("ASoC: sgtl5000: Fix the cache handling")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122728.12362-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/sgtl5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -56,8 +56,8 @@ static const struct reg_default sgtl5000
 	{ SGTL5000_CHIP_PLL_CTRL,		0x5000 },
 	{ SGTL5000_CHIP_CLK_TOP_CTRL,		0x0000 },
 	{ SGTL5000_CHIP_ANA_STATUS,		0x0000 },
-	{ SGTL5000_CHIP_SHORT_CTRL,		0x0000 },
 	{ SGTL5000_CHIP_ANA_TEST2,		0x0000 },
+	{ SGTL5000_CHIP_SHORT_CTRL,		0x0000 },
 	{ SGTL5000_DAP_CTRL,			0x0000 },
 	{ SGTL5000_DAP_PEQ,			0x0000 },
 	{ SGTL5000_DAP_BASS_ENHANCE,		0x0040 },


