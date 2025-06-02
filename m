Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D41122836C;
	Mon,  2 Jun 2025 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875774; cv=none; b=eJbZ4d5AAi0n7N10+0zWJbmquGLahAC3d6V76i7qY2H0UV7YHemieB5C/lVhZJKvTUOPIKugVTGnW5bo/CDjgG+SrWgUdbyvekkidIDMcUJqKdbOZIckz4tqBOn0aveq4+HGj5p5UQeSfoDGo68CnltMecAgFk0dBVv56G+X8fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875774; c=relaxed/simple;
	bh=W2J8mKCYhyXNXOorj8FC2q1coRjc3sFhUBNhbLcikR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXuboqFgY1XQY48kM8aDg7m0D/87cCS9q4FVZjIMsRY/PKwNAO2Un1zZkO9Ak5f5A0SDLbL5SaolPAjPO9O3tRMkagpwWbyhLit7Wm8eAYQ3NRMyPda6bzqduScufAKDWw4CwDiftgqQaVloH6oKuH4g/u27j39+cxumLgbk75A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzPAINyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzPAINyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C47C4CEEE;
	Mon,  2 Jun 2025 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875773;
	bh=W2J8mKCYhyXNXOorj8FC2q1coRjc3sFhUBNhbLcikR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzPAINyY1ueJGjP4bslR6Ev+JG1hDbem2l6fHWdyRNpOeN4biCbhaetlQReExgnsb
	 ejEP8iJ03qntg71bgvnDUt0oMWifkzXYMeG0aZrD8jPTdSLtv65To3UDcQ6s4Wt/9+
	 NNU1aQhclY0eKEycUOGXAWs1MVFdpH4mcYVphhus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 240/270] crypto: algif_hash - fix double free in hash_accept
Date: Mon,  2 Jun 2025 15:48:45 +0200
Message-ID: <20250602134317.142502202@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


