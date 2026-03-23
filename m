Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F153BD240;
	Mon, 23 Mar 2026 16:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282381; cv=none; b=u8yUvQpjs5sLPG7EgjNmDc9p/cA10J2jEpnLgrQLsBZ4Z3sms/DcN2/YZktpdl2pwKuqBkLBzVAqXE6zSgI6JDiCkszBMtKmcE4npcohdUnpNU0vCEwRHDm6UbnQM10tsPiAOh2gHezqRxU/036lFBMENdHOIhCy6hQcOPxWqMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282381; c=relaxed/simple;
	bh=5qzGa7Ap083E28WJn/+Sy9ivmJatUONPIukudhhCMB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGNP9LuHia4/Xsq/Dg53g6dH8+/wwKMxmVTMiUqlvPQHPezQfdZnRR7YzzDnWBuqG/xU3J37bUHfnBVcLerdTLX5wRNFrYS66u2kZWX3yv9VkdIuqOnUkKD6EvzuNuq8rg9ISllMmma2xJ76PJ1otJV2eLmdptUmoVPxd1TE4lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFuiJZ11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFuiJZ11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAB1C4CEF7;
	Mon, 23 Mar 2026 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282381;
	bh=5qzGa7Ap083E28WJn/+Sy9ivmJatUONPIukudhhCMB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFuiJZ11Ki0ufwMqEAgkcdFPJ5zjnfr8lzbtY3kS1vCujFcROadT9BpXpUvyA8rr6
	 JT6BwgTzV1OGGAYBOgEVSPVfBKgW+FCg7JDRMRHzKOGDtlL7kMqIUOcThUcmXY6lwn
	 1AV2dd+FxeVh500elW5BwlzzuH2aOgh+YfXtYm38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/481] nfc: rawsock: cancel tx_work before socket teardown
Date: Mon, 23 Mar 2026 14:41:56 +0100
Message-ID: <20260323134528.528758345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
index 8dd569765f96e..cffbb96beb6cb 100644
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



