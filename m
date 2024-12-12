Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC37F1487CD;
	Thu, 12 Dec 2024 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016972; cv=none; b=XiiMElm3FVAgdd0008U+NWEbdrISO+UduxkClemVpc1SwTbQjxmC3WA5fEmYmJcn+m91uwEp4REa9QwFXBzomSa+KVcZS8yFhgeIHC9qdlqqJOvlz2aiDzwocmb39W+1Ke54MPZyZ66DJVczhFEIuLOIS48jMBOm/DwP7cT247s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016972; c=relaxed/simple;
	bh=ng/gl+cDA45VhZiWZqd2G23Ie5ZuhGJcoCYCl+CJZLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFkFxVPo5hSZv5GtQfBt4tCA4scefYXMIhS+VcZqULPlzHmKkcx0tLvHkFVSvOaOkTzsbxNgC9EXgrgV5xWUu4N9fociPrkr2ntMn5Gv5tuYlw0qCi5sHsepovC2gNYwrl53C631nZxGhsC16Mcv37b6L/fba9r91OcJqaK/l6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StE3sAID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StE3sAID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29289C4CECE;
	Thu, 12 Dec 2024 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016972;
	bh=ng/gl+cDA45VhZiWZqd2G23Ie5ZuhGJcoCYCl+CJZLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StE3sAIDiSTBaQcgfTbYJVjBcZ8DfJb5wx6Vvqo2Kj9gcEb9FA3ILEy6V741FVwwP
	 SjTHpTr4d/vZHBYPeeINeZ0u0FWO7d9kqvbuI3rQnNSsAaHjTaTAj5hr1DXBsO7mC6
	 /tEQQvwxcmxlAv1Buu0yPhV0iXQmMXEcWW+3gIyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Pylaev <danstiv404@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/466] Bluetooth: Support new quirks for ATS2851
Date: Thu, 12 Dec 2024 15:58:34 +0100
Message-ID: <20241212144320.420147513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danil Pylaev <danstiv404@gmail.com>

[ Upstream commit 5bd3135924b4570dcecc8793f7771cb8d42d8b19 ]

This adds support for quirks for broken extended create connection,
and write auth payload timeout.

Signed-off-by: Danil Pylaev <danstiv404@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 7 +++++++
 net/bluetooth/hci_sync.c  | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 2e4bd3e961ce0..2b5ba8acd1d84 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3626,6 +3626,13 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
+	/* We skip the WRITE_AUTH_PAYLOAD_TIMEOUT for ATS2851 based controllers
+	 * to avoid unexpected SMP command errors when pairing.
+	 */
+	if (test_bit(HCI_QUIRK_BROKEN_WRITE_AUTH_PAYLOAD_TIMEOUT,
+		     &hdev->quirks))
+		goto notify;
+
 	/* Set the default Authenticated Payload Timeout after
 	 * an LE Link is established. As per Core Spec v5.0, Vol 2, Part B
 	 * Section 3.3, the HCI command WRITE_AUTH_PAYLOAD_TIMEOUT should be
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c0203a2b51075..c86f4e42e69ca 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4842,6 +4842,13 @@ static const struct {
 	HCI_QUIRK_BROKEN(SET_RPA_TIMEOUT,
 			 "HCI LE Set Random Private Address Timeout command is "
 			 "advertised, but not supported."),
+	HCI_QUIRK_BROKEN(EXT_CREATE_CONN,
+			 "HCI LE Extended Create Connection command is "
+			 "advertised, but not supported."),
+	HCI_QUIRK_BROKEN(WRITE_AUTH_PAYLOAD_TIMEOUT,
+			 "HCI WRITE AUTH PAYLOAD TIMEOUT command leads "
+			 "to unexpected SMP errors when pairing "
+			 "and will not be used."),
 	HCI_QUIRK_BROKEN(LE_CODED,
 			 "HCI LE Coded PHY feature bit is set, "
 			 "but its usage is not supported.")
@@ -6477,7 +6484,7 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 					     &own_addr_type);
 	if (err)
 		goto done;
-
+	/* Send command LE Extended Create Connection if supported */
 	if (use_ext_conn(hdev)) {
 		err = hci_le_ext_create_conn_sync(hdev, conn, own_addr_type);
 		goto done;
-- 
2.43.0



