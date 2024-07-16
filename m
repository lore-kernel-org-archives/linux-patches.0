Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A4FF9E8;
	Tue, 16 Jul 2024 15:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144684; cv=none; b=BOuo7cdb5uBO/KYQlkUQNk8//hZchHfLhe0jyObaMO/tScZMgc68e/Si9whhezgHvvTn2qN8789hKWDz3ZcsMr2O/oro2ujwjyh1Dj5OPu7gf7QwjzJZd4OKnhtcRP7YbeJqFwAYvA0KSaUoYKGVxJgWYcsamsuyH0P/thQpJCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144684; c=relaxed/simple;
	bh=nPzp8PL+BJ+lwlIqJbRueOhL3HMOnVbnXtupuOOVroA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3gM5LmfWmzepzmjIEYRW6XHqc7BhjJDpicHW6uOx7+5c6uJawRm+KWMAY2F+2A4HgW7nQT2XtGG7R8+BLmLVhJldERXC7jj4iPdIsimnuqrJj2jtr2XdP5pmZ4VDIse3APVbsX9cH+W/0YE8eTLew4KaINFEGfhqR0aD6gt5ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxoX4jxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxoX4jxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA7FC4AF0B;
	Tue, 16 Jul 2024 15:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144684;
	bh=nPzp8PL+BJ+lwlIqJbRueOhL3HMOnVbnXtupuOOVroA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxoX4jxLNAbQGRVVdF1bDbsAA1CqYR02JIrNP9F60hw7F/BQ7bKDD2oeXVngwH6P8
	 oCkRP8qn6XAiFlfMrIyLZqVXCryD9uM+CwvjytnJi11TtHpVQgS3l86tfyVnfsdAgm
	 GXKSgrd3XXgL8cIN4oIXs8JmBzigT9+9ZbHXDQk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Menglong Dong <imagedong@tencent.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 073/108] tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()
Date: Tue, 16 Jul 2024 17:31:28 +0200
Message-ID: <20240716152748.784336228@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 36534d3c54537bf098224a32dc31397793d4594d upstream.

Due to timer wheel implementation, a timer will usually fire
after its schedule.

For instance, for HZ=1000, a timeout between 512ms and 4s
has a granularity of 64ms.
For this range of values, the extra delay could be up to 63ms.

For TCP, this means that tp->rcv_tstamp may be after
inet_csk(sk)->icsk_timeout whenever the timer interrupt
finally triggers, if one packet came during the extra delay.

We need to make sure tcp_rtx_probe0_timed_out() handles this case.

Fixes: e89688e3e978 ("net: tcp: fix unexcepted socket die when snd_wnd is 0")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Menglong Dong <imagedong@tencent.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://lore.kernel.org/r/20240607125652.1472540-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -459,8 +459,13 @@ static bool tcp_rtx_probe0_timed_out(con
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	const int timeout = TCP_RTO_MAX * 2;
-	u32 rcv_delta, rtx_delta;
+	u32 rtx_delta;
+	s32 rcv_delta;
 
+	/* Note: timer interrupt might have been delayed by at least one jiffy,
+	 * and tp->rcv_tstamp might very well have been written recently.
+	 * rcv_delta can thus be negative.
+	 */
 	rcv_delta = inet_csk(sk)->icsk_timeout - tp->rcv_tstamp;
 	if (rcv_delta <= timeout)
 		return false;


