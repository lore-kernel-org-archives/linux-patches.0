Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56B142911;
	Tue, 14 May 2024 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686046; cv=none; b=mCF7P4TmpjryFM0KLq8X3Vj6pVZfEWiiFq+pvEZPlxvzQHISlBKD3HqkR2SwAoh/XAxMPMwWP1p1L18puDbGmwuJwYrWFGkpzN5bfNkUlxGEdwTNdX8e1Mca6ExHO65lEoJRs4mKUihVVZemuQ++Vslj9piwJVNcdyIYecZAjLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686046; c=relaxed/simple;
	bh=ZEJPPJAX9o6OM9swFXAOmGJyewk3g6WRSbYVn/CzpZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp5iqm1ozju+1P29r0w0eqt9auQzVijutYRxKpRgZt/J87J/K6XfDAalOmgV8wMirmEe9/tgDkZ3enPRyXfPUFExrm7afolJ/I5c+G0zO1gZIa+MEXtcFlcw3k9G62i3fdPOKrP89j00ipXcAypFGXpYKxO4Vmw5nWpk5BqFoXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXemtOU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXemtOU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C18C2BD10;
	Tue, 14 May 2024 11:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686045;
	bh=ZEJPPJAX9o6OM9swFXAOmGJyewk3g6WRSbYVn/CzpZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXemtOU3VYvlykN1DM2c+SxDQIg59smP9NKVgGXHQD1TciAGqRHWv2MxH4nOy3Lfp
	 SaTfxSqCRwPWqhQKNjuU7/++WfOOU3Vb8buY+n7QL2+FEuLKQHAYsKPiU/2N5Y82E4
	 NKiLpDlrpcPbtFi6W4ellnu4yImFGLw172fjaRsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 297/301] Bluetooth: qca: fix NVM configuration parsing
Date: Tue, 14 May 2024 12:19:28 +0200
Message-ID: <20240514101043.476171987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit a112d3c72a227f2edbb6d8094472cc6e503e52af upstream.

The NVM configuration files used by WCN3988 and WCN3990/1/8 have two
sets of configuration tags that are enclosed by a type-length header of
type four which the current parser fails to account for.

Instead the driver happily parses random data as if it were valid tags,
something which can lead to the configuration data being corrupted if it
ever encounters the words 0x0011 or 0x001b.

As is clear from commit b63882549b2b ("Bluetooth: btqca: Fix the NVM
baudrate tag offcet for wcn3991") the intention has always been to
process the configuration data also for WCN3991 and WCN3998 which
encodes the baud rate at a different offset.

Fix the parser so that it can handle the WCN3xxx configuration files,
which has an enclosing type-length header of type four and two sets of
TLV tags enclosed by a type-length header of type two and three,
respectively.

Note that only the first set, which contains the tags the driver is
currently looking for, will be parsed for now.

With the parser fixed, the software in-band sleep bit will now be set
for WCN3991 and WCN3998 (as it is for later controllers) and the default
baud rate 3200000 may be updated by the driver also for WCN3xxx
controllers.

Notably the deep-sleep feature bit is already set by default in all
configuration files in linux-firmware.

Fixes: 4219d4686875 ("Bluetooth: btqca: Add wcn3990 firmware download support.")
Cc: stable@vger.kernel.org	# 4.19
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -281,6 +281,7 @@ static int qca_tlv_check_data(struct hci
 	struct tlv_type_patch *tlv_patch;
 	struct tlv_type_nvm *tlv_nvm;
 	uint8_t nvm_baud_rate = config->user_baud_rate;
+	u8 type;
 
 	config->dnld_mode = QCA_SKIP_EVT_NONE;
 	config->dnld_type = QCA_SKIP_EVT_NONE;
@@ -346,11 +347,30 @@ static int qca_tlv_check_data(struct hci
 		tlv = (struct tlv_type_hdr *)fw_data;
 
 		type_len = le32_to_cpu(tlv->type_len);
-		length = (type_len >> 8) & 0x00ffffff;
+		length = type_len >> 8;
+		type = type_len & 0xff;
 
-		BT_DBG("TLV Type\t\t : 0x%x", type_len & 0x000000ff);
+		/* Some NVM files have more than one set of tags, only parse
+		 * the first set when it has type 2 for now. When there is
+		 * more than one set there is an enclosing header of type 4.
+		 */
+		if (type == 4) {
+			if (fw_size < 2 * sizeof(struct tlv_type_hdr))
+				return -EINVAL;
+
+			tlv++;
+
+			type_len = le32_to_cpu(tlv->type_len);
+			length = type_len >> 8;
+			type = type_len & 0xff;
+		}
+
+		BT_DBG("TLV Type\t\t : 0x%x", type);
 		BT_DBG("Length\t\t : %d bytes", length);
 
+		if (type != 2)
+			break;
+
 		if (fw_size < length + (tlv->data - fw_data))
 			return -EINVAL;
 


