Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B216328B517;
	Sat, 12 Sep 2026 08:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200375; cv=none; b=on4KuoSeEr5Raj7fMYSStNCNihjGIeWpldbmL9CD1BBuKZLOSUfru3DCvUjqkWsxTd5jCtxYzdoROrJDTUJD+C3pt/QSErfu0q8ObTnBzeqZdVUVOOeYyVZQhBWAR8/a3+GpFkYn14mNEViLz8241l5YuIPVEV4Q17wo8wFyw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200375; c=relaxed/simple;
	bh=Qat8FXmZ0Zu13zikBG7biI6cDF7XlPWpNmSuYLsErYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8S0NUjoG2xR9QRLz8AJOivLNL+sccgIyN1MXwEivlnEJOhY2JSTS9jJdiFw4u7L/fNiWxnEblirNyd6ACd6ZPPQZuNlbTO6nJDvHnKkyys7aMH0GQCvHLlX7zQ3ROhWX83WKEwMFkRv4dktJyiX3otGDvJc1f5e1F9Jvk8eqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fs55sygF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fs55sygF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E231F000FF;
	Sat, 12 Sep 2026 08:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200374;
	bh=dnlWjAmh/fVfAmCJYbCggjZkOzpEn9UuAcQFaTuUlZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fs55sygF+bDIVaB4tIytRMmtLbYqUPtYsut1D2xKL1aKiSlnBE18XB+v7r+F21Vmm
	 r7M93QZ9bkPkbkSGZ9jDP7+HSJHIWE499rCNQSXIZ3Pni7YaLWBJOmPk7nbHxvtbTl
	 cBVkKBuuz4sehJ1wn0gBOgi0eeeOlxGvImQ+uQ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0734/1815] RDMA/mlx5: Send cong param changes to the resolved port mdev
Date: Sat, 12 Sep 2026 08:41:24 +0200
Message-ID: <20260912065706.132591325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 033a79e308e4fe832b0924347eda8c4364055174 ]

mlx5_ib_set_cc_params() resolves the port-specific mlx5_core_dev via
mlx5_ib_get_native_port_mdev() but issued MLX5_CMD_OP_MODIFY_CONG_PARAMS
through dev->mdev. On an affiliated secondary RoCE port those pointers
refer to different devices, so a write to the secondary port's cc_params
debugfs file either altered the master port or failed with a master-side
command error, while the read path already used the resolved mdev and
returned the unchanged secondary value.

Issue the command to the resolved mdev, the same device whose capabilities
were checked when its debugfs directory was created. It is already
referenced by the get/put pair, so its lifetime is safe.

Fixes: 31578defe4eb ("RDMA/mlx5: Update mlx5_ib to use new cmd interface")
Link: https://patch.msgid.link/20260726-mlx5-ib-set-cc-params-applies-conges-v1-1-a253edafe1f3@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 113e5f5fc6fb2..42d005a5a7df4 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -361,7 +361,7 @@ static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u32 port_num,
 	MLX5_SET(field_select_r_roce_rp, field, field_select_r_roce_rp,
 		 attr_mask);
 
-	err = mlx5_cmd_exec_in(dev->mdev, modify_cong_params, in);
+	err = mlx5_cmd_exec_in(mdev, modify_cong_params, in);
 	kvfree(in);
 alloc_err:
 	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
-- 
2.53.0



