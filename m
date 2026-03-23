Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABA43C060B;
	Mon, 23 Mar 2026 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282618; cv=none; b=p5R3jhYyz8EEY0oAzrZrdDUZW75wuEYO9H6oy5ZMbAoFbH89OV8RG+wBVDW10dD3pYdDWNil8nsq1+9L/yAQRSdyO6uVbr5317XcRm/JQ0cEeGDWodh3CznC8nt+rrsumunwnQ1yclnXoayZoTpRXAdGdh/3o+F9NWV+YwY5ms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282618; c=relaxed/simple;
	bh=n6xcYK2nGJ8es1RYXk0d4H65BR7tCt7OYEJ0hc1FCZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFZf3Gqvf0kzoRegpfNd3f7ktiFlfIhCdzRat5FJp/e049GdlmUDE3ls939V48b96TtkpjwdbwCB5dEh62n6c2KB3OmESCSkSMAxRhsDFBh/kJaHgUspzHOL4O43FkXDj7AlNwQHGFAFe9kE+jS8/v7SQlhoRHFqsgj3xAwrWDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sB7fCZH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sB7fCZH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E36C4CEF7;
	Mon, 23 Mar 2026 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282617;
	bh=n6xcYK2nGJ8es1RYXk0d4H65BR7tCt7OYEJ0hc1FCZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sB7fCZH4f794Pe305ZDjNytWSON2OocejW4cDVnBVKqSr6jagJLAx9knj+ZQ871gU
	 JT+uAA2rb/XjkdYKhJZYyueG1IYf0qX9t4QXrXJina36Q+lRgOeDmDsaPqe40Fte13
	 Z3XrG69l+gsXV57yvhS5qqyWqf6V7yVMTmklf5OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehul Rao <mehulrao@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 222/481] tipc: fix divide-by-zero in tipc_sk_filter_connect()
Date: Mon, 23 Mar 2026 14:43:24 +0100
Message-ID: <20260323134530.559590679@linuxfoundation.org>
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
@@ -2235,6 +2235,8 @@ static bool tipc_sk_filter_connect(struc
 		if (skb_queue_empty(&sk->sk_write_queue))
 			break;
 		get_random_bytes(&delay, 2);
+		if (tsk->conn_timeout < 4)
+			tsk->conn_timeout = 4;
 		delay %= (tsk->conn_timeout / 4);
 		delay = msecs_to_jiffies(delay + 100);
 		sk_reset_timer(sk, &sk->sk_timer, jiffies + delay);


