Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1CF4C6E;
	Mon, 23 Jun 2025 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685641; cv=none; b=lyDljd/qi3u1fODgXfkQKoo6/bR/NrL40zAmeqg2WhBExY21Ey7OInC0GZgS/BBGaWRAUU2R2dljo2kMFOuMh8hfIi1bo/2biUIfNCoO+E2/Kq+JV6063+iYTfMr8xsO0csmnrWmVJ4zwanto/zs/LOg0XFA/Uy3xMZX1zdjdZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685641; c=relaxed/simple;
	bh=FQ6TIVdnJzKxThFi6WdyYOSfh23/tSGGL71k0i65op4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+eRhzmrivDjxSzHHPcBc8W9rO6rVU+HmRBzJMkCZrLNdLycnXKze/kIVPTnreDahJ91VV0llDMl17Qst7U6GWLQX4GZ8NKyW0MpwtTZHysFVzEQ0ogVtz2/21pOyTKIzIR6fzPah7XcvBHhDw0Ibk6wm2AEzxL5s22F9XF1JIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z50EqDdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z50EqDdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F00AC4CEEA;
	Mon, 23 Jun 2025 13:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685641;
	bh=FQ6TIVdnJzKxThFi6WdyYOSfh23/tSGGL71k0i65op4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z50EqDdg0/mlxSER7SAgZn2LxE3DRvc2YiwpXjEUDDGxENvaJtMluDVaWOI6Ladmw
	 oJYAF+XXRolIhGuqTZLCf+FdzvqCkN/nVrlz/NlbW3peMvXRM4IJ0b9i8UhSyYggTB
	 SfmDgSGkeI/+5UusW0MwFIdFLax01Bt5G1p8awTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/508] crypto: marvell/cesa - Avoid empty transfer descriptor
Date: Mon, 23 Jun 2025 15:01:06 +0200
Message-ID: <20250623130645.773269414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1bafd82d9a40cf09c6c40f1c09cc35b7050b1a9f ]

The user may set req->src even if req->nbytes == 0.  If there
is no data to hash from req->src, do not generate an empty TDMA
descriptor.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 84c1065092796..72b0f863dee07 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -663,7 +663,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (ret)
 		goto err_free_tdma;
 
-	if (iter.src.sg) {
+	if (iter.base.len > iter.src.op_offset) {
 		/*
 		 * Add all the new data, inserting an operation block and
 		 * launch command between each full SRAM block-worth of
-- 
2.39.5



