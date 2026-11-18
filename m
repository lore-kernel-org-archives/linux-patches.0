Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050146;
	b=u1AGQ6LSY6h8bqplgV4HLeqMh//o3/VS/xYnAy/gorA2puadyF2uEyz2Pm6fmR/9Lrlk
	 hO6OfMU/d3YxmjKAIj21FYvARVUbxC2ZRPH/V6ULwZMASzrarugPZBVnksTxkcHi0EXaD
	 PA0FYuSJMEcIni6cZXL4+HG0A+l876NltUDTlblErNk5/esxQcLbZfj54p/Oh15Scscsu
	 Fe9vS35ZTyy7Bll3DmE/ECi8g7QWjU8mH9NbtIF7BLz12v6xq+uCwTA6ibsQ4v5sSlcCu
	 HaJhwPKcX5KAK5NqtPfzCWhqeQBb2UtV3zrOuQDuD09AGt/xXw+hZ6/viB+lVcO1aVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/LBXBZRC1nKOJVog4rAjfvmxBpvJoEleAYmWsIPruNY=;
	b=PTSasv1ot6Ryrj+wVpK9ivsbICJ8V5bfoCBQNtCMimCc5WI+sq8npmv3RouzC2s+N/1v
	 SBtr1H+FWSYSaJPK9EvEuhtwMSKh3CD6I4K3XXUj6/CKEGjbZYYoahfV+WwHoKcziFuGd
	 T+Q1jI7C4xcaRGT4cBYi2W1hkVBmY+KFirdNIzG5jzgWm1e3nnilCrabXK3gu9/57bgYe
	 9KMe4j1RTJ9Fo6W4/AAfIbUI0h0jzVX7HUlidG0d0rykRs/YM0nT9etr3zoCS1gIeVsuv
	 nwHyQQpEvN1d1ea8sHkRyHHFvTcCbZb46wI5Cqfy0ksnbRs7EX2YdiGkDDKyUa0JaFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWUJctT0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9E606A31C;
	Thu, 19 Nov 2026 01:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWUJctT0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150831F000C4;
	Thu, 19 Nov 2026 01:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050146;
	bh=/LBXBZRC1nKOJVog4rAjfvmxBpvJoEleAYmWsIPruNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWUJctT09nK37P4y4iUrX+itvwktdHdpjS5ANjjnMrfH71LnMobCDId4QWeFg234P
	 pVje67Vb7sS3fyAwI5IsFYUTKzF5jnvhtD4mB5HW2tfviwxigU4YCCbtwElDj0E4k/
	 pakdg78NGmcUWAJRZ2ZD4Nk7/OAQxJ0uZmf9aPqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2604/2857] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Wed, 18 Nov 2026 16:00:38 +0100
Message-ID: <20261118150335.308885825@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d01ee4c84193196b6e4be4caf1ff8fdcc441ed96 ]

When an address-handle modification fails, the core replaces its source-GID
reference. The old address then loses the reference which keeps its source
entry alive.

Fixes: 1a1f460ff151 ("RDMA: Hold the sgid_attr inside the struct ib_ah/qp")
Link: https://patch.msgid.link/20261015-ib-core-fixes-v1-1-60f6da3ddec3@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 66abeaaaa5aa5..8dd752925f0e1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -951,7 +951,8 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 		ah->device->ops.modify_ah(ah, ah_attr) :
 		-EOPNOTSUPP;
 
-	ah->sgid_attr = rdma_update_sgid_attr(ah_attr, ah->sgid_attr);
+	if (!ret)
+		ah->sgid_attr = rdma_update_sgid_attr(ah_attr, ah->sgid_attr);
 	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
 	return ret;
 }
-- 
2.53.0



