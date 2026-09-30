Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06B04F7CBF;
	Wed, 30 Sep 2026 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788196; cv=none; b=UI+4KTFufwUEgex75TYPzP0xQz6BCn+O/fJFA6FgwBP/1NRsvynEZ+6GU2J0Hf14hLzYSDdCY47mX5qJSBnteRB9pDsi+7bU57RUpd/nEevtG8LSk11vDHsDy1c1+MpBGGdWEz5fqp00mrIQQLl8CvE/sonq3E7sxr9B7zagGBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788196; c=relaxed/simple;
	bh=n5JGQ2zcSR2di5eV/V5R5/bYrCdF66cCD0HDz+DKWas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H60FDN0upe4nfEReCIlw0wr4Idqg/ATFDnSNfKtDpslx81W+ASqIBHXXQSDJunexrnvPAFMFWXJKtiHey2czOnJrlYfkwIMKT+0SvsI4moMeitwH5Bn5tlsG+eJU31Ckr5NjfFrNu9BHXPWayFi0fOVc0mg5ahtropoJ/LFXtOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wa0Ac0PI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wa0Ac0PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587061F000FF;
	Wed, 30 Sep 2026 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788194;
	bh=NDj8a1n3oMLoSxBBDhXvKZKK3fmj77LepfG3R92t1G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wa0Ac0PILpTbGotFiBiHsTKU/jjJUXKyfnapygi4EjRkChsMH7yuALmTfn0EZ6Ju8
	 azasj0z23sO9q2/a5UBIRyiiELmzgU2kyzkB+ZP8O6JBUcv4TLiKa2JkBTu0JoqkIB
	 CTDyNzbz6KYwnCHFCoavu/0OktFlmpEdp7dmpbfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/877] RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted
Date: Wed, 30 Sep 2026 17:15:50 +0200
Message-ID: <20260930152415.588894667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 2ae16aaa78b5edc6e6d0904c84fd9cdfb762bcda ]

The client borrows shared CQ credits in the ADDR_RESOLVED handler via
ib_cq_pool_get(), before the peer is connected. create_cm() can return
-ERESTARTSYS from wait_event_interruptible_timeout() without destroying
the CM ID. The init_conns() and stop-and-destroy paths then call
destroy_con_cq_qp() while cq is still NULL (no PUT) and only afterwards
rdma_destroy_id().

CMA serializes the handler against rdma_destroy_id() with handler_mutex,
but that does not order the GET against destroy_con_cq_qp(). If
ADDR_RESOLVED has already passed the DESTROYING check, it can take
con_mutex, GET credits, and then lose the con to kfree. Device
unregister later hits WARN_ON(cq->cqe_used) in ib_cq_pool_cleanup().

Set a per-connection flag under con_mutex before CQ/QP teardown so a
racing ADDR_RESOLVED cannot borrow credits after teardown has begun.

Reported-by: syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d396918a29afb8543e1c
Fixes: 3b89e92c2a95 ("RDMA/rtrs: Use new shared CQ mechanism")
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Link: https://patch.msgid.link/20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 8 ++++++++
 drivers/infiniband/ulp/rtrs/rtrs-clt.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 8fa1d72bd20a4..fea3b17611c50 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1738,6 +1738,8 @@ static void destroy_con_cq_qp(struct rtrs_clt_con *con)
 	/*
 	 * Be careful here: destroy_con_cq_qp() can be called even
 	 * create_con_cq_qp() failed, see comments there.
+	 * Caller must set con->destroyed under this lock first so a
+	 * racing ADDR_RESOLVED cannot ib_cq_pool_get() after we PUT/SKIP.
 	 */
 	lockdep_assert_held(&con->con_mutex);
 	rtrs_cq_qp_destroy(&con->c);
@@ -1772,6 +1774,10 @@ static int rtrs_rdma_addr_resolved(struct rtrs_clt_con *con)
 	int err;
 
 	mutex_lock(&con->con_mutex);
+	if (con->destroyed) {
+		mutex_unlock(&con->con_mutex);
+		return -ECONNABORTED;
+	}
 	err = create_con_cq_qp(con);
 	mutex_unlock(&con->con_mutex);
 	if (err) {
@@ -2202,6 +2208,7 @@ static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_path *clt_path)
 			break;
 		con = to_clt_con(clt_path->s.con[cid]);
 		mutex_lock(&con->con_mutex);
+		con->destroyed = true;
 		destroy_con_cq_qp(con);
 		mutex_unlock(&con->con_mutex);
 		destroy_cm(con);
@@ -2368,6 +2375,7 @@ static int init_conns(struct rtrs_clt_path *clt_path)
 		if (con->c.cm_id) {
 			stop_cm(con);
 			mutex_lock(&con->con_mutex);
+			con->destroyed = true;
 			destroy_con_cq_qp(con);
 			mutex_unlock(&con->con_mutex);
 			destroy_cm(con);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.h b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
index 0f57759b3080f..e1e7c7adc9470 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
@@ -75,6 +75,8 @@ struct rtrs_clt_con {
 	unsigned int		cpu;
 	struct mutex		con_mutex;
 	int			cm_err;
+	/* Set under con_mutex before CQ/QP teardown. */
+	bool			destroyed;
 };
 
 /**
-- 
2.53.0



