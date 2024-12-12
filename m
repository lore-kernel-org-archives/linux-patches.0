Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF2E226866;
	Thu, 12 Dec 2024 16:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020694; cv=none; b=nP3+7jiqJXyxE+4nsIuu0V6N3OhVLIAgUXaVZlMcKnr+gUi7s0vgvlhkuEvn1K4VV+QWXCgIfPX2q4xqOi4OBDqfBL+0cDWNo2rCGDL9fH8aaetSZkV1dqCBeuOc6Go7MXVwQgTDk/qiIpPXChHnT4TcEWlAu3BFkBSh8gJ+5bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020694; c=relaxed/simple;
	bh=9YdS0VWMq9xoMptPFGfVwi/v6s872G1AWwJCsbc5QYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWWUA/IC+4q8lhUzLKQttsctgOn5laFtr0Y7AB5LPFQ6u/tKakWQXpgWZrWUoKT0gzb6wh0nubMusRCD7Wm6k5fhpYhK5fbnZwyTJKGl8D4vm4byE+u2DIkNUV0IA7XMN0zYuDdeoblUOUl1WkNoqKYPOg/VL1OqhlSvkeWvsMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IusjBU+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IusjBU+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66A7C4CECE;
	Thu, 12 Dec 2024 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020694;
	bh=9YdS0VWMq9xoMptPFGfVwi/v6s872G1AWwJCsbc5QYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IusjBU+fRQp9DyyIx7m38bz2WtPOhzfCcpTx0qi+mF7QjB0vsgUqxgMqB4MsZHaKX
	 doOphCjLf7SN2xRj3skKqthm4GjRBWv8Qco7l2kPZ/mAh1YDZggTe/vgRfjMBTdn+h
	 EHmCBBmQRk+dgnjfPewicOO0Zl5MA51/YviddrF4=
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
Subject: [PATCH 6.1 536/772] net/smc: fix LGR and link use-after-free issue
Date: Thu, 12 Dec 2024 15:58:01 +0100
Message-ID: <20241212144412.122612515@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e86db21fef6e5..868e722aef064 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1860,6 +1860,7 @@ static void smc_listen_out(struct smc_sock *new_smc)
 	if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
 		atomic_dec(&lsmc->queued_smc_hs);
 
+	release_sock(newsmcsk); /* lock in smc_listen_work() */
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
 		smc_accept_enqueue(&lsmc->sk, newsmcsk);
@@ -2352,6 +2353,7 @@ static void smc_listen_work(struct work_struct *work)
 	u8 accept_version;
 	int rc = 0;
 
+	lock_sock(&new_smc->sk); /* release in smc_listen_out() */
 	if (new_smc->listen_smc->sk.sk_state != SMC_LISTEN)
 		return smc_listen_out_err(new_smc);
 
-- 
2.43.0



