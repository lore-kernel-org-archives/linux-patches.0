Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4AB418368;
	Wed, 23 Sep 2026 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173283; cv=none; b=mbqQk+TmbPqERil+448PrZJQh1cidWzMuuoQBhKCxmsmz2CwRsGRrn723aDOpqtZdrljxR953euP9m9ft0044O0ogH5HuWfYPZoOJzT+IHWulr3Z8+jzdUfEcyjmI+/c8+fPf4XU6lA7JMu9WagnUYeAE3Q+xn1ETbkmwwA4KXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173283; c=relaxed/simple;
	bh=NqIVOw2AOh1pYDIJVpmFDyIUxdNO2KsGgkfNX1Z55wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKvhpQT/zBfAffxMJ56SjjPXKtAH8MpdeqTBLLeVf5KFWDl8NchqX10BwFHqdYKoAA3JvE5gGDxlFPwKsQC0bM5dlxgOAtuiwjYvK1Ctl9vA9pgTvu1kiL7XOpSkDkPR15wyT19wmcQJHr3UobpsiSIifuaLLIRFl+iKmzJhiYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xbshjmrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xbshjmrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B961F00893;
	Wed, 23 Sep 2026 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173282;
	bh=v0ziIBmp+lSPKXz0HxRHPzUUcLcFVnBzpyX+McodUFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xbshjmrp8NXEpxecmsWRkMm2UNP/rXqhIBc8bA8LTXcLnE00LDOY5e1NsBOMQgrln
	 r4+tWtjeVIqG7qcp4PQcnUdoECp8tr+DX2VQNvPWZFROF1h4NR1up4dJszhanEEeBF
	 ryVyJI3/ae2nLq8soYL+0A81Q3IGrqlIIxGtJZLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 199/438] ASoC: cs-amp-lib: Prevent NULL pointer if efi variable is zero length
Date: Wed, 23 Sep 2026 16:03:40 +0200
Message-ID: <20260923140649.914907079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 3482062c786ce4233f8ed3224d824184f53ec154 ]

In cs_amp_alloc_get_efi_variable() the first call to
cs_amp_get_efi_variable() might return EFI_SUCCESS if the variable
exists with zero length. Trap this and return -ENOENT to prevent
returning an unexpected NULL pointer.

The first cs_amp_get_efi_variable() call was assumed to return
EFI_BUFFER_TOO_SMALL if the variable existed, but if instead it
returned EFI_SUCCESS this would be converted to 0 by
cs_amp_convert_efi_status() and then be returned as a NULL pointer.

Fixes: 00fd40bc7acec ("ASoC: cs-amp-lib: Support Dell SSIDExV2 UEFI variable")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260914122611.2783563-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs-amp-lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/cs-amp-lib.c b/sound/soc/codecs/cs-amp-lib.c
index 371e99205b58e..58b06e6878b97 100644
--- a/sound/soc/codecs/cs-amp-lib.c
+++ b/sound/soc/codecs/cs-amp-lib.c
@@ -314,6 +314,8 @@ static void *cs_amp_alloc_get_efi_variable(efi_char16_t *name,
 	unsigned long size = 0;
 
 	status = cs_amp_get_efi_variable(name, guid, NULL, &size, NULL);
+	if (status == EFI_SUCCESS)
+		return ERR_PTR(-ENOENT);
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return ERR_PTR(cs_amp_convert_efi_status(status));
 
-- 
2.53.0



