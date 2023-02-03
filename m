Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CF51FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE138C4339C;
	Fri,  3 Feb 2023 10:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419810;
	bh=qK6dU8Q1RVgxK1eaf4/idch0rGUITW/wxXvP68iw/Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/XXgHn/umEklP3AKFlSjG9oZ/Duta93l+lLdoc1X0c/7eiQC12E/k6ik82wOzqkn
	 XfdebFODwY5B/8cwKorCy2pXIz/nVteL27iF0z6a1PuJOV9o3ZELCieoiTkMmXZOz9
	 m0dBP34Cj4eoeczcY7dNHiHlfgNDUVPFkN+vCCLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soenke Huster <soenke.huster@eknoes.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Subject: [PATCH 5.10 8/9] Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
Date: Fri,  3 Feb 2023 11:13:37 +0100
Message-Id: <20230203101006.747150911@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
References: <20230203101006.422534094@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Soenke Huster <soenke.huster@eknoes.de>

commit 3afee2118132e93e5f6fa636dfde86201a860ab3 upstream.

This event is just specified for SCO and eSCO link types.
On the reception of a HCI_Synchronous_Connection_Complete for a BDADDR
of an existing LE connection, LE link type and a status that triggers the
second case of the packet processing a NULL pointer dereference happens,
as conn->link is NULL.

Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4307,6 +4307,19 @@ static void hci_sync_conn_complete_evt(s
 	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
 	struct hci_conn *conn;
 
+	switch (ev->link_type) {
+	case SCO_LINK:
+	case ESCO_LINK:
+		break;
+	default:
+		/* As per Core 5.3 Vol 4 Part E 7.7.35 (p.2219), Link_Type
+		 * for HCI_Synchronous_Connection_Complete is limited to
+		 * either SCO or eSCO
+		 */
+		bt_dev_err(hdev, "Ignoring connect complete event for invalid link type");
+		return;
+	}
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);


