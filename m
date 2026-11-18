Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032375;
	b=ed7xopImOHdDEASy/oTT6hnGZWCKWcryKWNxwDHjnP1/LkLURlqHCmnu/1X6puYsWS/r
	 LX1fqNwcoF0TeJt7cnvAV6d1ygrv2VAYaeo5db8zk3a3AmscWdjEROGbSHAwWPsKYHNu2
	 xrtGZhGhJ73inPJmf8xjqSBgT4POa/o7NZOu8xf8/QRUvEApvfHAYbOYTP6yjX6RspVKR
	 FgYuRNr4oolpMjxFE4s3QF3Rfsz/HYbcg96Xlg5Ap6RoF2jwYAyQMpiaZcgEFQDZ8TaNS
	 /ceVeJcvDhNPe+70GFrRxzsK+WVVLIpdl5E8oFCCS8Me7XzpyfaO9jvuq5AQ3W0X1ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cVJt35H10d/O2qMT3tH9V3/btofu+UfEg7FCF+R73E4=;
	b=XIoDeuKyom+Pv15G6o+FIOIlzNBR1Q0URIVSFJd746htSJelc4Tq3zqaqtc32auqp5dp
	 Vsn1YuxEulikg1FjkAbffbwuOwXqu1Ze7mG4H8dJf5OynJiWjy4rZq0la1JwPKfNc5zXL
	 pxduxLPwsGqoesfkqaH7Pr4JfWaffhM8vi91uoxHlbWMYo0EJ+/cI8Ph7VmOMdBHoE7gn
	 WrVzcMFo5UN0HsuhwctpA0jmmgBKQc35EylaV3qQBLcbIbYc582YeDKcQdtLSNpt1l9p4
	 1bTzBVUZnYHxT72SQNqhHgLpIUVRcYSqVfJgI2aO4QY8/N9W22nqt/Iy0ZK0BqKYLKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbjpB+0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF94606A32C;
	Wed, 18 Nov 2026 20:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbjpB+0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C63F1F000C4;
	Wed, 18 Nov 2026 20:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032375;
	bh=cVJt35H10d/O2qMT3tH9V3/btofu+UfEg7FCF+R73E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbjpB+0KGJkHTSEZS3NooOoC+q7N9Cbo4jeujVW2JKsZGzGxmihfxIiPThNOd6YKy
	 CcuVMbUsae7h06Upnhprua3obncFT7KPgfJxOhdOJRiWATI1/LRbn74vpgADU3fSL8
	 Spnc89VOvIxJT1ItGS2dC/WarR6z54qfXqgkvzF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1390/1756] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Wed, 18 Nov 2026 15:58:37 +0100
Message-ID: <20261118150104.493129827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d6fd7db5cbbd7..28df0e8b8da8d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -954,7 +954,8 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
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



