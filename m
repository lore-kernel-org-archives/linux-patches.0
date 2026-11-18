Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042047;
	b=KjOtaCvaY/5oPoVhiLjuU8MyUZz7I5v2EkaPV47EdJ5uklN7rtwhSU7KbKqqxkaUhq3a
	 h54kiMaiGs/+4bXbw7oPU7BlaHlV8ADfsSdCdBAN56qqaXCClh0LjlEkmaummHvaWTd4w
	 VrOuL7WVWks03t1llJiAZjAz4iNEJ+3QH582svanoNpzwn8sxnUEk8jYj4mcS02ZyNErU
	 3AaoUNm8KAk3+FJjgBzgzfLPwRUrcWSEpaLkoTSNYSrp5lVOrGxKj2FB63gczFkOuZPbd
	 +RzR6xtz1W1dPleA3DW+Lo1cHTgCYJQlqFlAj9WWYl0sjIjXVrTuMmy6m+Oeqppxddg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WM1ENrQMrSPtmY9eWgjKghtnGSnUwj06uVkE/qms2Q8=;
	b=Gmbie4FbYQD1dwoTziuhT0ZyWaLrqGuINVZZaOFLbj727RLZDfVzofXq2p7G2JXZyG9O
	 /wjtt42yjGkUxMGAcqusVmeP+U6LaSdHUl22humnUBPy1dxQQCrWSQpKFvtk4BqJvn9v1
	 q3jUBZEZ4OuQhc1AVwNp+zKzncK6+mke2BNQTejH03M0fKdpbE/D7KJ3y4cnreqtOEB2l
	 rPRA9jkHWgq3u7/zq0le1dLNLoxFge1SqENnXLCo2FhBT3/0cXDWSBzWYkSipf6YCg54j
	 IV6ynoOpJil5KhVOa6wlBUftWzVStEybmdmn3lfkiZqg0+vgZh5mI5wQUlArNdGVG3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ye7Jn5g8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE2B606A32A;
	Wed, 18 Nov 2026 22:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ye7Jn5g8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818C11F000C4;
	Wed, 18 Nov 2026 22:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042047;
	bh=WM1ENrQMrSPtmY9eWgjKghtnGSnUwj06uVkE/qms2Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ye7Jn5g8rzxtlZb/6nhgXjM/DGk6Mx4UEtgs4APZnnPzSTB/QRzFjpUO+HQT0IzDW
	 LBt6EgzeR2dmJFUELVbcRrqYg8wMmOtq0SOyXY9+4Cc2ySN3odmoHG5XJK4MwhIoLb
	 EjI0blmi68ePMMKeBsmcIg8gpW3ijey8tTK/6lts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3024/3318] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Wed, 18 Nov 2026 16:00:46 +0100
Message-ID: <20261118150450.922774556@linuxfoundation.org>
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
index 55d985441a3c6..74ff967f1a589 100644
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



