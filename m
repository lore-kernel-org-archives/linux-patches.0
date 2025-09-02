Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5AD30AAB4;
	Tue,  2 Sep 2025 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819487; cv=none; b=XkAqB2Rs95mw8CTfMlY7u8u8N4imlocJVmJOteGpPDsg7slYHI4pyZ5ZGd1TxzZzEaRbtsFOEh/SszxUZZuBGfWQUyAmHbDqajWpLuIGBlnSYd5oo63lQLQ1VZB6L2JP8vWyQzsPE47vj4kZqQpdGX/52mM1IPnBSr7d319bt/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819487; c=relaxed/simple;
	bh=dFF+tTA9JlVT+m1J30BkVDkiw2UB03zDJ/TwlGpBUCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCez4iayvEJscQVo22y3upOl4nMiA5pp8126ZQBqtvBswii1NpzOsxeRokaaqizQLS+M4gQZJQJ95Rl9T8xHXwe3mgBdEZyaRrqxoHEgng1yQi3yJq6twCY0as5rAsTSDrEMZsMZm4THA3uW8jLClc1ua168W905ODegD61NRfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGJHT830; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGJHT830"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F41CC4CEED;
	Tue,  2 Sep 2025 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819486;
	bh=dFF+tTA9JlVT+m1J30BkVDkiw2UB03zDJ/TwlGpBUCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGJHT830XHiH9fuU5CHBoOHjYurjBfWA/iEobWn6xp2LT464bpuhirlCZJf4OJpIH
	 ZusKUztKdvzmk+Ho3//raW64cwT9z3e/uaUXxdjn54I5Tifo15XGmEtybDxi4glW8D
	 UwmTDXwCoohRNBGAmwuS5DDYoyMjS2ajG2OR6hqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludovico de Nittis <ludovico.denittis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 048/142] Bluetooth: hci_event: Mark connection as closed during suspend disconnect
Date: Tue,  2 Sep 2025 15:19:10 +0200
Message-ID: <20250902131950.093759249@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 1902982538da7..cadb53e21c0ef 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2718,6 +2718,12 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
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



