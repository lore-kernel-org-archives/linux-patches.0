Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9463A3955C1;
	Tue, 12 May 2026 17:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608087; cv=none; b=iZneUOWsCMBKgtdmonLtGLvwWn5NRkLgz4nJTW7u1yjlHotmx5PgAUTFa55npG2R4VqdUsG/0pnkyBh5nZC600IZUc9iHwESsUWA64Ov0P4QyxxMEc4rKKEE/qgEt4A88nf4zGauPirmg+k7x+4BSvIM8OgpN7LlKXsyEj/B9Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608087; c=relaxed/simple;
	bh=vzfDWyuVMbaC9EamXFrz222EQyzijZ1AqaDwSayO3gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcBnkc7WMCoBpt4sE8mhVkbmqVP8AVUvevW+M0ZVzvsz7qTEjzi3b40nwTvgYY3VI0CrVj/9/r4qFMJ2lIJKNYFRNSHcwA6DdEawVcy9ha8r7FElSF7Gsq1JNKHvbmtqMAeXnuUw4vOgFOwSgXe/9/RHRACliy4aGcyGZfna6iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M36VdqY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M36VdqY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29223C2BCB0;
	Tue, 12 May 2026 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608087;
	bh=vzfDWyuVMbaC9EamXFrz222EQyzijZ1AqaDwSayO3gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M36VdqY05+PfN0efIAop/i5bAj7dnzstb9ApraYUdi9GAjDxoMywNZUaIt2ngw/ne
	 bUwV2IDyXnP3JAVUwAjBE1j9SJUg8sC6uUCC1osB1gcZScjsDqQX+VwKdplHJ3rOmA
	 67aVqq80s1Bv/SR2BzVv5eQWP/a+dtcAGP0eo+ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 148/206] RDMA/mana: Fix error unwind in mana_ib_create_qp_rss()
Date: Tue, 12 May 2026 19:40:00 +0200
Message-ID: <20260512173935.996891014@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit 6aaa978c6b6218cfac15fe1dab17c76fe229ce3f upstream.

Sashiko points out that mana_ib_cfg_vport_steering() is leaked, the normal
destroy path cleans it up.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=4
Link: https://patch.msgid.link/r/7-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -236,13 +236,15 @@ static int mana_ib_create_qp_rss(struct
 		ibdev_dbg(&mdev->ib_dev,
 			  "Failed to copy to udata create rss-qp, %d\n",
 			  ret);
-		goto fail;
+		goto err_disable_vport_rx;
 	}
 
 	kfree(mana_ind_table);
 
 	return 0;
 
+err_disable_vport_rx:
+	mana_disable_vport_rx(mpc);
 fail:
 	while (i-- > 0) {
 		ibwq = ind_tbl->ind_tbl[i];


