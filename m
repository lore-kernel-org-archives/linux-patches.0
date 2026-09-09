Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C5D53B5FD;
	Wed,  9 Sep 2026 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962443; cv=none; b=fiENDhfSU2m7R/EDT0i6xIyrFFRXsYLv424pQ21XbbEnb/L7gGYIm4UfdU5zp6d868bXTV756eTWNcgjsUhox1tR1gx/PWb6cFonM2yXrck1CURGd0KCsrkwG/E1gMjiTQgT0ze9u9aEurBdkjz6QYUIy5KzLnG7HVazRUMvDIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962443; c=relaxed/simple;
	bh=EFg30glefk58qIEmRr02LlOi9qRw7+0xfZeWoegXAbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+FypCWZ+n4OzCQk9vb6DvUu8Dtk703k2Pe0EFQQPyB9FeTulPEszB8lC3fxgu5rriERg3iRLXgia/dXpkxNL+C98PzB+7sIbjtIxdbIjMUN1WuSWPfmQJ0gcXXOOkor9ya98KQCEBZtud5Q9a/5j9USvGSV0kFu6dQ0Y804b8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zi2spA1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zi2spA1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF811F00A3A;
	Wed,  9 Sep 2026 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962442;
	bh=TJhA2wsOd5OSaF4mmAqMQHesLRAZIgTNGoYS2UFcAoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zi2spA1djoG6ZA1An44IZxwHVtI3Kfjo7XmopVSHd7v2diDO2n+y5BkL6C5N6HKEM
	 j45MfM0HcXZvhi7EKG23qSJHtEzqty3cT1tzyFMPZElCwmmqdAQU1T2qkK+lnNIj4b
	 zS+IDU6pVnANM6WhWT/cf9UrgEUTnx+JOi+CpYmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 255/556] ASoC: tas2764: sort the register default table
Date: Wed,  9 Sep 2026 15:38:55 +0200
Message-ID: <20260909134239.467149073@linuxfoundation.org>
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

commit e7643c3f7eb3292f8a98c2ddbf46ba78d848b83d upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TAS2764_DVC (0x1a) is listed before TAS2764_CHNL_0 (0x03), which makes
it unreachable.  regcache_reg_needs_sync() then cannot compare it
against its default and reports that a sync is needed, so it is written
to the device on every regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805104149.9795-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2764.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -897,13 +897,13 @@ static const struct reg_default tas2764_
 	{ TAS2764_PAGE, 0x00 },
 	{ TAS2764_SW_RST, 0x00 },
 	{ TAS2764_PWR_CTRL, 0x1a },
-	{ TAS2764_DVC, 0x00 },
 	{ TAS2764_CHNL_0, 0x28 },
 	{ TAS2764_TDM_CFG0, 0x09 },
 	{ TAS2764_TDM_CFG1, 0x02 },
 	{ TAS2764_TDM_CFG2, 0x0a },
 	{ TAS2764_TDM_CFG3, 0x10 },
 	{ TAS2764_TDM_CFG5, 0x42 },
+	{ TAS2764_DVC, 0x00 },
 	{ TAS2764_INT_CLK_CFG, 0x19 },
 };
 


