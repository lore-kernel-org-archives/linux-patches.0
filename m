Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA91F223C62;
	Thu, 12 Dec 2024 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023177; cv=none; b=FVLsMBbsfiS7O6dujiD01J1C16tSM61WVLt+lj8fALXGHn2Q8Ywl2vnpxI8o+2k7lb+bjNTRirHNLf5SVMjOi60zmzlkcCbv9OKzxqKTL1zCyPRkWf9bgd4PVaokl5kOyVrzSp49OfSW7a8xdV3zaneYdudp0jlHBj9z30y0HvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023177; c=relaxed/simple;
	bh=jCR/Vzweiye6M0pqy3m+k8/VA9zuJYCrQ+VVngyF+gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IThzzlkV7vYsiQyb2krt3WeSsCgALvXEorsOv0tDEsM+27hDCYj2kFu7Ez0BdylohGOcf2DhI+jSTN6ZpnrrQN5bO1VIAQZHUMAL++0KAg3N3hzjzkYF995VrNwRirbgeIzr5D7V7LsrduOxMzDWyHJxS8BGiQ3gY10uGI0p5fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDgWAkJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDgWAkJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E110C4CED0;
	Thu, 12 Dec 2024 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023176;
	bh=jCR/Vzweiye6M0pqy3m+k8/VA9zuJYCrQ+VVngyF+gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDgWAkJmXRS73MoqdHEheqsI7tZmQRTGTrlY3Q17ku94pfJnxRlYqBR6xXIRoSDO6
	 5nydXLOacC//vLsjeuVTSyietOZOfTyzgvM96/BJgRGnpIuzDfp8+mUOkZKLCB+rLN
	 rosXZnmweN9oJ/NVZYAAi4dI4FWm+9PeHmcNj+qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Kai <KaiShen@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/565] net/smc: fix LGR and link use-after-free issue
Date: Thu, 12 Dec 2024 16:00:13 +0100
Message-ID: <20241212144328.183209998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 2c7f14ed9c19ec0f149479d1c2842ec1f9bf76d7 ]

We encountered a LGR/link use-after-free issue, which manifested as
the LGR/link refcnt reaching 0 early and entering the clear process,
making resource access unsafe.

 refcount_t: addition on 0; use-after-free.
 WARNING: CPU: 14 PID: 107447 at lib/refcount.c:25 refcount_warn_saturate+0x9c/0x140
 Workqueue: events smc_lgr_terminate_work [smc]
 Call trace:
  refcount_warn_saturate+0x9c/0x140
  __smc_lgr_terminate.part.45+0x2a8/0x370 [smc]
  smc_lgr_terminate_work+0x28/0x30 [smc]
  process_one_work+0x1b8/0x420
  worker_thread+0x158/0x510
  kthread+0x114/0x118

or

 refcount_t: underflow; use-after-free.
 WARNING: CPU: 6 PID: 93140 at lib/refcount.c:28 refcount_warn_saturate+0xf0/0x140
 Workqueue: smc_hs_wq smc_listen_work [smc]
 Call trace:
  refcount_warn_saturate+0xf0/0x140
  smcr_link_put+0x1cc/0x1d8 [smc]
  smc_conn_free+0x110/0x1b0 [smc]
  smc_conn_abort+0x50/0x60 [smc]
  smc_listen_find_device+0x75c/0x790 [smc]
  smc_listen_work+0x368/0x8a0 [smc]
  process_one_work+0x1b8/0x420
  worker_thread+0x158/0x510
  kthread+0x114/0x118

It is caused by repeated release of LGR/link refcnt. One suspect is that
smc_conn_free() is called repeatedly because some smc_conn_free() from
server listening path are not protected by sock lock.

e.g.

Calls under socklock        | smc_listen_work
-------------------------------------------------------
lock_sock(sk)               | smc_conn_abort
smc_conn_free               | \- smc_conn_free
\- smcr_link_put            |    \- smcr_link_put (duplicated)
release_sock(sk)

So here add sock lock protection in smc_listen_work() path, making it
exclusive with other connection operations.

Fixes: 3b2dec2603d5 ("net/smc: restructure client and server code in af_smc")
Co-developed-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Co-developed-by: Kai <KaiShen@linux.alibaba.com>
Signed-off-by: Kai <KaiShen@linux.alibaba.com>
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d433b88e6a277..1072b32a1d75d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1509,6 +1509,7 @@ static void smc_listen_out(struct smc_sock *new_smc)
 	if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
 		atomic_dec(&lsmc->queued_smc_hs);
 
+	release_sock(newsmcsk); /* lock in smc_listen_work() */
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
 		smc_accept_enqueue(&lsmc->sk, newsmcsk);
@@ -1921,6 +1922,7 @@ static void smc_listen_work(struct work_struct *work)
 	struct smc_init_info *ini = NULL;
 	int rc = 0;
 
+	lock_sock(&new_smc->sk); /* release in smc_listen_out() */
 	if (new_smc->listen_smc->sk.sk_state != SMC_LISTEN)
 		return smc_listen_out_err(new_smc);
 
-- 
2.43.0



