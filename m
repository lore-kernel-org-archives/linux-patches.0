Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D82D43DA24;
	Tue, 16 Jun 2026 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622906; cv=none; b=eiB66YTzxl74XhPZDQk62vMEJkNSGMpHC+1E9K6JxJYafsVn3YGoe0DUTMvPer6h58iKd9zQPBARORbWdJuUyKbRRZyP6j7I86yrDjavP7x8MHcGDgbqXzkKpvz6x6BdeHqWUKOrEkCYjS6XKaPt2nclZDvx1oEgIRce8f+DqKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622906; c=relaxed/simple;
	bh=/xDfKsJOO+HXtX62uCsWXUOcdMrpRO2mORchtRiziBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdU4Ov5mwr2LoeCmsg9/QqeakZP51G4nwX+iwFkdabzMh1Ptj2KC3Rn7jFlSXgkPKKS9eAJ8pQDXOl/hVWpC+UQzTzAs5bosSUtyFS9gSnT+Gp/sslD0ezqiQQMMB8jX302fiRiQa5Q9bUOyAaWHvXT08xBYGqTU0/LgM1sryVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7HD3QoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7HD3QoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D781F000E9;
	Tue, 16 Jun 2026 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622905;
	bh=iY61nlxyS9cO90LhkPm44kIE55BGPwverjnYR1m+K8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7HD3QoTzubCan6Jz1u2JWdu34+TJohha0wOpioIgt1Xsu96AmpCTALVy0Lv322D1
	 FFkxMWEFr8uB0NZSP/rzHfMPpgp8MHHOALc/49w8VnpwXMqih6AszNZlXzmTE/+PNV
	 khr4vzE895tfITKLhrKLaL4FhuGOjBCNEtd4rDT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 052/378] Bluetooth: SCO: Fix data-race on sco_pi fields in sco_connect
Date: Tue, 16 Jun 2026 20:24:43 +0530
Message-ID: <20260616145112.695541109@linuxfoundation.org>
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

[ Upstream commit 4847c5bca22227100ae69e96af86618b6fd2671f ]

sco_sock_connect() copies the destination address into sco_pi(sk)->dst
under lock_sock(), then releases the lock and calls sco_connect(),
which reads dst, src, setting, and codec without holding lock_sock() in
hci_get_route() and hci_connect_sco().

These fields may be modified concurrently by connect(), bind(), or
setsockopt() on the same socket, resulting in data-races reported by
KCSAN.

Fix this by snapshotting dst, src, setting, and codec under lock_sock()
at the start of sco_connect() before passing them to hci_get_route()
and hci_connect_sco().

BUG: KCSAN: data-race in memcmp+0x45/0xb0

race at unknown origin, with read to 0xffff88800e6b0dd0 of 1 bytes
by task 315 on cpu 0:
 memcmp+0x45/0xb0
 hci_connect_acl+0x1b7/0x6b0
 hci_connect_sco+0x4d/0xb30
 sco_sock_connect+0x27b/0xd60
 __sys_connect_file+0xbd/0xe0
 __sys_connect+0xe0/0x110
 __x64_sys_connect+0x40/0x50
 x64_sys_call+0xcad/0x1c60
 do_syscall_64+0x133/0x590
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 9a8ec9e8ebb5 ("Bluetooth: SCO: Fix possible circular locking dependency on sco_connect_cfm")
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 770b9d6fad88f9..47ff4b8d1ae2cd 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -312,11 +312,21 @@ static int sco_connect(struct sock *sk)
 	struct sco_conn *conn;
 	struct hci_conn *hcon;
 	struct hci_dev  *hdev;
+	bdaddr_t src, dst;
+	struct bt_codec codec;
+	__u16 setting;
 	int err, type;
 
-	BT_DBG("%pMR -> %pMR", &sco_pi(sk)->src, &sco_pi(sk)->dst);
+	lock_sock(sk);
+	bacpy(&src, &sco_pi(sk)->src);
+	bacpy(&dst, &sco_pi(sk)->dst);
+	setting = sco_pi(sk)->setting;
+	codec = sco_pi(sk)->codec;
+	release_sock(sk);
+
+	BT_DBG("%pMR -> %pMR", &src, &dst);
 
-	hdev = hci_get_route(&sco_pi(sk)->dst, &sco_pi(sk)->src, BDADDR_BREDR);
+	hdev = hci_get_route(&dst, &src, BDADDR_BREDR);
 	if (!hdev)
 		return -EHOSTUNREACH;
 
@@ -327,7 +337,7 @@ static int sco_connect(struct sock *sk)
 	else
 		type = SCO_LINK;
 
-	switch (sco_pi(sk)->setting & SCO_AIRMODE_MASK) {
+	switch (setting & SCO_AIRMODE_MASK) {
 	case SCO_AIRMODE_TRANSP:
 		if (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev)) {
 			err = -EOPNOTSUPP;
@@ -336,8 +346,8 @@ static int sco_connect(struct sock *sk)
 		break;
 	}
 
-	hcon = hci_connect_sco(hdev, type, &sco_pi(sk)->dst,
-			       sco_pi(sk)->setting, &sco_pi(sk)->codec,
+	hcon = hci_connect_sco(hdev, type, &dst,
+			       setting, &codec,
 			       READ_ONCE(sk->sk_sndtimeo));
 	if (IS_ERR(hcon)) {
 		err = PTR_ERR(hcon);
-- 
2.53.0



