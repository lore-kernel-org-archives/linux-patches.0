Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9BF6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ACEC433F0;
	Mon, 16 Jan 2023 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887552;
	bh=vtJY2kTts9nbX92BLs2HsagI58wuVw8En0ppsBK+7uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9o+XZFwPnks6eo84nK6Sw4X9kexzkYAd9BocaPXdcofH+McIle1opifzRDG3W/bC
	 nkjo8scAM45q01A7b7ZLFuReXaQyTAj3+9SMAiCkk5vU3GoW73drUeKdSV+2akjpr6
	 0J+1Qu6uXxh+NCSzhGxmoelRICvyeV4Wvwf8rFlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yiqun <zhangyiqun@phytium.com.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/521] crypto: tcrypt - Fix multibuffer skcipher speed test mem leak
Date: Mon, 16 Jan 2023 16:47:34 +0100
Message-Id: <20230116154855.657184565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index bf797c613ba2..366f4510acbe 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1285,15 +1285,6 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
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



