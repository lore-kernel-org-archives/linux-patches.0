Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E6B5803A4;
	Wed,  9 Sep 2026 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963771; cv=none; b=nZmwORJUKv2VQYnyM8X275pZwzTJnk4HOJDu9QDNABXdGuIeFmIfF1pAxfOVzRpbNfTfqOy9rFm8ZAv/r8f20gIwW8vOQy40VS8NlhFOyb2vfW23m1nDiVaYjC6CCNDMWV5qii/hQw0PsxXZKv8YKekUymALdxfCs20HhOEiSw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963771; c=relaxed/simple;
	bh=Ag9S5Z6JHLA9h3qNEZ78X200QDOaw7/VLvp3BVQthNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPhRl9OpnNJg4MeDXgwmGsUEiUpYlIquOm3AGAiAFwR37jtGovJjndGhqs96Axf+y+cIkKkr0JwJ14DkcHBZwNjU+Rct8d7P7clV4Jk2yL/FMIO3o27aPt7MYUM2+ZExw8S7W5nrbbaep5xmTBSUKDYXYcW4wfVtRkocJ3JmVqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7lJDIaI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7lJDIaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F9A1F00A3E;
	Wed,  9 Sep 2026 14:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963770;
	bh=90RMr1guaCfinJVzN3fmRmkF1FMbJ3K34MBvzoEXZeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7lJDIaIPbReT42WVZu2pwEwH5AWInulnKK7Qt/phYnd0L9ePfKhiCaVc2MYGeZTq
	 Y/makx3qDlpLiMVN5IyLJy83ixqs5S8bCRXbx4sPPinNGIHCZLNgcDG5CbeTfBgGrE
	 nocZuSpcWoONlEDEf4Xby6jjIwCFwhVgVzJ1u43s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 193/583] ASoC: tas2764: sort the register default table
Date: Wed,  9 Sep 2026 15:37:58 +0200
Message-ID: <20260909134244.854489692@linuxfoundation.org>
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
@@ -783,13 +783,13 @@ static const struct reg_default tas2764_
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
 


