Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5983A2DEA79;
	Mon, 22 Sep 2025 19:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570031; cv=none; b=topiZZHLeCClwrgP1vSrs46cYdI1pvnrHq5idvo6XCJsKKidYqBA76o28beCbFIrpBquQa7XjKAHR5BsF+N0i/+4KSou9TDl25LSZ0axu5HFStZtY3hblfBGrKVsA/9x5pR7/jVF+B36aIej/RBuLtwXyfoF2cgfZsEYL/FhUZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570031; c=relaxed/simple;
	bh=iq1uhupk6+IGqiAMyYVU7H34u6gmdfPESPhA/993m5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vfv6MxBCYmaNmfIN4K2CUi+PR5kb5K2/zh3dp13OePqDhLCacWvocsVULGSUMWS7c8p8mTbqbw0kJlSgkFVgD8sbbouNP4Q5kEgY5vAJNWsS+RKtqQaogbKQrSne97WqAI/+rY722t8h3EM7buDJjVlMZmeQZ29NbhPS4SGSYLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kstgEd5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kstgEd5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBB0C4CEF0;
	Mon, 22 Sep 2025 19:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570029;
	bh=iq1uhupk6+IGqiAMyYVU7H34u6gmdfPESPhA/993m5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kstgEd5Lvn7wJN7G3LHbcujR/hdK0WOQZJOZU6XiSt6O6bdUPwUspPe9VfLbS4238
	 r7qmR7kmGIL98NDkCX6bwYcS1B94SLB/HPynlE6NN0CimbK8KZxE1TLZyzKO2Ggxyn
	 FbYgcrtN8qS0xdsqdc8gqAaKKh+KL0yfPA5f1oRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/105] crypto: af_alg - Set merge to zero early in af_alg_sendmsg
Date: Mon, 22 Sep 2025 21:30:05 +0200
Message-ID: <20250922192411.047919676@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 crypto/af_alg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index f02c5586a8ab3..ca6fdcc6c54ac 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1025,6 +1025,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			continue;
 		}
 
+		ctx->merge = 0;
+
 		if (!af_alg_writable(sk)) {
 			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
@@ -1064,7 +1066,6 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			ctx->used += plen;
 			copied += plen;
 			size -= plen;
-			ctx->merge = 0;
 		} else {
 			do {
 				struct page *pg;
-- 
2.51.0



