Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51EE3FD133;
	Wed, 20 May 2026 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303033; cv=none; b=rS4++FghInyWJ/7RT317q6J6Lyarpq5caFV8EhpYNEkJsHnF0VS6sOrQXYTSB3gGvC5vu3x8vME04OZloH/b7cGH6Sn7kkrHyWDKHOrvoeZW0uSod0CoM1+FoRqSFhFS7EWXVLdKW0eJS4Ey2LVAZiANDod++tQZnHE53taeWkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303033; c=relaxed/simple;
	bh=XOKGB8nj2dwgNzUn97Bzp9ED3xvnSWu1E+cjwaC7VXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPkfnq7MOAPX9n/INGaHVYkJVYnlXIn4qhuE69olntGMqOVVOEVRxYaPAsiUv9XDMzKvPdRZPZxJe6Ix8CoPEJk2UwKCpwd4ysN555MZHterTxPTkJBpEXcMypP+UCIHcUCXaPhDdNrGRpNd9H0CZFu4uWnLGaQwF6TEqwATAxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWdYfgAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWdYfgAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A878A1F00893;
	Wed, 20 May 2026 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303030;
	bh=qpZiPS3Nq/JNEKNeEQoHYXMS8NoZ0zyEwASTDA301xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWdYfgAPsgeK5s8CxXTPHsRATnZ68jV60pU9lls50Qdmq9PQ4qcQbXxPn+aZj3h8N
	 kTUhDGtyUDwwmj7z3dIth9C6vGhraYgcsDtgrTeaCO2FLVhPLuEzZnvLdB03tzwvnY
	 GPmYQj3HLR6TC6tgxltOdG2WqDko9+omYyji3r0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 493/508] RDMA/mana: Validate rx_hash_key_len
Date: Wed, 20 May 2026 18:25:16 +0200
Message-ID: <20260520162109.279403833@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 6dd2d4ad9c8429523b1c220c5132bd551c006425 ]

Sashiko points out that rx_hash_key_len comes from a uAPI structure and is
blindly passed to memcpy, allowing the userspace to trash kernel
memory. Bounds check it so the memcpy cannot overflow.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Link: https://sashiko.dev/#/patchset/0-v2-1c49eeb88c48%2B91-rdma_udata_rep_jgg%40nvidia.com?part=1
Link: https://patch.msgid.link/r/4-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ kept the stable branch's existing `req_buf_size` calculation instead of upstream's `struct_size(req, indir_tab, ...)` form ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -24,6 +24,9 @@ static int mana_ib_cfg_vport_steering(st
 	mdev = dev->gdma_dev;
 	gc = mdev->gdma_context;
 
+	if (rx_hash_key_len > sizeof(req->hashkey))
+		return -EINVAL;
+
 	req_buf_size =
 		sizeof(*req) + sizeof(mana_handle_t) * MANA_INDIRECT_TABLE_SIZE;
 	req = kzalloc(req_buf_size, GFP_KERNEL);


