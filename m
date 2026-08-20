Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1D347ECFB;
	Thu, 20 Aug 2026 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248649; cv=none; b=mB1RqseTDOOp7yV03TvvBGGc9dgA4zvyCR1yoHAS3WtE/9V7PQT0jCNnkwjqVBrGpX/QiZ9JZUk0V/2ZpAS6YDUr6SSMljhCEEZrerZALEf7xxvDIj5Kks76gHCLumRU4qUfh7w/FJv/Gsih769wU529SE8/lDVv3HzqZ88RVNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248649; c=relaxed/simple;
	bh=BA/ocHCa5uO9MdlsI95APa6vWoM34w7p/Ladu3yHf5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfpvGWZ2/8CtENz4BVMIBAlw1hfjeOPwKooBhpTFpn9MDZhQY8d3Ld5pEsLR86CgTgtVMOChDEEQlcUGdfiDk8MTXsaYMHbFilHoAJ2vbf6/MK7DgSEATEsUTE7VqqqtAVQQalBh18L4Lnc0Tz5gzPaI2nEb6EidWVXLGhhaRfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAmsm1ma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAmsm1ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3861F000E9;
	Thu, 20 Aug 2026 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248648;
	bh=BCKpje2eninCniNxCGRifqGewu1nphcjGadKqaUP9YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAmsm1maIp7/f9N5mPvYa66/dIFxN0eaz6JtkbyoDnGty3TrNEvS7h2ARy2Y/r/x8
	 0BMtJ2ong4K0BoiiwJSw1/tia5eNL/clQyriDvVcIBkG5oXCM9n9y3LgM+hXPFyuzH
	 zcnoCojHTa3nD+JmDBiXxPiOVCD69d82rIFoaovQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9aa47cd4633a3cf92a80@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 300/303] Bluetooth: hci_sock: Prevent race in socket write iter and sock bind
Date: Thu, 20 Aug 2026 16:57:16 +0200
Message-ID: <20260820145302.485486297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

commit 89bb613511cc21ed5ba6bddc1c9b9ae9c0dad392 upstream.

There is a potential race condition between sock bind and socket write
iter. bind may free the same cmd via mgmt_pending before write iter sends
the cmd, just as syzbot reported in UAF[1].

Here we use hci_dev_lock to synchronize the two, thereby avoiding the
UAF mentioned in [1].

[1]
syzbot reported:
BUG: KASAN: slab-use-after-free in mgmt_pending_remove+0x3b/0x210 net/bluetooth/mgmt_util.c:316
Read of size 8 at addr ffff888077164818 by task syz.0.17/5989
Call Trace:
 mgmt_pending_remove+0x3b/0x210 net/bluetooth/mgmt_util.c:316
 set_link_security+0x5c2/0x710 net/bluetooth/mgmt.c:1918
 hci_mgmt_cmd+0x9c9/0xef0 net/bluetooth/hci_sock.c:1719
 hci_sock_sendmsg+0x6ca/0xef0 net/bluetooth/hci_sock.c:1839
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 sock_write_iter+0x279/0x360 net/socket.c:1195

Allocated by task 5989:
 mgmt_pending_add+0x35/0x140 net/bluetooth/mgmt_util.c:296
 set_link_security+0x557/0x710 net/bluetooth/mgmt.c:1910
 hci_mgmt_cmd+0x9c9/0xef0 net/bluetooth/hci_sock.c:1719
 hci_sock_sendmsg+0x6ca/0xef0 net/bluetooth/hci_sock.c:1839
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 sock_write_iter+0x279/0x360 net/socket.c:1195

Freed by task 5991:
 mgmt_pending_free net/bluetooth/mgmt_util.c:311 [inline]
 mgmt_pending_foreach+0x30d/0x380 net/bluetooth/mgmt_util.c:257
 mgmt_index_removed+0x112/0x2f0 net/bluetooth/mgmt.c:9477
 hci_sock_bind+0xbe9/0x1000 net/bluetooth/hci_sock.c:1314

Fixes: 6fe26f694c82 ("Bluetooth: MGMT: Protect mgmt_pending list with its own lock")
Reported-by: syzbot+9aa47cd4633a3cf92a80@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9aa47cd4633a3cf92a80
Tested-by: syzbot+9aa47cd4633a3cf92a80@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1247,7 +1247,9 @@ static int hci_sock_bind(struct socket *
 			goto done;
 		}
 
+		hci_dev_lock(hdev);
 		mgmt_index_removed(hdev);
+		hci_dev_unlock(hdev);
 
 		err = hci_dev_open(hdev->id);
 		if (err) {


