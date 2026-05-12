Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDB73EDE72;
	Tue, 12 May 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608739; cv=none; b=oVaaCthaprgQrLLmFyck/Qr3mIrdg2khoUpn0Ir+5hO8TAXLtRlPl2Bz6nkU1ZTfiPZlLSyjZDgNobQfwLjOuHAXUAbHcjIdVjwcNnlgueNmWC+Aog/E2Of0uzz5xSveFcSmH80eFZq+pANn67JB3ozx4fhWebhVwrvnIC13zbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608739; c=relaxed/simple;
	bh=CR7XbRC5EXYB5fUdZE4wMuMpf8NanoL/rewb54r3HLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHg0jYpgK56d9kPFSOkP3N3op/G5vUJSgwoq07HE+2FSXOS3K1gaYJpQ5dpzEog421OPcaYCMxI/PuRZzrzYcRfE/aJneKLTj+VGRcVj/fRgOayp99tlfnQoy/u5iLWeFEAB+vhpvCkliDwoNnDyxWwyD042fCDyBGSfzt//22M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAbyStbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAbyStbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364B7C2BCC7;
	Tue, 12 May 2026 17:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608739;
	bh=CR7XbRC5EXYB5fUdZE4wMuMpf8NanoL/rewb54r3HLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAbyStbge40B9V8w0w9LAfg9bfFK1o7JdVLrxJ4DXD/2MEXLqpd6lKeI9uqCh+wTK
	 TOApY9UVdqImJHf/Gn3eIiHLRM7D+pZ/q+KR0Iq/RYtbePDdBzRqnWAenT2TYT1SgT
	 QX7gwBBfJBOgFUWYbs5MykF0CtPyDpOdTAArbuNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 195/270] RDMA/mana: Fix mana_destroy_wq_obj() cleanup in mana_ib_create_qp_rss()
Date: Tue, 12 May 2026 19:39:56 +0200
Message-ID: <20260512173942.555289999@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 34ecf795692ee57c393109f4a24ccc313091e137 upstream.

Sashiko points out there are two bugs here in the error unwind flow, both
related to how the WQ table is unwound.

First there is a double i-- on the first failure path due to the while loop
having a i--, remove it.

Second if mana_ib_install_cq_cb() fails then mana_create_wq_obj() is not
undone due to the above i--.

Cc: stable@vger.kernel.org
Fixes: c15d7802a424 ("RDMA/mana_ib: Add CQ interrupt support for RAW QP")
Link: https://sashiko.dev/#/patchset/0-v2-1c49eeb88c48%2B91-rdma_udata_rep_jgg%40nvidia.com?part=1
Link: https://patch.msgid.link/r/6-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -194,11 +194,8 @@ static int mana_ib_create_qp_rss(struct
 
 		ret = mana_create_wq_obj(mpc, mpc->port_handle, GDMA_RQ,
 					 &wq_spec, &cq_spec, &wq->rx_object);
-		if (ret) {
-			/* Do cleanup starting with index i-1 */
-			i--;
+		if (ret)
 			goto fail;
-		}
 
 		/* The GDMA regions are now owned by the WQ object */
 		wq->queue.gdma_region = GDMA_INVALID_DMA_REGION;
@@ -218,8 +215,10 @@ static int mana_ib_create_qp_rss(struct
 
 		/* Create CQ table entry */
 		ret = mana_ib_install_cq_cb(mdev, cq);
-		if (ret)
+		if (ret) {
+			mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
 			goto fail;
+		}
 	}
 	resp.num_entries = i;
 


