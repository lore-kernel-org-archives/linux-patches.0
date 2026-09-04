Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F72541A574;
	Fri,  4 Sep 2026 06:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502498; cv=none; b=TatzaYBTuGF/1g3JnQ1G+dWUdsv8H7AwLNjQSEgOAU8iygoXDvtt3H63gyyigo1rSMy47SpCijCRCMZ2vIcMYFvzo9Fj1jHxBmr9kGHONklQv4un27YrP4Yaw8Xf0d+2/L+gO14Yp2Ig97WlZSinrdu3Omd1c65OnMrVmTUk0sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502498; c=relaxed/simple;
	bh=piRjJ1wNGfajBzXFhU7UsP8pyvwWj8JXucqxXsJBs/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t931BnIQ99l/s1uz2pAmyoVfGFI2/Ez2Rn6S6U82P7vtHsdxx/DTUfF/YultMZ4whTLLX3P1H/tZCxAp2Q0biWVHVghAJkKsfyJhbS2upcSSqVPYDkknjEDcDUr0Cq/4goCoqiS3i2wZH7KhnMxKmIPcUr4aA1gmT/xpggYqYZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UegLIvXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UegLIvXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CBF1F00A3D;
	Fri,  4 Sep 2026 06:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502496;
	bh=/vWweQfEzCXWO7T3qoXlCtWd2KfVh4I3X5C+Lo0XI4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UegLIvXxGCoh+fi8OMWoBF7a+gPTOwl9OUwzLtaHpoNp8qrVPNe7bLfb8iigN4Qun
	 GBUpIzUQN5L2rGs/8kgVE7yHhQLJJBY8P2CdaIaDC7PP32ylImSBKjk85eMLii34OO
	 lJuFWcVBO3ufiRjiynD+U0etetPwgskuvAQ8kxS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 185/403] Bluetooth: hci_sync: Clear HCI_CMD_PENDING when dropping the last request
Date: Fri,  4 Sep 2026 06:59:48 +0200
Message-ID: <20260904045739.062535164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>

commit cb19774faa57c51efa189d8b8606aeabccebc53b upstream.

A synchronous HCI command that never receives a response leaves
HCI_CMD_PENDING set: hci_req_cmd_complete() is the only place that clears
it, and it only runs when a response matching the last command sent
arrives.

hci_send_cmd_sync() populates hdev->req_skb only when the flag transitions
from clear to set, while hci_dev_open_sync() and hci_dev_close_sync() drop
req_skb without clearing the flag. After a timeout followed by either, the
two disagree: the flag claims a request is outstanding while req_skb is
NULL. Subsequent synchronous commands are then sent with no req_skb, so
hci_event_packet() has nothing to match an arriving event against, and the
caller times out even though the controller answered.

Commands answered by Command Complete recover on their own, since
hci_req_cmd_complete() clears the flag as a side effect. Drivers using
__hci_cmd_sync_ev() with a custom event do not, because a vendor event
never reaches that path. On a WCN3988 (hci_qca over UART) this makes a
controller firmware hang unrecoverable: the driver injects a hardware
error and re-runs qca_setup(), qca_read_soc_version() waits for
HCI_EV_VENDOR, the reply arrives within 4 ms and is discarded, and every
retry fails the same way. The adapter is left down until the driver is
unbound and rebound, or power is removed.

Clear the flag wherever the last request is dropped, restoring the
invariant that req_skb is non-NULL exactly when HCI_CMD_PENDING is set.
Verified on hardware by forcing a command timeout: without this change
setup fails on every attempt, with it setup succeeds on the first.

Fixes: 2615fd9a7c25 ("Bluetooth: hci_sync: Fix overwriting request callback")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5276,6 +5276,7 @@ int hci_dev_open_sync(struct hci_dev *hd
 		if (hdev->req_skb) {
 			kfree_skb(hdev->req_skb);
 			hdev->req_skb = NULL;
+			hci_dev_clear_flag(hdev, HCI_CMD_PENDING);
 		}
 
 		clear_bit(HCI_RUNNING, &hdev->flags);
@@ -5456,6 +5457,7 @@ int hci_dev_close_sync(struct hci_dev *h
 	if (hdev->req_skb) {
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = NULL;
+		hci_dev_clear_flag(hdev, HCI_CMD_PENDING);
 	}
 
 	clear_bit(HCI_RUNNING, &hdev->flags);


