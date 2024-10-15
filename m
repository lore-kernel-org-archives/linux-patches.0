Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668A31FC7CF;
	Tue, 15 Oct 2024 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998447; cv=none; b=n/hNyKecvXVj+B4Evi8FT3bcQtl6X87jKMXF0tToOAgiVBtEpM6jdfJUiS6mWm87EhqFsOUfObKedOJURYEoCafHyecypANP0jtmspQqbIyCjqxhf9ZKrZpcbsDGfcIbzlcrcD+ICsvMng0CFwYC3d9MAIiXPYL9Xz0tMAEDcCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998447; c=relaxed/simple;
	bh=6ZlVtsV0Hcvd0t7cJlCK4sPZK/rf9k+vU5t+1wCxqhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyjB/+u+HsEpZJEyjWTswkSDGk8qC3eBEfqxCApclGzS1lzZOnPRUXxt9HQIslF6q/zW5UpSY8GUMRIWeVYllk43ste9ibUDVOlnclUkpMfCqaHTvNlgdApoKLFC8rhyIqZm7M1FJnrBEMKqq46uDaktbXgCPOnVjlMRx/emUFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnIOp80n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnIOp80n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B3AC4CECE;
	Tue, 15 Oct 2024 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998447;
	bh=6ZlVtsV0Hcvd0t7cJlCK4sPZK/rf9k+vU5t+1wCxqhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnIOp80nDAlVEd45Ay/h32nLzoKdQNG61x4HXMTkUqsFfb6sBEeWwkgkZH3H62qpI
	 eGMZadFNXcIInO4OxKlpmvg8+vxuZdPJ7qbM/oVht8HCYhUDKz4txk2yEJ9qFJjmOs
	 n5dVZ4cwsWJT79CD+Wb9VVzYnVDVRutnk4fMx6P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7ce59b06b3eb14fd218@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 480/518] Bluetooth: RFCOMM: FIX possible deadlock in rfcomm_sk_state_change
Date: Tue, 15 Oct 2024 14:46:24 +0200
Message-ID: <20241015123935.528175111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4cf1fa9900cae..5a490f707c816 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -871,9 +871,7 @@ static int rfcomm_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 
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



