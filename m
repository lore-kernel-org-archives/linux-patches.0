Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215195;
	b=uY9S2v8sBEM/mfPKWrHoMuNvuu66rQCPv+evtRIq3KUaYh6dvXTsDVx1wxBCQ3Gjjtu1
	 F4a6BHdEiWXI5YLiSyopwovD9SzlsK9rw7l5ZKCVl6kYiEkjR5D6mxWtQOPcT379OWn4x
	 T50BLwb1VijtoiSdBEqI4BQGlDCtThWb2IqRmkQVgtagu81vIyLnvjq0xnYJ3gjZNp0KC
	 BgnKoQxRvjVhzbs5jQhk98CaiJmYIN9OJAEcTefVphAUC1GFHi4DYH/vm2VFLZMHt1GOk
	 ccfjFXuMNttSX/yDTCkKUqN8QQNGFpdZsOc9HH+ie6iQ+frsw7CGuwfND8erHkWF6kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vUw4Dm7/q9TFyPdMPJykTKvdPAAC270TaTOohUMi3LI=;
	b=H2/5UHIBFJjXowzD5+/0iZuKirGSrRXdpVu7L0dBkTg5kvqWqTf10WqflOvqtutI3EBN
	 HIxQohGtiBoiJHnKPUaD6IV1Iw30GKg15xYfMe4nTmkZLgM2VDRDMKPiINOe49BBcbr7U
	 zyh1Rvg/oILL+QtKa/f7KlWxilUmO0cVYWkrTgrV1ExOo21RW2FYWjtwbqvaA07iFsrXl
	 n8HIAc5mmsAFn2faHAIDFHN53SbKNNacrrkatkjCNFkzjPSE62qo2qPSmTpby2tGXX/Qk
	 dIeepuk8UoXMEqodiBfSBdKO4ooUiLqQIon2lD6sGPQYz4SXSn7oJimphfmww5bKd1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enL+REKG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E1E606A31A;
	Wed, 28 Oct 2026 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enL+REKG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98461F01825;
	Wed, 28 Oct 2026 19:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215195;
	bh=vUw4Dm7/q9TFyPdMPJykTKvdPAAC270TaTOohUMi3LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enL+REKGntikzp7MUaeaA88UiAfay9QOeL48oLLwtuwasbKmHO+hXSegfUPI5QPJE
	 wVqrtucd+1HX6qoYtCHQX1dQ+fQspTbSjmFdMs8yLY4YEwDCX26DzsaLV1S5Dqsk3P
	 +yMJs/yDKY+gfM1thyjbBB9iRJd2QjvpTJahIDkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1125/1887] Bluetooth: ISO: Fix data-race on iso_pi fields in hci_get_route calls
Date: Wed, 28 Oct 2026 17:53:41 +0100
Message-ID: <20261028170525.000550993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/bluetooth/iso.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index bb6e02f7e32e6..2281a915c6533 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -267,12 +267,19 @@ static int iso_connect_bis(struct sock *sk)
 	struct iso_conn *conn;
 	struct hci_conn *hcon;
 	struct hci_dev  *hdev;
+	bdaddr_t src, dst;
+	u8 src_type;
 	int err;
 
-	BT_DBG("%pMR", &iso_pi(sk)->src);
+	lock_sock(sk);
+	bacpy(&src, &iso_pi(sk)->src);
+	bacpy(&dst, &iso_pi(sk)->dst);
+	src_type = iso_pi(sk)->src_type;
+	release_sock(sk);
 
-	hdev = hci_get_route(&iso_pi(sk)->dst, &iso_pi(sk)->src,
-			     iso_pi(sk)->src_type);
+	BT_DBG("%pMR", &src);
+
+	hdev = hci_get_route(&dst, &src, src_type);
 	if (!hdev)
 		return -EHOSTUNREACH;
 
@@ -337,12 +344,19 @@ static int iso_connect_cis(struct sock *sk)
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
 
-	hdev = hci_get_route(&iso_pi(sk)->dst, &iso_pi(sk)->src,
-			     iso_pi(sk)->src_type);
+	BT_DBG("%pMR -> %pMR", &src, &dst);
+
+	hdev = hci_get_route(&dst, &src, src_type);
 	if (!hdev)
 		return -EHOSTUNREACH;
 
-- 
2.53.0



