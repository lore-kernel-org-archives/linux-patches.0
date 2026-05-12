Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DDE34E744;
	Tue, 12 May 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609540; cv=none; b=YKFZqZusSJxjCYVKA0Hx1QqaAEmbwPtdV1zBRvcGwHxW6ycGn3wVwtozo+8nPnlqLlI8UJI/106VxYFwZvYoyhkiSelhw+4xyIkOllLegeu0AY4aW1ULqKP+UQdFYfx6abjX2D7jGu64IocwRNLHUpuXGQzzUAc4JNncVJJpqUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609540; c=relaxed/simple;
	bh=0F4g7JSXPj+biescB8wB9GE0OBs/9hzcSI+b/3dg4iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9MQAmLhabUhu/YOYSCTbsVtMk+9fD/4wInxjlGeTSJ13t0HQCAjB+7kIH82+iDb+Abc0CLObzfWsD4cE1411/3850gd9bPLTNPZ76MlOvm1oSbpA/+jh46zMib12YUr8jU9/x5XElxdDMJr08jz6xFFkYgAP2E4cVhuehcJviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S46EYfnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S46EYfnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CF6C2BCB0;
	Tue, 12 May 2026 18:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609540;
	bh=0F4g7JSXPj+biescB8wB9GE0OBs/9hzcSI+b/3dg4iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S46EYfnIu9G5LhPhth3mP6CB8RnxzuZCoJaBk5N8JFiWYmhwl53AgxJYefBhVTdPx
	 faU5kPIJcZOnJVF+6rW7a8sm14W4UmPrkGFfzMMt5MVcU6zGBJNCm7sSlVmINjjrDS
	 oDkO8W58hUmwoDAH1d7XyC2bxanKkNV9Hltr5gIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 234/307] RDMA/mana: Fix mana_destroy_wq_obj() cleanup in mana_ib_create_qp_rss()
Date: Tue, 12 May 2026 19:40:29 +0200
Message-ID: <20260512173945.059848137@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -193,11 +193,8 @@ static int mana_ib_create_qp_rss(struct
 
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
@@ -217,8 +214,10 @@ static int mana_ib_create_qp_rss(struct
 
 		/* Create CQ table entry */
 		ret = mana_ib_install_cq_cb(mdev, cq);
-		if (ret)
+		if (ret) {
+			mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
 			goto fail;
+		}
 	}
 	resp.num_entries = i;
 


