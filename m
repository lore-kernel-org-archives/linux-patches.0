Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040285;
	b=UuhreEMqiKVqHXtHYJtrQlL+Oc/F7H2CjG/7B9iqMxQPp0N5fBBlKQh7kThFVOlr21fa
	 3MmusR2zqR/9wGLC0PMYWlZKADWw5GseDkot+n4kEIWcRHD5mxbK6R49zD2+dDNDQQ0Lm
	 MCuvvnosnUqopusO+GqDlz2mnJxP7wGHHovL9lPra8OFGKx4DN/CvWXykc8OLfHYNcPp6
	 CkP5UxLDKdGBPDIRIOVG4Ftt9d+Da7vR68KtwndpTzGm8nld9Luy9eEV9/5N4wCgu0heb
	 v1lfbU+O64ishn0w/XR0d+c75i6NpsIIwrcmqveyiRZMpcGUGorxkE8NL0CV8qLVhPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xuys3eHX7czJpvG8CGa/Di4NQy1XunAjbhGwO3o36/Y=;
	b=p2kyBLnz5iitROCvkNUdxDZb6U6sbd1I7OlRc3/Ln7chKskYI2YiC9j64Hyt+XvYeFe0
	 rGCRJj37uyhWMOP1c6rNGaqajGelAPk02RAfdV5eUBsv0Kj6zszjxIQH1vKkf2TxkmUdX
	 9uskuAS8rcrZoxxYly6edVd1lm3lHYd6w2a0/pNr2Vnxrsa377RmrWO1PiimIovs/Xyte
	 jLdY/E823vS7iur7S6asU7kQAIINxhgQcjp7pxXU5a3E/TiOHXL2btix9s55CUWP3BQif
	 z2IvR/p152JoTbeTy+wZqd1WpaXko6cjCpYQ4s3ufXUroMLw6ZPt6sid6hNKHq4daeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gS2o1f6i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB76606A31C;
	Wed, 18 Nov 2026 22:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gS2o1f6i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE9C1F000C4;
	Wed, 18 Nov 2026 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040284;
	bh=xuys3eHX7czJpvG8CGa/Di4NQy1XunAjbhGwO3o36/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gS2o1f6iwnHKRWKHpIKVKruDg/37DdWCtdt00SKDkz0BnEeImtjuA4PQV1cn/uVj9
	 YeQGkXYAeIPK39FMXYEKjr7K5VxwkAjh0cl2lLaNd92lnc+1II4z3dRvCWl8yuK0yJ
	 Vhy9qXWRyPwYD5uGLSs9Bb8qPcmyasb61cMdrEI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2400/3318] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:50:22 +0100
Message-ID: <20261118150433.506796898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



