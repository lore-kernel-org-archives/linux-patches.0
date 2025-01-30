Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CAA1BD9D3;
	Thu, 30 Jan 2025 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247273; cv=none; b=QKBaislu5TRJ0pYFLIKlD2GLmheJUOjfYxw8ChCdNCIUyOCIpR9XUuxsNn29ptATjRxshCj0vjLREuhkc673qYdEVOexv7j4Zo//N8B+MmP422atH8qg1eM5GHGgsKuh8GZ0gKg5ok76kbJN/tXf/lA0IzZg/XY8EAiG/xj/LAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247273; c=relaxed/simple;
	bh=+jFWLYQeCzyP/M0PZKVYYZqcdBMOPxiLF5boHbtipUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c04OdBlCzkRU7nJBR7tF7cp0n6OpoR2BNIyzaH1xTy5aEF9vnhuDifC2R09z6mwFXHAYtDENMgfK69rkfLII+khoZHSyyrDtFMm8YITwMNUoassHMQiLR/QQLdoDMb4jMwyrJuwjWo3Pg+4DkDT4nnntxWfLZ4Z63TYQXSahvkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lw8/C35L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lw8/C35L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C43C4CED2;
	Thu, 30 Jan 2025 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247273;
	bh=+jFWLYQeCzyP/M0PZKVYYZqcdBMOPxiLF5boHbtipUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lw8/C35LMNzB1Wrn/Wv/r1NZfux3pIWAkcCYOGpRsYnyGyWZSAyf1ZddUE/0z3MC6
	 KiRGevqgBjCPP6mm5/ad+GQqHg+FonuygbELamMVY9INKNau5ky/yFqRLTEMGuKo9i
	 CCzlKypsNaeLxdo9yvTTqr2G2TbqsbBcOpM6CUQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.10 126/133] Bluetooth: RFCOMM: Fix not validating setsockopt user input
Date: Thu, 30 Jan 2025 15:01:55 +0100
Message-ID: <20250130140147.600522150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit a97de7bff13b1cc825c1b1344eaed8d6c2d3e695 upstream.

syzbot reported rfcomm_sock_setsockopt_old() is copying data without
checking user input length.

BUG: KASAN: slab-out-of-bounds in copy_from_sockptr_offset
include/linux/sockptr.h:49 [inline]
BUG: KASAN: slab-out-of-bounds in copy_from_sockptr
include/linux/sockptr.h:55 [inline]
BUG: KASAN: slab-out-of-bounds in rfcomm_sock_setsockopt_old
net/bluetooth/rfcomm/sock.c:632 [inline]
BUG: KASAN: slab-out-of-bounds in rfcomm_sock_setsockopt+0x893/0xa70
net/bluetooth/rfcomm/sock.c:673
Read of size 4 at addr ffff8880209a8bc3 by task syz-executor632/5064

Fixes: 9f2c8a03fbb3 ("Bluetooth: Replace RFCOMM link mode with security level")
Fixes: bb23c0ab8246 ("Bluetooth: Add support for deferring RFCOMM connection setup")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -631,7 +631,7 @@ static int rfcomm_sock_setsockopt_old(st
 
 	switch (optname) {
 	case RFCOMM_LM:
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
+		if (bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen)) {
 			err = -EFAULT;
 			break;
 		}
@@ -666,7 +666,6 @@ static int rfcomm_sock_setsockopt(struct
 	struct sock *sk = sock->sk;
 	struct bt_security sec;
 	int err = 0;
-	size_t len;
 	u32 opt;
 
 	BT_DBG("sk %p", sk);
@@ -688,11 +687,9 @@ static int rfcomm_sock_setsockopt(struct
 
 		sec.level = BT_SECURITY_LOW;
 
-		len = min_t(unsigned int, sizeof(sec), optlen);
-		if (copy_from_sockptr(&sec, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&sec, sizeof(sec), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (sec.level > BT_SECURITY_HIGH) {
 			err = -EINVAL;
@@ -708,10 +705,9 @@ static int rfcomm_sock_setsockopt(struct
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			set_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);


