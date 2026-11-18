Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056619;
	b=ygfnD3Vm4mCBfpZmXGNzfzxEkgn/GSftdknSx1iRJwt3dQX0rKZjO6m+J+OFzZSyqA/H
	 VK24Dm9a7ZpMpUF3AWo1ErkMi3QA5+Jkuu4IcRAugH0a3zheSk2RImZURhqMWYmMC60BP
	 9ikcPl0zEckik+GSeFp0r9km2Mrb2ThO03e2+m5eHNaFfUSvC0AJiGKEozXvNuUgIvm3P
	 ue20Eic8Khzoer5aZmoEpJi2Xh8n9hl2wUXTCMHZ0qhKxF4Tb4fIzQUmUqhlNJaraFhP1
	 bY57BwX5s3ohDrEkxETW4PxuIjLyPPzl79cttDpxzWQdQ7f5K59b7qJe1IKo52o89gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZXhJ9UdKJWI9Km44YUrBWzEkqZ9fIm6NU3V8+YRFwAc=;
	b=P0c6wjtrorV2/2vwHupfthGP3/EpPe5PoAYzrEsrDmEAaNYjddpgmSAv/0uDatsfuCCb
	 cdlVK/1ucx8jZ1m2Q6m7T6Dja4/Sp6VRbhdyE9PsoKV/+4xudnciqdGYOnOLAco5jaU/3
	 hNnt0O19QJtAbhRJA+f7Ne6ehIQW0xHHQm5Y9LZhMQyOBIE5OxtxC83ahvmt/HuwV8gQV
	 KROZjh5SPom40mgFJY3rz/swJ3wkyhmGokPP8EfcwQTFEfGfj4wsuU/Mbid2O0yG5/ole
	 nwhhl03OQxxM5EIoZlOESCF+36VxC25Vx/MNvCxEINarFkKlPPZ/K8xp6CcJI81wnXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBztsBPT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC96606A32A;
	Thu, 19 Nov 2026 02:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBztsBPT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BAD1F000C4;
	Thu, 19 Nov 2026 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056619;
	bh=ZXhJ9UdKJWI9Km44YUrBWzEkqZ9fIm6NU3V8+YRFwAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBztsBPTTwf4MzE7VRdvIAc9quKppYphkT4F/P5rr6Fpqth3ipgZqJ1yCfr7c5d2G
	 /vZk771xmBTZjEvWIM+EpRwHic3cBR3FCn/14aUmMLNW9ZdBAu05b13CsuhHvfINGJ
	 EAxZ1C93QB9pC+8fbUqotPMADzYSZMbO9P7T4TP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2035/2214] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Wed, 18 Nov 2026 16:01:51 +0100
Message-ID: <20261118150132.155116624@linuxfoundation.org>
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
index e18f1f211af05..c75055a616606 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -956,7 +956,8 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
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



