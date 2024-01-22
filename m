Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D01F5C8F6;
	Tue, 23 Jan 2024 01:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974385; cv=none; b=A/sTIeocblJrADR8gdYs62QhmO7KACQO2DuQZXa9i4puaSmcoVhv/lzXTpnHYgcwx0qe/aFneDMvfl6XrpR5KaB/mTbDbb0KZEhg/J8rhqCVEFORn1perMQ0vkUznzp88kA0iC/QB5c++RKZRFITlyxYdX1hjm/goQalBl4YrVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974385; c=relaxed/simple;
	bh=SP24KkxQactEd0iMR+gLYShFecb502b8S8KNTCN9a9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7awdQXhGCkPcXcYkq5xXGoYqXkrF0l56d0kwvg0TQXsYLK066zSHEZK13mEVm1ExlmZTH0GpyUH9vmrqa2WdY6oM5A9xZ9bmHYWoGjWx6zXfdgFjfVqRIV9pPIaW8U5rPLjfITJVZpGjYXTRaKY8AS+g2wDD0vAzbYvnLT6M3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BW/CJXSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BW/CJXSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93358C433C7;
	Tue, 23 Jan 2024 01:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974384;
	bh=SP24KkxQactEd0iMR+gLYShFecb502b8S8KNTCN9a9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BW/CJXSI66oQ45ZBJ/vgJkN9Lb8W1c3+oMxsTQ/UGfGppx7Mw9d458n1xrMt/1MPh
	 GJPz1wIhF3IHL6L3TMZBPPM/M0QQxNJ1r82BV1Y2ll/fGJ7Pa7X5iusWQZsbcrV789
	 SOgUOey3hokQZ80XrjNEANwtjuFa64R3ApkM2wfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/583] crypto: scomp - fix req->dst buffer overflow
Date: Mon, 22 Jan 2024 15:52:05 -0800
Message-ID: <20240122235814.423025681@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 442a82c9de7d..b108a30a7600 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -117,6 +117,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	struct crypto_scomp *scomp = *tfm_ctx;
 	void **ctx = acomp_request_ctx(req);
 	struct scomp_scratch *scratch;
+	unsigned int dlen;
 	int ret;
 
 	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
@@ -128,6 +129,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
 		req->dlen = SCOMP_SCRATCH_SIZE;
 
+	dlen = req->dlen;
+
 	scratch = raw_cpu_ptr(&scomp_scratch);
 	spin_lock(&scratch->lock);
 
@@ -145,6 +148,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
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



