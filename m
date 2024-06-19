Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E90C147C6E;
	Wed, 19 Jun 2024 13:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804140; cv=none; b=lSeXUB9HuPbVM5hGNyed5eugbqUWSlECOu99mUuzZMtiCwkLSP00kGBPKhpo7yi9lLPLUUw4R7e/GkJ+/7Xt8+Cc/GGSegZLwMWTL09QqURiQ82N+/r2jJLO2TRrFJJ9eYzaj3tijRz5GPs+guEuTMBn0vB5s6nqnAvyWdYCN6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804140; c=relaxed/simple;
	bh=tAY0Dc9FpLb7UAGd5uIWAwdmb6dZQS0YuPV9RCEFoz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9VE2fjr+k/7mB8662Bjiji1qy4TU5TW4rwKRWzA08wTaQ8bdtPDYz60HroUaioQnoOycOtMVW082L8yanDyRZ+P09Ulgi34LucmRNdyLysne1ko/C3vttcybR7x1OMWS13xHWmoeD8Oxp2bqUFSbxnYRuScuHbEnbQHUz+5QtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAdhf6PK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAdhf6PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743D2C4AF1D;
	Wed, 19 Jun 2024 13:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804139;
	bh=tAY0Dc9FpLb7UAGd5uIWAwdmb6dZQS0YuPV9RCEFoz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAdhf6PKhfA0W+StLwJsa0nKDzCOHoybFDutK7XXRC9JWP4HF/5EhU/dXK2BnEfWp
	 m+wseYRPtuJAoDqJgnAM2E1MfCHMabO05bYSTdQdK5RWZKpSp+6eXuEa8bpbva/InT
	 iGQQPS5IP0OFWzHZGmdhBkFFUYwVj8BFjD3LOmio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 208/217] Bluetooth: qca: fix wcn3991 device address check
Date: Wed, 19 Jun 2024 14:57:31 +0200
Message-ID: <20240619125604.717499475@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
@@ -708,8 +709,10 @@ static int qca_check_bdaddr(struct hci_d
 	}
 
 	bda = (struct hci_rp_read_bd_addr *)skb->data;
-	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT))
+	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT) ||
+	    !bacmp(&bda->bdaddr, QCA_BDADDR_WCN3991)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
+	}
 
 	kfree_skb(skb);
 


