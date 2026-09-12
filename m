Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECE747887F;
	Sat, 12 Sep 2026 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220204; cv=none; b=cPPBah1TikoSsi+pXdKxABytvYtyGh07LUpFrH4Xh2r+5BlOcyeulYsFLqgFlKtBOMge8kpZIFkksjh46v9VQC34pWnOLOigjXY/XGctfnxDLk2aHNrd+VtDMYV7au2scj4ehc7CRijZCncv2rW70Bh++7gma+QSpYHjtWlldgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220204; c=relaxed/simple;
	bh=9fS7k1qUW7aCgUiblpU1mJy2BnALrziWSn7H/e4E0nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yya6clMHMCMW8mfO0SGBQSHNyb/M+HbJVbOAGmZFjF92UQWIi2fc4LeR7nV8xdcUIIOmCLtp10px6SwAGuc5XBt+O+jPIe+dkyu5dj+3yK/7UShZh5EPnCYPQrArJZN6hdYJPy2yOhBvACoaUj/tPhQdvDHPQ3OPF5RTe2a/sHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAKPS+kY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAKPS+kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC83D1F000FF;
	Sat, 12 Sep 2026 13:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220203;
	bh=nA+bXav5AsKOlaySu2arCKHYowIZZxkuCbgIpqIYnnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAKPS+kYD7rk58URzukVcSMUT7Jqhzkq/TvrTihaa6SWLpJ89Mfux332W5q8WQcBi
	 KuiAusCtnExdyVMxAqaGZpC41TpWEZMKbx9k0QJy7Xzv9DM5B/0ozqmhrInYYgI9pt
	 baeehWTyIM5ubf3tYNXULKmUnAwsCkDk3oBoiPnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0130/1424] Bluetooth: ISO: fix use-after-free of listener socket in iso_conn_ready
Date: Sat, 12 Sep 2026 08:42:42 +0200
Message-ID: <20260912065610.211512722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1760,6 +1760,14 @@ static void iso_conn_ready(struct iso_co
 
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


