Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3661C3C18;
	Wed,  4 Jun 2025 00:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998327; cv=none; b=OolOg15+4Re9YT1jEZItnyij14TcshcIEv6K5cCN5pkkCT0L105UREUzibGjeBVj1Y4q6htyj1d2rUCW4s9uR2tbZw4voiswwL8/sfqDp1FMvlF8AzO9CZz0kFIgLEC52vgNjcoEyIgG3fxdmIWijjRw/tdOaX1wgqrLIsapqnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998327; c=relaxed/simple;
	bh=e/b0x+1EBFPOuh6UR+XAbdCGkf9LsFKqCmI7UQQAjH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fhhwXheTGQEC5eiXQFP2Fcq+e2JsQ25sHPvdF2N0A40Wj1BEFl4D3jYfdlQrPdKTGfFdUES8SoJ+kE34DabqAcv2tUA5d6MZ0fbWy8I09L4vZSe1xR/y+aj6B3LcAGmVQGJ+PZ4qEk9mxHd4s/tUDrHBOxKSJU/u6+rFTAr/LpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pp4ua+yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pp4ua+yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55333C4CEED;
	Wed,  4 Jun 2025 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998327;
	bh=e/b0x+1EBFPOuh6UR+XAbdCGkf9LsFKqCmI7UQQAjH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pp4ua+yLHlWcJJzmvOPQb+SNNoEZNE56frjWJyli8HU/usoqk7MtR582bCmuZLE2c
	 OP4hYIoezm1ZydRQUHtIQyQbVYA4N7d1MRVtl+kHswX2bxrjBDanjL3yyWG39L5+hR
	 6ivyQYNJ09BVxcvE0qT7rGFZcGXZE3afo/C0V+xSy9rKNuL7LKlzph7rW7gCZcEMby
	 xJiFdpQ7phSi+GoAzLebYapZqN8TYBtOYLisITU1uwEcBGmVGJkNSxwq9IBlVz525D
	 1nCLc/5IjrlzMURA/lAezDCQNF79ttz2w0gEpD2nLmB3B1bD89YeID/y71ddjEoZAQ
	 J6jyC03l6M7Vw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ncardwell@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 038/118] tcp: add receive queue awareness in tcp_rcv_space_adjust()
Date: Tue,  3 Jun 2025 20:49:29 -0400
Message-Id: <20250604005049.4147522-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ea33537d82921e71f852ea2ed985acc562125efe ]

If the application can not drain fast enough a TCP socket queue,
tcp_rcv_space_adjust() can overestimate tp->rcvq_space.space.

Then sk->sk_rcvbuf can grow and hit tcp_rmem[2] for no good reason.

Fix this by taking into acount the number of available bytes.

Keeping sk->sk_rcvbuf at the right size allows better cache efficiency.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis, here's my assessment: **YES** This
commit should be backported to stable kernel trees. Here's my detailed
analysis: ## Code Change Analysis The commit makes a small but important
fix to the TCP receive buffer auto-tuning algorithm in
`tcp_rcv_space_adjust()`. The key changes are: 1. **Struct field type
change**: Changes `rcvq_space.space` from `u32` to `int` in
`include/linux/tcp.h` 2. **Calculation adjustment**: Adds receive queue
awareness by subtracting queued bytes from the copied bytes calculation
## Technical Impact **Before the fix:** ```c /bin /bin.usr-is-merged
/boot /dev /etc /home /init /lib /lib.usr-is-merged /lib64 /lost+found
/media /mnt /opt /proc /root /run /sbin /sbin.usr-is-merged /snap /srv
/sys /tmp /usr /var Number of bytes copied to user in last RTT linux/
copied = tp->copied_seq - tp->rcvq_space.seq; ``` **After the fix:**
```c /bin /bin.usr-is-merged /boot /dev /etc /home /init /lib /lib.usr-
is-merged /lib64 /lost+found /media /mnt /opt /proc /root /run /sbin
/sbin.usr-is-merged /snap /srv /sys /tmp /usr /var Number of bytes
copied to user in last RTT linux/ copied = tp->copied_seq -
tp->rcvq_space.seq; /bin /bin.usr-is-merged /boot /dev /etc /home /init
/lib /lib.usr-is-merged /lib64 /lost+found /media /mnt /opt /proc /root
/run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp /usr /var Number of
bytes in receive queue. linux/ inq = tp->rcv_nxt - tp->copied_seq;
copied -= inq; ``` The fix prevents the algorithm from overestimating
the application's consumption rate when the receive queue has pending
data that hasn't been read by the application yet. ## Why This Should Be
Backported 1. **Fixes Real Performance Issue**: When applications can't
drain the TCP socket fast enough, the original code would incorrectly
grow `sk->sk_rcvbuf` up to the system maximum (`tcp_rmem[2]`), wasting
memory and reducing cache efficiency. 2. **Small and Contained Change**:
The fix is minimal (6 lines changed) and only affects the receive buffer
auto-tuning logic. It doesn't introduce new features or architectural
changes. 3. **No Side Effects**: The change only makes the auto-tuning
more accurate by accounting for queued data. This cannot cause
regressions as it prevents unnecessary memory allocation. 4. **Follows
Stable Tree Pattern**: This matches the pattern of similar backported
commits (like the integer overflow fixes in commits #1 and #2 from the
examples), which also fixed TCP receive buffer calculation issues. 5.
**Author Authority**: Eric Dumazet is a well-known TCP maintainer with
extensive experience, and the commit was reviewed by Wei Wang, another
TCP expert. 6. **Part of Ongoing Improvements**: This commit is part of
a series addressing TCP receive buffer tuning issues (as seen in the
related commits f5da7c45188e and others), indicating this is an active
area of bug fixes rather than experimental features. 7. **Affects
Critical TCP Performance**: TCP receive buffer auto-tuning directly
impacts network performance for all applications, making this fix
important for system stability and performance. The fix addresses a
legitimate bug where the TCP stack would waste memory by growing receive
buffers unnecessarily when applications are slow to consume data. This
is exactly the type of important, low-risk bugfix that stable trees are
designed to include.

 include/linux/tcp.h  | 2 +-
 net/ipv4/tcp_input.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 1669d95bb0f9a..5c7c5038d47b5 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -340,7 +340,7 @@ struct tcp_sock {
 	} rcv_rtt_est;
 /* Receiver queue space */
 	struct {
-		u32	space;
+		int	space;
 		u32	seq;
 		u64	time;
 	} rcvq_space;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ed5f0ffab60dc..49adcbd73074d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -748,8 +748,7 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
 void tcp_rcv_space_adjust(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	u32 copied;
-	int time;
+	int time, inq, copied;
 
 	trace_tcp_rcv_space_adjust(sk);
 
@@ -760,6 +759,9 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 	/* Number of bytes copied to user in last RTT */
 	copied = tp->copied_seq - tp->rcvq_space.seq;
+	/* Number of bytes in receive queue. */
+	inq = tp->rcv_nxt - tp->copied_seq;
+	copied -= inq;
 	if (copied <= tp->rcvq_space.space)
 		goto new_measure;
 
-- 
2.39.5

