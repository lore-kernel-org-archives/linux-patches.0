Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355B8F58;
	Mon,  4 Mar 2024 21:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588400; cv=none; b=EbQiSxoBSLPiJf4cfJCoUb9D2F4XdX+Hm+GCzg6cwd49LnH5sWUM8oCcYlcFFcHJFDcBUXGtlg0jGhHkRf+shCQe1zc4vi6a6smL+vKcmh/ejV+3cD7DUo3PjhNhJe9H/Sh+C/EtSLo7ekCptQkyhS3dqIbVvaTphr6hereS22o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588400; c=relaxed/simple;
	bh=F3e4crSfJSJ9VkitZ0TaRm+3lSFEAGRjRaQZvzuxWFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDY7rXnyddWtekxjnrzmJMG49F4QST5KMxx9dxmUyE1ZVFPrq0Rs1bASswCjRsIyiABd0Ux1MnXz8FWG+WPVBamm9lc+No7a1PTTqJMcIgNSZ/4BwcJpuzfwifUtr0ikeqC7V4AG+yhDZ+KdArRXXFOkrtKiWby1e+5QVMUfbQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jykMK/HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jykMK/HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E20C433F1;
	Mon,  4 Mar 2024 21:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588400;
	bh=F3e4crSfJSJ9VkitZ0TaRm+3lSFEAGRjRaQZvzuxWFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jykMK/HQfub5M2GzMg1loLr4kj00DvlUBfR3hk5aX3gmgLnlcVLPzZKV3QsFUgUBh
	 cHfoz8C6UhGleWMvi3A3O1rHY6SXyXuYS6PYlQT+eHz/yDKfpCm5LIHpsPDJGCSr+T
	 MIY9AXNiH0AlUKfoYEX8pfFkdM7V9/FCGoPrHVbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Zhang <mrman@mrman314.tech>,
	Johan Hovold <johan+linaro@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 075/143] Bluetooth: hci_bcm4377: do not mark valid bd_addr as invalid
Date: Mon,  4 Mar 2024 21:23:15 +0000
Message-ID: <20240304211552.314543750@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

commit c17d2a7b216e168c3ba62d93482179c01b369ac7 upstream.

A recent commit restored the original (and still documented) semantics
for the HCI_QUIRK_USE_BDADDR_PROPERTY quirk so that the device address
is considered invalid unless an address is provided by firmware.

This specifically means that this flag must only be set for devices with
invalid addresses, but the Broadcom BCM4377 driver has so far been
setting this flag unconditionally.

Fortunately the driver already checks for invalid addresses during setup
and sets the HCI_QUIRK_INVALID_BDADDR flag, which can simply be replaced
with HCI_QUIRK_USE_BDADDR_PROPERTY to indicate that the default address
is invalid but can be overridden by firmware (long term, this should
probably just always be allowed).

Fixes: 6945795bc81a ("Bluetooth: fix use-bdaddr-property quirk")
Cc: stable@vger.kernel.org      # 6.5
Reported-by: Felix Zhang <mrman@mrman314.tech>
Link: https://lore.kernel.org/r/77419ffacc5b4875e920e038332575a2a5bff29f.camel@mrman314.tech/
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reported-by: Felix Zhang <mrman@mrman314.tech>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm4377.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -1417,7 +1417,7 @@ static int bcm4377_check_bdaddr(struct b
 
 	bda = (struct hci_rp_read_bd_addr *)skb->data;
 	if (!bcm4377_is_valid_bdaddr(bcm4377, &bda->bdaddr))
-		set_bit(HCI_QUIRK_INVALID_BDADDR, &bcm4377->hdev->quirks);
+		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &bcm4377->hdev->quirks);
 
 	kfree_skb(skb);
 	return 0;
@@ -2368,7 +2368,6 @@ static int bcm4377_probe(struct pci_dev
 	hdev->set_bdaddr = bcm4377_hci_set_bdaddr;
 	hdev->setup = bcm4377_hci_setup;
 
-	set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 	if (bcm4377->hw->broken_mws_transport_config)
 		set_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &hdev->quirks);
 	if (bcm4377->hw->broken_ext_scan)


