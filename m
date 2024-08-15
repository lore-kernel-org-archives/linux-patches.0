Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3991B32CD;
	Thu, 15 Aug 2024 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731177; cv=none; b=Mq6f4MRCcTHsdBlcpruEeYWiuKmdU2GlxEn6ObnNd1CDEShZ9tf764RZ53SM9rb0Hn1gh6jnj7SFLuaqKlSlVNnv2r2nOqFjC3HseWVLzE2Epilj1HJ7YjrCdFn0wYQHUbjzd0zeJuldE23FV55kXOX/W5dwRqIrSeiFDhwXp/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731177; c=relaxed/simple;
	bh=hiLbpp/u5f/vHKz+GXeUWiwuW88eInljKuyH16HX1N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuEGrUwcmpf9GaLp3eS+fSKjz7CwA+YmFephwOSNvJ+Pu773aUj+wlpudRQL2iDmaJabdhN2+D2kyR+ieotXfLAXtQLaMWPvtxXfKHqE8lHmD0O90gzpJUEA42yMtwHtRndJ/wu4Cew7WEz5Mihr83pNyw19hngl4BXFjpa+ISs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAe7AIqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAe7AIqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42391C32786;
	Thu, 15 Aug 2024 14:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731176;
	bh=hiLbpp/u5f/vHKz+GXeUWiwuW88eInljKuyH16HX1N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAe7AIqXlAp7U95FTZNkZVffs70cucGfvSs2njsqDOQ5uU74fY365LWeCp7QZ17vl
	 p42O9P5cbB/w6IHYjzaLAh1HIXHHfADNiGph9xZjT2IqxSxhz4zqY5IQV2p3w4lz89
	 TayVBMk/FFFlq5woCeStlD5oSLeCoLaO49G04LGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/259] gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey
Date: Thu, 15 Aug 2024 15:22:59 +0200
Message-ID: <20240815131904.583324704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3b7f721c023bb..f77ea3dc0cc84 100644
--- a/net/sunrpc/auth_gss/gss_krb5_keys.c
+++ b/net/sunrpc/auth_gss/gss_krb5_keys.c
@@ -161,7 +161,7 @@ u32 krb5_derive_key(const struct gss_krb5_enctype *gk5e,
 	if (IS_ERR(cipher))
 		goto err_return;
 	if (crypto_sync_skcipher_setkey(cipher, inkey->data, inkey->len))
-		goto err_return;
+		goto err_free_cipher;
 
 	/* allocate and set up buffers */
 
-- 
2.43.0



