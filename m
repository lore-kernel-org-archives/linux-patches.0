Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0043A1F60A;
	Mon,  4 Mar 2024 21:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587764; cv=none; b=oWj1IP3y4g52QUVi4ueqnqTSWcBLxAcwQGRRAkS6edcoolvSvDE5cXZZar9B42XpDtKF+Q4vB+pm4lYfRe/x+2+QxohE0iHigLHlvAAo0hbb4GyyuchOjKnMq9ikzsfZ5RUWf3ALh8RsiGjSFEdSL+lVfaipfbaiRhdcrC4azwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587764; c=relaxed/simple;
	bh=ls4m0Dag+rVZe+iYzn3VAS2BTpoO7xljaRpw4TLhAXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssS8z0EsmcYSfEX7uiDc257259YlH6lE6WIxfgg9NmSZI7NsqoBYsOWgNKMBMQiCPHOwfU0ZgC/XXuduRrOc3p2+DdWZuNPSBYiJECKuLBwmeVCLr6m6w7MA64VMLJDE34f1ATl3LFcFJvCnjcN/Bg9Am8s8JOFnkfhj18yqwOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRQVd/um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRQVd/um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D0CC433F1;
	Mon,  4 Mar 2024 21:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587763;
	bh=ls4m0Dag+rVZe+iYzn3VAS2BTpoO7xljaRpw4TLhAXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRQVd/umsRlx0YE1U13O09iu/tVCYfpLr1s/NVZGq23sORyi4Sdg7EWpXX/JUtBl6
	 o3hKxegx40UV4rmjOJs67uwoqEYfv4KuKfNmB+8i+G6mJEfyEzq0Ar8abIFi4rqO3I
	 SXD7MBIRTTGvZEB/bmR05w4TPqdVI/Yx+2D0Tuaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Zhang <mrman@mrman314.tech>,
	Johan Hovold <johan+linaro@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.7 081/162] Bluetooth: hci_bcm4377: do not mark valid bd_addr as invalid
Date: Mon,  4 Mar 2024 21:22:26 +0000
Message-ID: <20240304211554.430628995@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


