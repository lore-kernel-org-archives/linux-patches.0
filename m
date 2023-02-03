Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5021FBC
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D1BC433D2;
	Fri,  3 Feb 2023 10:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420255;
	bh=7WjKQhiTGM0FmWrOZWOPyG+HZZ6gAir80nqDcQUt/Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKpX2u3ujhXJXlr7ZCtMZX86aCGkfo6qUoMqrG8HVY6QZ1NoTz25cssCyEV0n6Qiw
	 98Fm0jHcu1HWNoia7O2FDF+fm46DrYn8hueHD+vzTc08goLsvKVG8+7+Mfv++58rXv
	 SmmKTtyo1tyuc5awLVdznr8Hn6ro7u80aJ8lTVd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soenke Huster <soenke.huster@eknoes.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Subject: [PATCH 5.4 132/134] Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
Date: Fri,  3 Feb 2023 11:13:57 +0100
Message-Id: <20230203101029.764495846@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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
@@ -4177,6 +4177,19 @@ static void hci_sync_conn_complete_evt(s
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


