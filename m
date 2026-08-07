Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF31246E00D;
	Fri,  7 Aug 2026 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117339; cv=none; b=jd0c/6ssd2vhhljq0k+wqOGprPnFKeDOWMQ0JejWDDxgd3ZU6Ti5P1P88wigyLgXAg4Utii/ss8frsi3iF41sqxu6ZpLvHwwNDa24PddWuPXczoBqnVkgfDz2wm5spZIKwjBxE3C0VIg1Ab1euxjr+pNQa/zo2htLXxihCQAhmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117339; c=relaxed/simple;
	bh=Rd5dmZukWvku9uhcbbe3/XPlXd1qlxB5gGHmdJpbmK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4FQdfYu+qWMfHuhJ7EFfbn7sp2ft+8LYz/d4y4hw2pVbE5ovjuzlXdbvbOuKgIszo6b4PDcP99p5IFThChw/dTIBSoWLOXxRtoy5oTE1S4PE4m70h4DZNi9AChmlflc7qeR0TAU70SImaYKmsxbIjFyPkgWczjMPM+Q+tVyx/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AcFSuot0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcFSuot0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2D31F000E9;
	Fri,  7 Aug 2026 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117338;
	bh=AxoMWC3NGqA9GuTDd1feVuDaBdCe463QAVyvsyJ2cuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcFSuot0OBndXc1/XyGT2ZZnMQeyuEhaC3pgVuObJVQUxqbqie+uKIhURDGK+qgB0
	 YUvVG7keixppLmjLSMg0tZXkAb2HgQLVNRGF8yRCleKZX8ltdyVBm+BO3zskLauCVm
	 /F2z0pS0otHTi72eKq3J7pjKISWBW3BHUPJ62m6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 284/438] tipc: avoid use-after-free in poll trace queue dumps
Date: Fri,  7 Aug 2026 16:38:00 +0200
Message-ID: <20260807143434.034729663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -795,7 +795,7 @@ static __poll_t tipc_poll(struct file *f
 	__poll_t revents = 0;
 
 	sock_poll_wait(file, sock, wait);
-	trace_tipc_sk_poll(sk, NULL, TIPC_DUMP_ALL, " ");
+	trace_tipc_sk_poll(sk, NULL, TIPC_DUMP_NONE, " ");
 
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		revents |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;


