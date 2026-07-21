Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605F1471265;
	Tue, 21 Jul 2026 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664356; cv=none; b=JbS927qWlHmStWwsPNpUEebR1Zq1r/h1kpUbEnIRSvPUnT4Xk0CWB0lIs0JdrVJLGwh5rvP17H8XyKv20RcnGcdu73TOJED0UNEEa8JyOpTWVdWoxff/L7XOYaYQUUJTSQd6LFHLCTuC3rl1Op8Bg06T0ope5TZ7cEXio0lD7wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664356; c=relaxed/simple;
	bh=nALqX8AVbbK9CCvngP42WYz2jhguL0JYg8Kzk1wj6ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CajNZp40scTlDg+utuL2pvWu16JnWLLXndBIUgwQ2xs2072WD1OQ1HVsAUpttRAT9sQifVyabqEjV2LfLedi80/UK//vwfdX4djL3h0hyHj/t2d0kBUry3LJCAJSPyjxXl0XNGwp3seNhhWb+NSW7M9Zn08nqnjeCpcryKZGez0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8dATL+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8dATL+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EE91F000E9;
	Tue, 21 Jul 2026 20:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664355;
	bh=zc89chhqOkIByl/bs7DVqWkguzmsHiPw8Q7WFkRIKsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8dATL+wWHFVYduYlAAuFFnNOn2yKwzxUVVyYjGoJF0Dy0Ws1Wtvnk9GXCzsKvOKO
	 YR9MmcRrosd40sImCzXfhl7s2V3v6KBNhA/UR5a0fC+kmS7gk/ZIkW6EfHjoX+R2lD
	 KC6Qy5cPlhFEM1tVHBdWBZ4OE1in52inAJEuBl5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1170/1276] Bluetooth: L2CAP: Fix not tracking outstanding TX ident
Date: Tue, 21 Jul 2026 17:26:53 +0200
Message-ID: <20260721152512.206934590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 6c3ea155e5ee3e56606233acde8309afda66d483 ]

This attempts to proper track outstanding request by using struct ida
and allocating from it in l2cap_get_ident using ida_alloc_range which
would reuse ids as they are free, then upon completion release
the id using ida_free.

This fixes the qualification test case L2CAP/COS/CED/BI-29-C which
attempts to check if the host stack is able to work after 256 attempts
to connect which requires Ident field to use the full range of possible
values in order to pass the test.

Link: https://github.com/bluez/bluez/issues/1829
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Stable-dep-of: 2641a9e0a1dd ("Bluetooth: L2CAP: cancel pending_rx_work before taking conn->lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/l2cap.h |    3 --
 net/bluetooth/l2cap_core.c    |   53 ++++++++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 16 deletions(-)

--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -658,8 +658,7 @@ struct l2cap_conn {
 
 	struct sk_buff		*rx_skb;
 	__u32			rx_len;
-	__u8			tx_ident;
-	struct mutex		ident_lock;
+	struct ida		tx_ida;
 
 	struct sk_buff_head	pending_rx;
 	struct work_struct	pending_rx_work;
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -928,26 +928,18 @@ int l2cap_chan_check_security(struct l2c
 				 initiator);
 }
 
-static u8 l2cap_get_ident(struct l2cap_conn *conn)
+static int l2cap_get_ident(struct l2cap_conn *conn)
 {
-	u8 id;
+	/* LE link does not support tools like l2ping so use the full range */
+	if (conn->hcon->type == LE_LINK)
+		return ida_alloc_range(&conn->tx_ida, 1, 255, GFP_ATOMIC);
 
 	/* Get next available identificator.
 	 *    1 - 128 are used by kernel.
 	 *  129 - 199 are reserved.
 	 *  200 - 254 are used by utilities like l2ping, etc.
 	 */
-
-	mutex_lock(&conn->ident_lock);
-
-	if (++conn->tx_ident > 128)
-		conn->tx_ident = 1;
-
-	id = conn->tx_ident;
-
-	mutex_unlock(&conn->ident_lock);
-
-	return id;
+	return ida_alloc_range(&conn->tx_ida, 1, 128, GFP_ATOMIC);
 }
 
 static void l2cap_send_acl(struct l2cap_conn *conn, struct sk_buff *skb,
@@ -1776,6 +1768,8 @@ static void l2cap_conn_del(struct hci_co
 	if (work_pending(&conn->pending_rx_work))
 		cancel_work_sync(&conn->pending_rx_work);
 
+	ida_destroy(&conn->tx_ida);
+
 	l2cap_unregister_all_users(conn);
 
 	/* Force the connection to be immediately dropped */
@@ -4776,12 +4770,41 @@ static int l2cap_le_connect_rsp(struct l
 	return err;
 }
 
+static void l2cap_put_ident(struct l2cap_conn *conn, u8 code, u8 id)
+{
+	int ret;
+
+	switch (code) {
+	case L2CAP_COMMAND_REJ:
+	case L2CAP_CONN_RSP:
+	case L2CAP_CONF_RSP:
+	case L2CAP_DISCONN_RSP:
+	case L2CAP_ECHO_RSP:
+	case L2CAP_INFO_RSP:
+	case L2CAP_CONN_PARAM_UPDATE_RSP:
+	case L2CAP_ECRED_CONN_RSP:
+	case L2CAP_ECRED_RECONF_RSP:
+		/* The remote may send bogus ids that would make ida_free
+		 * generate warnings, so only free ids that are actually
+		 * allocated: probing the exact id returns -ENOSPC when it
+		 * is in use, otherwise the probe allocated it and freeing
+		 * is safe either way.  Only on -ENOMEM is the id known to
+		 * be unallocated and the free must be skipped.
+		 */
+		ret = ida_alloc_range(&conn->tx_ida, id, id, GFP_ATOMIC);
+		if (ret >= 0 || ret == -ENOSPC)
+			ida_free(&conn->tx_ida, id);
+	}
+}
+
 static inline int l2cap_bredr_sig_cmd(struct l2cap_conn *conn,
 				      struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 				      u8 *data)
 {
 	int err = 0;
 
+	l2cap_put_ident(conn, cmd->code, cmd->ident);
+
 	switch (cmd->code) {
 	case L2CAP_COMMAND_REJ:
 		l2cap_command_rej(conn, cmd, cmd_len, data);
@@ -5495,6 +5518,8 @@ static inline int l2cap_le_sig_cmd(struc
 {
 	int err = 0;
 
+	l2cap_put_ident(conn, cmd->code, cmd->ident);
+
 	switch (cmd->code) {
 	case L2CAP_COMMAND_REJ:
 		l2cap_le_command_rej(conn, cmd, cmd_len, data);
@@ -7043,13 +7068,13 @@ static struct l2cap_conn *l2cap_conn_add
 	     hci_dev_test_flag(hcon->hdev, HCI_FORCE_BREDR_SMP)))
 		conn->local_fixed_chan |= L2CAP_FC_SMP_BREDR;
 
-	mutex_init(&conn->ident_lock);
 	mutex_init(&conn->lock);
 
 	INIT_LIST_HEAD(&conn->chan_l);
 	INIT_LIST_HEAD(&conn->users);
 
 	INIT_DELAYED_WORK(&conn->info_timer, l2cap_info_timeout);
+	ida_init(&conn->tx_ida);
 
 	skb_queue_head_init(&conn->pending_rx);
 	INIT_WORK(&conn->pending_rx_work, process_pending_rx);


