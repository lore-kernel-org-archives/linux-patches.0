Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027327;
	b=lpBkc3X4YhbgxaXMSdjlnpLmkc3FZfCmI/LwFuH72BejVcaOMKBW9PjqGDFlhsj68Jk0
	 UUruZkzN8lzdekaOuE1HsHahGH7gXQ2kwIWPpu1l/yXtoNm9930HH++Po5JQl9QNL5PeP
	 ppvqo/q4XDHj65TkilVEJQTM4P7M468vcZg3s4aRYusOifx3rYuAzwoPXVWY/2/BlVbCk
	 4PYk2TCFyjelg/3ZIhgXlFa3p3F4PLNGfQNUGdH13HQ/tC+0XR/jfTlt/XnW6Or6CC/C+
	 OlEgT/A8oH3NaRwO4ROW587cnxm3bKEEmcXBP8e9yijS6A+YIPKLE4tpWNNRIYtRDnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XIzzJ8cETQ8OZv4GKODBu3dG8XV5BF/OQkRLR1hAArs=;
	b=N6qi1L31YMzwY7RNqJocD1Ifbg4BdIqAdWAGxcAroemWLZwulNB3r+W/d5TnYK2oYaZO
	 ftBrXLrQmGQKGeA3A/wisWVvrsAV/nWuyGryGXJymx5ITgicSkxPAFVYp27WQcf1YjUvB
	 vP2bZVlV+HC0yvW1gZvlB9MdRnVGKnHTvMy5/w3NANQKY44BhwZAwYj3usbg23/fSiGFu
	 Q38w3CiPX+FPkSXqYuz9QI2s+Q++P0fHxoDjBbo1l+naKVbpSJiA1CmnjgrLZsWWTh19y
	 HAxoDRrN2PENgljBXO9qRB//haA66EMUw6WOhBakKB6WWHsO/DHiqYTrZI2Ij89mByw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytbCKcpE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716E8606A33A;
	Wed, 18 Nov 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytbCKcpE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8FC1F000C4;
	Wed, 18 Nov 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027327;
	bh=XIzzJ8cETQ8OZv4GKODBu3dG8XV5BF/OQkRLR1hAArs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytbCKcpEbxf4SCoKEAYdj/7qygu2//+GByAf/7VqB+ADSoWi5j0Fjt7GZqlyJ/t19
	 T34pxrfeTCw4clKmW4J6FBXXWa+99jxeemgesVHH5bHN5we7kt2in3FpXqn1wQ0Bfe
	 dnmiJY2sygDxBXPzf0dPbLcfd1wSDrp2s+D725b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1751/2151] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Wed, 18 Nov 2026 15:58:06 +0100
Message-ID: <20261118150225.638925637@linuxfoundation.org>
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
index fcc21fb5fb86c..55bce9bb64323 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1005,7 +1005,8 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
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



