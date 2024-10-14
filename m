Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5B81C0DCB;
	Mon, 14 Oct 2024 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919994; cv=none; b=eZDylSEfGu8cIGo3OOKQmqMvQ085ph8nMeaIYD4EbugkYc2XwfPvhaqdwmYodJP4QJUbhtSPEOGUVPH6fdMm7ndmneaf0rZrPju7rqb54Yt5f3aoDOWIbFLt1bSh//mIdEGxz3H6H+2O4RbiP+z435jJGCdcN+9lWUB3rPHi1oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919994; c=relaxed/simple;
	bh=nwKB4zkrWNBuq8gE2wjdsVCeKDHMfNd1lo0jlxca11U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw/EHuFlDvZrnGPCv4GmBvwEhGNqNXP9bO6OBE888605NRwMsu8eAPdNfQfeiKKArwRkUD5N5C+Xo1+YEwCOVDH6l7Xgn+GusV2doR9cZ7GB1AjZSaYkf7XFzSn9zck4ByOguEIYi8pPt000h3MwjrfeNqMSRnnU5opF45kjiKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWwU3kpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWwU3kpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74CFC4CEC3;
	Mon, 14 Oct 2024 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919994;
	bh=nwKB4zkrWNBuq8gE2wjdsVCeKDHMfNd1lo0jlxca11U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWwU3kpdy7d3SlB08Y79Q401UYkT5V6Ez1Cgi6oYM/5q3TVXDWbDNaLPQCgfIsi34
	 UnX7Nz0OYnC4qwG6s7RYKnFIZ2zX4OhaL4oNwqfhR4ML3sZMeZ4hYx6FCRYx8zz1xn
	 bG7y6eFOilbeb6f7280Q3tCzHUYV9/cjBP/9Dssw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7ce59b06b3eb14fd218@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 736/798] Bluetooth: RFCOMM: FIX possible deadlock in rfcomm_sk_state_change
Date: Mon, 14 Oct 2024 16:21:30 +0200
Message-ID: <20241014141246.986445925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 08d1914293dae38350b8088980e59fbc699a72fe ]

rfcomm_sk_state_change attempts to use sock_lock so it must never be
called with it locked but rfcomm_sock_ioctl always attempt to lock it
causing the following trace:

======================================================
WARNING: possible circular locking dependency detected
6.8.0-syzkaller-08951-gfe46a7dd189e #0 Not tainted
------------------------------------------------------
syz-executor386/5093 is trying to acquire lock:
ffff88807c396258 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1671 [inline]
ffff88807c396258 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sk_state_change+0x5b/0x310 net/bluetooth/rfcomm/sock.c:73

but task is already holding lock:
ffff88807badfd28 (&d->lock){+.+.}-{3:3}, at: __rfcomm_dlc_close+0x226/0x6a0 net/bluetooth/rfcomm/core.c:491

Reported-by: syzbot+d7ce59b06b3eb14fd218@syzkaller.appspotmail.com
Tested-by: syzbot+d7ce59b06b3eb14fd218@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d7ce59b06b3eb14fd218
Fixes: 3241ad820dbb ("[Bluetooth] Add timestamp support to L2CAP, RFCOMM and SCO")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/sock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 29aa07e9db9d7..cbff37b327340 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -865,9 +865,7 @@ static int rfcomm_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 
 	if (err == -ENOIOCTLCMD) {
 #ifdef CONFIG_BT_RFCOMM_TTY
-		lock_sock(sk);
 		err = rfcomm_dev_ioctl(sk, cmd, (void __user *) arg);
-		release_sock(sk);
 #else
 		err = -EOPNOTSUPP;
 #endif
-- 
2.43.0



