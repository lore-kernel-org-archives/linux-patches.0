Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7400826CE32;
	Mon, 13 Apr 2026 16:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097306; cv=none; b=eZ3sChVW9PPSQvItmAjC0q7pLx54a1q05MxK5GUSMpu5IfHLz0Glfg6i+SmHz5eXU1K1wRYK5AR3QsV2gBXmxEkABnct7Ng7a32Rpp+KeG8uMzE0i3OyrSQl0hcCEXDOejwvFTvGdMRLvUKaUhIdW+GH4RS2GMztnXmcE0uMiNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097306; c=relaxed/simple;
	bh=oRmu83i1XT7e+25Al5YnjNlGCgC5y34zXvyYo2oTmcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9u4AgRUYS0R7kSNyKoINOr6jJdhTZ8dprLgn86edFwgCKu83WxjH6uJDYKWmfC1Sm3/JvW0OqW1j66JdeaB/jwvBKzNq4U1rWqrXNXk4aHMzv/gacP5xj3PP96Zp3kBd08RSkD4BZp1/w6FJ4coHIRLIJznJ9cyAINNdKsr6nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li/TcmpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li/TcmpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38ADC2BCAF;
	Mon, 13 Apr 2026 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097306;
	bh=oRmu83i1XT7e+25Al5YnjNlGCgC5y34zXvyYo2oTmcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li/TcmpTCP37BY4+BjepapPyWdnChKBhKSmFmNeKeN14XhTbBeXwT+OSpINZcmpCy
	 Tvx0/qjTyGI4SWpRnl+u5qFfUMc6cE1fP04J5BiFQCuzFhvnPHXmOc/KSmda/WL2Zh
	 4mxhy9t+QEoBnFsVjv/DMFQDuvAjb9dg/Sv3UIgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/570] nfc: rawsock: cancel tx_work before socket teardown
Date: Mon, 13 Apr 2026 17:53:35 +0200
Message-ID: <20260413155833.590323107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d793458c45df2aed498d7f74145eab7ee22d25aa ]

In rawsock_release(), cancel any pending tx_work and purge the write
queue before orphaning the socket.  rawsock_tx_work runs on the system
workqueue and calls nfc_data_exchange which dereferences the NCI
device.  Without synchronization, tx_work can race with socket and
device teardown when a process is killed (e.g. by SIGKILL), leading
to use-after-free or leaked references.

Set SEND_SHUTDOWN first so that if tx_work is already running it will
see the flag and skip transmitting, then use cancel_work_sync to wait
for any in-progress execution to finish, and finally purge any
remaining queued skbs.

Fixes: 23b7869c0fd0 ("NFC: add the NFC socket raw protocol")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/rawsock.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 0ca214ab5aeff..23d52b8d6363e 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -66,6 +66,17 @@ static int rawsock_release(struct socket *sock)
 	if (sock->type == SOCK_RAW)
 		nfc_sock_unlink(&raw_sk_list, sk);
 
+	if (sk->sk_state == TCP_ESTABLISHED) {
+		/* Prevent rawsock_tx_work from starting new transmits and
+		 * wait for any in-progress work to finish.  This must happen
+		 * before the socket is orphaned to avoid a race where
+		 * rawsock_tx_work runs after the NCI device has been freed.
+		 */
+		sk->sk_shutdown |= SEND_SHUTDOWN;
+		cancel_work_sync(&nfc_rawsock(sk)->tx_work);
+		rawsock_write_queue_purge(sk);
+	}
+
 	sock_orphan(sk);
 	sock_put(sk);
 
-- 
2.51.0



