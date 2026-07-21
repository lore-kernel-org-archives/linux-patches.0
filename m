Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CE13C0A02;
	Tue, 21 Jul 2026 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668532; cv=none; b=Ug+11q5XdxGAZgM6GSdnqOL5Qd2sDwbYpx+6RvlnegZ1/QBaoe5Z/E1R7h6+P3yQoWXf4MwFSCe+H4BfSNNoiPT/Ve7FHTlbAgSaH5EaW9UtCjyis5firPs3mYGAre8EHaZGWNFbZPaf/x4xnXvBdOx+Qf8PuwlwEwjzknY07yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668532; c=relaxed/simple;
	bh=V0qSdmIaslTmXQ8p75JKU5F6tafkyoNFEuiQEME93x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp3XxUeCRh1oNzQBvPytyaa1GYELHaoh9vq01jatpp3LhJLYWnXPwtuazHB6otQiMsw7jTvNGUbDIn7MUTWft4N/fZMLl5TSw4ezCTlJnLK4TbKgQscdcW0cEGEZaIHzy7xV1S+v3tZyki9Yo3qu28zMmaNWbCMpjc5IkfgmzH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gy9vKLQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gy9vKLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B361F000E9;
	Tue, 21 Jul 2026 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668531;
	bh=8hf7bl9b4IXs8P56kQurtaPPZIeEMgMXg+WDhkFXriE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gy9vKLQA7RwmkEEe6XSuYlZWE3mMFb7ApAWebXpn2+AjccBup45wMnxuB5Z++EfR
	 XoEy5I5Yd4NpP7xnKSaZSz4FncvlCL5m6PzF8COhD3dz5GOSvR27dGqZWPBZQbW88u
	 pO7xztB1FgHx3cCsS4yTYcOdu69S2BVRM5POiT+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruijie Li <ruijieli51@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 0211/1067] crypto: pcrypt - restore callback for non-parallel fallback
Date: Tue, 21 Jul 2026 17:13:32 +0200
Message-ID: <20260721152429.313653703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Ruijie Li <ruijieli51@gmail.com>

commit ed459fe319376e876de433d12b6c6772e612ca36 upstream.

pcrypt installs pcrypt_aead_done() on the child AEAD request before
trying to submit it through padata.  If padata_do_parallel() returns
-EBUSY, pcrypt falls back to calling the child AEAD directly.

That fallback must not keep the padata completion callback.  Otherwise
an asynchronous completion runs pcrypt_aead_done() even though the
request was never enrolled in padata.

Restore the original request callback and callback data before calling
the child AEAD directly.  This keeps the fallback path aligned with a
direct AEAD request while leaving the parallel path unchanged.

Fixes: 662f2f13e66d ("crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Ruijie Li <ruijieli51@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/pcrypt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -122,6 +122,8 @@ static int pcrypt_aead_encrypt(struct ae
 		return -EINPROGRESS;
 	if (err == -EBUSY) {
 		/* try non-parallel mode */
+		aead_request_set_callback(creq, flags, req->base.complete,
+					  req->base.data);
 		return crypto_aead_encrypt(creq);
 	}
 
@@ -173,6 +175,8 @@ static int pcrypt_aead_decrypt(struct ae
 		return -EINPROGRESS;
 	if (err == -EBUSY) {
 		/* try non-parallel mode */
+		aead_request_set_callback(creq, flags, req->base.complete,
+					  req->base.data);
 		return crypto_aead_decrypt(creq);
 	}
 


