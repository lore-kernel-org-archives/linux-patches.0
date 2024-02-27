Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6B41420D8;
	Tue, 27 Feb 2024 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041540; cv=none; b=Ejq3+rASWyTo2/BTVkqrL4k+nf0vR1P6YTdXhl/y6vBDQByfAiWVk9r2VVCUbRBoC+3X0Qqr0rAefdMF+CyhdbL0LlgaLCs2kLgT9pdeTB4LCXWtqjxun8wVuVyscM5qi7khCJ77xqX6M2uN0sFne80M6uVe+iWpKOPjfXYHHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041540; c=relaxed/simple;
	bh=w+xvFraHg9Rs5QEYDzP+/17ZZQfZyKfbdl2v4KqTTSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYQDaLGYuZsjg15zGvB6aQM8O2iFdwjotSLTKElrLCklAc343B/xvhP/lbsOWAcyCj7gNazV5jrOU/WR3XBpgxY/ENtioK9y1fN6LI5F7ld6reLyC4ekamGV5R6hod605ulJsE/qhpthUXDlKeee4dMQ5J0fuqn3t1oaNJK3DWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4IOy2qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4IOy2qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0E8C43330;
	Tue, 27 Feb 2024 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041540;
	bh=w+xvFraHg9Rs5QEYDzP+/17ZZQfZyKfbdl2v4KqTTSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4IOy2qxl/l7vpWmgGs+nIV4fKxnvEZpXF/3vBk73QzGr4gJv3v1CJ1Npwf+qhnme
	 izdj3xL1vf3E1tGzttj2brAzKPFS1Lwl/x2GyMmeWqkJ9M+050EYLNaEMWN+XPHzb4
	 tSJ0JUAqYbdlcGYHbA7AXteYY1te2spbN0wk/Gqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/52] RDMA/srpt: fix function pointer cast warnings
Date: Tue, 27 Feb 2024 14:26:27 +0100
Message-ID: <20240227131549.847362225@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit eb5c7465c3240151cd42a55c7ace9da0026308a1 ]

clang-16 notices that srpt_qp_event() gets called through an incompatible
pointer here:

drivers/infiniband/ulp/srpt/ib_srpt.c:1815:5: error: cast from 'void (*)(struct ib_event *, struct srpt_rdma_ch *)' to 'void (*)(struct ib_event *, void *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
 1815 |                 = (void(*)(struct ib_event *, void*))srpt_qp_event;

Change srpt_qp_event() to use the correct prototype and adjust the
argument inside of it.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240213100728.458348-1-arnd@kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 4a696bf280ef9..5cbccf5a54d68 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -221,10 +221,12 @@ static const char *get_ch_state_name(enum rdma_ch_state s)
 /**
  * srpt_qp_event - QP event callback function
  * @event: Description of the event that occurred.
- * @ch: SRPT RDMA channel.
+ * @ptr: SRPT RDMA channel.
  */
-static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
+static void srpt_qp_event(struct ib_event *event, void *ptr)
 {
+	struct srpt_rdma_ch *ch = ptr;
+
 	pr_debug("QP event %d on ch=%p sess_name=%s-%d state=%s\n",
 		 event->event, ch, ch->sess_name, ch->qp->qp_num,
 		 get_ch_state_name(ch->state));
@@ -1766,8 +1768,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	}
 
 	qp_init->qp_context = (void *)ch;
-	qp_init->event_handler
-		= (void(*)(struct ib_event *, void*))srpt_qp_event;
+	qp_init->event_handler = srpt_qp_event;
 	qp_init->send_cq = ch->cq;
 	qp_init->recv_cq = ch->cq;
 	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
-- 
2.43.0



