Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBD73C0A1A;
	Tue, 12 May 2026 17:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608134; cv=none; b=PQTx8H4B5WaL/WKt2Spsqkv9lR9swEp87fn3Qbk1HT6aHpeQrTHZodRxG3nN92xgXn7OEMq12ACJ7pGLJvauCIxb1kwNTmRGOVNYo5pIleg1LJmTcaNi/FFV0NSbg5KbPzojCssPMPURExVIeqeXyE59qNWrbVVjVr/PC3cJlT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608134; c=relaxed/simple;
	bh=jVunKvZc7ykfce374DElfu3dGnb2i/d+HOuJaTuSAaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugKmKlCiYG7ZpW9gR3SEbvYQCK7EZeikiwZem3PcGO8odutYaEvSDze1AbszND4EFWAfF86MlVG2KQyrOBEzsR9ZxSYL6Eya6bwwuhbWpRYxG7S/SMZOdEWrm2t6y0gZBBA3X6Za9DPA1gQ6vmOJVeU7MVMe61W1M1ZKJejUTXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPIrcQk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPIrcQk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33C0C2BCB0;
	Tue, 12 May 2026 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608134;
	bh=jVunKvZc7ykfce374DElfu3dGnb2i/d+HOuJaTuSAaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPIrcQk/1/snhSlgDYYFwcKvvibhxTrX5SVoOEIaN0JKtcadl/b477vnCzxdlEm4c
	 CPNtNMm5EWfQLoqXY9vTSmaJOLiKlD7r4/NJlPBvCXYH5kbuI04TvNPkvlp5q5MOIN
	 DIajWVMmgzhoggHWvDF0pC++UJlC22VosTeKCoJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 151/206] RDMA/mlx4: Fix resource leak on error in mlx4_ib_create_srq()
Date: Tue, 12 May 2026 19:40:03 +0200
Message-ID: <20260512173936.060050732@linuxfoundation.org>
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

commit c54c7e4cb679c0aaa1cb489b9c3f2cd98e63a44c upstream.

Sashiko points out that mlx4_srq_alloc() was not undone during error
unwind, add the missing call to mlx4_srq_free().

Cc: stable@vger.kernel.org
Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=8
Link: https://patch.msgid.link/r/11-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/srq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -193,13 +193,15 @@ int mlx4_ib_create_srq(struct ib_srq *ib
 	if (udata)
 		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof (__u32))) {
 			err = -EFAULT;
-			goto err_wrid;
+			goto err_srq;
 		}
 
 	init_attr->attr.max_wr = srq->msrq.max - 1;
 
 	return 0;
 
+err_srq:
+	mlx4_srq_free(dev->dev, &srq->msrq);
 err_wrid:
 	if (udata)
 		mlx4_ib_db_unmap_user(ucontext, &srq->db);


