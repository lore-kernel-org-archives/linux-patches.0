Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44FD38C437;
	Tue, 16 Jun 2026 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622900; cv=none; b=rLQlbSyro82q8m1BZDX29gc2AUunheiHZ+ZqjWcKn1HpembBXSHNyMxKdNvtv97nSav2KQ/mq+hSqxjUi+xOUzZEmDR1IzEvuQUkAtC4KiOHii0tZeL2X0YudOlFpRFTpVEqQuvGX1D+ZvErp6N37oqvCsMG6YIxreR6byYAAQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622900; c=relaxed/simple;
	bh=+dEIidKudcRcGlNEUL8ZMvE5HLBL7Y/XU3QpiyG83bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBOIIPJcFWM0Zyr8rfPv9KmGzM5Gkxt72DssIg1gtiBaCtU1KWJgWO7LXJHGsMpz3OAXn4cj7G1pJHmTvr8FeNm9pBBafZbfdx8q46AJ+ZZVyidH31+GNL2f7klkVvKggJ++MxI84OHffVwPDCMB/fnFE2pdvRTzsDOVPYZkqcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa53Ln8g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa53Ln8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64D51F000E9;
	Tue, 16 Jun 2026 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622899;
	bh=1VEZzyV2Lid72EHCYLjZ690qtUhrbCxkg+J0QnZXGW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pa53Ln8gRGIK/UY0oRDskkhWIA2b7MeTzgk03+2v6093UzVhQZGFQLnv/dehYn8Ki
	 eUtxV+XuiWSxsOJ+3pnkgSRjp+qOYweINAQgEv59JW3mqk+YbImPFQh5ZZrUiR+Axq
	 C4VyIyxwPwuyY0XrLpAnAs3cgr0oQ5+cHzJkSqOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 051/378] Bluetooth: ISO: Fix data-race on iso_pi fields in hci_get_route calls
Date: Tue, 16 Jun 2026 20:24:42 +0530
Message-ID: <20260616145112.630969704@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeungJu Cheon <suunj1331@gmail.com>

[ Upstream commit 9ca7053d6215d89c33f28893bfd1625a32919d3f ]

iso_connect_bis(), iso_connect_cis(), iso_listen_bis(), and
iso_conn_big_sync() call hci_get_route() using iso_pi(sk)->dst,
iso_pi(sk)->src, and iso_pi(sk)->src_type without holding lock_sock().

These fields may be modified concurrently by connect() or setsockopt()
on the same socket, resulting in data-races reported by KCSAN.

Fix this by snapshotting the required fields under lock_sock() before
calling hci_get_route().

BUG: KCSAN: data-race in memcmp+0x45/0xb0

race at unknown origin, with read to 0xffff8880122135cf of 1 bytes
by task 333 on cpu 1:
 memcmp+0x45/0xb0
 hci_get_route+0x27e/0x490
 iso_connect_cis+0x4c/0xa10
 iso_sock_connect+0x60e/0xb30
 __sys_connect_file+0xbd/0xe0
 __sys_connect+0xe0/0x110
 __x64_sys_connect+0x40/0x50
 x64_sys_call+0xcad/0x1c60
 do_syscall_64+0x133/0x590
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 241f51931c35 ("Bluetooth: ISO: Avoid circular locking dependency")
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 60 +++++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 05a3f1e554fe67..34e4803313d130 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -337,12 +337,20 @@ static int iso_connect_bis(struct sock *sk)
 	struct iso_conn *conn;
 	struct hci_conn *hcon;
 	struct hci_dev  *hdev;
+	bdaddr_t src, dst;
+	u8 src_type, bc_sid;
 	int err;
 
-	BT_DBG("%pMR (SID 0x%2.2x)", &iso_pi(sk)->src, iso_pi(sk)->bc_sid);
+	lock_sock(sk);
+	bacpy(&src, &iso_pi(sk)->src);
+	bacpy(&dst, &iso_pi(sk)->dst);
+	src_type = iso_pi(sk)->src_type;
+	bc_sid = iso_pi(sk)->bc_sid;
+	release_sock(sk);
 
