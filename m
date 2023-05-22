Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CC7171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C750C433EF;
	Mon, 22 May 2023 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783175;
	bh=Lrk0sCmNEkxtu2/MlJ+jrJS74kP+1R0OConkS7V2rIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9LUcXkbuJhKvn45Eso2XHZTKZ8s4jIwEaKvb9PDsar9wdhTNujKZBIpW4+H/rvnc
	 qkvnhRt++ow0XvMOUCwXZIYTotusdmjd5PUMFpYjynMU3/BRhrGbcEAda66DN/Ip0P
	 gVSJ5fZ1QPgvohUyneDV+LolRFtWwxHVYmlI9C5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Subject: [PATCH 5.15 164/203] USB: UHCI: adjust zhaoxin UHCI controllers OverCurrent bit value
Date: Mon, 22 May 2023 20:09:48 +0100
Message-Id: <20230522190359.513485012@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weitao Wang <WeitaoWang-oc@zhaoxin.com>

commit dddb342b5b9e482bb213aecc08cbdb201ea4f8da upstream.

OverCurrent condition is not standardized in the UHCI spec.
Zhaoxin UHCI controllers report OverCurrent bit active off.
In order to handle OverCurrent condition correctly, the uhci-hcd
driver needs to be told to expect the active-off behavior.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230423105952.4526-1-WeitaoWang-oc@zhaoxin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/uhci-pci.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -119,11 +119,13 @@ static int uhci_pci_init(struct usb_hcd
 
 	uhci->rh_numports = uhci_count_ports(hcd);
 
-	/* Intel controllers report the OverCurrent bit active on.
-	 * VIA controllers report it active off, so we'll adjust the
-	 * bit value.  (It's not standardized in the UHCI spec.)
+	/*
+	 * Intel controllers report the OverCurrent bit active on.  VIA
+	 * and ZHAOXIN controllers report it active off, so we'll adjust
+	 * the bit value.  (It's not standardized in the UHCI spec.)
 	 */
-	if (to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_VIA)
+	if (to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_VIA ||
+			to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_ZHAOXIN)
 		uhci->oc_low = 1;
 
 	/* HP's server management chip requires a longer port reset delay. */


