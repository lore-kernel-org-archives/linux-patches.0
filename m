Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FC413B59A;
	Mon,  6 Jan 2025 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179049; cv=none; b=YuFgY/9HDXwF9hcOsk3UJjFTHKWm/byZDzqCSMLK8Z5IPa1IqvDOXVBoc4QxLZ5FrqhVXt3jr6JkSw+cmscpoFws4CgXQLLCc3SlUrWCxCYh6VKAr/LEyuNe4jiwFF4RecYL0X0EtvoHowDTxZrlzAbB9J4NsiTz52SxpAoswu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179049; c=relaxed/simple;
	bh=eZq8xh8gsGEwgwLwW7HnpUof0UuVpU+gf5M7iRpGe/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECChKxEZY5uo0kjtcJlLo9GDaVliE8iMAFNyTkvIoQZxagrLjWOeN3CJRjZEdLH25SMRRVcN+TN+Z97vrHipHRt/vN5L0K3CxbIYhmT1MdJeAW4BRU2NWFe7UirU+RvNKut6PJfE6ao2xRr16hKZmkR6ZFXoXe5lpIUr6mFnStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnMQsiPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnMQsiPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276BBC4CED6;
	Mon,  6 Jan 2025 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179048;
	bh=eZq8xh8gsGEwgwLwW7HnpUof0UuVpU+gf5M7iRpGe/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnMQsiPbrvm6Y0FybOWqLcQPEjNPlGT3R+4KFH19k/bLR9jS95YHCwGvuc0I0noA9
	 kK4+MpOkbP/q+CEJObGUOzSsdsZIxWOElBGEdbZlXSCLDwdjLxXrEQLm64jDqcUXT0
	 VVRcGJtTVC7Yf9fq8GEuTfCaYueXOyuGBjKHPtGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/93] net/smc: check sndbuf_space again after NOSPACE flag is set in smc_poll
Date: Mon,  6 Jan 2025 16:16:46 +0100
Message-ID: <20250106151129.087814868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e070b0e2a30c..1373a0082b5a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1660,6 +1660,13 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
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



