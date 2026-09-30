Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD234E324C;
	Wed, 30 Sep 2026 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786802; cv=none; b=hUcvXIaf9/BGD9RLSpE92P44QyQESeSvxFA9OKvxFclK7Ol9Q9vfLIzGoO+TkxUF39oY19Ba/CIqDQgWcthS9aS0aSTVMsz1yI/PtZS7T3Z8WqukhHCdXeT+nxcSvQLb/VdJS4lds3lQ7ut7HNjtg9W67lSYfzrqTAFfUuijNko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786802; c=relaxed/simple;
	bh=liGkIPSVrMyJQImiN6igQdMqEgI+DM5Yi7XKpJDJpf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkFQYkgZL9pGM/hcWRYGFNZP7tSXF+A1dxjYD0S2Oqr9SNsZj+cnxX3TGGY0uvXRe9xzfUSIIvCcO8axqJxezeJ0/MxgEPgnHPYvCOthYKBO00G/U3jQ50Rv8p01a8dbSSPdcikIH6ZjSQTFuo5Xf2MHCQ3Q2yPtMPxL9HLEq3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIMnnYtM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIMnnYtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D731F00893;
	Wed, 30 Sep 2026 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786801;
	bh=9GC6YXrwypvYkwSB+Ngdr5XdYq1S/+aUQV4JJfuRfSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIMnnYtMErkddDENO4pLD6QflmrwzFJTtrd2caPrecHeaTiDkxmuuDPQ60ci5OX//
	 zffUoeEjZrMAemEKPccR9m3CdILGkw466b/ACbFEE75kNognjqJydrDNMTHhZGiAwc
	 fzGqAECyCr8lkc8DNmupiCE5lwch7Y2HNgorbG00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 973/982] Bluetooth: RFCOMM: fix NULL dereference of dlc->session in RFCOMM_CONNINFO
Date: Wed, 30 Sep 2026 17:28:29 +0200
Message-ID: <20260930152437.645198703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

commit 46f8ffd0a1f1eb6cbc94946a92c11ef601e228a1 upstream.

The RFCOMM_CONNINFO getsockopt handler accepts a socket that is not
connected as long as deferred setup is enabled:

	if (sk->sk_state != BT_CONNECTED &&
				!rfcomm_pi(sk)->dlc->defer_setup) {
		err = -ENOTCONN;
		break;
	}
	l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;

dlc->defer_setup is set in rfcomm_sock_init() when rfcomm_connect_ind()
creates a child socket for an incoming connection on a listening socket
that has BT_DEFER_SETUP enabled. It is never cleared afterwards. The
session, however, can go away underneath it.

rfcomm_recv_disc() forces the dlc state before tearing it down:

	d->state = BT_CLOSED;
	__rfcomm_dlc_close(d, err);

The RFCOMM_DEFER_SETUP early return in __rfcomm_dlc_close() only covers
BT_CONNECT, BT_CONFIG, BT_OPEN and BT_CONNECT2, so with the state
already BT_CLOSED that switch does not match and the function falls
through to rfcomm_dlc_unlink(), which sets d->session = NULL, while
d->defer_setup stays 1.

A getsockopt(SOL_RFCOMM, RFCOMM_CONNINFO) on the accepted socket after
that point therefore skips the -ENOTCONN path -- sk->sk_state is
BT_CLOSED, but dlc->defer_setup is still set -- and dereferences the
NULL session. No race is needed: once the DISC has been processed, the
dereference is unconditional.

Reproduced on a KASAN kernel under QEMU with a BR/EDR peer emulated over
/dev/vhci: the peer brings up an ACL link, opens L2CAP on the RFCOMM
PSM, starts a session and sends SABM for a channel bound with
BT_DEFER_SETUP, and sends DISC for that dlci after the socket has been
accepted. getsockopt(SOL_RFCOMM, RFCOMM_CONNINFO) on the accepted
socket then hits:

 Oops: general protection fault, probably for non-canonical address
 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
 KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
 CPU: 1 UID: 0 PID: 150 Comm: init Tainted: G B 7.3.0-rc3-g5dd1818b15d9
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
 RIP: 0010:rfcomm_sock_getsockopt+0x529/0x780
 Call Trace:
  <TASK>
  do_sock_getsockopt+0x3ad/0x7d0
  __sys_getsockopt+0x10e/0x1b0
  __x64_sys_getsockopt+0xc2/0x160
  do_syscall_64+0xda/0x4b0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

0x10 is the offset of sock in struct rfcomm_session;
rfcomm_sock_getsockopt_old() is inlined into rfcomm_sock_getsockopt().

Commit 43a556b2fd43 ("Bluetooth: RFCOMM: take rfcomm_mutex for the
deferred setup accept") fixed the same "a remote DISC clears the session
while deferred setup is still flagged" problem in rfcomm_dlc_accept();
this is the remaining instance of it, in the getsockopt path.

Deferred setup only leaves a socket usable here once it has reached
BT_CONNECT2, so restrict the exception to that state and check that a
session is actually present before following it.

Fixes: bb23c0ab8246 ("Bluetooth: Add support for deferring RFCOMM connection setup")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -786,8 +786,10 @@ static int rfcomm_sock_getsockopt_old(st
 		break;
 
 	case RFCOMM_CONNINFO:
-		if (sk->sk_state != BT_CONNECTED &&
-					!rfcomm_pi(sk)->dlc->defer_setup) {
+		if ((sk->sk_state != BT_CONNECTED &&
+		     !(sk->sk_state == BT_CONNECT2 &&
+		       rfcomm_pi(sk)->dlc->defer_setup)) ||
+		    !rfcomm_pi(sk)->dlc->session) {
 			err = -ENOTCONN;
 			break;
 		}


