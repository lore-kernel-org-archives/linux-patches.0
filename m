Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2302AEEB;
	Sat, 12 Sep 2026 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227092; cv=none; b=NIoNQCoXTrOoQ+OCUornI7zCtyvX3uR8eI3KpaxVl46UtymOzk71ZYoHKEzycuj6yW9cWS8tJM/gSR13NKBYBXRTVPWBy2tc//QUALiN0EO9EhWeCdKeczlonhIroLRxjoJ//m26H8sONfDAazPtGqf3JAhsiRN8Vkj649INX2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227092; c=relaxed/simple;
	bh=/rsKmZVDu6y2CjXjWBdZsW0NWjyItWNYry0GDHk6roA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgqfS1uDX232yuWnS0abFMD4Ertshr3qkGMqcQDkZLqA2q6jQd4BTY3pueMrtKErcy1INHrd2GWDVgYK9n5gAVb5dbKAs1TN4fNMElkI6ZTUDFO57YSweu1ENBinhazapUfEr4onvEoIeeIZAZlznL73bsXpi6WbWNreg4zFOc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXuDMPQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXuDMPQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FD51F000FF;
	Sat, 12 Sep 2026 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227091;
	bh=xhTeWHIRTvjJPBiAa0AIY2NOuPeHZmjbmdYcL4K5zpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXuDMPQgFYFXQDwE8rWXV6F2z0GyZCPwnQikrBTWjDoEGIs9IiCeKgUXows8D0Dez
	 9nivcnk6H9+LYIk4LbMeXcx6MOSCGOUv/Yw8Ly3fwv6ac2kcTrDvipAKPBQgs0Qt29
	 EgSi2rXnKCH1YW1R77CIWd/SYrYlOB3+h22lE5+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0111/1191] Bluetooth: ISO: fix use-after-free of listener socket in iso_conn_ready
Date: Sat, 12 Sep 2026 08:47:19 +0200
Message-ID: <20260912065550.680796944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1479,6 +1479,14 @@ static void iso_conn_ready(struct iso_co
 
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


