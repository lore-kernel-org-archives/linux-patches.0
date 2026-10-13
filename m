Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295344FC8F2;
	Tue, 13 Oct 2026 12:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892843; cv=none; b=IATvDVKv5ECxynYE8irne7MgBna1zOGPuEXq2zj4LH9XJFw63gj/Ez+f4X60gUk1umKkXwa5pcpgNG+YoHmD2NBeoLJMv8spngAOd5HOciv2o9eulT5dBIav2ieNvcpXH1UiaBUu1hOq1TsX1zxmLVMTyipzLeo8rZCBABD2+Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892843; c=relaxed/simple;
	bh=n3nl9m5ybIsoCTzGhYTOm3gGBLkuDDE3ZWL+vynQF18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah5hlaLchoEsL2Wmr2yXW8LGSCmTKZkp26kM+rZVRxNjjWZ9LhkVwCFRLAoLJzcZUruTeB0V7otRm/2Bm8SsU+io2bCHZZWKWkEgR204OY36PCHlkhGR3x7mD0bRI6zRppiLDrzwCJm35gt2iy0MN5Bn1ITZ2Ar3y1YBLGn8gIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdFpU+5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdFpU+5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771321F000FF;
	Tue, 13 Oct 2026 12:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892842;
	bh=S+7woNKeH2PUPffttdNYSAw0CLkoDsNmajI2KEeRF5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdFpU+5effKubKlnM6dp1+QP7T9dut5lcydTNNM930fmx2V2q/QFJvma/Trsyvx87
	 awIqwZabDnN7dzhC8oRYtZU9Pk0OGzQ8zGWwkwpGAbz2GnuEVxf5nO/AOI81WLmhi0
	 7I22ktPPBJeKclTt47LOnyVKgFOXivMJTyxzRKxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Yassine Jebabli <med.jebabli@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 027/621] ALSA: hda/tas2781: Accept V1 calibration data without CRC
Date: Tue, 13 Oct 2026 13:30:22 +0200
Message-ID: <20261013112921.510154792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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


