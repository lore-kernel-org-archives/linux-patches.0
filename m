Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A03002A9;
	Tue, 12 May 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608422; cv=none; b=FH/cROPq9st0DJpwp0FvVjl2hRjxOWybD9mw2QVCuw87Y2elYOcwNhFLVoMRKzDFpn1ER+jGuafERbTct+s6qT5+VfGrwfKefQHggOB181gxvb0cOPVv1lomAS5EP49Kai8Zg/7TRzcSvG3hjd3T5atYuC5O8i8Uf/l3NhTU4Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608422; c=relaxed/simple;
	bh=THtRRrOR9mTj0amylZjcyNTP4AxjnfVcNOBKhKIm0s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR5QRlmTx+TWKm8BxQFrj/qdN1Wd/H4tJa452zIX8W5o4XyqthlUwbKKrIthQORmD+NO9a+oKXuqfHM1OSV12EP6b7Fe/xxns6h6qlNlN0uNZUrNUmr3GqHwNXJW3bMPaxcN0/jh8VWnZ3TLgZc8nRU8PMJj5Mqq3tOHkEaBHF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvtbPKaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvtbPKaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1175EC2BCB0;
	Tue, 12 May 2026 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608422;
	bh=THtRRrOR9mTj0amylZjcyNTP4AxjnfVcNOBKhKIm0s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvtbPKaC2/mYBbgM9FXa8q26/NR55SNwOgJaDZzvcxNg6N1xHMmVtVnApLN/5wlbo
	 Ey+R4Zak+k5MOX0ZvJwgwIWc3nuRjTaJGDMT48ySf1+Y4UGiZrYtz5ka9xpDAJncCl
	 QxagcmJatCp7m3ck6fak+sTKQLyAk14vCkmSlSrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhiTao Ou <hkbinbinbin@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 071/270] Bluetooth: hci_event: Fix OOB read and infinite loop in hci_le_create_big_complete_evt
Date: Tue, 12 May 2026 19:37:52 +0200
Message-ID: <20260512173939.945991755@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 5ddb8014261137cadaf83ab5617a588d80a22586 upstream.

hci_le_create_big_complete_evt() iterates over BT_BOUND connections for
a BIG handle using a while loop, accessing ev->bis_handle[i++] on each
iteration.  However, there is no check that i stays within ev->num_bis
before the array access.

When a controller sends a LE_Create_BIG_Complete event with fewer
bis_handle entries than there are BT_BOUND connections for that BIG,
or with num_bis=0, the loop reads beyond the valid bis_handle[] flex
array into adjacent heap memory.  Since the out-of-bounds values
typically exceed HCI_CONN_HANDLE_MAX (0x0EFF), hci_conn_set_handle()
rejects them and the connection remains in BT_BOUND state.  The same
connection is then found again by hci_conn_hash_lookup_big_state(),
creating an infinite loop with hci_dev_lock held.

Fix this by terminating the BIG if in case not all BIS could be setup
properly.

Fixes: a0bfde167b50 ("Bluetooth: ISO: Add support for connecting multiple BISes")
Cc: stable@vger.kernel.org
Signed-off-by: ZhiTao Ou <hkbinbinbin@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6973,9 +6973,29 @@ static void hci_le_create_big_complete_e
 			continue;
 		}
 
+		if (ev->num_bis <= i) {
+			bt_dev_err(hdev,
+				   "Not enough BIS handles for BIG 0x%2.2x",
+				   ev->handle);
+			ev->status = HCI_ERROR_UNSPECIFIED;
+			hci_connect_cfm(conn, ev->status);
+			hci_conn_del(conn);
+			continue;
+		}
+
 		if (hci_conn_set_handle(conn,
-					__le16_to_cpu(ev->bis_handle[i++])))
+					__le16_to_cpu(ev->bis_handle[i++]))) {
+			bt_dev_err(hdev,
+				   "Failed to set BIS handle for BIG 0x%2.2x",
+				   ev->handle);
+			/* Force error so BIG gets terminated as not all BIS
+			 * could be connected.
+			 */
+			ev->status = HCI_ERROR_UNSPECIFIED;
+			hci_connect_cfm(conn, ev->status);
+			hci_conn_del(conn);
 			continue;
+		}
 
 		conn->state = BT_CONNECTED;
 		set_bit(HCI_CONN_BIG_CREATED, &conn->flags);
@@ -6984,7 +7004,10 @@ static void hci_le_create_big_complete_e
 		hci_iso_setup_path(conn);
 	}
 
-	if (!ev->status && !i)
+	/* If there is an unexpected error or if no BISes have been connected
+	 * for the BIG, terminate it.
+	 */
+	if (ev->status == HCI_ERROR_UNSPECIFIED || (!ev->status && !i))
 		/* If no BISes have been connected for the BIG,
 		 * terminate. This is in case all bound connections
 		 * have been closed before the BIG creation


