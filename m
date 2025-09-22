Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCBE2E2847;
	Mon, 22 Sep 2025 19:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569809; cv=none; b=mdSQniYIlmFutOrBoTFDx7XRhhedAUNiME2tA85keiv3jdijPjMkb7VT0SDI4M8TbDa0+QFKaBkbYEH5fzHzLharNR4C2dhPWyBOJv7tbEanE5W7TLcucWJ9zKjuD9Sw4INVQwv6zrqIgurS1W7MtACNKl0kSdBQf0eZe2W6xgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569809; c=relaxed/simple;
	bh=rk/DxQ+ChFHUbqXiVvDJaH7kHh0+mq9kmcu9oMmD4x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Roi/IGUIUoYSQdFfQWjj95/++UvWW/uFemBH7c+Llq0uNfFrhxOluc4GgBrwNeEf7Hdk8xEc7QqDtMwjfX6RdTu1/FLO+pgIzOCj+MWKs55YCFMzaltIYxnugMFeuQdhkc6PaL8yrlGy7YgwdKdsBix6fqBSBuh3QFmAlB8hCdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzbsUGsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzbsUGsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669C9C4CEF0;
	Mon, 22 Sep 2025 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569809;
	bh=rk/DxQ+ChFHUbqXiVvDJaH7kHh0+mq9kmcu9oMmD4x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzbsUGsVbvlOYHsvylUQMZCAbHeIUhF6sQVbWV0yryMo/TEDmXaAzhVjry4zzxasi
	 0AfPT1okep2U6x2ki5H4awqbFGFp7fb1ixXetVvV4pL4s2d6YnMLkWYEnV0+C/AIbr
	 qd088C+u03heV0RzhEizJ1J/NqOfD+Us8+KYKiUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 55/70] crypto: af_alg - Set merge to zero early in af_alg_sendmsg
Date: Mon, 22 Sep 2025 21:29:55 +0200
Message-ID: <20250922192406.081774571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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
index dbddcf52b9920..886eccb97b041 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1024,6 +1024,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			continue;
 		}
 
+		ctx->merge = 0;
+
 		if (!af_alg_writable(sk)) {
 			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
@@ -1063,7 +1065,6 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			ctx->used += plen;
 			copied += plen;
 			size -= plen;
-			ctx->merge = 0;
 		} else {
 			do {
 				struct page *pg;
-- 
2.51.0



