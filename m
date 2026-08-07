Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263F4281369;
	Fri,  7 Aug 2026 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116137; cv=none; b=VIfvvq68VpnAQmuDI8TDuICCMxiOyW+QnpIAoinSUfRj+DA46XwgYoXIGInhU6HumWPT8m/8pFHwPYPf8aEAL0gNhLe+3etjA95Z3rev/E3iuY3guypMoV5GoWkFvuhP05StuyUWBn5r5QhI0JpNt57JdzQZ7FYvOfxQJSFHjZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116137; c=relaxed/simple;
	bh=lPPEsSoeLCBXdGO344zRM04K1Dks3YDIkeSFLkij+xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npr3UvwO4JiyQKVBEeqaTlwygsDNLh8nL0hKgZpPQNpUE/X2T2bD3pDeR7GDsrUg5+HRu2daoxclOjFwqQMoDVxh6K1UBbnP5vTPAIYzB0nuin8WlkQwXJnaql3F/BvRs446I6qEdgjEltLeJGqWJQpi++irETp1RkYavwgIihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+1kGoSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+1kGoSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816FB1F000E9;
	Fri,  7 Aug 2026 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116136;
	bh=f1DHFeh8hgz98fke/Sq2DTfSJfqGaUAi7o7JHqaJKck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+1kGoStC9+BF1f/yR2XtfJDFxENwEOtuwxmAULXDDPkQGEabNBSTcaTNOgLS8PCu
	 ggQ3Xq00DxrKUvISeTJc2awo/cKyYRfAQ5dUO4AwwdlMNkaYr1op+qu7kZEe0dfRkO
	 icbF0ktxe28Fm81sueFyaGM7enlmUprOSw+3UJUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 126/261] tipc: avoid use-after-free in poll trace queue dumps
Date: Fri,  7 Aug 2026 16:38:03 +0200
Message-ID: <20260807143418.086745274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit b4f1719dfea023220e0e6bd892b087d76b2a6a49 upstream.

TIPC socket tracepoints dump queue state through tipc_sk_dump(). Most
queue-dump callsites already serialize that walk under the socket lock or
sk->sk_lock.slock, but tipc_poll() calls trace_tipc_sk_poll(...,
TIPC_DUMP_ALL, ...) without holding either lock.

That lets the poll trace path reach tipc_list_dump() and backlog head/tail
dumping while another context dequeues and frees an skb, leaving the trace
helper dereferencing a stale queue entry.

Stop the unlocked poll trace site from requesting queue dumps. Other queue
dump trace callsites keep their existing output under the locking they
already provide, while poll still emits the event itself without walking
live queue members from an unlocked context.

Fixes: b4b9771bcbbd ("tipc: enable tracepoints in tipc")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/f8119abd5e5ecc400597de667ae9d39656de56d0.1784794294.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -798,7 +798,7 @@ static __poll_t tipc_poll(struct file *f
 	__poll_t revents = 0;
 
 	sock_poll_wait(file, sock, wait);
-	trace_tipc_sk_poll(sk, NULL, TIPC_DUMP_ALL, " ");
+	trace_tipc_sk_poll(sk, NULL, TIPC_DUMP_NONE, " ");
 
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		revents |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;


