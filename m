Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43521187FF2;
	Tue, 30 Jul 2024 16:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355766; cv=none; b=PwfALn21MPxwA1ptOGD2aMMGBnHN68XhS4qp49bBkWZ4iQihzV3XrtooAXQUPNwgqwGoe94zWTA8Q9eV7B21DTh6mDH0Op36ZkD5kdLPI/uilTK5ZriNxfwyI8ViS9CcfcDxv2aKteJDglCeu+2br6LPpqbaAM6cccHUvq7BGQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355766; c=relaxed/simple;
	bh=7TL/pJf787GFotqojdesXgAiM+8nJngvFp5mHF7H6nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN9SWaO6Zd2z0k4FseYQdj9THURgI9sUGh9J+kVayaWEpq1OFcu25u3iPzeb+DtkTIn3XtoSoVmGC92YgMUozAb+eNtNmRZur18H1YG3Ue8BHyo3bbUbHWvqV6xWG4vRDcc3ZvQgbxvyFc0/P8BlBoedIC6iqxhSF1btBhIGHcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVI1oa3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVI1oa3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32A9C32782;
	Tue, 30 Jul 2024 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355766;
	bh=7TL/pJf787GFotqojdesXgAiM+8nJngvFp5mHF7H6nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVI1oa3zG5az+R2JVtdbbf4WCxne69wfKpDjXB21ipWDcpiczyw3XZs9cxJmQzwLk
	 X7JxqlUKeN0Q81YHXstqXBlwAZS1XgD1pCCtkgYwApXz6eO0Km4WmZGr9Z6IpNaRh+
	 OsWonfwM6MnHDwbWJnGZami1zKJfsL9C5lmkniKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/440] gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey
Date: Tue, 30 Jul 2024 17:45:49 +0200
Message-ID: <20240730151620.422315548@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 726c076950c04..fc4639687c0fd 100644
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



