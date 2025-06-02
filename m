Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018832C324F;
	Mon,  2 Jun 2025 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875013; cv=none; b=TLhMH5alKMX1BxkwMqGM+Dx/6V5m6e94dqr6/7qZK/VHY4uQozz9KiPbWnGJfXX2sOTuS7hrvzG4jcC3Jgq0pmfpoIlV9a9VKRRgFrVlPZpnVlKTpfGyyHfkmGF9enXpVeboRGdDsDtk/OTFPFl64at8l1W6YRIdUe5EvX44nnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875013; c=relaxed/simple;
	bh=PM/2+2q4xCmDXHzeWyW3UWSl5/hPWrYbqqarT+80irg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7wmdd/P63gescVeTadUKYX3tlacqSkmdqZNSx4F2N2FDKScI1WH7bB8ysprfr4I+m8gov1ya2JsQWu5xVu3FLjPcNlTcuWgmkUwMPFoGRcmG4kxe+YxXRQ2kHRqz795aMHNar9pkiYlEvb6g6ggJfDLwM4klhXWtSIeS90O5f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyaa93YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyaa93YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC7DC4CEF0;
	Mon,  2 Jun 2025 14:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875012;
	bh=PM/2+2q4xCmDXHzeWyW3UWSl5/hPWrYbqqarT+80irg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyaa93YCfs18VO0r9hr0sUhCKcNYE9AqEoTztRnqkdqeA+nB3SwRnIMZkeXg6M3nb
	 V/XKiVKBBCsCKX/4t0DKYvKgYrIy971Sz8DJQ/YLIvtNLj0FyUw5m7BYWw/zBFrjQ2
	 cK8+pKsMZaNdqcXl2oH1n//YD6NJb3X2mqJL/Ye4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 175/204] crypto: algif_hash - fix double free in hash_accept
Date: Mon,  2 Jun 2025 15:48:28 +0200
Message-ID: <20250602134302.525812388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Pravdin <ipravdin.official@gmail.com>

commit b2df03ed4052e97126267e8c13ad4204ea6ba9b6 upstream.

If accept(2) is called on socket type algif_hash with
MSG_MORE flag set and crypto_ahash_import fails,
sk2 is freed. However, it is also freed in af_alg_release,
leading to slab-use-after-free error.

Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_hash.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -262,10 +262,6 @@ static int hash_accept(struct socket *so
 		return err;
 
 	err = crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
-	}
 
 	return err;
 }


