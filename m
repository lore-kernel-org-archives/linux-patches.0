Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81724F3EA5;
	Tue, 13 Oct 2026 11:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891974; cv=none; b=dgyWmmtfzSapl3x/WRzKDKWnEf4mqOY4rNkot7xVL9OFeJw8I20KjEJqbcMsSzNuNmmMdL6ljwmp5phQQMsRjhbxPFMGMOCVKS2lD/4REPvF9EyIMGeFzytFTyuQgomQp2lqnujz1KD0y1JIRKqfRTEMOhhu9jIVOHTo9O0X9OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891974; c=relaxed/simple;
	bh=EeOPVZuqC5W4UlMCSrNE7f9zs+o5OOCpEt6D4Z7yTDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpIhmoFKlzac8Vtc21vunp0BiAB46d4jB8afHiD9S11QqkgwSL9710s4gVbW6vqUV3/o5FqE0uzf8KSN4ZJh03z6WSoCKIjx6aZJSgZkS2pmkq4wrgdDyq5xjMd0xslCkghqWyN4tFTBj0Eep2BAA3bp8ho4Z6YhQBiTxHnzcWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfU+8rFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfU+8rFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087DA1F00898;
	Tue, 13 Oct 2026 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891973;
	bh=uAl7eFebQvdhuri1/WaZ1W8yhPBr7QTxAltL+MLJ+xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfU+8rFiDsQsxujj4AMbnCNrDwfa/DF+n9HGCU/BE8vsfWaNlk7VwC4Nu8VT9d130
	 uWp3hHMgXTJEotZGYKNImBSqr2ArZRBKUDGHnK6r3VoDdWM2OxSGDRslqdKXRqur0h
	 NsFbrJjJH00jNKzrr7p5YKBnQ3mIUyX2a/skbnFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Yassine Jebabli <med.jebabli@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 019/281] ALSA: hda/tas2781: Accept V1 calibration data without CRC
Date: Tue, 13 Oct 2026 13:35:35 +0200
Message-ID: <20261013112855.516431406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Mohamed Yassine Jebabli <med.jebabli@gmail.com>

commit 408249089c48df1a4d23f60b831be3f3c311e6d1 upstream.

Some Lenovo BIOSes (e.g. Legion Pro 7 16IRX9H, SSID 17aa:38cd) store
valid V1 calibration data in the CALI_DATA EFI variable but leave the
TimeStamp and CRC fields zeroed. The driver rejects such data, so the
amplifiers always run with default parameters on these machines.

The rejection was silent until
commit 4fe238513407 ("ALSA: hda/tas2781: Move and unified the
calibrated-data getting function for SPI and I2C into the tas2781_hda lib")
turned it into "V1 CRC error".

The stored values are consistent (R0 = 3.82/3.83 ohm, 1/R0 matching
within 1e-4), so accept V1 data when both TimeStamp and CRC are zero
and the first device entry is non-zero, and emit a warning.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Yassine Jebabli <med.jebabli@gmail.com>
Link: https://patch.msgid.link/20261001-tas2781-v1-nocrc-v1-1-ff0c1032ce76@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/sound/hda/codecs/side-codecs/tas2781_hda.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda.c
@@ -139,9 +139,21 @@ static void tas2781_apply_calib(struct t
 		 */
 		crc = crc32(~0, data, 84) ^ ~0;
 		if (crc != tmp_val[21]) {
-			cali_data->total_sz = 0;
-			dev_err(p->dev, "%s: V1 CRC error\n", __func__);
-			return;
+			/*
+			 * Some Lenovo BIOSes (e.g. Legion Pro 7 16IRX9H,
+			 * SSID 17aa:38cd) store valid V1 calibration data
+			 * but leave TimeStamp and CRC zeroed.
+			 */
+			if (!tmp_val[20] && !tmp_val[21] &&
+			    tmp_val[0] && tmp_val[1]) {
+				dev_warn(p->dev,
+					 "%s: V1 data without CRC, accepting\n",
+					 __func__);
+			} else {
+				cali_data->total_sz = 0;
+				dev_err(p->dev, "%s: V1 CRC error\n", __func__);
+				return;
+			}
 		}
 
 		for (j = p->ndev - 1; j >= 0; j--) {


