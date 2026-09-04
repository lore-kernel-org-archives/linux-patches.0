Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F63417BCA;
	Fri,  4 Sep 2026 05:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499223; cv=none; b=jA+SoC7p3151vsTOfIV1JXReyr/wFWQPM/k5DkK9TfK2P86Cqv9UlbqlgyLQt9sEsILU64BtyfYWaw9UFboGNSfYJzmGBowvohcrZExwN3zbkeGGdfvu0lCVpJt5nAKXLVZ2rmsPL2koo59Q23TNlh8eq+kNEMJiGj2LMnni/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499223; c=relaxed/simple;
	bh=PVPqcEekISZHJvdfTrmHHA70InYWeOgq5e7qkclYUdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6Pca4gaATF4o/OSHAv20in5fhu/a5bxXbH++wWkwMIhMhYHhiQsfGMLCE+BMO/hNeEsiqS08fNHkCEaAqhCz2JY0qpz2xtby9Q8aOmk0d1ZBikmjsJMVRrYrFd7VWkVGywcopQhpXJUKWiDLLO+wIlaZ6dI0FK6i6/itz3x8A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VY3aChi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VY3aChi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2681F00ACA;
	Fri,  4 Sep 2026 05:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499222;
	bh=KiKkK+NJ5sd6txN+gfvj0tuIPJaanHSCTbzhbaMHbHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VY3aChi/LRNN8jm7J923vKfFbQ44Ih6fst349LkpHLV9k9Un5ojCNZbF1VG5nVj7V
	 sGqBF0FrKtJP58Moes3zD4y49VQcqFmEtjBqaV6Us1HvkYJFfH+iG41kFec23BhS6A
	 hlLggqNonRFpO37UuFIeVp/nbtHeOvHSdO+y5elo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 340/713] Bluetooth: ISO: fix use-after-free of listener socket in iso_conn_ready
Date: Fri,  4 Sep 2026 06:55:08 +0200
Message-ID: <20260904045811.449450186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hang Nan <2122295973@qq.com>

commit 560bef609fa5992745929e8d7d458b9d88dd2830 upstream.

iso_conn_ready() looks up the BIS listener socket with iso_get_sock(),
which takes a reference, and then, without re-checking its state,
creates a child socket from it:

    parent = iso_get_sock(hdev, ...);
    if (!parent)
        return;

    lock_sock(parent);
    sk = iso_sock_alloc(sock_net(parent), NULL, BTPROTO_ISO, ...);
    ...
    iso_chan_add(conn, sk, parent);
    ...
    release_sock(parent);
    sock_put(parent);

If the listener socket is closed concurrently, between iso_get_sock()
and lock_sock(), the reference taken by iso_get_sock() may be the last
one: the close path drops the link-list reference, and once
iso_conn_ready() drops its own reference at the end of the function the
socket is freed.  The child socket, however, is already linked to the
freed parent, and a later disconnect of the child runs iso_chan_del()
-> bt_accept_unlink(), which dereferences the dangling parent pointer
into the freed accept queue (a use-after-free).  The same dangling
pointer is also dereferenced through parent->***() in
iso_chan_del().

Fix it the same way the connected (non-BIS) path was fixed in commit
0d255e63fcf3 ("Bluetooth: ISO: hold sk properly in iso_conn_ready"):
after taking the socket lock, re-check that the parent is still a
listening, alive socket, and bail out otherwise.

Fixes: ccf74f2390d60 ("Bluetooth: Add BTPROTO_ISO socket type")
Cc: stable@vger.kernel.org
Signed-off-by: Hang Nan <2122295973@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2277,6 +2277,14 @@ static void iso_conn_ready(struct iso_co
 
 		lock_sock(parent);
 
+		/* The listener may have been closed concurrently. */
+		if (parent->sk_state != BT_LISTEN ||
+		    sock_flag(parent, SOCK_ZAPPED)) {
+			release_sock(parent);
+			sock_put(parent);
+			return;
+		}
+
 		sk = iso_sock_alloc(sock_net(parent), NULL,
 				    BTPROTO_ISO, GFP_ATOMIC, 0);
 		if (!sk) {


