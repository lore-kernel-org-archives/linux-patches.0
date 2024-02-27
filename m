Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58E713B2AC;
	Tue, 27 Feb 2024 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042245; cv=none; b=mK6UBQPmHpxKQLpXJrQW8wSBWuzJ0TCLYDRA3xNbc97y36FMGIRYjTHVDJPirWgOqNjRA8IOLgoIwmLhwe4mFi4jm+PBj5MCxHNr5OBa5SjcetW9/uT8pr/B8hoszuVEllKtC9CSiEc/xwM50Dh9cF4cgv+peH36lvbhfpkBTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042245; c=relaxed/simple;
	bh=MaPDJb9pH+OUvDaKLnj72ClsNLtC4VdxIRBmFEP5viA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sy5JlzpizeZh24Wk/XEFEh30sPS47MuK0zM9C93+oL09e3q1MelySkglNyYTKQjxKMlnH3EaDl+Tp8X+Pc635IZtiPNKdUZUxHwZQSR2wBPn6s6p7wH0BTQlYVi7YunL0yLi940fG4JHz2fR6cVRgg+g8VyBVq+8XbuIW511BSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKC8oCnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKC8oCnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEFDC433C7;
	Tue, 27 Feb 2024 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042245;
	bh=MaPDJb9pH+OUvDaKLnj72ClsNLtC4VdxIRBmFEP5viA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKC8oCnqSe4M/03EscVt46wNawGgV6O9fLei9uqiLQsAAw+efVkWOQaE8EzCNrIHa
	 bvAgkjhnC64B6YV6pdbauakuYKPmLLEvLsw1fcPAXGmc17oz31Rz67QxZwzZv3ovW7
	 1o0dCO2DEAzxvD/1DHtyAsSvFKdi7xyOGYBjJ5NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/299] RDMA/srpt: fix function pointer cast warnings
Date: Tue, 27 Feb 2024 14:25:41 +0100
Message-ID: <20240227131633.151848143@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
index 38168d8c626fe..015bfeede90e1 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -214,10 +214,12 @@ static const char *get_ch_state_name(enum rdma_ch_state s)
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
@@ -1811,8 +1813,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	ch->cq_size = ch->rq_size + sq_size;
 
 	qp_init->qp_context = (void *)ch;
-	qp_init->event_handler
-		= (void(*)(struct ib_event *, void*))srpt_qp_event;
+	qp_init->event_handler = srpt_qp_event;
 	qp_init->send_cq = ch->cq;
 	qp_init->recv_cq = ch->cq;
 	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
-- 
2.43.0



