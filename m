Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173DB3064BB;
	Tue,  2 Sep 2025 13:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820183; cv=none; b=ZnkiKs/5Mqlohe17zw9mKkOaPkCd5HjkP8GpC4z3mZEg8oRxG6hXDcOYrU4lpWYBvuf++mG3RtcgJ5zm7JT6ofwqjKLPCZc/49TNsEV4SDif2rCyAhux2MpzEc8SbjsDa6kUjJIvypLGgPJRAPm9iOxATrdommjhT8IA2xbHkIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820183; c=relaxed/simple;
	bh=ey4vJud2LmCEg6NH6KWXC3UUjZZvDwTzwCKUfSoRSgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7YkkJdQf2zKG4EYO5ThTmvb/HEfXBqj7OtSeGd4pY4Ap9yfQn1amR+XC41ld95ykM0HlOurDixVCWQ7XudsbfQEkA/4ko6ZDH6+1YSHIN6VJLlnItDgK1NR0naix19CF4IUyvQrzLSXMRZP2NF9SYRNkN0SbEYWmaa7JPrJ7do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8TH2WUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8TH2WUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413DCC4CEED;
	Tue,  2 Sep 2025 13:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820181;
	bh=ey4vJud2LmCEg6NH6KWXC3UUjZZvDwTzwCKUfSoRSgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8TH2WUxC1bRgVWh5Ahm6FwBBcJYL1Y/rg5isl34y2QZnKFhFksWY9DkUvu5sC704
	 3+RmvUWGhvHyUeIa5IqTcbgWKAkSh1q3POWbQaPuofkSrn76wO11IXKDdGm8ci4ZEW
	 6N2i+ldzwma0RJ04DaAjrvQK86Llw1l1YA2XjRuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludovico de Nittis <ludovico.denittis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/75] Bluetooth: hci_event: Mark connection as closed during suspend disconnect
Date: Tue,  2 Sep 2025 15:20:35 +0200
Message-ID: <20250902131936.028989423@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovico de Nittis <ludovico.denittis@collabora.com>

[ Upstream commit b7fafbc499b5ee164018eb0eefe9027f5a6aaad2 ]

When suspending, the disconnect command for an active Bluetooth
connection could be issued, but the corresponding
`HCI_EV_DISCONN_COMPLETE` event might not be received before the system
completes the suspend process. This can lead to an inconsistent state.

On resume, the controller may auto-accept reconnections from the same
device (due to suspend event filters), but these new connections are
rejected by the kernel which still has connection objects from before
suspend. Resulting in errors like:
```
kernel: Bluetooth: hci0: ACL packet for unknown connection handle 1
kernel: Bluetooth: hci0: Ignoring HCI_Connection_Complete for existing
connection
```

This is a btmon snippet that shows the issue:
```
< HCI Command: Disconnect (0x01|0x0006) plen 3
        Handle: 1 Address: 78:20:A5:4A:DF:28 (Nintendo Co.,Ltd)
        Reason: Remote User Terminated Connection (0x13)
> HCI Event: Command Status (0x0f) plen 4
      Disconnect (0x01|0x0006) ncmd 2
        Status: Success (0x00)
[...]
// Host suspends with the event filter set for the device
// On resume, the device tries to reconnect with a new handle

> HCI Event: Connect Complete (0x03) plen 11
        Status: Success (0x00)
        Handle: 2
        Address: 78:20:A5:4A:DF:28 (Nintendo Co.,Ltd)

// Kernel ignores this event because there is an existing connection
with
// handle 1
```

By explicitly setting the connection state to BT_CLOSED we can ensure a
consistent state, even if we don't receive the disconnect complete event
in time.

Link: https://github.com/bluez/bluez/issues/1226
Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Signed-off-by: Ludovico de Nittis <ludovico.denittis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fb5e4e4858f77..a07ad1c99a4b0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2707,6 +2707,12 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
 		goto done;
 	}
 
+	/* During suspend, mark connection as closed immediately
+	 * since we might not receive HCI_EV_DISCONN_COMPLETE
+	 */
+	if (hdev->suspended)
+		conn->state = BT_CLOSED;
+
 	mgmt_conn = test_and_clear_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags);
 
 	if (conn->type == ACL_LINK) {
-- 
2.50.1



