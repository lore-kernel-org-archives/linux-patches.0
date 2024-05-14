Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28D54F1E5;
	Tue, 14 May 2024 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686011; cv=none; b=R5BTvi1szfDUzq7bw3BCaAiSyc34WMTR6JIRovvmFqdDphjYgDPCfninbFtLEkvqgnoUM+d+MJCUqWoSVMSA8ZEZRZmMBXjiKSXIAC4OSZDtFZxMjOLy/Upa6Jx1EIMUAM0Mlop1FFPaXUKEk4ZSqb366cJfpO3rij91K8TpD5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686011; c=relaxed/simple;
	bh=IbTzhlLPRIrl3ec2SupDyk5fKYYFtZwylKHY3TaKfVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPr/N6xn8KcvVB+jPXsnoM4fcFCbfqRSAJtYhaOof8l319orkiwTJxHopa7tIB+DROvRu1hRRvnhITdG7/77c8oeos/eau8t/AK8gs8NCitGp1nwYwJEauUrzdvDPjUp1nYCM9FmkdbK2kNhcFMBbkOXG+ecjqgUJmB3+t6neow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVBAE4FB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVBAE4FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9E3C2BD10;
	Tue, 14 May 2024 11:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686011;
	bh=IbTzhlLPRIrl3ec2SupDyk5fKYYFtZwylKHY3TaKfVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVBAE4FB5MOOgz0vAXKrdBh6XunaiGb0vtDliaQkMfoLy3iJ7V5zQKtuWksoFdXJX
	 quwVnrc8Hw82wRp2gqQc7uNs2HnBYryVKEgNFzIF+Xft5HzRagU7HNqhRzuMv8IbGA
	 5Ql75GBDarME09dys/OMGqZox5Kjew7A3RFG3+n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 295/301] Bluetooth: qca: fix wcn3991 device address check
Date: Tue, 14 May 2024 12:19:26 +0200
Message-ID: <20240514101043.398893832@linuxfoundation.org>
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
 drivers/bluetooth/btqca.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 216826c31ee3..cfa71708397b 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -16,6 +16,7 @@
 #define VERSION "0.1"
 
 #define QCA_BDADDR_DEFAULT (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x00, 0x00 }})
+#define QCA_BDADDR_WCN3991 (&(bdaddr_t) {{ 0xad, 0x5a, 0x00, 0x00, 0x98, 0x39 }})
 
 int qca_read_soc_version(struct hci_dev *hdev, struct qca_btsoc_version *ver,
 			 enum qca_btsoc_type soc_type)
@@ -638,8 +639,10 @@ static int qca_check_bdaddr(struct hci_dev *hdev)
 	}
 
 	bda = (struct hci_rp_read_bd_addr *)skb->data;
-	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT))
+	if (!bacmp(&bda->bdaddr, QCA_BDADDR_DEFAULT) ||
+	    !bacmp(&bda->bdaddr, QCA_BDADDR_WCN3991)) {
 		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
+	}
 
 	kfree_skb(skb);
 
-- 
2.45.0



