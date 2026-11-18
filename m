Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061064;
	b=nkO+Z6HaaPZZjFcvcqpTMcDwTVUI9SLU8WfLygC4GNsksOzTFxGrApqA7kD0ks7/h3jm
	 RXZxeUZZmXh+ro3X2QMSIemYsW6LXSVvtArpWCwamP4/bFVT1K1L2n+93F8QFwywH5jXS
	 XexDAf2zGiZcpzgeW/wgk5l3Lz+oMofL8YFA0PSCOTHfop3lpoq9EvqIkRBNtpCTRzdtc
	 88L6voORtYppjQBKxPw/KM/n14YgXnRd4aFVrECaUeInjnUuyXtGrQmp2SIc4bemD1w0h
	 0CQygM7ylII7oLW6worWg80CaxKe3gfNhfioBHxKEomvOglkv7QTWmqN89UUcd/yHtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IHTe8yV9oLCBGTCZsKI5JIuWYG+zX6jekDNgcg8jtEU=;
	b=hXykNyMT2k0BOxpafHsL07O/KjCaciPDR2JNtutVng9Qj//sWAaGQRENduRYtNLSTv22
	 D7h7P/fYw6T45lYoyRHRJocKMHH4EQ9uGMuaDZEmu5VjIcNw0dXainjrXAGxuLLw8rraq
	 P+gkJ1PeiuyOyYEZHTUU1HFNocNUuc8aKFwVMFz+d1bayyQbmY+PDJMwdWx5J8i12Dkrg
	 CBSnDFueePOZ6L4luvPJb3IygETmGq7zxsEFzdPN+yFPqJ1avN0X4gMx62/Rxyjy8bdTO
	 JupCegJSC5CNUksW8U4mImgiXVpK4FFQXI/dfRGNiwtBZGcObficTDdspALBhxmdU9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRhXn1d0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318EF606A325;
	Thu, 19 Nov 2026 04:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRhXn1d0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346D61F000C5;
	Thu, 19 Nov 2026 04:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061063;
	bh=IHTe8yV9oLCBGTCZsKI5JIuWYG+zX6jekDNgcg8jtEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRhXn1d07nhcQ6n3IytVQMaGvAmQ8uFtDrfvH0xYYj4dJvsPc7hfRJur5/knqWADv
	 i6hkzteuxDU8V6+KOvy5eIPEDEBkq0S9VlbREJBIf0jC5AJL7GzvbIVT0lKLaOKwpe
	 bb7bla85PT9lM601iPc9yzORsJYm0hjFcEkw1afk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1378/1848] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:56:56 +0100
Message-ID: <20261118150017.192541015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 88ea5ba47f914..e2613fd078822 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -153,6 +153,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
 	buf_attr.region[0].hopnum = hr_dev->caps.cqe_hop_num;
 	buf_attr.region_count = 1;
+	buf_attr.user_access = IB_ACCESS_LOCAL_WRITE;
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + HNS_HW_PAGE_SHIFT,
-- 
2.53.0



