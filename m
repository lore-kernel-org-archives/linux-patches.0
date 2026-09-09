Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A944F568FDA;
	Wed,  9 Sep 2026 13:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962347; cv=none; b=F0XCakgluTsg5vAx2byX4eUxxEi6qzRWP6Tl08g/F2Gq27sKo+yoeH1eLfVvv5uy2kVzjC6kTfLumS5mvIUMW71HRIHn53R6dWDPWXt8j9GUpjHSIcP7QziVbWxCorl0VH2nof/DiFN56syZ39D6P0UyjxfLQiRPo08xIjcxJCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962347; c=relaxed/simple;
	bh=b3QBU09P5aSJNuJS9eP3GEJkVNzKBU8trNMDPaeWX2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcbwrGQP1g/YUATbhW2iJ7CAXq+ge3M8Lrt3edh3ypNPeq+HEUzuqumfb47Qlzf/hTYb9bU2Nj9p4b0tLQV2PoJoo0OYdgKqKhRGpHUTppsAPduCEb9qapet/BJtOpLv82EzXQZFL4sPTOYHiEMsvCTyvXkmNIc9DfIiaGBbG9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIkKqvef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIkKqvef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2541F00A3A;
	Wed,  9 Sep 2026 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962346;
	bh=T9I3DIqWXVZFq03u9ZYsbnHldhuwrc7Rp4cn02R0y+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIkKqvefpxieh9kPoVpX43QmC4n5JuB1B7LpzDIm6LbXcSMEtilq6tEHl4L14tBfS
	 dWeY2SyPTy7LmXgWvJN/iBm1voCHVbm2tMNpGKpGkj9zj7ORG3cLyZxGEgRlTzYsxW
	 HbIZKD1LI4bj3i6+rwrDUKNejlbf6PjVhbyXgvWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 252/556] ASoC: sgtl5000: sort the register default table
Date: Wed,  9 Sep 2026 15:38:52 +0200
Message-ID: <20260909134239.363213855@linuxfoundation.org>
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


