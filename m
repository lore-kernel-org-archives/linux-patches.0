Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB8D38B7C4;
	Mon, 23 Mar 2026 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282956; cv=none; b=D3pHpFFkDvJ1imBdVBeMykO1kKbDN22FJQ4EUo6QbWvhK1uqEQAmXNKhkuENuThOwHuiv4dZ42nQgqR8mBGh4SD03Fnnz6NEbntmtAuHN9mD7gQghFIVLhf4kUcbw4hN69I280T6oBbvSKCqUk0o28Zb+ixIF4XOQc/BQHCSMK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282956; c=relaxed/simple;
	bh=311MuOeqe+Kcxa2VdaK5MdbAKl470hJFhFMdFkI/8ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVB8TL7EALwJHOvv3/bgkqHPEiVtidNNJXFDZEMGFoZUaE/30ZFyEOGwzTa145CQe5aBTv8yofiDoc0dH6Xasbsfk38uOLVhlBAV36cxjF67sErmSNddiRewDG3AgOTWwjEcGW/Ssvv4j49IaOHxOc56skzkVUXutNvn5DGDMos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFG5r9i8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFG5r9i8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914B6C4CEF7;
	Mon, 23 Mar 2026 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282955;
	bh=311MuOeqe+Kcxa2VdaK5MdbAKl470hJFhFMdFkI/8ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFG5r9i8+N9ZBwjo0dvBqyNuz31ODDkq3EZiGJbk2x3pUDUe6t3o5u+FKlTTbuBR+
	 yE/Nyu+ETINNKXVm8iACSil0Fxu15qGl8Zg9jo5h5YTMswrvn4UBJNk7N+kC/d27R8
	 Hrz4inW4IANTU6SIsb1ALiZDDG0ASbuC9tMWdXGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 348/481] crypto: atmel-sha204a - Fix OOM ->tfm_count leak
Date: Mon, 23 Mar 2026 14:45:30 +0100
Message-ID: <20260323134533.582350787@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d240b079a37e90af03fd7dfec94930eb6c83936e ]

If memory allocation fails, decrement ->tfm_count to avoid blocking
future reads.

Cc: stable@vger.kernel.org
Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ adapted kmalloc_obj() macro to kmalloc(sizeof()) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -52,9 +52,10 @@ static int atmel_sha204a_rng_read_nonblo
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc(sizeof(*work_data), GFP_ATOMIC);
-		if (!work_data)
+		if (!work_data) {
+			atomic_dec(&i2c_priv->tfm_count);
 			return -ENOMEM;
-
+		}
 		work_data->ctx = i2c_priv;
 		work_data->client = i2c_priv->client;
 


