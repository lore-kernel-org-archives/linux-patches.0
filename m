Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F234628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CA4C433EF;
	Mon, 30 Jan 2023 14:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087323;
	bh=YX4RugcpItiVM8A7NG6e5fEYq5hgkGcvBR9y9xKIkjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4FMsrDHVjtn5O+wz0iRtDHzxG9N6izejiuxyYNZ3bpuAkYYjsYwHRrkl9Q+I2vMZ
	 lNcODFbWkXawdpeM71mWEXF7k0o3pAfY34pe8zYLcxvbxOWNM22Br0U9oTdlKo+mny
	 r9lfaT+LwMSTYebUwRcwPf/b/yMBHG9bTJc/M7SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchung Cheng <ycheng@google.com>,
	David Morley <morleyd@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/313] tcp: fix rate_app_limited to default to 1
Date: Mon, 30 Jan 2023 14:49:35 +0100
Message-Id: <20230130134343.174504672@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Morley <morleyd@google.com>

[ Upstream commit 300b655db1b5152d6101bcb6801d50899b20c2d6 ]

The initial default value of 0 for tp->rate_app_limited was incorrect,
since a flow is indeed application-limited until it first sends
data. Fixing the default to be 1 is generally correct but also
specifically will help user-space applications avoid using the initial
tcpi_delivery_rate value of 0 that persists until the connection has
some non-zero bandwidth sample.

Fixes: eb8329e0a04d ("tcp: export data delivery rate")
Suggested-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David Morley <morleyd@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Tested-by: David Morley <morleyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4f2205756cfe..ec19ed722453 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -435,6 +435,7 @@ void tcp_init_sock(struct sock *sk)
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 
 	/* See draft-stevens-tcpca-spec-01 for discussion of the
 	 * initialization of these values.
@@ -3177,6 +3178,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->last_oow_ack_time = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 	tp->rack.mstamp = 0;
 	tp->rack.advanced = 0;
 	tp->rack.reo_wnd_steps = 1;
-- 
2.39.0



