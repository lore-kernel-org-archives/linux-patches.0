Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5F1D6BA
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ays9UR7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B142C433CA;
	Wed,  4 Oct 2023 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444453;
	bh=ZGkzdKJ65adkR+pcci+EKjRxW7o0SS9LPgaMeBSvru4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ays9UR7A9Y3YTnHQ4P58Gi7Lny0HnwJtE16y16bYeN+rEFlsZ+Xiokv06R1amfJBe
	 kzOgszQ77A23GxQ9OW08mj5FPDzqQPi53/xz5JMBZCnhNUUFscDvyu17mXZV8du44N
	 cnTW7X5Btu/JZi6h/RCFZbUY6BZBXCV0WrWo/IFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.5 256/321] crypto: sm2 - Fix crash caused by uninitialized context
Date: Wed,  4 Oct 2023 19:56:41 +0200
Message-ID: <20231004175241.126277021@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 21155620fbf2edbb071144894ff9d67ba9a1faa0 upstream.

In sm2_compute_z_digest() function, the newly allocated structure
mpi_ec_ctx is used, but forget to initialize it, which will cause
a crash when performing subsequent operations.

Fixes: e5221fa6a355 ("KEYS: asymmetric: Move sm2 code into x509_public_key")
Cc: stable@vger.kernel.org # v6.5
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/sm2.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/sm2.c b/crypto/sm2.c
index 285b3cb7c0bc..5ab120d74c59 100644
--- a/crypto/sm2.c
+++ b/crypto/sm2.c
@@ -278,10 +278,14 @@ int sm2_compute_z_digest(struct shash_desc *desc,
 	if (!ec)
 		return -ENOMEM;
 
-	err = __sm2_set_pub_key(ec, key, keylen);
+	err = sm2_ec_ctx_init(ec);
 	if (err)
 		goto out_free_ec;
 
+	err = __sm2_set_pub_key(ec, key, keylen);
+	if (err)
+		goto out_deinit_ec;
+
 	bits_len = SM2_DEFAULT_USERID_LEN * 8;
 	entl[0] = bits_len >> 8;
 	entl[1] = bits_len & 0xff;
-- 
2.42.0



