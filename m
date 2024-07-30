Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB671078F;
	Tue, 30 Jul 2024 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356605; cv=none; b=Fn1LrRjUgWOu0RAYcMEJ/dLeQUJJumEbAU9z669R1UI6sCDQW477F/EssynZeU7XbmqvvFtwXXmBCAP9n3G4BzEBwwPLFW9v/qSdDaEC/bxqzV/kxvRI57cFk0vQlv4ZlZxJGT+H7Ma191KdYmCneoCSoI1ZyvPkA8FR+/RyY/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356605; c=relaxed/simple;
	bh=4Wu+eG9lLYnJp2xHmalmeUH9hbGRM9Vj3x+KJnxFN8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4VJ9QvnafouTUKkLxq3812DhRSPMdOAtZwUj10OKRH+s1p5Ojum7RpYclAsnaIZQTu+1NNByZ1grJ2gXBRewtVVfIDE7oO1TPyspCTi3104NqgvSsOX7Vk21kdLS5cCxUEIk1X+tQicj3Rbm90W1tF3fE+RQGyDRASgR/ZHKeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgXQpv5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgXQpv5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C85DC32782;
	Tue, 30 Jul 2024 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356605;
	bh=4Wu+eG9lLYnJp2xHmalmeUH9hbGRM9Vj3x+KJnxFN8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgXQpv5dZAEyD1K6xEJCducfF01eEVRwZFGN9hvXKY9BI5jRicw3aZScSB8KRRHeF
	 45cfIcJwtLPAMwzqrIxkTIMJ22cPfLfdMOl5zLsgkiA0WjTixn+JEVyUaj7/41pDHh
	 EAslGSDjBH3TlnPSC+8UDuOaCGgOsSoCi2JQMono=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/568] gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey
Date: Tue, 30 Jul 2024 17:44:23 +0200
Message-ID: <20240730151645.977654992@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit a3123341dc358952ce2bf8067fbdfb7eaadf71bb ]

If we fail to call crypto_sync_skcipher_setkey, we should free the
memory allocation for cipher, replace err_return with err_free_cipher
to free the memory of cipher.

Fixes: 4891f2d008e4 ("gss_krb5: import functionality to derive keys into the kernel")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_keys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_keys.c b/net/sunrpc/auth_gss/gss_krb5_keys.c
index 06d8ee0db000f..4eb19c3a54c70 100644
--- a/net/sunrpc/auth_gss/gss_krb5_keys.c
+++ b/net/sunrpc/auth_gss/gss_krb5_keys.c
@@ -168,7 +168,7 @@ static int krb5_DK(const struct gss_krb5_enctype *gk5e,
 		goto err_return;
 	blocksize = crypto_sync_skcipher_blocksize(cipher);
 	if (crypto_sync_skcipher_setkey(cipher, inkey->data, inkey->len))
-		goto err_return;
+		goto err_free_cipher;
 
 	ret = -ENOMEM;
 	inblockdata = kmalloc(blocksize, gfp_mask);
-- 
2.43.0



