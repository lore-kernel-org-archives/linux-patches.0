Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061878;
	b=O1s6poVUGnnMwQjLTuxFM8pxstQeWnnTDQfI380Oq/1/wEuEjhAG7q76DRlOYb+zeJEe
	 lX9pN6kXbbm+IzYLf7L/pyy11RMoVc1mFvbjJL0z0mUh6V2pbchSNQNgfIdTapox/5WEo
	 4PAjnFBqaoIKUdSOD/oVEz+eS+Y1Gu9SQuchtfnLg6frclppnyEhVBtOuztq0jrqub403
	 zF+MH8GmHOjcS7lDXf7GJBb4QeF1oYVY0V4cMkYLfzm6CCVOpHt7pMn4gt3CP7PrIKkeF
	 WHEslNc2LJKzWIqnLUl5pr1V/Ei4FBniDU58sX3beS0HHK1x60z7fzM/nhbs20FvI0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IqBKmlGhybBn+Es4FDIrz7HxLnNDv56FdStGbJGoJcA=;
	b=BQQ1bX0zAsWO42OIYEm5+IV/hfeAP+b9Ho9HoNMNUII2zaNbwzNBAW0nJb6n0uwpREjZ
	 KPdPmjGFqN3ovViwT+PHkj+9jO9fR+zMutBXrYHHXa9MLavBZko5xH65xS4qtA+bY4ev2
	 jaajtOmUblDGvnEFxkddo00/zqT/oZQKzEJC4JoI9v4SkpTxmNJEkfZsKf3n8IfInqimO
	 +FMKhEkaSXF0pO8OobuAN+WzkuL1bPBUIX499w53aoZcaaKloARXe6/GzlCFx4ftPnYNE
	 sUQsie1kYRqj5w/nNKt6tjILi4wkFKamhz14282iMoVnTqYZWxC/MhwJkPPG+Vjgn8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IjS/JMAb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5177D606A333;
	Thu, 19 Nov 2026 04:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IjS/JMAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525821F000C4;
	Thu, 19 Nov 2026 04:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061877;
	bh=IqBKmlGhybBn+Es4FDIrz7HxLnNDv56FdStGbJGoJcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjS/JMAb0zDFB42nw2AHVym4U7a52IE9r67OXU9X9WB9UFVIgX5HXBXtpE1AKU8AQ
	 flLaILTGXsSO2lsv6+saqTV5bUiaRy8cCPLNh+vLB10AXSmY49XcXPD8hlBJ7pxQLC
	 8yH1p4QH7YncZOJVrWQvrr+bCbMyMtUKMO45vlmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1710/1848] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Wed, 18 Nov 2026 16:02:28 +0100
Message-ID: <20261118150031.279960149@linuxfoundation.org>
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
index 1fdaffd0b9880..38355f56c68c6 100644
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



