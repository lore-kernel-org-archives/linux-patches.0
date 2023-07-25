Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4175D14A82
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A7FC433C8;
	Tue, 25 Jul 2023 10:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282653;
	bh=gpzIfCH0s7WTLgAVB9JQDjEWS38URzkX6wg4LeYGzAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeSMeyq7VBoHKOfvR1oFdcuYfJYCjs1GdX4KOAnE32SetyFcEPccZFLv+JFLtW5QR
	 gOXt0JjreC2guyUl00niwcIegbToaoFWTIBQG1FEspisM246goVaeKxHq+9qrA+mFi
	 86NKxoxDnJ6brmGbDVIxqaX43xtUpoeLNWv0zbqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 207/227] tcp: annotate data-races around tp->tcp_tx_delay
Date: Tue, 25 Jul 2023 12:46:14 +0200
Message-ID: <20230725104523.334628031@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
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

[ Upstream commit 348b81b68b13ebd489a3e6a46aa1c384c731c919 ]

do_tcp_getsockopt() reads tp->tcp_tx_delay while another cpu
might change its value.

Fixes: a842fe1425cb ("tcp: add optional per socket transmit delay")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8d20d9221238c..c0e0add372f75 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3783,7 +3783,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_TX_DELAY:
 		if (val)
 			tcp_enable_tx_delay();
-		tp->tcp_tx_delay = val;
+		WRITE_ONCE(tp->tcp_tx_delay, val);
 		break;
 	default:
 		err = -ENOPROTOOPT;
@@ -4263,7 +4263,7 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_TX_DELAY:
-		val = tp->tcp_tx_delay;
+		val = READ_ONCE(tp->tcp_tx_delay);
 		break;
 
 	case TCP_TIMESTAMP:
-- 
2.39.2



