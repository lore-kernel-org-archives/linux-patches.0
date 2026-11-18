Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026258;
	b=hACDg48NF8hY0Ivo17DoQf+xs8mew7XTakv3o6I3BGul/Sy/HOB800eAVIswP1mjzQGw
	 4wJLRuIlX7p9vTl8RVL5IKhZhpI18BMkPEmYvZSa5pnGR7tenunPp8442w314/yW/HcmK
	 YScqVH8M88jvIHxtKFORjpoC8FJBH2hbyzf1Rki0oeMdqNaWbyJigIyJilxzTUIpwhScD
	 LQ4TCdHpugmRowbH8kQF4ZonrEsSCb1au97d7alOgo6AKT1vR464OxbPR/xcSUwSRyGLZ
	 mBAbNrCB81LqmZIW3H9pFCWmPnA6wnxEpXtUWp5zAZWsVUjr8kRlKvIrFHCBXMr9POg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4gj2PkhfZ1zd1J14bq6kerHbEa/ezc+5F/lHflHmk4=;
	b=oK65Oi+I4wqYmrymS2KOR2jHoLV8umwstaWQi1adTAet/K2MBeDGmIgZWEmjeLNBIrCx
	 JP/juxJoWIZlcDMGeOlKYXBZXUuHz9Je2iqRyl8HtxWODtQZobCrNddYU/2/fy5dxEiTf
	 MoUFytiFQJcgXj3rgArKoS7PRAAgfXvbFFJPXNWkrgxvfBdHmBVhygH9HoWkWNeExr1Ab
	 eYYC8dTfTFXZAc0dq4Z0yr2IXbvOQyaV9wOgAouKzFSeZw/3w06x7Gv8SU5YPlaqlxxEW
	 p3JprG26k9zCynEXocJZ2+aIxEPR6phTJ47jkQNzr5sC4H9XgGMDqhqhx/QYmyvJIvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w1N/++EO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9401606A32C;
	Wed, 18 Nov 2026 18:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1N/++EO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEE11F000C4;
	Wed, 18 Nov 2026 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026257;
	bh=L4gj2PkhfZ1zd1J14bq6kerHbEa/ezc+5F/lHflHmk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1N/++EOkMoSptvvtMAbZ9XJjvQx8WTYsvN4KdtLpfeY71w3+sTgrEVChr3xTrcxi
	 NWhB9t2W4f5GT/EhVHARAdc1ptgMTL6MseVGNg2YsaWhoWVStdA2+xidRGblJFA0W9
	 BUk9/CSHOESz82w1b9ij9a0Eu0Skv6ezXw/bJ6rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1334/2151] RDMA/mlx5: Cancel software CQ notifications before teardown
Date: Wed, 18 Nov 2026 15:51:09 +0100
Message-ID: <20261118150210.657427530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit a0ab2bb269e7fd8523f87950b91a42a36c7f8f2a ]

GSI completions queue notify_work to invoke the CQ completion handler.
CQ destruction drains hardware events and core polling, but does not
cancel this software notifier.

Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20261008141209.6923-1-prathameshdeshpande7@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index c6590dde68332..4f25aa8c72fd6 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1064,6 +1064,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
+	if (!cq->uobject)
+		cancel_work_sync(&mcq->notify_work);
+
 	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 }
 
-- 
2.53.0



