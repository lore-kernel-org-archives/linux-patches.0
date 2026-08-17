Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374643231F;
	Mon, 17 Aug 2026 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979975; cv=none; b=jbW9PcuZ2FWnKRWa9PmFzNMuDy0cDEnJ+WEQi9cRDSxISbcf8LeqiLSipC2h4s46XEadI1A3Z+dIQn0MDq+de/IwVtJzEFx05S9vL+0XoZuhK9/hqf3qxOCxU9j9h7Mcq9Muo1tjVCWrlyY/qEtAPSkwphXvu0eo6bPaqZZuINU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979975; c=relaxed/simple;
	bh=MqFwBzZ8LzYFXFOebvnex48arMh8AC9Yx8BipjOMIW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNXDPoZWo0zCtuEMSkmRyaRBAGxq1jOowaXJTsQWAYR/CCYM5hS6QGTmI6l1PuWLUyfvSWTNekpOuuMkS9PLq4dz7nqsi1AZzUeqFBvl65cY+RWitCuTYP5yJ+1j/Szm4nm+619rimUiUKW8LL1+ITboFSQaVmfUEZENhi48mH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBVhWLIp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBVhWLIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E640E1F00A3A;
	Mon, 17 Aug 2026 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979968;
	bh=ZHyo+ZmOq26WxHRfxyvo/NzKt9lXKb3nDdmCyk+dmnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBVhWLIp14rwBLr0HSK+pq/iD+lB5OSVlf8tVy+H0IQt62TY1W6Esl2uQc0o2w3CQ
	 VIs9FEU2s/Wn44pusU9Zo4FJ5qgOtZp8rxK7kEy74wsDbwe6wsbHIc5Mo9xJ1Rhu3q
	 At+mbKjdnZOlsZ52Ig1Vs/2BZsuigHF+ZUPF/cDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 411/609] tipc: avoid use-after-free in poll trace queue dumps
Date: Mon, 17 Aug 2026 15:31:47 +0200
Message-ID: <20260817132557.909139146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -797,7 +797,7 @@ static __poll_t tipc_poll(struct file *f
 	__poll_t revents = 0;
 
 	sock_poll_wait(file, sock, wait);
-	trace_tipc_sk_poll(sk, NULL, TIPC_DUMP_ALL, " ");
+	trace_tipc_sk_poll(sk, NULL, TIPC_DUMP_NONE, " ");
 
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		revents |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;


