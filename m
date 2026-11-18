Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055515;
	b=mT+oR1fOg0O3nyBItkcqUgH2lLhrQUSDZyXh/KpYqNreyZEfiyB0OjzdkbgaXXhqnm6F
	 MaCH5aMkmrzf9a4i4piBg2CAkf8LKbJEYjEKsQAs3N435F5OIp/pYDBrQnZoN71DNJwYd
	 LZcr+Mn7DK6RojBSw9dHXay8vRW0K7jNDSs42IwfbjSUp8AvfZFQcQafdjrYBX4BLeF73
	 kHqID27SQ6C5huVyeCSgJj4CvFQHa9qJxUNUpyrSNNY7cusXp3GnUvZcLdYwEy3nDoVHM
	 ZkB4ZyYXdyxLp4ZMB/LpE/fHbn8IIJ/SNUIGq3/tBeV+/GxdfRFJSOuvfCE6OM+M3yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xK2YBq53Vmt33w3HE/Zx8ljM1n2i8h6WsimJsBVK5gQ=;
	b=eTyHbRfXORFL8cefMzcEXWZpT/46f/jaEv+cyHBftffyE4TczBSPyhsld5kluwdWbo0t
	 2LNwIfFTfJGOrWWU2uYrx61O9LZVXEMqRanAUK9SBNlPu0mHVNGRY+TI3Eb1XrBm9yrfw
	 nCDmsmlmOl9kL5jGmH+VNAH417IwUb5U+GI6x7c4fb2q04B08duKJ2eKCmXnvu4C4N6jc
	 jnue5abTwe3H4zqWmiNxnlnQmobzRurmaYJD8H7SAO7OvMtZsF9HMvC1e9+/XkoEfiEOM
	 MD1ccdC7glxD278XIoYORCTUmZnKM/sDGa7miM3vy7K2KCaytBnAg2RNxQrUB8Aq1Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ej5q9kbp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABADB606A31C;
	Thu, 19 Nov 2026 02:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ej5q9kbp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E47A1F000C4;
	Thu, 19 Nov 2026 02:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055515;
	bh=xK2YBq53Vmt33w3HE/Zx8ljM1n2i8h6WsimJsBVK5gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ej5q9kbp5rEMoXsq66KXih9aFhKnBlknSXovMDq/BamcT9QaDA7PLCmLBE2vXE4XN
	 gc4lfUmxTn9yWSO//+utDKtt+7/qR3Uh1nuOCU1JNvveAjWjCoOlYchrtg/v0EhC9x
	 EprRtKPd+JOqrsiZqejfiwCHzrX8aooXZiOJe4Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1659/2214] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Wed, 18 Nov 2026 15:55:35 +0100
Message-ID: <20261118150118.240808481@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9728effe43d8fc4d58e12b697d0d6127355abdd5 ]

In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
so set_pi_umr_wr can read it during this call. The pointer is never
restored, so after the function returns mr->pi_mr dangles at a freed stack
frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
remapping reads the stale pointer and dereferences it.

Save the original pi_mr (captured at function entry) and restore it on
the out path.

Fixes: 2563e2f30acb ("RDMA/mlx5: Use PA mapping for PI handover")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260919100848.2442-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/wr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index b81d282fb0d52..2fd943f541549 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -1149,6 +1149,7 @@ static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 
 out:
+	mr->pi_mr = pi_mr;
 	return err;
 }
 
-- 
2.53.0



