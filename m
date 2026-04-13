Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037F430FC1E;
	Mon, 13 Apr 2026 16:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098684; cv=none; b=hz+Sm/ku3+FcyQUpVn2Q3BR6V0tFrXmQzXuzPFVAhxpiLABjPHTdlulrzEv5lVZxSN1n6je2YEJ3IlUOjPmtqezROQP7Kx8hsoh2JBSvko45AZ8FYi0covEuk16oSjjIJKgzQ2SdxCDLTQGgvO8QHyI251EO+hF64qT5ByxmuRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098684; c=relaxed/simple;
	bh=n8IOE5hVKAQW2eLZtK3k2QgzEKc1XaV5Aa3y7csNEm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxc1oqA/V0yCKYJLIMVzcMPnA0lz1XMKblZ7/wsR6I7rAIXLA2uyFGAdgkXHHfv8HxHbk/xJxW0InQBjaJdUKtQ8Dv5LT8GDrMi8gaDT1C54rVy30o3C9qhvNTrf5xeDYYESRvvWEp3da3jVmd8I5hh4SDI3d8IYv++zCKN8HxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT8PreDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT8PreDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CECAC2BCB0;
	Mon, 13 Apr 2026 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098683;
	bh=n8IOE5hVKAQW2eLZtK3k2QgzEKc1XaV5Aa3y7csNEm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GT8PreDxLXSs0iuyTyCxX9N1FHGmhOIEVDO0R24uVMT1zvHCpPdeUYNulwimUF4CC
	 kgJWIhdVTWgV3GSpNoI/jX9r0zpMO84dYckkx/Do9EYVfwmR7xa0+cGaj16vjG3yUK
	 OXrCzIsXzBZ8WMdmoHQV2qgFtARUT+K0s6/Zg3+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/491] nfc: rawsock: cancel tx_work before socket teardown
Date: Mon, 13 Apr 2026 17:54:54 +0200
Message-ID: <20260413155820.888273984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5f1d438a0a23f..0e59706e4e8ab 100644
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



