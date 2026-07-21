Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B683B1ECC;
	Tue, 21 Jul 2026 20:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666104; cv=none; b=lK8hc0ejksbTlzm4G0NujS9sV0Eq6xcHtkPTQMo1duuUHAkEzkfVTCVTSwUgX0E19z4/NSHEMLoYhllemkCEQMa8jJaVQ56SkSqGJITAvJrFkynRLjm3VdC80peb5Eymrr++8b+81lNMWZn7RoNyUgMAhCoVSOhVUG7KT1BnO5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666104; c=relaxed/simple;
	bh=2g/cxLU/3ipb+E+J9zndE4yT0RO2VBeOgeDhid3XDNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcD/anenwK0B1mA1KCkxN0qAfRbeLniHvyfJB01nbti2k34E3bxvpYIsP1DwANmx3ZHX3Pj6M0ngrBWyF4RC3fgf1EGw0u4x40YHk0IW8P7qADGjpWGcVB+zUQZF45RQjjbWyyP9KVRxO6sKotzaWoFd199FSj+zG7yInjhICNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slo5wNKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slo5wNKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1A11F000E9;
	Tue, 21 Jul 2026 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666103;
	bh=d0uPz7jx3xPyb1pcV+UAnj3WYeFnObn0k5y/0Uddjlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slo5wNKm4PZlTu3KHdqSQ0Hpq8WGGQbh9MRqj4N7V302oTmFHYecn1B5eaqrFvvSR
	 X6JwH/pUX7rCF4lxrzRMvszGXH/oarJ3KAbH/cW2kxGLBabRgMNWf5T29FxMbndP55
	 v+qhAkax54DCMpXdgSgvCs8aK+SuGFQ03hopW+GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0512/1266] IB/mlx5: Properly support implicit ODP rereg_mr
Date: Tue, 21 Jul 2026 17:15:49 +0200
Message-ID: <20260721152453.303912329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index b6727f4647915b..25348f732ac541 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1707,6 +1707,21 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
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



