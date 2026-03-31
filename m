Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D43C3F8E04;
	Tue, 31 Mar 2026 16:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975930; cv=none; b=i58gTCZ56ewbfWK6YPryXzVv5YzZyRBYitEVSLzocbj0QzaPaDg+oySIZD5ZCBnKLTpHbPy55WO0RKxZA8WDkC4nbbN0XhGjlDq6DeWXW5oeKHqHoIRlXNNxWHaUvVELviHLmceiBC7v0S51TIEKRvGeQhX0QRY7U+JzMBVrd6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975930; c=relaxed/simple;
	bh=t4xlBt7HKK3bGhh8TQgdfmLkAdqoKsfJaDmbkl+JBoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riWuer/34kyKsgITfg1DXkc3nepezHtrt4vFgyrCPNHULw5PmMIt8vJE6FSJBmcfWn8hCpHqT+5U3P/OwMSv9gSDy4D3jokHscrofmbF1veeq97bE4og056/qibT6ABCVZRfaTSgABnkkiwpVGbCBwqAvCYGAkovdQ5uSahfm6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/Qbq3/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/Qbq3/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61CFC2BCB1;
	Tue, 31 Mar 2026 16:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975930;
	bh=t4xlBt7HKK3bGhh8TQgdfmLkAdqoKsfJaDmbkl+JBoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/Qbq3/na8KYZxUWILz/cUySeO5CfSxCkviHF1sUISeV4ZIHTnqaIfQHhx/9CkHI4
	 GH8HsDQPeyGssrBXFx9pPofiNAkFh+GWaQd1pgdYuzgFBjLUHExjdgprBFInppdSRm
	 WWs0ezym5zYz0qIAV5ioO5j08IfYngotaEACzMrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/244] RDMA/irdma: Initialize free_qp completion before using it
Date: Tue, 31 Mar 2026 18:20:58 +0200
Message-ID: <20260331161745.656296750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index ac01b6c10327e..7514c5e54e026 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1008,6 +1008,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 	spin_lock_init(&iwqp->sc_qp.pfpdu.lock);
 	iwqp->sig_all = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
 	rf->qp_table[qp_num] = iwqp;
+	init_completion(&iwqp->free_qp);
 
 	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
 		if (dev->ws_add(&iwdev->vsi, 0)) {
@@ -1042,7 +1043,6 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 		}
 	}
 
-	init_completion(&iwqp->free_qp);
 	return 0;
 
 error:
-- 
2.53.0



