Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642931420D3;
	Tue, 27 Feb 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043876; cv=none; b=PeiyumpfMyN30uJ0OwbWODaR9q20Ut83/FiD+MGl5YKGHSo+hsKbER+/WP6Rgn9VNEhyajlq5uNeKRXOcMwC9hOs45Jt9arnYLv/VsfsRGoHA0WVP/sAPxJ5uYQHZ0P3+B85FxJCqV1AQsqhdhjiikJZ2JPd+7L5zzumCV99Elc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043876; c=relaxed/simple;
	bh=0dBe1vZNIxoNuBNMkcszCJuSByz/0eav64bTklpCIJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6J8vMjCICQxxc+0lxibnvFy9uc9qibBaAOZSAAk+vxth1nX7LFLWCFfEPKiUtFU/Koxa6cxkCQ1lvfK0lntI+JjxAgNDCYJ9wgrCX80v3wWSjLGh7qykcpMhif1KSu6dngCoVF4WMyMF3ONui3BgBkfQA8rfNS6psoXWi2nmpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SszE3Z5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SszE3Z5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7073DC43390;
	Tue, 27 Feb 2024 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043876;
	bh=0dBe1vZNIxoNuBNMkcszCJuSByz/0eav64bTklpCIJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SszE3Z5XtnJ5RUcFDOzf9pY1kWmVo/26d8HnPmvNhVXlYjRjYPbSl2NJTqMMF85M2
	 py6uazBJaov6/kza09E2RQrBaNJ6EzRm5HxO+fM7R4+qeS+KbGk9vguDwe3/ym4Ep4
	 jrPIx39lUfD5dPlwoYGGMQ7kYS3apOIRmeayCYKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 66/84] RDMA/srpt: fix function pointer cast warnings
Date: Tue, 27 Feb 2024 14:27:33 +0100
Message-ID: <20240227131555.019912178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ccd9811c6c1e2..d03a4f2e006fb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -213,10 +213,12 @@ static const char *get_ch_state_name(enum rdma_ch_state s)
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
@@ -1802,8 +1804,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
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



