Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243138F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5E3C433C8;
	Sun, 16 Jul 2023 20:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540827;
	bh=YAsotvrNMiPGAqllvHLoMnfarJENIyWh8Nx2BpSkrWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBA1NmCR4/yvifP+j4TEZiwlKb63wApQ+fVHueBqKbn4AhNbKisALzZjT95yUr7+N
	 hofLDVnKOyFXeke3+ylpCJncvnStjv2fRwsOAHC/TlvcT1Mi/s98e4AeRHUJ7UA6vu
	 6pvUErJHgcpFUv1a2sZyinsVfY3gojK00O7+vK18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 502/591] tcp: annotate data races in __tcp_oow_rate_limited()
Date: Sun, 16 Jul 2023 21:50:41 +0200
Message-ID: <20230716194936.880633798@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 998127cdb4699b9d470a9348ffe9f1154346be5f ]

request sockets are lockless, __tcp_oow_rate_limited() could be called
on the same object from different cpus. This is harmless.

Add READ_ONCE()/WRITE_ONCE() annotations to avoid a KCSAN report.

Fixes: 4ce7e93cb3fe ("tcp: rate limit ACK sent by SYN_RECV request sockets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5dabb38b857ff..e2d3ea2e34561 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3590,8 +3590,11 @@ static int tcp_ack_update_window(struct sock *sk, const struct sk_buff *skb, u32
 static bool __tcp_oow_rate_limited(struct net *net, int mib_idx,
 				   u32 *last_oow_ack_time)
 {
-	if (*last_oow_ack_time) {
-		s32 elapsed = (s32)(tcp_jiffies32 - *last_oow_ack_time);
+	/* Paired with the WRITE_ONCE() in this function. */
+	u32 val = READ_ONCE(*last_oow_ack_time);
+
+	if (val) {
+		s32 elapsed = (s32)(tcp_jiffies32 - val);
 
 		if (0 <= elapsed &&
 		    elapsed < READ_ONCE(net->ipv4.sysctl_tcp_invalid_ratelimit)) {
@@ -3600,7 +3603,10 @@ static bool __tcp_oow_rate_limited(struct net *net, int mib_idx,
 		}
 	}
 
-	*last_oow_ack_time = tcp_jiffies32;
+	/* Paired with the prior READ_ONCE() and with itself,
+	 * as we might be lockless.
+	 */
+	WRITE_ONCE(*last_oow_ack_time, tcp_jiffies32);
 
 	return false;	/* not rate-limited: go ahead, send dupack now! */
 }
-- 
2.39.2



