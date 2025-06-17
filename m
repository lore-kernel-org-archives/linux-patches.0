Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3F21E8332;
	Tue, 17 Jun 2025 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174362; cv=none; b=GCm+ykah7loh6iS1WgCAgVrAVUW7rgccFUPfAMZb4yUsCldcPpcsr8uN04Z2wR/9korh7OjwAG6iyb8HRyxwNLw4plOoiQ6ri2FOYq26Kwexenxlssy7j0sOIUyAFqel9aIN2N9TtkeW6AIEFSo+QaZpl77SauLZYqwhEPvAS64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174362; c=relaxed/simple;
	bh=+xS33DYqv7Vk6yJEiksJpzyHMM/NxW9UP+o9D5X2p7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyM7LUQ4fyVg8wb7IazIK+yMWQUntd/+X/dnj/iGZ5JKfp5QaM0RsZEJPXgLI1QjbLGBCMWmoTpNfKr9vfZb61o7EMJeMR/mgOj9F7oOW9UziwmZGmcAROyCYz6hBB09kh3EOC013w94k0nd2ee7JGQgMWdeqNd3Oztned/ZMyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhOvcLmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhOvcLmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C1EC4CEE3;
	Tue, 17 Jun 2025 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174361;
	bh=+xS33DYqv7Vk6yJEiksJpzyHMM/NxW9UP+o9D5X2p7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhOvcLmdXgK4oUwZSzYVSdY0DacJWQpeISEVPLV5X0Q+4NxnTlseE2KghwTVkqIt5
	 glit8pzXOfG8LHrfMfAOfbjwyFYK7RKSAKQuEDQvfSgHard6f+V2sqfQLwZE5q4swe
	 YerLC45NEY1SxkNmBVG6FsbQqu18JXUJ5ozidDRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/356] crypto: marvell/cesa - Handle zero-length skcipher requests
Date: Tue, 17 Jun 2025 17:22:24 +0200
Message-ID: <20250617152339.406156437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 8a4e047c6cc07676f637608a9dd675349b5de0a7 ]

Do not access random memory for zero-length skcipher requests.
Just return 0.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/cipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 0f37dfd42d850..3876e3ce822f4 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -459,6 +459,9 @@ static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
 	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
 	struct mv_cesa_engine *engine;
 
+	if (!req->cryptlen)
+		return 0;
+
 	ret = mv_cesa_skcipher_req_init(req, tmpl);
 	if (ret)
 		return ret;
-- 
2.39.5



