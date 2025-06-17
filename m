Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524F22ECD22;
	Tue, 17 Jun 2025 15:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174365; cv=none; b=IIrvLJh7VD2/oQX/LJLgvaOG9Hld4/TDjoGFjPInoFPnYTE4nI1R5Sk5qCAujLK4mZfh1FiTscjND7ddWnpnamsWQhNrS3fhPGTYvMJ/t6GM82eOy5qksCsaAdjuPHRyaow2COlOhx71ctnExDTSEP1TuHC9yt+5p5N9/pSPjkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174365; c=relaxed/simple;
	bh=YnXOZEi1NRAfYW65NCJSjer0GL7ohd3lc/1n1HLEfjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivNDgWphK7RUeLLUXHJpGG6qt554z72RJpHwHVk2xF80dfJ8FcmT+SRArAOt8ArHMkbwGsnzK3LBhh7sY/P2YIFbcb/TnbVy7PmjsYZ+7tZ9YWPoMuCQ72w/F9j3xNXiklQ8o1kSzlojs42GbFb0JLInLoA1OUsHsSYOe7aUGWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9DT1M/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9DT1M/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCD4C4CEE3;
	Tue, 17 Jun 2025 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174364;
	bh=YnXOZEi1NRAfYW65NCJSjer0GL7ohd3lc/1n1HLEfjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9DT1M/RFhOMtMNkEWIZLgB6kUlJNyDxKRFRmgxn4i56UmSB/+Ls7soCjU4/+b1W2
	 xAyt5xGXtof01L3bOiJ7/CaIosBB5uxkxMVHS3wgksCVRNC7al1KfK1OivZZ1aWeY3
	 Jd+wyPUmJBumgIQE40xDwjXMrSRv7QAcuh2vaJ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/356] crypto: marvell/cesa - Avoid empty transfer descriptor
Date: Tue, 17 Jun 2025 17:22:25 +0200
Message-ID: <20250617152339.443286377@linuxfoundation.org>
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
index f150861ceaf69..6815eddc90681 100644
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



