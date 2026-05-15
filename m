Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419243C9896;
	Fri, 15 May 2026 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861309; cv=none; b=FVebDFRBQv6yeMuAagXW6z9DQbQkX3oWnfsFepcfcaCEA1r6zXBPKHeJ9TSitUacLLiAYtfUCC8HiawXhHLkKX5Agkv2NPkI/IVQnGV12aa+joHTFG82YuuA2n0JYL6ncsoyAOaUmNf8+eG0wjRLP73S+b/YAmmV49pBWuni8Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861309; c=relaxed/simple;
	bh=JSWdLCsp+3Z3mvVIuYtIAES+Tv1tMcVJdWlcXm5RDL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF41OS7QA+EJt6zK3ZnCEUB6ZU6byqrzkPj661aPvhIEQoo0azR9LRg1pmMQwqEGDRUtmQnlAqy9jLxDkBkA7kicR4fy5Edn6jU1GJkGRj3ZQLU3KOXB3EMPs3AYft4cNQkLMjGbLK/ITZG9J1OegbnRMzvkZknDadu8Zkglqls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfTeDzHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfTeDzHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC69FC2BCB0;
	Fri, 15 May 2026 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861309;
	bh=JSWdLCsp+3Z3mvVIuYtIAES+Tv1tMcVJdWlcXm5RDL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfTeDzHOCyrpxWZnXHaJbnI1f76ry1bUoSX3bfdMscGtdf5JT8AI93YG+RxQUdtn0
	 NkK99gDgquQm0ViVsDdgY5MhA7Qdq2/WxYhHAMK1vh+en1MogmiUaMAq1viTJYK6yQ
	 /Lg4p9411oLcztD4mKNtd9qSefqUfHQMEI6/Q5v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 278/474] RDMA/mlx5: Fix error path fall-through in mlx5_ib_dev_res_srq_init()
Date: Fri, 15 May 2026 17:46:27 +0200
Message-ID: <20260515154721.016349678@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit c488df06bd552bb8b6e14fa0cfd5ad986c6e9525 upstream.

mlx5_ib_dev_res_srq_init() allocates two SRQs, s0 and s1. When
ib_create_srq() fails for s1, the error branch destroys s0 but falls
through and unconditionally assigns the freed s0 and the ERR_PTR s1 to
devr->s0 and devr->s1.

This leads to several problems: the lock-free fast path checks
"if (devr->s1) return 0;" and treats the ERR_PTR as already initialised;
users in mlx5_ib_create_qp() dereference the freed SRQ or ERR_PTR via
to_msrq(devr->s0)->msrq.srqn; and mlx5_ib_dev_res_cleanup() dereferences
the ERR_PTR and double-frees s0 on teardown.

Fix by adding the same `goto unlock` in the s1 failure path.

Cc: stable@vger.kernel.org
Fixes: 5895e70f2e6e ("IB/mlx5: Allocate resources just before first QP/SRQ is created")
Link: https://patch.msgid.link/r/SYBPR01MB7881E1E0970268BD69C0BA75AF2B2@SYBPR01MB7881.ausprd01.prod.outlook.com
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2924,6 +2924,7 @@ int mlx5_ib_dev_res_srq_init(struct mlx5
 		ret = PTR_ERR(s1);
 		mlx5_ib_err(dev, "Couldn't create SRQ 1 for res init, err=%d\n", ret);
 		ib_destroy_srq(s0);
+		goto unlock;
 	}
 
 	devr->s0 = s0;


