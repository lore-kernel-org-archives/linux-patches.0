Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1652BC8E6;
	Mon, 22 Sep 2025 19:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569599; cv=none; b=il/n999RUtEOM9lNfL+s/SVof2T3rKorXonAJ/LlkVIfSawsS+aFLz/p93mHcci7gHv83WOGTTLhaqHHCQP1DRo97JI2a3wLY4YWLM+IFSfMYlYpgdHsXAPAzf6fOflO7/W9W9/9079Q1lohQg96foytjqLlHldCEKJJM/IO4jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569599; c=relaxed/simple;
	bh=luTmsAIj9CP/8Q+emcvxAmejTatbDed6ZKRLGVcxF4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFOTgm1r9pbw+X8QuT9F8sxjbHeZgrJ27QQA6QL07mtkXyPDJEuC9ErdTUiiccgeEmxVYVPQH0lIPd1PQ120wzNSseY0F69Mymfe08+s8u40hMsqUJQfmVz/iWK7L+xqqFYen5HENF/Hc1h0WJqZULI5RWP3lu/SOMVIXDvSUlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPvfBXq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPvfBXq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41F2C4CEF0;
	Mon, 22 Sep 2025 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569599;
	bh=luTmsAIj9CP/8Q+emcvxAmejTatbDed6ZKRLGVcxF4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPvfBXq1bb7PLgcLWBh/Gfw9ZdR75IDY89p9e2XGGstnVpOLmZEIXDuAyu4a8ea//
	 1L0/90hk/JbMS/DTyYr5xb7XxFpx1dZjAZ9WNBtAeHByhAn9TRpL0t0zcTSOFIin3s
	 4b/Pk4Muybb+tnZdlSi2TfjTMyQRxyKKFDPZjZ3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/61] crypto: af_alg - Set merge to zero early in af_alg_sendmsg
Date: Mon, 22 Sep 2025 21:29:37 +0200
Message-ID: <20250922192404.796697469@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

[ Upstream commit 9574b2330dbd2b5459b74d3b5e9619d39299fc6f ]

If an error causes af_alg_sendmsg to abort, ctx->merge may contain
a garbage value from the previous loop.  This may then trigger a
crash on the next entry into af_alg_sendmsg when it attempts to do
a merge that can't be done.

Fix this by setting ctx->merge to zero near the start of the loop.

Fixes: 8ff590903d5 ("crypto: algif_skcipher - User-space interface for skcipher operations")
Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index d5a8368a47c5c..aca9d72553e8f 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -908,6 +908,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			continue;
 		}
 
+		ctx->merge = 0;
+
 		if (!af_alg_writable(sk)) {
 			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
-- 
2.51.0



