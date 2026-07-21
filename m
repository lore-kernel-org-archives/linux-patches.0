Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5D415F2F;
	Tue, 21 Jul 2026 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656535; cv=none; b=beVmnUEkDgULoLt1gBahJPN5kHJhsazh7M5yEG97e4Ki/l1pAzdIN3b4nHH/a2BNmvj4yBf2HKSHz3LaxK7j90ykf4RkKFbGUdCrjQMHnirxulUs0HyDHEk0Nd2cZvlwbiCde3NmUFwgd0R1N1fO9jmrPFpnno+SmSRqNFOkUEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656535; c=relaxed/simple;
	bh=1XUE3VPrI0DmKARTb98rdfn5CTwea8wmgvnqARJZ+d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai5o1rL/bASqwwQqjqLUoxUtm5xp9Cl7mbi0c5aMp6B71+wLdUSFOKl0ySA/NlRtsNWnfC9otNQiyBTb7JJ2pVFgA1tep/c7QmAO0CvdbHUnmZT765DU+lVbAFoxU8WclDuliBe40GEvDbmai/Cd9caqrO6zVYno4zLhAyeCQAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DYgYstP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DYgYstP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298FC1F00A3E;
	Tue, 21 Jul 2026 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656534;
	bh=rI6bxcScObuCVNEZvPr7BDfdbhpDRk8/VYvFrM0E0KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DYgYstPyk/emcDQXvNWf3+a3Eg4d012HmldqZmkNfFIAkNUj+X634Ay+eHuUPyHC
	 SoaIIJ9ILq/ioSwRwvIiBIf8d/aj/WrfpTNMmAUsUuXeqiy4r7CC/tV/fZ0oubm8wJ
	 jMPY24HOret+akGQ1NmoIuGImiz5IkC0ti/nA12M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0381/1611] IB/mlx5: Properly support implicit ODP rereg_mr
Date: Tue, 21 Jul 2026 17:08:17 +0200
Message-ID: <20260721152523.771194845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit ee7a8335069150c3f1893a697ab30bbeca00d796 ]

Due to all the child mkeys in the implicit ODP configuration we cannot
change anything in place for the parent mkey. Instead the whole thing
needs to be rebuilt if any change is requested. If the user does not
specify a translation then force the implicit values which will then fall
through the logic into mlx5_ib_reg_user_mr() to allocate a completely new
MR.

Since implicit children were also touching the mr->pd, this removes
another case where the access was racy.

Fixes: ef3642c4f54d ("RDMA/mlx5: Fix error unwinds for rereg_mr")
Link: https://sashiko.dev/#/patchset/20260427-security-bug-fixes-v3-0-4621fa52de0e%40nvidia.com?part=4
Link: https://patch.msgid.link/r/3-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 374e40758359db..c581ac46e0c996 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1904,6 +1904,21 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 	if (!(flags & IB_MR_REREG_PD))
 		new_pd = ib_mr->pd;
 
+	if (mr->is_odp_implicit && !(flags & IB_MR_REREG_TRANS)) {
+		if (!(new_access_flags & IB_ACCESS_ON_DEMAND))
+			return ERR_PTR(-EOPNOTSUPP);
+
+		/*
+		 * Due to all the child mkeys we cannot actually change an
+		 * implicit MR in place. If the user did not specify a new
+		 * translation then force the fixed implicit MR values.
+		 */
+		start = 0;
+		iova = 0;
+		length = U64_MAX;
+		flags |= IB_MR_REREG_TRANS;
+	}
+
 	if (!(flags & IB_MR_REREG_TRANS)) {
 		struct ib_umem *umem;
 
-- 
2.53.0



