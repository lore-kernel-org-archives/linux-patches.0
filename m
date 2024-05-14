Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEF642A9C;
	Tue, 14 May 2024 10:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684135; cv=none; b=fkREGTqzduvoIV2xGTZfFhAJ3x/1g2e4qCV0mp1XRS1thQ4imvI9Igp1s77XO71BgM09t6zgB0ctThPBBlxB/g3W99Qswhn/NuTqLP9VxbgsxPGkL0SikiJ9uHQeq8z2bgxd0iuAYs1nTgrhpRY27yEDjqlw+6gsOr1CqmSdxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684135; c=relaxed/simple;
	bh=67J8LL0YcD5lh++KMtikNUWtNQRO3kWIvgX14NilzF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwpUJ8q2mPWKRCleycSXlNfY7LwfcZYb8akHmmNICzIGnAY4JrpbBa19b1pM7YehpwkIcNyK51LmMaEUWI18JJ2tAtiKwk7Ms/fEG4ohEFvh9UWRlINeLw/n7cFuZr4YGtJTNlj1MaES0RhT+rTEhp4OzALtvR7sMSzL9Ch293Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbfCM440; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbfCM440"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EE7C2BD10;
	Tue, 14 May 2024 10:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684135;
	bh=67J8LL0YcD5lh++KMtikNUWtNQRO3kWIvgX14NilzF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbfCM440hEgWyghAlH+qXHO1iyLxXQreUCoaVQJYj7+xdVd4utfZILdihKSDt5f+G
	 JWSX1A/5WuXOLgVGUMpl/2xhKn1pZ5k+m8brouKW2XjKjz9GqiiucjwSNXNzrZP4Qx
	 XLse1Rei6pmyIyj7X/Kty3icFNbOc3JvsYUkU1Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 330/336] Bluetooth: qca: fix wcn3991 device address check
Date: Tue, 14 May 2024 12:18:54 +0200
Message-ID: <20240514101051.083350843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 66c39332d02d65e311ec89b0051130bfcd00c9ac upstream.

Qualcomm Bluetooth controllers may not have been provisioned with a
valid device address and instead end up using the default address
00:00:00:00:5a:ad.

This address is now used to determine if a controller has a valid
address or if one needs to be provided through devicetree or by user
space before the controller can be used.

It turns out that the WCN3991 controllers used in Chromium Trogdor
machines use a different default address, 39:98:00:00:5a:ad, which also
needs to be marked as invalid so that the correct address is fetched
from the devicetree.

Qualcomm has unfortunately not yet provided any answers as to whether
the 39:98 encodes a hardware id and if there are other variants of the
default address that needs to be handled by the driver.

For now, add the Trogdor WCN3991 default address to the device address
check to avoid having these controllers start with the default address
instead of their assigned addresses.

Fixes: 32868e126c78 ("Bluetooth: qca: fix invalid device address check")
Cc: stable@vger.kernel.org      # 6.5
Cc: Doug Anderson <dianders@chromium.org>
Cc: Janaki Ramaiah Thota <quic_janathot@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -16,6 +16,7 @@
 #define VERSION "0.1"
 
 #define QCA_BDADDR_DEFAULT (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x00, 0x00 }})
+#define QCA_BDADDR_WCN3991 (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x98, 0x39 }})
 
 int qca_read_soc_version(struct hci_dev *hdev, struct qca_btsoc_version *ver,
 			 enum qca_btsoc_type soc_type)
@@ -638,8 +639,10 @@ static int qca_check_bdaddr(struct hci_d
 	}
 
 	bda = (struct hci_rp_read_bd_addr *)skb->data;
-	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT))
+	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT) ||
+	    !bacmp(&bda->bdaddr, QCA_BDADDR_WCN3991)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
+	}
 
 	kfree_skb(skb);
 


