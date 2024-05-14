Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1F12E1F7;
	Tue, 14 May 2024 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686711; cv=none; b=RFl4Jpw5CBv1/MCl9lskW5ul8UbAbaEmR4m6jegFSPWqC9piQpkUVIXNoZaaxHU340J5j5FxF+3RTlUyH+B3aQYj4MNI+lNChCR5qpR42JvSGzV538ZtGKG5P5NVma845LMJOQ3+E3TGwC60OSjJGYYjwl/3SVh+pQ4gnnqAAn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686711; c=relaxed/simple;
	bh=f1+9I12bUpKHpuj2dp+t2hGbsgvlVLyVhGEGHU6tqZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGCrSmNP8IMhS4qTZ0IFB+Sfaxd8zAPAnWMq6qdA/73ZJJYL0WrJjV/cZrRcoB1YH5TiZCiSxrDm4XFpMqZj9FJL6/EAAfjS8bq+6hOet8bMezIzAiERO6FyfB0Pw5Qsdmv93IDreLty2Ga331wYc+FJgSDRT2Z5RbrDH+C0WDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyrZBhar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyrZBhar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087D0C2BD10;
	Tue, 14 May 2024 11:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686711;
	bh=f1+9I12bUpKHpuj2dp+t2hGbsgvlVLyVhGEGHU6tqZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyrZBharpqGKQxlSFmcb5jYxEO+GhDvCdxgBT+HGqvJjjV+9UF4HvhC/0V7f5gAx/
	 okNA9xuXmocxlzzEVYPWOuBmfInD7FIabpAtV46A/ZkcRHVIdQWdlSxqgTeSIF1SiB
	 F5OPzSmT/ABAEfZzsn8VmkSNklpgoziVwhSv5wOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 233/236] Bluetooth: qca: fix NVM configuration parsing
Date: Tue, 14 May 2024 12:19:55 +0200
Message-ID: <20240514101029.203378400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -278,6 +278,7 @@ static int qca_tlv_check_data(struct hci
 	struct tlv_type_patch *tlv_patch;
 	struct tlv_type_nvm *tlv_nvm;
 	uint8_t nvm_baud_rate = config->user_baud_rate;
+	u8 type;
 
 	config->dnld_mode = QCA_SKIP_EVT_NONE;
 	config->dnld_type = QCA_SKIP_EVT_NONE;
@@ -343,11 +344,30 @@ static int qca_tlv_check_data(struct hci
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
 


