Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738A6420889;
	Fri,  4 Sep 2026 06:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502506; cv=none; b=RFWDXFQ8lvJKN/ALVIf8B07n2+9HT5U6FX+Egq6eRzgouDjOblDTyAowyfHPb5W4xjWGM411ptmLHgDhlfKjQwGRCsq3Ba+9RQ7w2oZ1sE/bIoMGQZlCavOB9/V3pMHWsV7xgkRyqQApC8yzEhy8bTWK2kYhNCG2h+/zNje2Bqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502506; c=relaxed/simple;
	bh=t5fMx2D0vRAkBlJyuPrmQJlLYn3NMhE+LDmBa0jIlg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STxvEJx2LK/wiGhReNZZUUjgYO77idt5CYbirzOiT/M5wgjVlj2tvyG3ioJy8zFTOQDzoG+1gyfe1RtYnv6IwbxScJVKt8zrI0feQvKpvI7CJuAsq9rRv0Wrg6QJmNq3fsmfAvHAqOLAc1Oqj9OctWxdkYbtaXkQQ+5SX20l8xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/lTVrxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/lTVrxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA541F00A3D;
	Fri,  4 Sep 2026 06:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502505;
	bh=Lm63XwP4t11hQF54xmX3zW+TODuMJ8H57mCrZWjs0Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/lTVrxwU4XpSp48zvhIPBs1EEjNB7Detdii9p5ZN7onzj0rELg3SGjEeE+SxstK7
	 GkUG410ePj6epF8QM+xM2/Kl+nnGYYl7hWdD06w+rPQlvJiM2dEzUG3BwCk4ugvypC
	 7Jxs6hgofkcYxMf+Ks/zY1EnNo34lo1VAQ4D5MQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 178/403] Bluetooth: ISO: fix use-after-free of listener socket in iso_conn_ready
Date: Fri,  4 Sep 2026 06:59:41 +0200
Message-ID: <20260904045738.905652545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -2001,6 +2001,14 @@ static void iso_conn_ready(struct iso_co
 
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


