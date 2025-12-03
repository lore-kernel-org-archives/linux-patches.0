Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4E53570A7;
	Wed,  3 Dec 2025 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781002; cv=none; b=uYwtzOva9AJhVppOBsqymvLKwjNUi5fYAfo9upwmngJBBuT+SouQHMKhe8cW9ImPMTBFYahX+OrljSWSYbosKj489lsg2+DZYxecVounNIum24gBwDPaR0A3XxHK2vzFzQ5Z8wpn6VRTVJTJ+dy868i9DKrcmLKxJl7on8qVwmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781002; c=relaxed/simple;
	bh=2vHUP3/wegvbWGJQCrnj9qho8F+/mTtFa4bYsqRoi7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yn6TIGgxFVVRqQG7lLW6OFuiD6dskLbvgbTcD1GvykLXflBKDx3E4DpGjb+YTcFfT/qJI1wt3mGQOtGAoKHLGfTZ8mZ+qI4fQty2vq3JgRzLK3dDj+F3ALnU5ADWEIX0hlJ4LsKH+Rix1srvx6Qv/YR8iML0WeGO8wMURPv4/0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZqnQAL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZqnQAL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA23C4CEF5;
	Wed,  3 Dec 2025 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781001;
	bh=2vHUP3/wegvbWGJQCrnj9qho8F+/mTtFa4bYsqRoi7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZqnQAL77C9/7D56DmiRz48H8HVP2MmnZFhLP0lHbujTbz4N/pYfiB64BY/8uSrYi
	 XvX8TjhAtrvr7WldKUT0eSk6Zd8GOZRTE34DPrlpiLQLNHw0lfu6PPpz1Dtl2EHkXg
	 fxZBVbYGj19aAHRZv2r0SIXmt5XHBh6c4rn8NXYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9aa47cd4633a3cf92a80@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/93] Bluetooth: hci_sock: Prevent race in socket write iter and sock bind
Date: Wed,  3 Dec 2025 16:28:58 +0100
Message-ID: <20251203152336.701516958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 89bb613511cc21ed5ba6bddc1c9b9ae9c0dad392 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d2613bd3e6db0..8b3ef088ed14e 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1304,7 +1304,9 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 			goto done;
 		}
 
+		hci_dev_lock(hdev);
 		mgmt_index_removed(hdev);
+		hci_dev_unlock(hdev);
 
 		err = hci_dev_open(hdev->id);
 		if (err) {
-- 
2.51.0



