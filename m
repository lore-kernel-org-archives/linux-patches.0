Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048685;
	b=B5padTwwUAyhFWjvsVPPndwmS2I8TWN3Idv6k3SJQxmrUg3ISLFie8+IIeWJj0HF3R3+
	 zMJ05gN7FbAp+n+11l7zIB1+2wx57LQD6YfcvovSSedM7BJ3xJ6eYbd19M2zVbi0Vrz/C
	 B79P0fyVnZOWTnj+Zr3m1xzPUlWzKjpTkXT9qXKQPRDZAKYUVY8upH1BH2S2Jk+V7bwOB
	 tpyalRrpU+PMSkLPfhbnt9XxtT6OLrSgCsHsdhFazAQOPtCLOzYj9bOiJTaQJEwTAQ9ev
	 dcr/214NvlH4EjXxEsggF2IFoiTCEY9iS6bjhXivBgjlPX0fI7bY+z2YTdpshqlR+Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dnvAos0m1tBPDhKcyQ3Z03v8+QW9E1VLcJYgraERi8w=;
	b=1dVijg1aZWKBIFkKysxxc1/5YfcfklUdkNHjEfR82NAtuPbJdINnrfdzdxE3TyUWnGf6
	 JZQIo+E6mdiX+7D5vtbrVPb9jRkkfgtJAJQ11mj6Xb2fn6qFEx2mZMjGKooXncs4W+ewO
	 t5sdWL4+ImUDl+kzQBp4wKVzeNl8o1FJUpA5rvdk69U+vv8/jjB8T8aDDDm5DI2PWW3Eh
	 rG9DwuhqRwUma7LiJqlz0xBrLZKCREoxkB/K/bil2YoOkzO58qcf+kAXQi/5+uevI8uSu
	 4lC+JSy21eu3Hd5OdAi0s0URrK1zHqpXQzg3rNy1w6CBeFptVEIfvhyJIkk+NATj+QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvGpxudf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABD9606A31C;
	Thu, 19 Nov 2026 00:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvGpxudf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF181F000C4;
	Thu, 19 Nov 2026 00:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048685;
	bh=dnvAos0m1tBPDhKcyQ3Z03v8+QW9E1VLcJYgraERi8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvGpxudfIkok18Kuxc/Jvj6Ai/8LzyATCQYaEoGRtZJmUHxSeD7+NTTq0abgaeQ1l
	 J2Cz8mvS/72QzRgo+XR/CkKfb3zZscQWRXukAXJz+SAq/4Aj7CR10gC1oiRmMSqRqi
	 5hY0YevGlXuuial0JyQeCmS/Dkf/nDKxZSdbLigQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2084/2857] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:51:58 +0100
Message-ID: <20261118150316.444895159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c72bbf21f1aeb..7d79273b39cd5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -206,6 +206,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
 	buf_attr.region[0].hopnum = hr_dev->caps.cqe_hop_num;
 	buf_attr.region_count = 1;
+	buf_attr.user_access = IB_ACCESS_LOCAL_WRITE;
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + PAGE_SHIFT,
-- 
2.53.0