-	hdev = hci_get_route(&iso_pi(sk)->dst, &iso_pi(sk)->src,
-			     iso_pi(sk)->src_type);
+	BT_DBG("%pMR (SID 0x%2.2x)", &src, bc_sid);
+
+	hdev = hci_get_route(&dst, &src, src_type);
 	if (!hdev)
 		return -EHOSTUNREACH;
 
@@ -434,12 +442,19 @@ static int iso_connect_cis(struct sock *sk)
 	struct iso_conn *conn;
 	struct hci_conn *hcon;
 	struct hci_dev  *hdev;
+	bdaddr_t src, dst;
+	u8 src_type;
 	int err;
 
-	BT_DBG("%pMR -> %pMR", &iso_pi(sk)->src, &iso_pi(sk)->dst);
+	lock_sock(sk);
+	bacpy(&src, &iso_pi(sk)->src);
+	bacpy(&dst, &iso_pi(sk)->dst);
+	src_type = iso_pi(sk)->src_type;
+	release_sock(sk);
+
+	BT_DBG("%pMR -> %pMR", &src, &dst);
 
-	hdev = hci_get_route(&iso_pi(sk)->dst, &iso_pi(sk)->src,
-			     iso_pi(sk)->src_type);
+	hdev = hci_get_route(&dst, &src, src_type);
 	if (!hdev)
 		return -EHOSTUNREACH;
 
@@ -1220,18 +1235,25 @@ static int iso_sock_connect(struct socket *sock, struct sockaddr_unsized *addr,
 
 static int iso_listen_bis(struct sock *sk)
 {
-	struct hci_dev *hdev;
-	int err = 0;
 	struct iso_conn *conn;
 	struct hci_conn *hcon;
+	struct hci_dev *hdev;
+	bdaddr_t src, dst;
+	u8 src_type, bc_sid;
+	int err = 0;
+
+	lock_sock(sk);
+	bacpy(&src, &iso_pi(sk)->src);
+	bacpy(&dst, &iso_pi(sk)->dst);
+	src_type = iso_pi(sk)->src_type;
+	bc_sid = iso_pi(sk)->bc_sid;
+	release_sock(sk);
 
-	BT_DBG("%pMR -> %pMR (SID 0x%2.2x)", &iso_pi(sk)->src,
-	       &iso_pi(sk)->dst, iso_pi(sk)->bc_sid);
+	BT_DBG("%pMR -> %pMR (SID 0x%2.2x)", &src, &dst, bc_sid);
 
 	write_lock(&iso_sk_list.lock);
 
-	if (__iso_get_sock_listen_by_sid(&iso_pi(sk)->src, &iso_pi(sk)->dst,
-					 iso_pi(sk)->bc_sid))
+	if (__iso_get_sock_listen_by_sid(&src, &dst, bc_sid))
 		err = -EADDRINUSE;
 
 	write_unlock(&iso_sk_list.lock);
@@ -1239,8 +1261,7 @@ static int iso_listen_bis(struct sock *sk)
 	if (err)
 		return err;
 
-	hdev = hci_get_route(&iso_pi(sk)->dst, &iso_pi(sk)->src,
-			     iso_pi(sk)->src_type);
+	hdev = hci_get_route(&dst, &src, src_type);
 	if (!hdev)
 		return -EHOSTUNREACH;
 
@@ -1576,9 +1597,16 @@ static void iso_conn_big_sync(struct sock *sk)
 {
 	int err;
 	struct hci_dev *hdev;
+	bdaddr_t src, dst;
+	u8 src_type;
+
+	lock_sock(sk);
+	bacpy(&src, &iso_pi(sk)->src);
+	bacpy(&dst, &iso_pi(sk)->dst);
+	src_type = iso_pi(sk)->src_type;
+	release_sock(sk);
 
-	hdev = hci_get_route(&iso_pi(sk)->dst, &iso_pi(sk)->src,
-			     iso_pi(sk)->src_type);
+	hdev = hci_get_route(&dst, &src, src_type);
 
 	if (!hdev)
 		return;
-- 
2.53.0



