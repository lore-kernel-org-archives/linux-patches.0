Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679DF347517;
	Wed,  8 Apr 2026 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671781; cv=none; b=RmVyKFOoRhRThb5vJtTNu1X0zwVs/3nh2GbjGyLMFy5w69nVymPJpsf4q4bg0qa219rw0Ted8D1N7ToBTrNgQVbvLSe79rrTuW5HhXxxM90BM8Cy3wcMb23Gqg0/Lx9TqPhpQrglJtkGKkNxMXEQDfxn5d65XDZxixNigmf38pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671781; c=relaxed/simple;
	bh=81JLeFVzgryrS+/2+HzSs2OJqg72gCWq/HUnpzMczKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BltjAq//6SVeL1nHgzrn07FmXIf9zk4ibF/55Utn/w3S29+B9HLcNahHcJ7LUQMSabOjZmsTr2BsDUd2VxpOlc9Snk/wrHD3EOga2RKOktuz4w1uPqNOXfTRgsnZ3R0aKFC3Z5jV7YZtt9RgjPeY9O0xV5B/G6gk1E2HkZXSsXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H//7ulbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H//7ulbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1595C19421;
	Wed,  8 Apr 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671781;
	bh=81JLeFVzgryrS+/2+HzSs2OJqg72gCWq/HUnpzMczKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H//7ulbdHwEepO9l1vRW2CL5o1FqAg+U6XVLY9vFa4xDytsVsyDOe/tCHePgjcUsS
	 gRTSgw7xFJXvj1acBxTWVqnM4nHjygChThcsOhcHVRqpuJqV+O39UP/fVtxsuhRz9J
	 z1MoytkF1oj6lwkK1dsokYRzCmZfGhsWEXY5SgMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/312] RDMA/irdma: Initialize free_qp completion before using it
Date: Wed,  8 Apr 2026 19:59:43 +0200
Message-ID: <20260408175936.204872125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 11a95521fb93c91e2d4ef9d53dc80ef0a755549b ]

In irdma_create_qp, if ib_copy_to_udata fails, it will call
irdma_destroy_qp to clean up which will attempt to wait on
the free_qp completion, which is not initialized yet. Fix this
by initializing the completion before the ib_copy_to_udata call.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index d0139a696d437..2f5299c9d9ed3 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1005,6 +1005,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 	spin_lock_init(&iwqp->sc_qp.pfpdu.lock);
 	iwqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) ? 1 : 0;
 	rf->qp_table[qp_num] = iwqp;
+	init_completion(&iwqp->free_qp);
 
 	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
 		if (dev->ws_add(&iwdev->vsi, 0)) {
@@ -1039,7 +1040,6 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 		}
 	}
 
-	init_completion(&iwqp->free_qp);
 	return 0;
 
 error:
-- 
2.53.0



