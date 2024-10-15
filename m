Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C83B1EABC3;
	Tue, 15 Oct 2024 12:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994186; cv=none; b=BMv9LdFWaP3i5k4tcwEGAR3qzSc4SXu6ZIYOu8Q962c/TkgO9cimvSWPb8kL0B14p/CDKJk4DR10DFLljE2zPW691JgyPznUQXBeW9BYfWkk0lu8mzZwLmuyp/++T9Rim3SsGdDzPa3GDXI9Oz0hA1NcLZelG2vA6dWPhkN3bpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994186; c=relaxed/simple;
	bh=S3rLIbRWb0PZDnt0/feGXyyy0yaK/787Gq9OnPjXHjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8xUp/O0K7xqXkR/WEnNkKTbZspQwXbxLjIv25tMGh5D7Wuu6Kn4gDFcpRWL8nWtvxAwBI/Oelbuu9RGroS0EUit2YCr2ezWK/pmy+UfO4Rqnon5jIGnu3p66gH4lPpDgXV51rAw5WhE2Iz+TQ0QzaEkRTDLJj4mb7hUV2NA2qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nITzR8ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nITzR8ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A5DC4CEC6;
	Tue, 15 Oct 2024 12:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994186;
	bh=S3rLIbRWb0PZDnt0/feGXyyy0yaK/787Gq9OnPjXHjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nITzR8ul99dWdDXFDQmJGbbSTf9AKSfSHSBxKAYBARjjjTDE6Q21kBPaHjussAQ8y
	 JfZ7wf4UhK0USGlZOPEaFTWa4JS+cKeEWykOdJ5jDyWJCNeU1dohpA0LLWD8xmZ3h0
	 mpBfJNVSZyw3703ezHc64P1a6LKzyW53ai2HpY8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7ce59b06b3eb14fd218@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 632/691] Bluetooth: RFCOMM: FIX possible deadlock in rfcomm_sk_state_change
Date: Tue, 15 Oct 2024 13:29:40 +0200
Message-ID: <20241015112505.413297382@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4397e14ff560f..44c998e4a9e6c 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -876,9 +876,7 @@ static int rfcomm_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 
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



