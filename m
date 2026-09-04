Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA332F9DA1;
	Fri,  4 Sep 2026 05:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501148; cv=none; b=Btt1+Tx6tVHDdhflpUi4mHqmtO8+Oh02ENxJ4oL9242F9CElLsdAlbxj5/NRTAaWbQ4wOhCCqbEEz4O85i2SHP2ewa0WNmSfnEOO04DysXHVskLdOWWuvnc+p/bWMUmJDmEiuao01qOCnAwk2evT/1r+QKkSMIcIkdAMLlNP62A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501148; c=relaxed/simple;
	bh=gyjt65jz3HGKNpbYghbIAarFlzyWnR9ZwKubsLA2GMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MejS+5fO/k1ZKt/DRQd1LvDAK7H4VCOGnOdxo1ti2sCVF2zZlNXvwHYuwWruIK8QNYfBkGNuyd+UvSblTTj58MvDRokdgCuy+N2XFEyK3PDmgGz483bS5sjyRaa7txT3mFwUOZEwtJLI5Foo9VEW/APhCVBPHi6Rau2yS0PoRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZUkH+dP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZUkH+dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C657D1F00A3D;
	Fri,  4 Sep 2026 05:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501147;
	bh=mnQp10pf2HSl6qUfbiqXGqAZvN9pClxxNSBl1id6MA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZUkH+dPtwRTBTLFfU8/y+hBJD8nbXpCJfCKyrMCcYYTxfn8mnoBqyzvBYFpI8OLI
	 uG99EI38uYjjE/S1ZLBrvdyGeQDvXuIIvkPZ5HqNFlokgTQ6PwJEcSpDdcncPdsCMx
	 dzJEM6YmD7QmxLw8gk9RbfQu7ki8BFa+lSg37638=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 254/552] Bluetooth: hci_sync: Clear HCI_CMD_PENDING when dropping the last request
Date: Fri,  4 Sep 2026 06:56:51 +0200
Message-ID: <20260904045755.458484043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5300,6 +5300,7 @@ int hci_dev_open_sync(struct hci_dev *hd
 		if (hdev->req_skb) {
 			kfree_skb(hdev->req_skb);
 			hdev->req_skb = NULL;
+			hci_dev_clear_flag(hdev, HCI_CMD_PENDING);
 		}
 
 		clear_bit(HCI_RUNNING, &hdev->flags);
@@ -5484,6 +5485,7 @@ int hci_dev_close_sync(struct hci_dev *h
 	if (hdev->req_skb) {
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = NULL;
+		hci_dev_clear_flag(hdev, HCI_CMD_PENDING);
 	}
 
 	clear_bit(HCI_RUNNING, &hdev->flags);


