Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C773EDE59;
	Tue, 12 May 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608752; cv=none; b=opd0QwKGChrx/18kc8yL1/9VQLNNuhvAvYcWR/XSoKGUp4Um3tmHzQewIkQLarJCrAe+fxBs7cKIz0cm2NGXpuB88vcvLUv7eIQ+1xnUdpqktbs7bYEphf4XMzaLuCjgF0tOHYrkCXlK4axeWvyNBHq8iSIUWDWYcmo5nchPSdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608752; c=relaxed/simple;
	bh=5IFhBkROWsFpgkkAaJvnHASgROBlb4hqrUZh/5xWb6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhBsmyFvAVX90DoALBvIwPhiFUAfTC7KMFzRHrugzCBaaZohOAHoD8poblNfPT21guagI1Vg9QPFnW9HU+dNyLgNAZMAnbn80RfMnS3Imobvdmx+41g1L0I/Kgd11cMBEUMqEKEY0qecwurKwgic4BvaaJ2ss2/Qn6GSQHz59qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oARgHzjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oARgHzjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198A7C2BCB0;
	Tue, 12 May 2026 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608752;
	bh=5IFhBkROWsFpgkkAaJvnHASgROBlb4hqrUZh/5xWb6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oARgHzjEiMc02YiLEaOnftlP9py0Qg7YyzP+aoMeHWS0djFqZXiJ1zhY0MH2nSHOw
	 4n5+P9n/REEynbJDE99d9C54q7Sntp7q0R4puk9j6EGY6DShr4zaIAMY74FHlNKe7W
	 sfc6KEISvdQNHMFBtbWdUSf2sHvMtczi+X2yOliY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 200/270] RDMA/mlx5: Fix error path fall-through in mlx5_ib_dev_res_srq_init()
Date: Tue, 12 May 2026 19:40:01 +0200
Message-ID: <20260512173942.660103387@linuxfoundation.org>
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
@@ -3181,6 +3181,7 @@ int mlx5_ib_dev_res_srq_init(struct mlx5
 			    "Couldn't create SRQ 1 for res init, err=%pe\n",
 			    s1);
 		ib_destroy_srq(s0);
+		goto unlock;
 	}
 
 	devr->s0 = s0;


