Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687683ACA68;
	Mon, 23 Mar 2026 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274224; cv=none; b=csRzaosZ93Z1RQBOzcZ2JT7MyPt7yvpCO8XU8oOe0sXMXAHJMB0pX8blKQT4TlRPZDI0B30nFNAXclJv9K7Ey+N2wl225x6TkKP7S7nR9UCxfQ6wij8pp/FNJVDQEmluTujnSku1m58MpG/l9eP0o91m9uQZRswNvfoWyUzG2sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274224; c=relaxed/simple;
	bh=sBJY3uu+TeXWCHSBLksv50IKCLw7P86HReyFSFim+Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD1qxTA9+ouJZlioD1HTf5c4zZkQyBqCsVdyrDPz80U+vDO1fGBNfGgVncoCGQPM2ID5rFVOPT34rQsH2fVVwHkWot1dZMp4wK5U/H33ryrd6vH0dT0j6J9NXFfzxsuRzlfv9JJwQKqKoevTeOM2MTOYHoY82wZXLlsYrQMoJ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sn82zgdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sn82zgdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EC9C2BC9E;
	Mon, 23 Mar 2026 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274224;
	bh=sBJY3uu+TeXWCHSBLksv50IKCLw7P86HReyFSFim+Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sn82zgdxD4xO+Qwa+oc11I/w7lnLgJ4unh57PGaanJJ5U59rtIMo0J3zE0g6yQDDK
	 Rbq43jccgzbmH6yMsAggOo9bX9P4/kKJDQrowkt6rduk3hWzGO7AtB4LSzO1G5k8gT
	 rsiDOFSXmVuZL9bFkysBpPVb0/tLztvnaa7zQXzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 122/220] Bluetooth: hci_sync: Fix hci_le_create_conn_sync
Date: Mon, 23 Mar 2026 14:44:59 +0100
Message-ID: <20260323134508.448823205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 2cabe7ff1001b7a197009cf50ba71701f9cbd354 ]

While introducing hci_le_create_conn_sync the functionality
of hci_connect_le was ported to hci_le_create_conn_sync including
the disable of the scan before starting the connection.

When this code was run non synchronously the immediate call that was
setting the flag HCI_LE_SCAN_INTERRUPTED had an impact. Since the
completion handler for the LE_SCAN_DISABLE was not immediately called.
In the completion handler of the LE_SCAN_DISABLE event, this flag is
checked to set the state of the hdev to DISCOVERY_STOPPED.

With the synchronised approach the later setting of the
HCI_LE_SCAN_INTERRUPTED flag has not the same effect. The completion
handler would immediately fire in the LE_SCAN_DISABLE call, check for
the flag, which is then not yet set and do nothing.

To fix this issue and make the function call work as before, we move the
setting of the flag HCI_LE_SCAN_INTERRUPTED before disabling the scan.

Fixes: 8e8b92ee60de ("Bluetooth: hci_sync: Add hci_le_create_conn_sync")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 80b601e344ae3..43b36581e336d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6596,8 +6596,8 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 	 * state.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
-		hci_scan_disable_sync(hdev);
 		hci_dev_set_flag(hdev, HCI_LE_SCAN_INTERRUPTED);
+		hci_scan_disable_sync(hdev);
 	}
 
 	/* Update random address, but set require_privacy to false so
-- 
2.51.0



