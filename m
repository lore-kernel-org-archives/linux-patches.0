Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976A23C819C;
	Fri, 15 May 2026 16:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861127; cv=none; b=vCvtgiW4bCno9L4hhxlWf+IlT7rXJq4i+PgwsT0tm6VnIn9YrrGPShqF+QEegyt4JpQHl+DWokfARhELZGU3pWwEkvHC1GOrS8jSit2EiY89Re6VZkhV2a9cKu0Mb3AK5OJnOYkccmkg4L8aBSSaESwluPvgJ7xSQUnaSvQQyao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861127; c=relaxed/simple;
	bh=vNaF5FLc8YOKyFCwAyVdNR4ahIve4+MJyDFbVymuQt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq5GVQcdLdzR4r54sQ6jRrHVM212ssEmfGu1yEx2MYzd+XjW2ryIbAYU9NXbjXouCCFX1E/teGpWWLbyJ4deUwRq4AQeNwJG7YUH58ZSCGM2d/a/qj9AcSpH6lyHPce64uU/2aYc7qxWRloOVMqEXqcei3xcgsNwlF9HE+VNKvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+IodDLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+IodDLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9A9C2BCB0;
	Fri, 15 May 2026 16:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861127;
	bh=vNaF5FLc8YOKyFCwAyVdNR4ahIve4+MJyDFbVymuQt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+IodDLWsXxjrqnpZHS/bdcbClp/d63EFP/4rBS07b+EpNWQ7r9Xhv66CMi83TZSp
	 a7gjQV4mR+3tS8UHRBbFOd7PqjQCKhpqIqjnZ/FC8L6ClknEM/GtLiFC2jMOlVdzxO
	 Rk1zFYtG7eT/4IgpmSKiQNxYo9ZHdH5pgRR7HNMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhiTao Ou <hkbinbinbin@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 210/474] Bluetooth: hci_event: Fix OOB read and infinite loop in hci_le_create_big_complete_evt
Date: Fri, 15 May 2026 17:45:19 +0200
Message-ID: <20260515154719.555157836@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6874,9 +6874,29 @@ static void hci_le_create_big_complete_e
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
@@ -6885,7 +6905,10 @@ static void hci_le_create_big_complete_e
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


