Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853541F1522;
	Mon, 23 Jun 2025 13:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684456; cv=none; b=oLYSIdJXgYwciwXlG5IqQZEo2jKMZSJw4gwmSt4I8WCrsZGJ40SD3ipQjMxQdnpTINRkZ986/KTa3/eVoQVA7kmEM/jvAcVrKfIZxL9KDw1CXPrx9wefmcDqfiJ+HBaABnVeWefGR4Z51jWGIz2A6CqFM3tvK3Bou7qwO7M+K5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684456; c=relaxed/simple;
	bh=ZcS9H8JHJKzq1UNmvmulh4r/AXXSFZZSXAjTcLEeEmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSOWiGgMyYgo0QcutpSOk+D4d/SrT61YCN+KbSAKWani2oY6iCkEf+V7BoG1g/XSVY9E0G5tQ7iBb9f+nUINWeHd7WEAfbT4OX6hKtNVu6+dSlXQsc+DMs9IWIBHRXaKfasE7DSMHdiEpCos3q4fRxfgII+I0MWv9nfigeDbh4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbY5U/6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbY5U/6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFC0C4CEEA;
	Mon, 23 Jun 2025 13:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684456;
	bh=ZcS9H8JHJKzq1UNmvmulh4r/AXXSFZZSXAjTcLEeEmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbY5U/6o31SMHOqREWXWFHNPZ6NCopQvXGJtYAyb5CwAeAF39IrpEV5kfq9LhRSe6
	 FgB4cpix2RYDVp9CTWGdYr3ZmDqXqY6ocjCuGhhJD+ul86cHQrKp5rOoNxveHZ0Dig
	 0Y1nWdtgKnTeuj249gkhB70jvpA3PX70L49JK0Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Robert Morris <rtm@mit.edu>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.15 031/592] wifi: p54: prevent buffer-overflow in p54_rx_eeprom_readback()
Date: Mon, 23 Jun 2025 14:59:49 +0200
Message-ID: <20250623130700.978966231@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@gmail.com>

commit da1b9a55ff116cb040528ef664c70a4eec03ae99 upstream.

Robert Morris reported:

|If a malicious USB device pretends to be an Intersil p54 wifi
|interface and generates an eeprom_readback message with a large
|eeprom->v1.len, p54_rx_eeprom_readback() will copy data from the
|message beyond the end of priv->eeprom.
|
|static void p54_rx_eeprom_readback(struct p54_common *priv,
|                                   struct sk_buff *skb)
|{
|        struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
|        struct p54_eeprom_lm86 *eeprom = (struct p54_eeprom_lm86 *) hdr->data;
|
|        if (priv->fw_var >= 0x509) {
|                memcpy(priv->eeprom, eeprom->v2.data,
|                       le16_to_cpu(eeprom->v2.len));
|        } else {
|                memcpy(priv->eeprom, eeprom->v1.data,
|                       le16_to_cpu(eeprom->v1.len));
|        }
| [...]

The eeprom->v{1,2}.len is set by the driver in p54_download_eeprom().
The device is supposed to provide the same length back to the driver.
But yes, it's possible (like shown in the report) to alter the value
to something that causes a crash/panic due to overrun.

This patch addresses the issue by adding the size to the common device
context, so p54_rx_eeprom_readback no longer relies on possibly tampered
values... That said, it also checks if the "firmware" altered the value
and no longer copies them.

The one, small saving grace is: Before the driver tries to read the eeprom,
it needs to upload >a< firmware. the vendor firmware has a proprietary
license and as a reason, it is not present on most distributions by
default.

Cc: <stable@kernel.org>
Reported-by: Robert Morris <rtm@mit.edu>
Closes: https://lore.kernel.org/linux-wireless/28782.1747258414@localhost/
Fixes: 7cb770729ba8 ("p54: move eeprom code into common library")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://patch.msgid.link/20250516184107.47794-1-chunkeey@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intersil/p54/fwio.c |    2 ++
 drivers/net/wireless/intersil/p54/p54.h  |    1 +
 drivers/net/wireless/intersil/p54/txrx.c |   13 +++++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -231,6 +231,7 @@ int p54_download_eeprom(struct p54_commo
 
 	mutex_lock(&priv->eeprom_mutex);
 	priv->eeprom = buf;
+	priv->eeprom_slice_size = len;
 	eeprom_hdr = skb_put(skb, eeprom_hdr_size + len);
 
 	if (priv->fw_var < 0x509) {
@@ -253,6 +254,7 @@ int p54_download_eeprom(struct p54_commo
 		ret = -EBUSY;
 	}
 	priv->eeprom = NULL;
+	priv->eeprom_slice_size = 0;
 	mutex_unlock(&priv->eeprom_mutex);
 	return ret;
 }
--- a/drivers/net/wireless/intersil/p54/p54.h
+++ b/drivers/net/wireless/intersil/p54/p54.h
@@ -258,6 +258,7 @@ struct p54_common {
 
 	/* eeprom handling */
 	void *eeprom;
+	size_t eeprom_slice_size;
 	struct completion eeprom_comp;
 	struct mutex eeprom_mutex;
 };
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -496,14 +496,19 @@ static void p54_rx_eeprom_readback(struc
 		return ;
 
 	if (priv->fw_var >= 0x509) {
-		memcpy(priv->eeprom, eeprom->v2.data,
-		       le16_to_cpu(eeprom->v2.len));
+		if (le16_to_cpu(eeprom->v2.len) != priv->eeprom_slice_size)
+			return;
+
+		memcpy(priv->eeprom, eeprom->v2.data, priv->eeprom_slice_size);
 	} else {
-		memcpy(priv->eeprom, eeprom->v1.data,
-		       le16_to_cpu(eeprom->v1.len));
+		if (le16_to_cpu(eeprom->v1.len) != priv->eeprom_slice_size)
+			return;
+
+		memcpy(priv->eeprom, eeprom->v1.data, priv->eeprom_slice_size);
 	}
 
 	priv->eeprom = NULL;
+	priv->eeprom_slice_size = 0;
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
 	dev_kfree_skb_any(tmp);
 	complete(&priv->eeprom_comp);


