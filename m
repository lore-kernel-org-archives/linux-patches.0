Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164282572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E0FC433EF;
	Tue, 18 Apr 2023 12:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821796;
	bh=Qxy8ZmtPJkvBYhgNYNbwECvwRmJOJ2gSy/Ii9u2NxSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmkeGWHFI67uuhgLatFmTGmZ5JYAVSEwV4LPn06mjOsZKeXphyIVhJN1vxQaOPJP1
	 AwWh2P7nheZzGxeJ59UpJ3m0qvemBygZcJRf84AOOgxIAC740U3lAcxo/7D8088eW3
	 UoWIr8Ww8CiO2YcPD/x5Ux35lxZyG09ukfYWPrfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archie Pusaka <apusaka@chromium.org>,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 015/134] Bluetooth: Free potentially unfreed SCO connection
Date: Tue, 18 Apr 2023 14:21:11 +0200
Message-Id: <20230418120313.525364928@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Archie Pusaka <apusaka@chromium.org>

commit 0f00cd322d22d4441de51aa80bcce5bb6a8cbb44 upstream.

It is possible to initiate a SCO connection while deleting the
corresponding ACL connection, e.g. in below scenario:

(1) < hci setup sync connect command
(2) > hci disconn complete event (for the acl connection)
(3) > hci command complete event (for(1), failure)

When it happens, hci_cs_setup_sync_conn won't be able to obtain the
reference to the SCO connection, so it will be stuck and potentially
hinder subsequent connections to the same device.

This patch prevents that by also deleting the SCO connection if it is
still not established when the corresponding ACL connection is deleted.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1063,8 +1063,15 @@ int hci_conn_del(struct hci_conn *conn)
 
 	if (conn->type == ACL_LINK) {
 		struct hci_conn *sco = conn->link;
-		if (sco)
+		if (sco) {
 			sco->link = NULL;
+			/* Due to race, SCO connection might be not established
+			 * yet at this point. Delete it now, otherwise it is
+			 * possible for it to be stuck and can't be deleted.
+			 */
+			if (sco->handle == HCI_CONN_HANDLE_UNSET)
+				hci_conn_del(sco);
+		}
 
 		/* Unacked frames */
 		hdev->acl_cnt += conn->sent;


