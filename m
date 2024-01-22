Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8EF37C;
	Tue, 23 Jan 2024 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972193; cv=none; b=fBhBnO5f+rmp3x7Iit9tzqjm7dYi6zehB6VqRbhB5iICDDqMaAC9JpbbyTJ8hfNp7sM1czZ4gSa7ZLY//7q5lJfSsIJHHIrSsfPFcijCbdJi5gpmro7p+wN9qSaoZ03Nu3H3EvoBP9BN2aHNFp3eIu3pDtU6PAt8plbLcngxAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972193; c=relaxed/simple;
	bh=NI+w7EET0A4VSRRV49l89dRdLv/5aL0YzdygU08GAGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaJBnjSE0TnuAQqWhnpKgDon47MbnyI9Bk1OBT9fdf9QbSOH3j2EGZtOoZLYDQoFT2ycES5vnJQKUT6sXPYImmDcf7QtOpvb6DV3X7VB0dEtnuAz4djIBGn0LxnsXFlmDSLlBGd6kLoGwxyg2vLp5Lwqy/GgSeMoFoeXPlZRXmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAeFjHVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAeFjHVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80800C43390;
	Tue, 23 Jan 2024 01:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972193;
	bh=NI+w7EET0A4VSRRV49l89dRdLv/5aL0YzdygU08GAGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAeFjHVIp2PSAARcJw933kOxYYCjNc61lVoVIToI8aD1SitI1KeuDKb4m3smlzAk1
	 tvyjvhcrqEt/6Vg+P+NItGxEYTT3BjgIshfxrPGrDfB7tZ1oOWSSsakJcaRtIXS+RT
	 /iO77RBBp12ZH4CMuV+PiN0W3qzxp9HGpgCkQK30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/374] crypto: scomp - fix req->dst buffer overflow
Date: Mon, 22 Jan 2024 15:56:10 -0800
Message-ID: <20240122235748.603790883@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 744e1885922a9943458954cfea917b31064b4131 ]

The req->dst buffer size should be checked before copying from the
scomp_scratch->dst to avoid req->dst buffer overflow problem.

Fixes: 1ab53a77b772 ("crypto: acomp - add driver-side scomp interface")
Reported-by: syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/0000000000000b05cd060d6b5511@google.com/
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/scompress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 738f4f8f0f41..4d6366a44400 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -124,6 +124,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	struct crypto_scomp *scomp = *tfm_ctx;
 	void **ctx = acomp_request_ctx(req);
 	struct scomp_scratch *scratch;
+	unsigned int dlen;
 	int ret;
 
 	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
@@ -135,6 +136,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
 		req->dlen = SCOMP_SCRATCH_SIZE;
 
+	dlen = req->dlen;
+
 	scratch = raw_cpu_ptr(&scomp_scratch);
 	spin_lock(&scratch->lock);
 
@@ -152,6 +155,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 				ret = -ENOMEM;
 				goto out;
 			}
+		} else if (req->dlen > dlen) {
+			ret = -ENOSPC;
+			goto out;
 		}
 		scatterwalk_map_and_copy(scratch->dst, req->dst, 0, req->dlen,
 					 1);
-- 
2.43.0



