Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4285204092;
	Tue,  3 Dec 2024 15:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240204; cv=none; b=pgORBYWPum0HWtT6lKcoKGGbAq+dMbfBCIdmD41AFzdBjWYGJKiCjO02EjW4W44b6eXEG0JyBspEBRIh0g48Qib09bxpv+h674AkfD8qScphme4Q1JMIpvhbRTraJ2PxI4bxA/yMN7POxU1TfMeQiB6yVYg9wUMNr/dF3QRhWM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240204; c=relaxed/simple;
	bh=QksBFP36RJWMW/VKbN1hxKJzDB8gHvoZiRl3GxexLe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiZZLbJEPcWWJD9tKlV6VHp6YIcdridQcn0M81W/CFv4JwoHT81u2dI6qyMYn0VKUVMl9Q9REhU4LvJhg5WFeeULLaxDi/s5NhRqnocl8a8hwwPuMHYMMATb9HwliYFghif+bsUnL03vvYFS+X1t7XARXGDU1M5iEgSWf6QfHmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2a78F9Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2a78F9Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F57C4CECF;
	Tue,  3 Dec 2024 15:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240203;
	bh=QksBFP36RJWMW/VKbN1hxKJzDB8gHvoZiRl3GxexLe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2a78F9SsuHqMigR8KS6rnIXDsF8QnK5xsNKLTBLrHUg15NyPtwx8sIN/UETsgEanK
	 D5/mP5+jKbgJvzFYaHTfuaBhUh8XAEVTnvrZz34s6v/O0cjbHFNXCGZRI3OjmZQdig
	 f8W3AXs7ruwWyfppkElfPo+wlUCbsunYQi78xzwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/826] crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY
Date: Tue,  3 Dec 2024 15:36:25 +0100
Message-ID: <20241203144745.735386479@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 662f2f13e66d3883b9238b0b96b17886179e60e2 ]

Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for
PADATA_RESET"), the pcrypt encryption and decryption operations return
-EAGAIN when the CPU goes online or offline. In alg_test(), a WARN is
generated when pcrypt_aead_decrypt() or pcrypt_aead_encrypt() returns
-EAGAIN, the unnecessary panic will occur when panic_on_warn set 1.
Fix this issue by calling crypto layer directly without parallelization
in that case.

Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index d0d954fe9d54f..7fc79e7dce44a 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -117,8 +117,10 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
-	if (err == -EBUSY)
-		return -EAGAIN;
+	if (err == -EBUSY) {
+		/* try non-parallel mode */
+		return crypto_aead_encrypt(creq);
+	}
 
 	return err;
 }
@@ -166,8 +168,10 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
-	if (err == -EBUSY)
-		return -EAGAIN;
+	if (err == -EBUSY) {
+		/* try non-parallel mode */
+		return crypto_aead_decrypt(creq);
+	}
 
 	return err;
 }
-- 
2.43.0



