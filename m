Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6035C2D8771;
	Tue, 31 Mar 2026 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977017; cv=none; b=Bsi3Fjf7rIVjUB28V05MvrPolQ9JH2gCRxaj9IG5uHqd5+XSi/YE8rXcA50fkMexC4VRiEAyOdGH5pGOpyBrK2ptbm6hTFTxiyKgpHGQ2R9r/7YM1pdUKHDGVlz5FjPDMAQlWwxh4J5rRszxAMqEeKEsO4ITVCQvE5MRJJUQy8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977017; c=relaxed/simple;
	bh=hCCbz6N+z2uvFygvQnc+zbDxeqqbRqngkepdDrBwr5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2V0FSwtGX9lDf4dPF3jqmpy1+UzMhhdug+9f8NuSKyH0nsYcFA76idNASF6qPb0YRdf4KMcX/foSBjjr1aK9h1AQmXB5DrDObivWMljVSzFYkH3xU8Fh6tpzVfFic2vvI3NJOH7xGZ8U83r4a0S+oUxItkfOeU6VS594I8Q4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1QQVDiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1QQVDiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EE8C19423;
	Tue, 31 Mar 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774977017;
	bh=hCCbz6N+z2uvFygvQnc+zbDxeqqbRqngkepdDrBwr5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1QQVDiQ+7Q9u+5gYkAxGz6SQCTCEY6rSHlRL20Zvosle/uv+J//WJtc5lpCsdWs6
	 uN1eAAKpGkUJxnSupzmhEXKUS2skORiokqCWD4PVIWH3uOo2JXnCP14cXSJrceYfUF
	 YP6hTk9kaFYei2qCLEas0Pfqv5IEJMQkIqprXTls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Christian Eggers <ceggers@arri.de>
Subject: [PATCH 6.18 309/309] Bluetooth: L2CAP: Fix regressions caused by reusing ident
Date: Tue, 31 Mar 2026 18:23:32 +0200
Message-ID: <20260331161804.936345873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
@@ -658,6 +658,7 @@ struct l2cap_conn {
 	struct sk_buff		*rx_skb;
 	__u32			rx_len;
 	struct ida		tx_ida;
+	__u8			tx_ident;
 
 	struct sk_buff_head	pending_rx;
 	struct work_struct	pending_rx_work;
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -926,16 +926,39 @@ int l2cap_chan_check_security(struct l2c
 
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
 
 static void l2cap_send_acl(struct l2cap_conn *conn, struct sk_buff *skb,


