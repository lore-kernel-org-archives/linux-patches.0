Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC10F1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEA7C433C8;
	Tue, 25 Jul 2023 11:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283141;
	bh=f0bD1/WfdlfuDuC/NKyGnpwdduzMP/rOtgKbRLsRUUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSbjTG7b551WBWafAb4qgpExm+OuGdcpw3ZR30eopltZAGJl7ZVyqtaqc6cSP1uB2
	 xFWuF/xQhr8XS1V15NIAPx2PjbL9bTuTD5ycOCl+39nWpJZ8J+mM3agVYqmWqmTxQb
	 TGbVu1p8HFE1ijNaIhV6XUr/SqG5i0B8a3CdgPEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/183] tcp: annotate data-races around tp->tsoffset
Date: Tue, 25 Jul 2023 12:46:21 +0200
Message-ID: <20230725104513.361489137@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
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

[ Upstream commit dd23c9f1e8d5c1d2e3d29393412385ccb9c7a948 ]

do_tcp_getsockopt() reads tp->tsoffset while another cpu
might change its value.

Fixes: 93be6ce0e91b ("tcp: set and get per-socket timestamp")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c      | 4 ++--
 net/ipv4/tcp_ipv4.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5e4bc80dc0ae5..3edf7a1c5cbd2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3762,7 +3762,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		if (!tp->repair)
 			err = -EPERM;
 		else
-			tp->tsoffset = val - tcp_time_stamp_raw();
+			WRITE_ONCE(tp->tsoffset, val - tcp_time_stamp_raw());
 		break;
 	case TCP_REPAIR_WINDOW:
 		err = tcp_repair_set_window(tp, optval, optlen);
@@ -4260,7 +4260,7 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_TIMESTAMP:
-		val = tcp_time_stamp_raw() + tp->tsoffset;
+		val = tcp_time_stamp_raw() + READ_ONCE(tp->tsoffset);
 		break;
 	case TCP_NOTSENT_LOWAT:
 		val = tp->notsent_lowat;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d49a66b271d52..9a8d59e9303a0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -307,8 +307,9 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 						  inet->inet_daddr,
 						  inet->inet_sport,
 						  usin->sin_port));
-		tp->tsoffset = secure_tcp_ts_off(net, inet->inet_saddr,
-						 inet->inet_daddr);
+		WRITE_ONCE(tp->tsoffset,
+			   secure_tcp_ts_off(net, inet->inet_saddr,
+					     inet->inet_daddr));
 	}
 
 	inet->inet_id = get_random_u16();
-- 
2.39.2



