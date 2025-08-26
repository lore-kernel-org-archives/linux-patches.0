Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE8341653;
	Tue, 26 Aug 2025 11:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207693; cv=none; b=FCepdZfzRmexd0BkLRm71wTQ8gCVB4pCBAEPneGvGQGqRh89F9SpYCBO2C4MkglNZhpWckNUITmXevYYP5O82zMOb8HAmoEuG/DYHR36Ch9vGSd0jOyJDibA/5UQgqahVF8g2Aj79wth5fRLoZBi1P33yFaKfjESv4D/CbS+qxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207693; c=relaxed/simple;
	bh=HsKSYa2IszX4xu0PJmmvjvX+Xd28MMFwiJivlu65VPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S84DI9sXHyvV3TGF2kh6R7gX7WgvJNouseNlT26qTVJxuFCidx1lsA7n+dhnJSmAXjCpwJ1nRH5ETjqBs4SP0Y0GwchHXiOPsbe505jykQLJjfRx/Ymd7cd5cZ00dDdh+ZTgpWY5xGbTcZvlJz2y+0eiIy4Hydr3NCt1ApwvywE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGKGUAax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGKGUAax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED112C19422;
	Tue, 26 Aug 2025 11:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207693;
	bh=HsKSYa2IszX4xu0PJmmvjvX+Xd28MMFwiJivlu65VPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGKGUAax6NGyj4udUigmPO6kj+7TuQcKUOLDbZ+1B5/vVa4wi+dL3YTXC6jRl890Y
	 /KhGHULCaEaS5m8xhOxR3MKoxyXSnFAp10JQIOEnEds9S6i9PR4MGAWFrKGL8tSgtm
	 HnsXiqCcMgTxIwcgvrS+XhvLYwMqzFUKBSHqQS1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 250/457] ALSA: hda: tas2781: Fix wrong reference of tasdevice_priv
Date: Tue, 26 Aug 2025 13:08:54 +0200
Message-ID: <20250826110943.542692322@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3f4422e7c9436abf81a00270be7e4d6d3760ec0e upstream.

During the conversion to unify the calibration data management, the
reference to tasdevice_priv was wrongly set to h->hda_priv instead of
h->priv.  This resulted in memory corruption and crashes eventually.
Unfortunately it's a void pointer, hence the compiler couldn't know
that it's wrong.

Fixes: 4fe238513407 ("ALSA: hda/tas2781: Move and unified the calibrated-data getting function for SPI and I2C into the tas2781_hda lib")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1248270
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250820051902.4523-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -287,7 +287,7 @@ static int tas2563_save_calibration(stru
 	efi_char16_t efi_name[TAS2563_CAL_VAR_NAME_MAX];
 	unsigned long max_size = TAS2563_CAL_DATA_SIZE;
 	unsigned char var8[TAS2563_CAL_VAR_NAME_MAX];
-	struct tasdevice_priv *p = h->hda_priv;
+	struct tasdevice_priv *p = h->priv;
 	struct calidata *cd = &p->cali_data;
 	struct cali_reg *r = &cd->cali_reg_array;
 	unsigned int offset = 0;


