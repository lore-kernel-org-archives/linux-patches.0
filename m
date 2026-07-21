Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E8F4307AD;
	Tue, 21 Jul 2026 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672998; cv=none; b=btx5K2LZcCBdyi/068PtpNX05XdMGISfA820tLTgVmcNgZA3txo2W+NPvN0uuaqe/0AvLlh8OOhpTOYoezfe+jPfBJfDsYVJX1cBcWBjODw5ZAQaY4oJWJR7kIyu6IpAPyzFhw2AmTeZuz+Mso3wFyoN3b7jB2a670XxVFYWKbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672998; c=relaxed/simple;
	bh=IKoXWe46OE8D9ec1ndmR1qYpQ1cEcC13RSr7Lx2Wss4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tg78sysDDTzmN9QZ/Kvz0hR7nW41+IN0k8sFDhOsWbMMQBUfFTDYntsfxdoKjkhsRJJ5U15DpjxgT08aCWBnfhdxJ9TwKy8f9f2EBc0WlGoj5ZtP5uS2sn+XhSoSuAGj5Y25UjjWQ3WwYkeHOv7A/jC4vujx4zg7pj1cjJVMNBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjPBQzDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjPBQzDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E848C1F000E9;
	Tue, 21 Jul 2026 22:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672997;
	bh=DUIuA50x0o4H6TH+eyrs5VD06oRu587gVATw/Zt2WpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjPBQzDoQObkXxj+w19GamuechsPLiMpNcP1WeOGjWaVYtcLpqLev576ANYS8cZ2i
	 LTxOWEDgMDSnKTz7Nt0kxsQYGdmPEKeEKCH4b1Y8f7buKekLnx0xWjj8jO475c7jqE
	 e60sIE+CeoWCgq3EMlJxdFJQ1fKT582/vlQKRXX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Christian Eggers <ceggers@arri.de>
Subject: [PATCH 5.15 836/843] Bluetooth: L2CAP: Fix regressions caused by reusing ident
Date: Tue, 21 Jul 2026 17:27:51 +0200
Message-ID: <20260721152424.885128629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 761fb8ec8778f0caf2bba5a41e3cff1ea86974f3 upstream.

This attempt to fix regressions caused by reusing ident which apparently
is not handled well on certain stacks causing the stack to not respond to
requests, so instead of simple returning the first unallocated id this
stores the last used tx_ident and then attempt to use the next until all
available ids are exausted and then cycle starting over to 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221120
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221177
Fixes: 6c3ea155e5ee ("Bluetooth: L2CAP: Fix not tracking outstanding TX ident")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/l2cap.h |    1 +
 net/bluetooth/l2cap_core.c    |   29 ++++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -692,6 +692,7 @@ struct l2cap_conn {
 	struct sk_buff		*rx_skb;
 	__u32			rx_len;
 	struct ida		tx_ida;
+	__u8			tx_ident;
 
 	struct sk_buff_head	pending_rx;
 	struct work_struct	pending_rx_work;
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -939,16 +939,39 @@ int l2cap_chan_check_security(struct l2c
 
 static int l2cap_get_ident(struct l2cap_conn *conn)
 {
+	u8 max;
+	int ident;
+
 	/* LE link does not support tools like l2ping so use the full range */
 	if (conn->hcon->type == LE_LINK)
-		return ida_alloc_range(&conn->tx_ida, 1, 255, GFP_ATOMIC);
-
+		max = 255;
 	/* Get next available identificator.
 	 *    1 - 128 are used by kernel.
 	 *  129 - 199 are reserved.
 	 *  200 - 254 are used by utilities like l2ping, etc.
 	 */
-	return ida_alloc_range(&conn->tx_ida, 1, 128, GFP_ATOMIC);
+	else
+		max = 128;
+
+	/* Allocate ident using min as last used + 1 (cyclic) */
+	ident = ida_alloc_range(&conn->tx_ida, READ_ONCE(conn->tx_ident) + 1,
+				max, GFP_ATOMIC);
+	/* Force min 1 to start over */
+	if (ident <= 0) {
+		ident = ida_alloc_range(&conn->tx_ida, 1, max, GFP_ATOMIC);
+		if (ident <= 0) {
+			/* If all idents are in use, log an error, this is
+			 * extremely unlikely to happen and would indicate a bug
+			 * in the code that idents are not being freed properly.
+			 */
+			BT_ERR("Unable to allocate ident: %d", ident);
+			return 0;
+		}
+	}
+
+	WRITE_ONCE(conn->tx_ident, ident);
+
+	return ident;
 }
 
 static void l2cap_send_cmd(struct l2cap_conn *conn, u8 ident, u8 code, u16 len,


