Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879AF3A960A;
	Thu,  2 Jul 2026 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009460; cv=none; b=aSIr59tL7Vvs06gGqY58LPu0Hc+mGDW/m7dsuSIVOcLgdWMl8a/dJ5QY0UYec/BK0DmTSmxkH97AMLvR9wBxc5GpR+U32KQYneAsW8ZBaVCxxs4b638n1ZSl5fwgVxmYlvTVF4tHJ3IKO2uf7u5F0tl8kcMsnDyPv/54P07KO9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009460; c=relaxed/simple;
	bh=+AkLVqHSNdVcENkwAvbbsus0lkzMeDVjwD7LKlreCcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdXxl/IYds8RUzTnjz54DImVfu3mchhxaWA8KMDQEZqndX4w4K9aShu/WE6vbD9aVxArZghMogN0PoO17dYP0DQCLQiO0X7U/dDduJDJXx0L/yvUJ+0g7ej+bbPSXjkm3YYYXV24l1V9PSrm5ykiN0GvBkpY9I06DH2vBpt0tOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSZj7Rua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSZj7Rua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9A91F00A3D;
	Thu,  2 Jul 2026 16:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009455;
	bh=z2ASbxDPPzRcXeWQAoKfLg6hON5WsOnM/1B4UMhmf9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSZj7RuaDsZfEiXzpiXd/X1ud77mmSXEigwISY5AX1XGLx7sfnVcsTV7nqZLNYBtd
	 pGx7Z2BT9dqjuj3toePWQ/8nBsAg/gDadMTACA+firD6u8Lh0y+McIK/kvYSDF+PhO
	 PeUY9hd7kL9cH1soaJO6sMNmqQR8kYLgoDG7YiH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/96] crypto: af_alg - Set merge to zero early in af_alg_sendmsg
Date: Thu,  2 Jul 2026 18:19:51 +0200
Message-ID: <20260702155110.223108068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 9574b2330dbd2b5459b74d3b5e9619d39299fc6f upstream.

If an error causes af_alg_sendmsg to abort, ctx->merge may contain
a garbage value from the previous loop.  This may then trigger a
crash on the next entry into af_alg_sendmsg when it attempts to do
a merge that can't be done.

Fix this by setting ctx->merge to zero near the start of the loop.

Fixes: 8ff590903d5 ("crypto: algif_skcipher - User-space interface for skcipher operations")
Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 4983dd68578e24..6acee8e0041a42 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -892,6 +892,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			continue;
 		}
 
+		ctx->merge = 0;
+
 		if (!af_alg_writable(sk)) {
 			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
-- 
2.53.0



