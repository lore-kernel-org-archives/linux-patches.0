Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2119A1EBFE0;
	Tue, 12 Aug 2025 18:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022391; cv=none; b=H6KnZI9oxowee76Qj654wwvfypotlRlLruxJHKDaI1nXuStOysuPSyniykK0mbrAPMz46SL8rT3dqKo1jeN7yRm8I52VfsaWIQ6Ju9PdddLRB/CW2DsmMN2TQEnSk+KpESwhtxIjkwkdW1UUYUcnL+5xwgi5VSy010pu5TCoErY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022391; c=relaxed/simple;
	bh=QeOFuwmkHd8i/dnrhxqrSU3yhjk9YTbtD2uiOanibMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCPA8fpAeyhbkF6IAAwZ6kBtVk+3CrHKkMGHMHuuqArfC/q62QYeyVpXXbaPaxS2Zi1A73U0vxRhqCw26zXlhoKVkw2N+ywzecQq/rscYqUghs5pZ17AdED6LqkN/nuA9YmV/7CAco5rl69XUwCDc/iWaENreaKVjhoAqqi/dcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fv2XtBqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fv2XtBqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842FFC4CEF1;
	Tue, 12 Aug 2025 18:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022391;
	bh=QeOFuwmkHd8i/dnrhxqrSU3yhjk9YTbtD2uiOanibMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fv2XtBqLykZNIrNl+3hNAMZHrIbu7F3DJ0pSTF4UzK9+XTCyRPavBrCnC5q8o1FME
	 lxWxF3j+R19otlROmes8rxg65vTfTAixlxSwt/Ogn3Ia0uwRL98/AfxlWa0l8xMMp0
	 72DeM/Ig9vO55ydzUk9kcqM5MNw9UDEP4HLTMa8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/369] tcp: call tcp_measure_rcv_mss() for ooo packets
Date: Tue, 12 Aug 2025 19:26:45 +0200
Message-ID: <20250812173018.841851841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 38d7e444336567bae1c7b21fc18b7ceaaa5643a0 ]

tcp_measure_rcv_mss() is used to update icsk->icsk_ack.rcv_mss
(tcpi_rcv_mss in tcp_info) and tp->scaling_ratio.

Calling it from tcp_data_queue_ofo() makes sure these
fields are updated, and permits a better tuning
of sk->sk_rcvbuf, in the case a new flow receives many ooo
packets.

Fixes: dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250711114006.480026-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d45a6dcc3753..30f4375f8431 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5040,6 +5040,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		return;
 	}
 
+	tcp_measure_rcv_mss(sk, skb);
 	/* Disable header prediction. */
 	tp->pred_flags = 0;
 	inet_csk_schedule_ack(sk);
-- 
2.39.5



