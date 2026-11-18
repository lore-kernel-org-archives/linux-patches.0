Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020957;
	b=Ll8zZ0iITTUPnMtRJwRmdeMJMj9od6+CHoT4zOuVZ5BNFnagKPSCCnFleQmnRCFXLNzl
	 sdPCmt+LEVPmWY9NQTr9RfFouRR7D688aYu9euApoVbg6WXxcxSbnUV668aXNIYMZ806z
	 TKDd6Zr4SOyuZzo1ES5ePrbzGFvAHbCXO1ui40B48Kqb7GWatsxTvVdMv8BX28zLIIKhO
	 +qlEnX223H7Us9SExfamVvnrYptBzCMtdmw4lbMxvuj86z3KwDBHs9ERjyjiEdyLLzza5
	 lGTaxf2pGMS0EBhAzaM/r4EJVoVM1ZPaeBPEpZmbk/1PUKFzxAiOvWaoQdyAdlr+R1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IoXlRrvnhRd0GOj4a3e7DFWFQmU8wDHz9MuH9TSovaU=;
	b=rddG3AN0zVaQcH2DwkxWdPqRlyQEQA4UCIS5fKJgikO3GtuDLZnMhaDbMBRNRuWlq4BD
	 C/84W5bQbH3sGC/FwcpVtcodUw5ozU38lS3BIdOYJkLA/PXGm95INJGt9cHFYqswCnsFJ
	 q2mvNgYJuBf1WxX9m37rK/M4aKVWGKjy74dLOmAE0fALrLbp6jqthENq4ixnc9nGMe2nV
	 mvnuU/MDu32BybXa8ov5qL6Ls4tyj3SMPFpD8AVAOkkVNBgV7340SNWdnC4yF87K3JEaM
	 ICdW/F7GA7G6u3AwYbQ2zfq7GKm8cAVAhhuzxWVg+pyN5cvV1EVFlN8dU/xeh1Pu0Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GrMJOGY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC8606A320;
	Wed, 18 Nov 2026 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GrMJOGY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B401F000C4;
	Wed, 18 Nov 2026 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020956;
	bh=IoXlRrvnhRd0GOj4a3e7DFWFQmU8wDHz9MuH9TSovaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GrMJOGYlly0TcirRZ0PsxN3zctVwjJQkfAAe9fAqtpzOGsxb+Flrr6DABRW4udt5
	 ILw5PCb9MWZ+j+HNvQmtsDXCait2AsMbSdlt+co0QusRfy3d+gUUDZbSRytPstRrcl
	 sIjnMT4ezlY7u+5zZWU/Z2MOIBGu4rkFJRvUou+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2135/2651] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Wed, 18 Nov 2026 15:56:15 +0100
Message-ID: <20261118150402.747628799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 308c7fdf486ef..5dea57778b1a0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1011,7 +1011,8 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
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



