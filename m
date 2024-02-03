Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94A61643E;
	Sat,  3 Feb 2024 04:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933826; cv=none; b=Fo1qk+9az5i8emcfyV4KgvOgNbJ7B0HDjb3bcKss1IfGQ/ZpmTxZZjz8co54Jg0ONakZtv+tCoJ6C84Wu9OZ2R8D7drg1Y79z2y+8YTh34iFZ/+Pl+6aoGf3ddYltue7ryR5PJRPTWuZjdVoCHwu2TkyGn9Hs/mkCZ+b1pS2QBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933826; c=relaxed/simple;
	bh=6NSTYxB2LVJNip4gZs2ARY1mUgpqr94A5eBhZ4BWgdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIGcSraYL+X8t26qaptLa0AFw/dmn5aM1RrZklpAnVbz9lsVIG4nH9iGaGmXDO9q5fR8ueSnC/0BQqHSUpAMuExEo9TWeuAxwuIKwc/b3ME6cHF2J0hUad9V7Y4aLimBEI+4lqoMseaZpIYW2xhXvQ6c9uPiLSR8hBSNV2xSbHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6cZJogd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6cZJogd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A230CC43394;
	Sat,  3 Feb 2024 04:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933826;
	bh=6NSTYxB2LVJNip4gZs2ARY1mUgpqr94A5eBhZ4BWgdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6cZJogdNqd2xCb8rJRain6+JA2OWJ+pfbasr1AiJcZEqxEcALe3rqz1LSvxtbCca
	 bFyh3nULvEDfD0gdjxIXvl+AEMEDVyr34eb3QzHkeKPeYAYwuZKIiHWby/4qnkkcIz
	 7t3jov03C7nlVxzZ9i6hl29hja47gZkJlyg5kRnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 149/353] Bluetooth: ISO: Avoid creating child socket if PA sync is terminating
Date: Fri,  2 Feb 2024 20:04:27 -0800
Message-ID: <20240203035408.386785549@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 9f150019f176078144b02c4b9b9dbe7fd5a2fcc3 ]

When a PA sync socket is closed, the associated hcon is also unlinked
and cleaned up. If there are no other hcons marked with the
HCI_CONN_PA_SYNC flag, HCI_OP_LE_PA_TERM_SYNC is sent to controller.

Between the time of the command and the moment PA sync is terminated
in controller, residual BIGInfo reports might continue to come.
This causes a new PA sync hcon to be added, and a new socket to be
notified to user space.

This commit fixs this by adding a flag on a Broadcast listening
socket to mark when the PA sync child has been closed.

This flag is checked when BIGInfo reports are indicated in
iso_connect_ind, to avoid recreating a hcon and socket if
residual reports arrive before PA sync is terminated.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 51 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 07b80e97aead..fd81289fd3e5 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -54,6 +54,7 @@ static void iso_sock_kill(struct sock *sk);
 enum {
 	BT_SK_BIG_SYNC,
 	BT_SK_PA_SYNC,
+	BT_SK_PA_SYNC_TERM,
 };
 
 struct iso_pinfo {
@@ -82,6 +83,11 @@ static bool iso_match_sid(struct sock *sk, void *data);
 static bool iso_match_sync_handle(struct sock *sk, void *data);
 static void iso_sock_disconn(struct sock *sk);
 
+typedef bool (*iso_sock_match_t)(struct sock *sk, void *data);
+
+static struct sock *iso_get_sock_listen(bdaddr_t *src, bdaddr_t *dst,
+					iso_sock_match_t match, void *data);
+
 /* ---- ISO timers ---- */
 #define ISO_CONN_TIMEOUT	(HZ * 40)
 #define ISO_DISCONN_TIMEOUT	(HZ * 2)
@@ -190,10 +196,21 @@ static void iso_chan_del(struct sock *sk, int err)
 	sock_set_flag(sk, SOCK_ZAPPED);
 }
 
+static bool iso_match_conn_sync_handle(struct sock *sk, void *data)
+{
+	struct hci_conn *hcon = data;
+
+	if (test_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags))
+		return false;
+
+	return hcon->sync_handle == iso_pi(sk)->sync_handle;
+}
+
 static void iso_conn_del(struct hci_conn *hcon, int err)
 {
 	struct iso_conn *conn = hcon->iso_data;
 	struct sock *sk;
+	struct sock *parent;
 
 	if (!conn)
 		return;
@@ -209,6 +226,25 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 
 	if (sk) {
 		lock_sock(sk);
+
+		/* While a PA sync hcon is in the process of closing,
+		 * mark parent socket with a flag, so that any residual
+		 * BIGInfo adv reports that arrive before PA sync is
+		 * terminated are not processed anymore.
+		 */
+		if (test_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags)) {
+			parent = iso_get_sock_listen(&hcon->src,
+						     &hcon->dst,
+						     iso_match_conn_sync_handle,
+						     hcon);
+
+			if (parent) {
+				set_bit(BT_SK_PA_SYNC_TERM,
+					&iso_pi(parent)->flags);
+				sock_put(parent);
+			}
+		}
+
 		iso_sock_clear_timer(sk);
 		iso_chan_del(sk, err);
 		release_sock(sk);
@@ -545,8 +581,6 @@ static struct sock *__iso_get_sock_listen_by_sid(bdaddr_t *ba, bdaddr_t *bc,
 	return NULL;
 }
 
-typedef bool (*iso_sock_match_t)(struct sock *sk, void *data);
-
 /* Find socket listening:
  * source bdaddr (Unicast)
  * destination bdaddr (Broadcast only)
@@ -1759,9 +1793,20 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 		/* Try to get PA sync listening socket, if it exists */
 		sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr,
 						iso_match_pa_sync_flag, NULL);
-		if (!sk)
+
+		if (!sk) {
 			sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr,
 						 iso_match_sync_handle, ev2);
+
+			/* If PA Sync is in process of terminating,
+			 * do not handle any more BIGInfo adv reports.
+			 */
+
+			if (sk && test_bit(BT_SK_PA_SYNC_TERM,
+					   &iso_pi(sk)->flags))
+				return lm;
+		}
+
 		if (sk) {
 			int err;
 
-- 
2.43.0



