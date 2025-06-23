Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB4A70838;
	Mon, 23 Jun 2025 21:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713010; cv=none; b=jUDZyBqiZndQuFudvDWiI6v48elIG6C0nhg/O35wFAikjPJhcOB8pwmMT7mnPhVOYgWHku53ZcKzRfMQWA/CRnisM28Cinzyp6yRTsjbL1bhJItiiKLsLNbm4zK9+iUxnKqRHukbAOtr8j/um5Z3jUGkHH6W3VOdadbVTPnvA+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713010; c=relaxed/simple;
	bh=gP3Llo70KNnZF4RJESCyMUV0PKCLvgul+RkiwNBVTv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtgSMqxH/Ols34mI1/LXfZu7VhA+Gx9xjr8hLg7P/ZzjAXBXHPf9gFdpKJ2veOJ/YGGvNY0zKvUOUjNosL9T259nx1nbEq0E3htW/+9A7nXXOGByNdKTRxhv095lUv/Yskh9fO4mjRGoLOn5QlfS94WYLuTDX+PvrrM27HCLzmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bl9IE+GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bl9IE+GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E0AC4CEEA;
	Mon, 23 Jun 2025 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713009;
	bh=gP3Llo70KNnZF4RJESCyMUV0PKCLvgul+RkiwNBVTv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bl9IE+GEJHW4XTLKMbx6K3dYyp5AdJMN8j3x1Zgn3U1t8UgL5fOBGTo1Z8xyISd7G
	 /cHQ3Y3z2lw9EzviUsy2U/F1GIXWqWSl1z/M1I9fOn0qFaRSPocAqbV2Jxi3K8sX0u
	 sa6rdhdYwOHDdQZYFUPblg3A5op7tzSw+h956vDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Robert Morris <rtm@mit.edu>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 023/414] wifi: p54: prevent buffer-overflow in p54_rx_eeprom_readback()
Date: Mon, 23 Jun 2025 15:02:40 +0200
Message-ID: <20250623130642.606606437@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


