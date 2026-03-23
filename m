Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E496A2798EA;
	Mon, 23 Mar 2026 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278386; cv=none; b=k7w2I2KlLOd9byKE7Tdr6EpHX55ZOCen/quIVVsw5Ov5JVhaK+d1S7LILisonL7f7l1R+m6M+A34TMjWlkACr7wbIJl2vMq4NdkWyiBiyyMSoNlyLVvqgLXzluhRikDExMCsXEkD4IMt4N2GyTiMMFh6XMv/gUiV+OP/ixegur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278386; c=relaxed/simple;
	bh=hMhJhLtbv7U98aQLeDxA33vefMpSWHK/8xVcyovbU4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Br5n0gMqCfJwAn/1s3bRuRoYUEKEtnVsrAln46AZakMmcWWVjWiB/J8W4rcjpoCNN8roFSPr7iiAtH8EsVq6DnsB4joeHTtexqhU7mecIojWWD8RUDKHiR/PZDs53H0IOgmHQPvM0pVstJ+DtJ0XZPAbVfbUvufOK8g+HgRxv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDC/vwVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDC/vwVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68353C2BC9E;
	Mon, 23 Mar 2026 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278385;
	bh=hMhJhLtbv7U98aQLeDxA33vefMpSWHK/8xVcyovbU4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDC/vwVHz0uO8bZIPdy6lHpfrKvC/Qe4MJQpBoZBwyfawE6mWkwd3+3gePNrzKB9d
	 uN02lx67QvdBbWl3yiJ+9GaGgrple2rE8mlJo8T6jTxEgWXfhZhDR2comInRrT+/cJ
	 bF+lAtQlyDFQEnPJzaAESU6iOzQao9CaFIQ1rKaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehul Rao <mehulrao@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 292/567] tipc: fix divide-by-zero in tipc_sk_filter_connect()
Date: Mon, 23 Mar 2026 14:43:32 +0100
Message-ID: <20260323134541.046107820@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Mehul Rao <mehulrao@gmail.com>

commit 6c5a9baa15de240e747263aba435a0951da8d8d2 upstream.

A user can set conn_timeout to any value via
setsockopt(TIPC_CONN_TIMEOUT), including values less than 4.  When a
SYN is rejected with TIPC_ERR_OVERLOAD and the retry path in
tipc_sk_filter_connect() executes:

    delay %= (tsk->conn_timeout / 4);

If conn_timeout is in the range [0, 3], the integer division yields 0,
and the modulo operation triggers a divide-by-zero exception, causing a
kernel oops/panic.

Fix this by clamping conn_timeout to a minimum of 4 at the point of use
in tipc_sk_filter_connect().

Oops: divide error: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 119 Comm: poc-F144 Not tainted 7.0.0-rc2+
RIP: 0010:tipc_sk_filter_rcv (net/tipc/socket.c:2236 net/tipc/socket.c:2362)
Call Trace:
 tipc_sk_backlog_rcv (include/linux/instrumented.h:82 include/linux/atomic/atomic-instrumented.h:32 include/net/sock.h:2357 net/tipc/socket.c:2406)
 __release_sock (include/net/sock.h:1185 net/core/sock.c:3213)
 release_sock (net/core/sock.c:3797)
 tipc_connect (net/tipc/socket.c:2570)
 __sys_connect (include/linux/file.h:62 include/linux/file.h:83 net/socket.c:2098)

Fixes: 6787927475e5 ("tipc: buffer overflow handling in listener socket")
Cc: stable@vger.kernel.org
Signed-off-by: Mehul Rao <mehulrao@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260310170730.28841-1-mehulrao@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2238,6 +2238,8 @@ static bool tipc_sk_filter_connect(struc
 		if (skb_queue_empty(&sk->sk_write_queue))
 			break;
 		get_random_bytes(&delay, 2);
+		if (tsk->conn_timeout < 4)
+			tsk->conn_timeout = 4;
 		delay %= (tsk->conn_timeout / 4);
 		delay = msecs_to_jiffies(delay + 100);
 		sk_reset_timer(sk, &sk->sk_timer, jiffies + delay);


