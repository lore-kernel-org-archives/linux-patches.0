Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147DC51C356;
	Wed, 23 Sep 2026 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172785; cv=none; b=Od49IJS0r/8pHbMBC9fjyE+bBpIJSZuIsejnBQHTUP1kS6uMRZFas4Fm+cRI4tAcTxbTMuRt0HKbYKsoj6tuu3gR1ru383/q3fE1t5nvMeBI+Zn99x82We9sU/+CP0aCGBr85iISoTdOl30Ah7VYOWoCzUwDoF3X0ANs7f+bOyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172785; c=relaxed/simple;
	bh=3R80QZu16dqFjX3Phu2KJrrML1thvxhOR0zXyYAs/O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6tsfNNO7MD1LukqJ27LycYUx1t0zcWLzdOqGSFMRDEFXCK7Uy3xG8TIkrel1YetoZshOvTRbNGCwL/Vajja6DnbDN5z9g7gUwP42aCK0qkOZ82/fSXXkgXoCwUiNkpqGOCl/jdoLJcIzwuHgHjrfkV4Dajn6jDoNfLh1o58B04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NORcYYTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NORcYYTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BC81F000FF;
	Wed, 23 Sep 2026 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172783;
	bh=l/o5cLseikR2cZ42dqt9E7ZLiXFIql1xeKt0+d3bZq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NORcYYTVvRdrX26KF1aFCV/fIf6kdezZcNOJMXng2eYdkDRAEzruOLUc9j1eYdULz
	 z/GxT0jb8voQEkjoIW6lwnLfNgQFqDr5IvdwHoTv+n1h3lGrIkwJal9mHrstCDadfH
	 wowQG1a5Yty08xPf6ziJA2TyQquWMexb6y98DKXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 043/438] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
Date: Wed, 23 Sep 2026 16:01:04 +0200
Message-ID: <20260923140645.898170663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 3fb905f07ea45b31c8f67ba6e4668de46f527e65 ]

Enforce local fence for IB_WR_REG_MR to avoid spurious
FASTREG_VALID_MKEY async events during heavy invalidation
and registration activity.

Commit 69e8e429bca2 ("RDMA/irdma: Enforce local fence for LOCAL_INV WRs")
was very similar, but was not sufficient to prevent all occurrences
of these async events.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260901160014.2026285-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 04d5af78686b5..e926eb37982c6 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4244,7 +4244,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.total_len = iwmr->ibmr.length;
 			stag_info.reg_addr_pa = *palloc->level1.addr;
 			stag_info.first_pm_pbl_index = palloc->level1.idx;
-			stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE;
+			stag_info.local_fence = true;
 			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR)
 				stag_info.chunk_size = 1;
 			err = irdma_sc_mr_fast_register(&iwqp->sc_qp, &stag_info,
-- 
2.53.0



