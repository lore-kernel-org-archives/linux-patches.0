Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8175411689;
	Thu, 30 Jul 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426948; cv=none; b=jnsn8SOmScWsjp59JE+N88KMqPSzNnV6PLB5x7zrQbxbPJ/He9qCHmwO+XvutYLTk7DZ4A/x15JMo+3IufGUaZSttgCDTLaCOrQP69VqLrI4KAR3VPxRMPfHeqnPQQN6wYr+75p3yW/bLSfe97Tsz7wvAAqRP3t47KomX2kWs7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426948; c=relaxed/simple;
	bh=HSrz+Xlst2bptMOieUQoNjKY/2FwHKzSfhxHkrMVz5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fL8h4Jr9sUJEru6qlmVp4hIS9Jq0LCbewis2thYbTfrHFxfm1JCkGQEDY59Bu/3lhnEU+75fPED8+33iRsp7WevJUU4wtMik312sHm+Q8139EuNj5LKYe4FcXFFiwajutQY8BL2WYyqWY2h4DEyvUYSmP282ouGs9AJLY5CVQiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3l61XIP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3l61XIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C881F000E9;
	Thu, 30 Jul 2026 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426947;
	bh=MZaLy85OoOavF8w5jjAE3Ql4KEDaYCARbaMqdKb06/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3l61XIP4w4B3AYxVHT0mPB2SLpVb7pr0vxfmw/59JDLFVC45h0nRk4IZeTNQcBTc
	 tf11i7B5dIzrGPzXkQ7ZJNM+DIbc6HQxEWxYM7X3c66mRLmBhU1P8JkO97EKxkL/vT
	 /zbetH4+27fAwwdsMGZbH1l3hQOuG3wm/yh8t9Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 597/602] Bluetooth: hci_conn: Fix running bis_cleanup for hci_conn->type PA_LINK
Date: Thu, 30 Jul 2026 16:16:29 +0200
Message-ID: <20260730141448.601341010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit d36349ea73d805bb72cbc24ab90cb1da4ad5c379 upstream.

Connections with type of PA_LINK shall be considered temporary just to
track the lifetime of PA Sync setup, once the BIG Sync is established
and connection are created with BIS_LINK the existing PA_LINK
connection shall not longer use bis_cleanup otherwise it terminates the
PA Sync when that shall be left to BIS_LINK connection to do it.

Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c  |   10 +++++++++-
 net/bluetooth/hci_event.c |    7 ++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -830,7 +830,15 @@ static void bis_cleanup(struct hci_conn
 		/* Check if ISO connection is a BIS and terminate advertising
 		 * set and BIG if there are no other connections using it.
 		 */
-		bis = hci_conn_hash_lookup_big(hdev, conn->iso_qos.bcast.big);
+		bis = hci_conn_hash_lookup_big_state(hdev,
+						     conn->iso_qos.bcast.big,
+						     BT_CONNECTED);
+		if (bis)
+			return;
+
+		bis = hci_conn_hash_lookup_big_state(hdev,
+						     conn->iso_qos.bcast.big,
+						     BT_CONNECT);
 		if (bis)
 			return;
 
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7026,9 +7026,14 @@ static void hci_le_big_sync_established_
 				continue;
 		}
 
-		if (ev->status != 0x42)
+		if (ev->status != 0x42) {
 			/* Mark PA sync as established */
 			set_bit(HCI_CONN_PA_SYNC, &bis->flags);
+			/* Reset cleanup callback of PA Sync so it doesn't
+			 * terminate the sync when deleting the connection.
+			 */
+			conn->cleanup = NULL;
+		}
 
 		bis->sync_handle = conn->sync_handle;
 		bis->iso_qos.bcast.big = ev->handle;


