Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D7714A4E7;
	Tue, 17 Dec 2024 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456190; cv=none; b=hyPNWiye1bBhn4CLrr5EPlSmuvhqyLZJjqd9EUNATV6CtOfBkSjF7MMgUJZpFU7eJ5z7GsdULIcLrZ6uQRI4XEmjLLHva4PgokwjBwEIK7MfGpZVnPARiTDFu2vqeAnqWkE5331i2+ELOUvFe2yVXynzu7zG7n3s3PY8EBFhYWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456190; c=relaxed/simple;
	bh=svQyhjUpjfpj7Py0iqBYFa9e65PSJRHxlpNbr/KKlLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLn6bRY14GRJl/BPDB0iBtU9b8BIe+adWarO2xeEL19ciDXj3FNbnk71sFn8sAYoMQaIHvHFvZG8X+PtxOU4mGETNgLoxh8H67xMkZcLslYcuVag+BeXSl6YS9JF8kW061QhGXGWrZ5b10bnR3TTMAdHK7blpHk6lYe2iOF0lU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I23rJjuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I23rJjuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AC6C4CEE0;
	Tue, 17 Dec 2024 17:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456190;
	bh=svQyhjUpjfpj7Py0iqBYFa9e65PSJRHxlpNbr/KKlLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I23rJjuwRviGCFtHsks6eEsQ0vC97l+uZFaC4oZaU96dUzXwxlL6OumoV/8LkCFwV
	 TXjQCLqosrvb5x6bqTgpQjudTHSb1c4JSyM5jYGBHJpY3/CFyE2BrqutyOhxl4cSIq
	 NA+BsUvReYcfHBuvM1om1/AJOX2l7S7uQihU78Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/109] Bluetooth: iso: Fix recursive locking warning
Date: Tue, 17 Dec 2024 18:08:12 +0100
Message-ID: <20241217170537.060330796@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 9bde7c3b3ad0e1f39d6df93dd1c9caf63e19e50f ]

This updates iso_sock_accept to use nested locking for the parent
socket, to avoid lockdep warnings caused because the parent and
child sockets are locked by the same thread:

[   41.585683] ============================================
[   41.585688] WARNING: possible recursive locking detected
[   41.585694] 6.12.0-rc6+ #22 Not tainted
[   41.585701] --------------------------------------------
[   41.585705] iso-tester/3139 is trying to acquire lock:
[   41.585711] ffff988b29530a58 (sk_lock-AF_BLUETOOTH)
               at: bt_accept_dequeue+0xe3/0x280 [bluetooth]
[   41.585905]
               but task is already holding lock:
[   41.585909] ffff988b29533a58 (sk_lock-AF_BLUETOOTH)
               at: iso_sock_accept+0x61/0x2d0 [bluetooth]
[   41.586064]
               other info that might help us debug this:
[   41.586069]  Possible unsafe locking scenario:

[   41.586072]        CPU0
[   41.586076]        ----
[   41.586079]   lock(sk_lock-AF_BLUETOOTH);
[   41.586086]   lock(sk_lock-AF_BLUETOOTH);
[   41.586093]
                *** DEADLOCK ***

[   41.586097]  May be due to missing lock nesting notation

[   41.586101] 1 lock held by iso-tester/3139:
[   41.586107]  #0: ffff988b29533a58 (sk_lock-AF_BLUETOOTH)
                at: iso_sock_accept+0x61/0x2d0 [bluetooth]

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 83597b3c0a8d..b94d202bf374 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1120,7 +1120,11 @@ static int iso_sock_accept(struct socket *sock, struct socket *newsock,
 	long timeo;
 	int err = 0;
 
-	lock_sock(sk);
+	/* Use explicit nested locking to avoid lockdep warnings generated
+	 * because the parent socket and the child socket are locked on the
+	 * same thread.
+	 */
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 
 	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
 
@@ -1151,7 +1155,7 @@ static int iso_sock_accept(struct socket *sock, struct socket *newsock,
 		release_sock(sk);
 
 		timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, timeo);
-		lock_sock(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	}
 	remove_wait_queue(sk_sleep(sk), &wait);
 
-- 
2.39.5



