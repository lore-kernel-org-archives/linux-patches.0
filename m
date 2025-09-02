Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4CA30BBBD;
	Tue,  2 Sep 2025 13:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819953; cv=none; b=hl7/U7QSxmzbGU+ndy5yX8g0j6MMdTQznIkXLAjfOCSQjMHXxvuEtW3ZXX8lqwFnCPSi88UVJ4lsniNpIZJ/WsXGAyELpKBdjG8N9KhhqA+Fgx1Sc/58ZrA82dcpHLZdZ9ne0gtS5md46mbp3uSR1MxFozVsC3YhvoKGMWQJryY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819953; c=relaxed/simple;
	bh=5aEUdK3XZbtZq6zvCsWH7qduKbHV4yHeiGIv2dxrsfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agzLTN9ljj4Ym2Jrz2HgnHkumacay8pF0lYOSHc64xF269mxxwT03b8xv9ue/dg8/oY/eyp8EbouIybe0Ievy1m2lsTbi3OQ4qtl9NjOmt58n95nCXiJ+V9/0vUNZbwKBpqMiZVPmo5Z+gEcslWQ1R1ZsSvTjOEcEtg7g4wFOSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=og2+yrda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="og2+yrda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E816FC4CEED;
	Tue,  2 Sep 2025 13:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819953;
	bh=5aEUdK3XZbtZq6zvCsWH7qduKbHV4yHeiGIv2dxrsfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=og2+yrdaVn+wjwB/mEe59pH8kvb/6kPv/YW30N2A16wwZZQOCs9vqHFRd2z2kIU6y
	 rclV0yaO/r6XImCpBJAgcsRjYR/BZl2GnwDHHiyfg0d65faI0NcFO8ElznFg5K8Pq9
	 XIn3k0T875eYGNQFYphX62ETPXTeh/aXSUDXuG0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludovico de Nittis <ludovico.denittis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 29/95] Bluetooth: hci_event: Treat UNKNOWN_CONN_ID on disconnect as success
Date: Tue,  2 Sep 2025 15:20:05 +0200
Message-ID: <20250902131940.730119428@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovico de Nittis <ludovico.denittis@collabora.com>

[ Upstream commit 2f050a5392b7a0928bf836d9891df4851463512c ]

When the host sends an HCI_OP_DISCONNECT command, the controller may
respond with the status HCI_ERROR_UNKNOWN_CONN_ID (0x02). E.g. this can
happen on resume from suspend, if the link was terminated by the remote
device before the event mask was correctly set.

This is a btmon snippet that shows the issue:
```
> ACL Data RX: Handle 3 flags 0x02 dlen 12
      L2CAP: Disconnection Request (0x06) ident 5 len 4
        Destination CID: 65
        Source CID: 72
< ACL Data TX: Handle 3 flags 0x00 dlen 12
      L2CAP: Disconnection Response (0x07) ident 5 len 4
        Destination CID: 65
        Source CID: 72
> ACL Data RX: Handle 3 flags 0x02 dlen 12
      L2CAP: Disconnection Request (0x06) ident 6 len 4
        Destination CID: 64
        Source CID: 71
< ACL Data TX: Handle 3 flags 0x00 dlen 12
      L2CAP: Disconnection Response (0x07) ident 6 len 4
        Destination CID: 64
        Source CID: 71
< HCI Command: Set Event Mask (0x03|0x0001) plen 8
        Mask: 0x3dbff807fffbffff
          Inquiry Complete
          Inquiry Result
          Connection Complete
          Connection Request
          Disconnection Complete
          Authentication Complete
[...]
< HCI Command: Disconnect (0x01|0x0006) plen 3
        Handle: 3 Address: 78:20:A5:4A:DF:28 (Nintendo Co.,Ltd)
        Reason: Remote User Terminated Connection (0x13)
> HCI Event: Command Status (0x0f) plen 4
      Disconnect (0x01|0x0006) ncmd 1
        Status: Unknown Connection Identifier (0x02)
```

Currently, the hci_cs_disconnect function treats any non-zero status
as a command failure. This can be misleading because the connection is
indeed being terminated and the controller is confirming that is has no
knowledge of that connection handle. Meaning that the initial request of
disconnecting a device should be treated as done.

With this change we allow the function to proceed, following the success
path, which correctly calls `mgmt_device_disconnected` and ensures a
consistent state.

Link: https://github.com/bluez/bluez/issues/1226
Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Signed-off-by: Ludovico de Nittis <ludovico.denittis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 768bd5fd808f2..428aba38a3654 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2694,7 +2694,7 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
 	if (!conn)
 		goto unlock;
 
-	if (status) {
+	if (status && status != HCI_ERROR_UNKNOWN_CONN_ID) {
 		mgmt_disconnect_failed(hdev, &conn->dst, conn->type,
 				       conn->dst_type, status);
 
-- 
2.50.1



