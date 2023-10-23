Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F3314F6E
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="herTjPZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2783C433C7;
	Mon, 23 Oct 2023 11:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060173;
	bh=cZGsV8VeEUwsvLkYEQIKZNu2WlXawgi3ARezfgI9jVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=herTjPZ+8AWxrDxxY+kNH9dr+bWkv4Zv8uxM4fxG+EnJGc0zEN3N/QHFeMVgjeBe1
	 dApzxsrwO5UynNT4dKGlAL6/OoxQ+72DWZDV3iTjHzAJpgJewe0geKh6D0btDi+JoB
	 fazRiFq0SdSgqr4ux61HGhBlU4Z8jVW5lXaIzOcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 055/196] tcp: tsq: relax tcp_small_queue_check() when rtx queue contains a single skb
Date: Mon, 23 Oct 2023 12:55:20 +0200
Message-ID: <20231023104830.091262472@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit f921a4a5bffa8a0005b190fb9421a7fc1fd716b6 upstream.

In commit 75eefc6c59fd ("tcp: tsq: add a shortcut in tcp_small_queue_check()")
we allowed to send an skb regardless of TSQ limits being hit if rtx queue
was empty or had a single skb, in order to better fill the pipe
when/if TX completions were slow.

Then later, commit 75c119afe14f ("tcp: implement rb-tree based
retransmit queue") accidentally removed the special case for
one skb in rtx queue.

Stefan Wahren reported a regression in single TCP flow throughput
using a 100Mbit fec link, starting from commit 65466904b015 ("tcp: adjust
TSO packet sizes based on min_rtt"). This last commit only made the
regression more visible, because it locked the TCP flow on a particular
behavior where TSQ prevented two skbs being pushed downstream,
adding silences on the wire between each TSO packet.

Many thanks to Stefan for his invaluable help !

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Link: https://lore.kernel.org/netdev/7f31ddc8-9971-495e-a1f6-819df542e0af@gmx.net/
Reported-by: Stefan Wahren <wahrenst@gmx.net>
Tested-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20231017124526.4060202-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2489,6 +2489,18 @@ static bool tcp_pacing_check(struct sock
 	return true;
 }
 
+static bool tcp_rtx_queue_empty_or_single_skb(const struct sock *sk)
+{
+	const struct rb_node *node = sk->tcp_rtx_queue.rb_node;
+
+	/* No skb in the rtx queue. */
+	if (!node)
+		return true;
+
+	/* Only one skb in rtx queue. */
+	return !node->rb_left && !node->rb_right;
+}
+
 /* TCP Small Queues :
  * Control number of packets in qdisc/devices to two packets / or ~1 ms.
  * (These limits are doubled for retransmits)
@@ -2526,12 +2538,12 @@ static bool tcp_small_queue_check(struct
 		limit += extra_bytes;
 	}
 	if (refcount_read(&sk->sk_wmem_alloc) > limit) {
-		/* Always send skb if rtx queue is empty.
+		/* Always send skb if rtx queue is empty or has one skb.
 		 * No need to wait for TX completion to call us back,
 		 * after softirq/tasklet schedule.
 		 * This helps when TX completions are delayed too much.
 		 */
-		if (tcp_rtx_queue_empty(sk))
+		if (tcp_rtx_queue_empty_or_single_skb(sk))
 			return false;
 
 		set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);


