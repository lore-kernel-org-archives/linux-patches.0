Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C036439010;
	Tue, 21 Jul 2026 22:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671232; cv=none; b=BZPUtwh6OVLqKnhmW77gwmdJ/9GizrtgGwru2rp0FI/rHJrXGrIBFvr02bTzRKq3sB/6iGnySXaQT4jRp4UMAAVn313G8KzqzyrMbwvovBGtl+UuS03SwJ6aNJtMAnryCC16sTJA8/l7UWeMQwZf5jHD+MGU/f7cBNaUxP83nJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671232; c=relaxed/simple;
	bh=z4sCd7cPU18gYcX1aLQMs1y9kkP80AoTtFBwdHsReM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0tSe4foLh9HnIgy0hn4tGKI4fhOukJ53vx6vAbgxXmik2Ex9zjONOkl6eI2Rtwz1XcbTMb+q23dsCJEVGpYGcryEfSOIsEGvElXYdBITBjHF1F7U5VpeujfFGSCbuohxYyCcUa4Q7M+EHtdj3tcfy++MJTzxTY3w7nlqXtLKLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPv7bDHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPv7bDHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E719F1F00A3A;
	Tue, 21 Jul 2026 22:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671231;
	bh=BbA1za51BsrlAZzSuBKgMwRF8ih8XDL0hBamVA97xFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPv7bDHF7dEmsF+2XMgoAXOun7gi2uhHfQuHkm8uB2wfRkNkrbzbA7/h0oJ2ehtH4
	 zFGjugF0SGR6pGdX9+hX+k982X0Fj9EDhp9KcVNhg+s3EACX/DbQUV/khTWC5CeR+U
	 FCC7zxt+IPW/2RT0sZxMDZRj28UNhSG6j4bJSCD4=
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
Subject: [PATCH 5.15 166/843] crypto: pcrypt - restore callback for non-parallel fallback
Date: Tue, 21 Jul 2026 17:16:41 +0200
Message-ID: <20260721152409.752127673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


