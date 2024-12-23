Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E36188006;
	Mon, 23 Dec 2024 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970289; cv=none; b=S4tsrQ8o9Hp5+1e2XU572hlDlEEEK43EyrPBNHOz8eljMtPRahDiL2X46ptER4Op6N52ic6XUH6EUYytap6gTVEZTq77NwNCY871z7qd6/SuvRWjJoyR+W/Pp7shG0gaDUGCBAVNqi1gWqTdSXa795YEupjVNAIOhYItQubLfIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970289; c=relaxed/simple;
	bh=frYztCd8zRBTk4LNCMIU/VdtC+SqsDER6ktsP9oD9wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNttVw0bFRO59JmXf0e8H55dNRYCj08IDOsGYPHUPkty5QspNqUfd48YoZcJkKwdBxPduyXKb8E1NvSI89wfEGlJ8phZuIIQTa0NrPhKyqPXDQUS1wGgRQ+LT8TF0/r5FTSJA/cbnl55sMI7kSXt3xtbA7ualjQvfZoG53ivDnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm5AzGOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm5AzGOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B585BC4CED3;
	Mon, 23 Dec 2024 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970289;
	bh=frYztCd8zRBTk4LNCMIU/VdtC+SqsDER6ktsP9oD9wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hm5AzGOnQqDyzxsLWzcfW4GmVl7tbjSlglblAKIUWN1hVHUcOdzwhbz2o0UZ3vSj/
	 nBY+dd5VWLo7VEJgEHkcjR6rTYdIETm46b5Wvnn4RjvS07camCxGeDyEZxi8S0ZpZJ
	 QYfCTJmW1UczkZsHF4ueRn0C2Q0DzAfxT31XAt+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/116] net/smc: check sndbuf_space again after NOSPACE flag is set in smc_poll
Date: Mon, 23 Dec 2024 16:58:30 +0100
Message-ID: <20241223155401.125290402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77c6c0dff069..06d607e676f6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2888,6 +2888,13 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
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



