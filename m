Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47DB28C2BF;
	Thu, 20 Aug 2026 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247217; cv=none; b=BTen/cReGm5MhrNqzDUznrnd/KyfxhaJJuwMwstzxpgRcZuERioptBPMzP3xmIx3MS3tv5LEilFn3JwV7S0ccpRP4R0EbIIuUmt+SD7tYWjZyXvDKaUCSnxJ0NDSgMgGZ3e72rBkWD3guHBkiSxgqbBVxQIJFF231sdxNPibmlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247217; c=relaxed/simple;
	bh=BlkkP6M/kK+aMqCK9FMwpnFKpy7l9Z0PA4EvBkchq1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5DhuKCSUm9oWv3BLZ92IZuDc6x/Ii77zo2sshN64BIFOkESn9NXLzemM1Kpj+sd8IBljy8yzqWQP1MFOBMv/SV6Cyuw1uwUmo3ajaTBeeRJcnYfl3BKqojlpJyXJEqvJInSb2evxThdGdgc9BY+nTWGRHkN+KT8SnzLuawhuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjA8SbWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjA8SbWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDF31F000E9;
	Thu, 20 Aug 2026 17:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247215;
	bh=qcD7D7Xdvu1vYgsulNHYMiWF96+bmY8Q2/YbCvpy9bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjA8SbWZkHiKBE4WB90SYGOg242jilsgTFwR0rqfMakE5T/gb9grh50u7nHicDqfM
	 8XArXhr0g5QdG7kzkgIVjCVEZa1kovWNMYs6MJbU2JrRPrqPWJVwFDBPZ12rN+sdBu
	 6tW2XiDNYhKVkAIdfSZTm7+w3GUkORqiYhy+ODmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/220] tcp: reorganize tcp_sock_write_txrx group for variables later
Date: Thu, 20 Aug 2026 16:55:30 +0200
Message-ID: <20260820145227.681557962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

[ Upstream commit c3426ba2ed6942fe33c75bf17fc7513ba2c6ac64 ]

Use the first 3-byte hole at the beginning of the tcp_sock_write_txrx
group for 'noneagle'/'rate_app_limited' to fill in the existing hole
in later patches. Therefore, the group size of tcp_sock_write_txrx is
reduced from 92 + 4 to 91 + 4. In addition, the group size of
tcp_sock_write_rx is changed to 96 to fit in the pahole outcome.
Below are the trimmed pahole outcomes before and after this patch:

[BEFORE THIS PATCH]
struct tcp_sock {
    [...]
    __cacheline_group_begin__tcp_sock_write_txrx[0]; /*  2521     0 */
    /* XXX 3 bytes hole, try to pack */

    [...]
    struct tcp_options_received rx_opt;              /*  2588    24 */
    u8                         nonagle:4;            /*  2612: 0  1 */
    u8                         rate_app_limited:1;   /*  2612: 4  1 */
    /* XXX 3 bits hole, try to pack */

    __cacheline_group_end__tcp_sock_write_txrx[0];   /*  2613     0 */
    /* XXX 3 bytes hole, try to pack */

    __cacheline_group_begin__tcp_sock_write_rx[0] __attribute__((__aligned__(8))); /*  2616     0 */

    [...]
    __cacheline_group_end__tcp_sock_write_rx[0];     /*  2712     0 */

    [...]
    /* size: 3200, cachelines: 50, members: 161 */
}

[AFTER THIS PATCH]
struct tcp_sock {
    [...]
    __cacheline_group_begin__tcp_sock_write_txrx[0]; /*  2521     0 */
    u8                         nonagle:4;            /*  2521: 0  1 */
    u8                         rate_app_limited:1;   /*  2521: 4  1 */
    /* XXX 3 bits hole, try to pack */
    /* XXX 2 bytes hole, try to pack */

    [...]
    struct tcp_options_received rx_opt;              /*  2588    24 */

    __cacheline_group_end__tcp_sock_write_txrx[0];   /*  2612     0 */
    /* XXX 4 bytes hole, try to pack */

    __cacheline_group_begin__tcp_sock_write_rx[0] __attribute__((__aligned__(8))); /*  2616     0 */

    [...]
    __cacheline_group_end__tcp_sock_write_rx[0];     /*  2712     0 */

    [...]
    /* size: 3200, cachelines: 50, members: 161 */
}

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250911110642.87529-4-chia-yu.chang@nokia-bell-labs.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a28c4fcbf774 ("tcp: challenge ACK for non-exact RST in SYN-RECEIVED")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tcp.h |    4 ++--
 net/ipv4/tcp.c      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -282,6 +282,8 @@ struct tcp_sock {
  *	Header prediction flags
  *	0x5?10 << 16 + snd_wnd in net byte order
  */
+	u8	nonagle     : 4,/* Disable Nagle algorithm?             */
+		rate_app_limited:1;  /* rate_{delivered,interval_us} limited? */
 	__be32	pred_flags;
 	u64	tcp_clock_cache; /* cache last tcp_clock_ns() (see tcp_mstamp_refresh()) */
 	u64	tcp_mstamp;	/* most recent packet received/sent */
@@ -300,8 +302,6 @@ struct tcp_sock {
  *      Options received (usually on last packet, some only on SYN packets).
  */
 	struct tcp_options_received rx_opt;
-	u8	nonagle     : 4,/* Disable Nagle algorithm?             */
-		rate_app_limited:1;  /* rate_{delivered,interval_us} limited? */
 	__cacheline_group_end(tcp_sock_write_txrx);
 
 	/* RX read-write hotpath cache lines */
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -5061,7 +5061,7 @@ static void __init tcp_struct_check(void
 	/* 32bit arches with 8byte alignment on u64 fields might need padding
 	 * before tcp_clock_cache.
 	 */
-	CACHELINE_ASSERT_GROUP_SIZE(struct tcp_sock, tcp_sock_write_txrx, 92 + 4);
+	CACHELINE_ASSERT_GROUP_SIZE(struct tcp_sock, tcp_sock_write_txrx, 91 + 4);
 
 	/* RX read-write hotpath cache lines */
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, bytes_received);
@@ -5078,7 +5078,7 @@ static void __init tcp_struct_check(void
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, bytes_acked);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_rtt_est);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcvq_space);
-	CACHELINE_ASSERT_GROUP_SIZE(struct tcp_sock, tcp_sock_write_rx, 99);
+	CACHELINE_ASSERT_GROUP_SIZE(struct tcp_sock, tcp_sock_write_rx, 96);
 }
 
 void __init tcp_init(void)


