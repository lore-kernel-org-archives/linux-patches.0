Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8791C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A7CC433D2;
	Wed, 28 Dec 2022 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243917;
	bh=nEC565JBodTcslZS0YFyAvQ6xeJWT3+TMb2qbBBL0Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwBTom7jh4mp0kKTx8sEpGk9SbCOOZzpQvJxQ2NYqA8mkPzuckrCjI9VqqsRQb4Un
	 C9NEhspTGnE/t/Eo9wb0Lxea7H+BjYZsFaIW8YnCbFY/NoIta0MZ6o4j9IBWEQUQbT
	 WxfVvH7hig4nCuhMQNdGvK5Oxdv7RNK9oo2GR+AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yiqun <zhangyiqun@phytium.com.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0615/1073] crypto: tcrypt - Fix multibuffer skcipher speed test mem leak
Date: Wed, 28 Dec 2022 15:36:43 +0100
Message-Id: <20221228144344.747500416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Yiqun <zhangyiqun@phytium.com.cn>

[ Upstream commit 1aa33fc8d4032227253ceb736f47c52b859d9683 ]

In the past, the data for mb-skcipher test has been allocated
twice, that means the first allcated memory area is without
free, which may cause a potential memory leakage. So this
patch is to remove one allocation to fix this error.

Fixes: e161c5930c15 ("crypto: tcrypt - add multibuf skcipher...")
Signed-off-by: Zhang Yiqun <zhangyiqun@phytium.com.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 574640210c80..bc57b182f304 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1101,15 +1101,6 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 			goto out_free_tfm;
 		}
 
-
-	for (i = 0; i < num_mb; ++i)
-		if (testmgr_alloc_buf(data[i].xbuf)) {
-			while (i--)
-				testmgr_free_buf(data[i].xbuf);
-			goto out_free_tfm;
-		}
-
-
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = skcipher_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-- 
2.35.1



