Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A144BA34;
	Mon,  6 Jan 2025 15:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178538; cv=none; b=iqIT3UaqN0qPK/2NWbo93rnORQNeAD+4MCd4S5LVsPidKxgXQpmLpkVFT3jMhsHcuQANfbBb675X5Ioxcv18BxU/KJKeVURzDkMPbnd8TL04+BSS5+odHC+soGj8p9u84SC6vBekVVz7qENjpTL8f2JqgEvJsGsM1VyZ1w8Jgb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178538; c=relaxed/simple;
	bh=EzdwveI87GTWJKGCbqohGYHyCAmXouW8PHhDPBEVXCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6H9IVmhsuf3diGjdODCWXqlvNQeS9VAIH73SQmFEr4g7VhKABZcmDQZIAw++OEUT1OO09wxmF0APnFQO2ousZRl4imcz/FQOccMF/09vsdDkOEqoj057iKOfybBvJbWbX7YjFM8ejtH912uWisWC5/+4UNqBzqz13cg2OkaX24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOZbt/Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOZbt/Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B2DC4CEDF;
	Mon,  6 Jan 2025 15:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178537;
	bh=EzdwveI87GTWJKGCbqohGYHyCAmXouW8PHhDPBEVXCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOZbt/PnT8GoZVr5lf9WxxGogvWTISO6/fH2aK+f47vHu3xYffqq2VuMCZZp6QLQr
	 lxMwvXMhRckBCBsnIRM6B6IPjBljAq+5CvOxUtlwJ42JN+uwNweNQ3JC11w9y3TFgA
	 7IA4EyF2Eeshx4xcxPVPfpWvT0bP1Fwbuy2m1nZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/168] net/smc: check sndbuf_space again after NOSPACE flag is set in smc_poll
Date: Mon,  6 Jan 2025 16:15:21 +0100
Message-ID: <20250106151138.963825753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit 679e9ddcf90dbdf98aaaa71a492454654b627bcb ]

When application sending data more than sndbuf_space, there have chances
application will sleep in epoll_wait, and will never be wakeup again. This
is caused by a race between smc_poll and smc_cdc_tx_handler.

application                                      tasklet
smc_tx_sendmsg(len > sndbuf_space)   |
epoll_wait for EPOLL_OUT,timeout=0   |
  smc_poll                           |
    if (!smc->conn.sndbuf_space)     |
                                     |  smc_cdc_tx_handler
                                     |    atomic_add sndbuf_space
                                     |    smc_tx_sndbuf_nonfull
                                     |      if (!test_bit SOCK_NOSPACE)
                                     |        do not sk_write_space;
      set_bit SOCK_NOSPACE;          |
    return mask=0;                   |

Application will sleep in epoll_wait as smc_poll returns 0. And
smc_cdc_tx_handler will not call sk_write_space because the SOCK_NOSPACE
has not be set. If there is no inflight cdc msg, sk_write_space will not be
called any more, and application will sleep in epoll_wait forever.
So check sndbuf_space again after NOSPACE flag is set to break the race.

Fixes: 8dce2786a290 ("net/smc: smc_poll improvements")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 4019f2dc9dee..fb299dbc0c26 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2355,6 +2355,13 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
 			} else {
 				sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+
+				if (sk->sk_state != SMC_INIT) {
+					/* Race breaker the same way as tcp_poll(). */
+					smp_mb__after_atomic();
+					if (atomic_read(&smc->conn.sndbuf_space))
+						mask |= EPOLLOUT | EPOLLWRNORM;
+				}
 			}
 			if (atomic_read(&smc->conn.bytes_to_rcv))
 				mask |= EPOLLIN | EPOLLRDNORM;
-- 
2.39.5



