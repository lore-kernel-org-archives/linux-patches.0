Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDB82F3C1C;
	Fri, 10 Oct 2025 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102302; cv=none; b=e146bQL0VWCf7paCUTcrT5AjB/1P6ioK31YaRxyfkoswXVpsSVntcT/IWr2rHXe03OOZQgLUYt3xFNsPNDFfDS1j40qQrlMR6A3g0QhgGE3Qsa4ZdIvOTJUAY2GgJyBof0qXsoJDW4uElKtjamgU3wsuItzbk8m/NQRqlOVgHKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102302; c=relaxed/simple;
	bh=+TSqb09QHdN8xYvC10NmkN6WPa2puEROc/AL0mEPxnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOGDXLf6FZlVtWZwfmOqQaevp6cJt7nfxGllxDHY9YAEXtSXfkDZ4k57FM+esjAjkhFaIQy9+ZAQz7ZHn2ZEdFoLGTb+2pSIpuZhol/DdjqBJFEMtWXENyemd5aW9d6aSqm0lgk9a7Qrx4J+AYRcuv4wm/DvpWCQSs/3GyjW4+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WTf9i/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WTf9i/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF796C4CEF1;
	Fri, 10 Oct 2025 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102302;
	bh=+TSqb09QHdN8xYvC10NmkN6WPa2puEROc/AL0mEPxnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WTf9i/UXdOMRfd0xtEsHfq/XTYP7Oumh4/JtVTyQwloPaqWi69gpV6IQU9SOeGl0
	 bKU2YyK6+32tojUEGeq6juPFF0oF3EKluZiH5nhXMsuCE4cd5iaHGPGlzVzjDIRjC3
	 JSkQyUHzsIQObXPToEc63U/vjKJZbSmTXc5KEgjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Gergo Koteles <soyer@irl.hu>
Subject: [PATCH 6.16 01/41] ALSA: hda/tas2781: Fix the order of TAS2781 calibrated-data
Date: Fri, 10 Oct 2025 15:15:49 +0200
Message-ID: <20251010131333.476298429@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

commit 71d2893a235bf3b95baccead27b3d47f2f2cdc4c upstream.

A bug reported by one of my customers that the order of TAS2781
calibrated-data is incorrect, the correct way is to move R0_Low
and insert it between R0 and InvR0.

Fixes: 4fe238513407 ("ALSA: hda/tas2781: Move and unified the calibrated-data getting function for SPI and I2C into the tas2781_hda lib")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20250907222728.988-1-shenghao-ding@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Gergo Koteles <soyer@irl.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/tas2781_hda.c
+++ b/sound/pci/hda/tas2781_hda.c
@@ -31,6 +31,23 @@ const efi_guid_t tasdev_fct_efi_guid[] =
 };
 EXPORT_SYMBOL_NS_GPL(tasdev_fct_efi_guid, "SND_HDA_SCODEC_TAS2781");
 
+/*
+ * The order of calibrated-data writing function is a bit different from the
+ * order in UEFI. Here is the conversion to match the order of calibrated-data
+ * writing function.
+ */
+static void cali_cnv(unsigned char *data, unsigned int base, int offset)
+{
+	struct cali_reg reg_data;
+
+	memcpy(&reg_data, &data[base], sizeof(reg_data));
+	/* the data order has to be swapped between r0_low_reg and inv0_reg */
+	swap(reg_data.r0_low_reg, reg_data.invr0_reg);
+
+	cpu_to_be32_array((__force __be32 *)(data + offset + 1),
+		(u32 *)&reg_data, TASDEV_CALIB_N);
+}
+
 static void tas2781_apply_calib(struct tasdevice_priv *p)
 {
 	struct calidata *cali_data = &p->cali_data;
@@ -101,8 +118,7 @@ static void tas2781_apply_calib(struct t
 
 				data[l] = k;
 				oft++;
-				for (i = 0; i < TASDEV_CALIB_N * 4; i++)
-					data[l + i + 1] = data[4 * oft + i];
+				cali_cnv(data, 4 * oft, l);
 				k++;
 			}
 		}
@@ -128,9 +144,8 @@ static void tas2781_apply_calib(struct t
 
 		for (j = p->ndev - 1; j >= 0; j--) {
 			l = j * (cali_data->cali_dat_sz_per_dev + 1);
-			for (i = TASDEV_CALIB_N * 4; i > 0 ; i--)
-				data[l + i] = data[p->index * 5 + i];
-			data[l+i] = j;
+			cali_cnv(data, cali_data->cali_dat_sz_per_dev * j, l);
+			data[l] = j;
 		}
 	}
 


