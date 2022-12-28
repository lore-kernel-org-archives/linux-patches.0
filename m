Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05E51863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432A8C433EF;
	Wed, 28 Dec 2022 15:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240844;
	bh=zjFIJkCz3oOe0Gx5mrgHSHt97IArqt35YJEJbgTvRB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtfy29wI3wc6mMFGwaT8TdpEqqZQv8T1iUidCBPgryOvB+EfCWPQcNAH/D/AxEClW
	 TYT7bHsaMc8ZVOHx4r2J7x4P0X0PhzvTI50QFYwulhhLI/MPOVylwVRhCplcWJtTjU
	 +BnWK3sC4y6ZWwE+Ppe4tj7/e9RGsEzRYfZQH//M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yiqun <zhangyiqun@phytium.com.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/731] crypto: tcrypt - Fix multibuffer skcipher speed test mem leak
Date: Wed, 28 Dec 2022 15:38:31 +0100
Message-Id: <20221228144308.277930720@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 3362897bf61b..4ada7e749390 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1295,15 +1295,6 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
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



