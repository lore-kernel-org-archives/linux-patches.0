Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D413242BD;
	Fri,  4 Sep 2026 05:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500981; cv=none; b=hnQ3EQOr5Wq5TjSETBkl4gHQFgfc6I+pItDDhwYxOznTd9zNw6KogA3TJ2c6n9/SwkkuJUBfuG/MKWWNU2lUOCJ4x9P+lb6KwRbAMl1Euz1OWTuWnyeEHvder3YXtRaA0gVdWdH8MmwdmOWErSws2ChyMi70wVlstGP/eer2RRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500981; c=relaxed/simple;
	bh=SS3sWk8fmG8FaB2nbJN5HYdRus9Vsq7DFI38bAJyeGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouXiTMjnCYssGsVwZQrbW5uHsOv4wcV29FibmEvNgSLao98D+BHe5g2oEEpqSFg9VH3lCP/mgcOdwNkfELnU7UUcmd3jz2njCMxnDMUhIOapjHWDz8lk9a+6kJPL7kvwZJq2gY/8Wfj3MoCtQKkyRj9rQPvIxOODPqae5iO5p/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGVMIrA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGVMIrA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D1A1F00A3D;
	Fri,  4 Sep 2026 05:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500980;
	bh=WtaH4Xjwb61elKPsbJ231Uf+jP7hpnOzCsAAoO/spR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGVMIrA8bxEEEI/bClO/XU1BiN1Zxjd5w+COeD4jm8/JahJ17ZPACS4Rn6vBhGuu2
	 4SRwr2vSL4sRioA+ZBpLXUlqJpR6lnqw//maSEbLL3E7ujaQYwBdCP1vFiLFOXTWZa
	 NIBk+8JEoSRsccRqKk43zSg8tL8MKKZv74EU+Tys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Nan <2122295973@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 247/552] Bluetooth: ISO: fix use-after-free of listener socket in iso_conn_ready
Date: Fri,  4 Sep 2026 06:56:44 +0200
Message-ID: <20260904045755.162830922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -2148,6 +2148,14 @@ static void iso_conn_ready(struct iso_co
 
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


