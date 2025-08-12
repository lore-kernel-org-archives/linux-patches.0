Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876722CA9;
	Tue, 12 Aug 2025 18:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024468; cv=none; b=ChRBi2895L/LkcFbB2opqCRacDtDriTH38oFa3H8rhVAKM8W3PAiuvC9h9WqxxGoJ34zQjGhW4F7mPOFaE8kQC/ZWT486W3Crt/jmp+BMZDS9zg8Vz0OE9AoJEiZvEY61ANsa3VByJTU6pjDHDSkLuFDr9tVESoIt1Y22S39DtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024468; c=relaxed/simple;
	bh=i4TU4hci6a2E3QWpgLgL2Tx7ffMMdxB+SkLXFSjvTRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFDSzCS3p8PICE5/2PbaJvwDbUh8ZfAOpcxcZY1QnbWnVlHowQxps1/75Y906c0ELfFMC0XFth3yu44T3h3kXrZvs2Ql8tCQFocp18v2SsiaGtwLq6Q2E7SLcNAG1QHRNa6BsCiC1/TD2OZaVb5zP1BVf8y7bRIu8Aabhhn71bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrlv0tz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrlv0tz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3A1C4CEF0;
	Tue, 12 Aug 2025 18:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024468;
	bh=i4TU4hci6a2E3QWpgLgL2Tx7ffMMdxB+SkLXFSjvTRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrlv0tz2R1l+RgxxCuCfzf9BouYFmRX2MmdvHGAEWIo/FfSma+PPk6ldKrf1N36tZ
	 h4tDkOVQXsVLF5+vWJFrBZ6aumoAVTAQIJ+0dhHgbyFftpsxAbJp/J5dAz4bNRYBbx
	 9cDRx5pJ6lRh7qyHPlLrve/9yQhR1BbPZkPLhLhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 349/627] RDMA/nldev: Check CAP_NET_RAW in user namespace for QP modify
Date: Tue, 12 Aug 2025 19:30:44 +0200
Message-ID: <20250812173432.562314636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 28ea058a2979f063d4b756c5d82d885fc16f5ca2 ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails. Due to this
when a process is running using Podman, it fails to modify
the QP.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: 0cadb4db79e1 ("RDMA/uverbs: Restrict usage of privileged QKEYs")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/099eb263622ccdd27014db7e02fec824a3307829.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c      | 2 +-
 drivers/infiniband/core/uverbs_cmd.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index a872643e8039..be6b2ef0ede4 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -255,7 +255,7 @@ EXPORT_SYMBOL(rdma_nl_put_driver_u64_hex);
 
 bool rdma_nl_get_privileged_qkey(void)
 {
-	return privileged_qkey || capable(CAP_NET_RAW);
+	return privileged_qkey;
 }
 EXPORT_SYMBOL(rdma_nl_get_privileged_qkey);
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4d96e4a678f3..0807e9a00008 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1877,7 +1877,8 @@ static int modify_qp(struct uverbs_attr_bundle *attrs,
 		attr->path_mig_state = cmd->base.path_mig_state;
 	if (cmd->base.attr_mask & IB_QP_QKEY) {
 		if (cmd->base.qkey & IB_QP_SET_QKEY &&
-		    !rdma_nl_get_privileged_qkey()) {
+		    !(rdma_nl_get_privileged_qkey() ||
+		      rdma_uattrs_has_raw_cap(attrs))) {
 			ret = -EPERM;
 			goto release_qp;
 		}
-- 
2.39.5



