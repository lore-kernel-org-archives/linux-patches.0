Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055440;
	b=ksun9F7kBuc/xG1vcN8voshg8OVmwZU6YCR4MT8icRz+VWtLQPPePjt+bDO/eIl6pPgk
	 Mcg3AZIk8H2JaX5KIKwzyzcXsCUmRZdAee9kfr7MbjEkdikLl37AKHHq27q/AnthmVAVo
	 zr3Xd/2Z4rWiIN56X8caGlGoMhMYyUlDq2v3RawqtDhLyqV86TCz2usgD5j8IsVyJV4Yw
	 YHTrmWV6fgqL2M+GxykUjOCndTlVdM8dKHmaxzbt1nGnZT+QnMF2bQ1N5JFS7lI3ojlE/
	 Sj3Pfc5NXRnzrlwmVmMXI+5AifsjhJTG0bjFXcTzAP0VxZo0sAbsdJ0wR2AfS4pp9kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3Nxg8a89cPT1dTu/mx3Wlq2UF2r2nuJVgB2ZwdE2Dk=;
	b=tGj+DxfCBQNzONQm2BF3m9HhUNCgFEorXSkJVdtHzRPRn3KESFZFnVkSrL1U1uwsF5PT
	 o+Yy83dKSgPetspjNzC+lk/zlLR7ZHpqJLdwhPOA0fCFfOMAPGe110TWAHSYAGdjSR9jq
	 fl0DwFziwwtShcj03R3p2y4k1IZoXcDP1HEU5Q6kaXbvZeZCFoCBrRNfhvxTvPqraLl+F
	 5t3lbQI7iUYjZ70aPoC0uRYY52esJovGkh0SjfosC670p66Wt8IFLJppJn2T+1lqqw2d8
	 DNiO2Fofd/voX3S2dxvr8sRWa5BXjQXI3R7WSHq67taCMNWZxr2CEh7Cby5Itpfrr+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1llhNxb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCB0606A31C;
	Thu, 19 Nov 2026 02:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1llhNxb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13E01F000C5;
	Thu, 19 Nov 2026 02:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055440;
	bh=X3Nxg8a89cPT1dTu/mx3Wlq2UF2r2nuJVgB2ZwdE2Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1llhNxb9rnIw16z7by4EBdJqAgFZnXbIA3omBNjLzyc0zo1QqIPNyDFtK9Tfgq9D
	 e8TCN607aAPok7XDL+BpLEnxqdLEmy/F2q9gXJEGujo0YF+petjM9iJC/2kuNty5KG
	 Y+WJP/brWecXxDZ3X3aWDkP3ZGdkU+lS6J0Af1pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1631/2214] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:55:07 +0100
Message-ID: <20261118150117.202085210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit ce29f6e741844a78ad1977f2a550ede27ecf95f8 ]

alloc_cq_buf() leaves user_access zero-initialized, but the device
writes CQEs into the CQ buffer. Set IB_ACCESS_LOCAL_WRITE so the buffer
is pinned writable, matching the device's write access.

Fixes: 744b7bdfa79e ("RDMA/hns: Support 0 hop addressing for CQE buffer")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-3-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 5ecd4075de937..85a84a2690644 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -205,6 +205,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
 	buf_attr.region[0].hopnum = hr_dev->caps.cqe_hop_num;
 	buf_attr.region_count = 1;
+	buf_attr.user_access = IB_ACCESS_LOCAL_WRITE;
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + PAGE_SHIFT,
-- 
2.53.0



