Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F68963409;
	Tue, 23 Jan 2024 00:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971179; cv=none; b=IUZNYqxiokIFJ4XNIk0LHV56f4D9m4O0X8nKWAg0sp9bOTWEOx4SZqc4t/sD3bTVjXrU8eigZVr1szzZfkFJLiQmPFc0dWP54Cx/GtJ8Okd1BHjvs5qXGyfK5Fpn9cYT5hClHGphCCUdW1y02nVzLaxnN4aJyJnvkqPh9dlqJjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971179; c=relaxed/simple;
	bh=3tsJPZszjcbkqklgwkMyoX8JmX1OBIGVFyHKNGk9/DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Zf2apkPeKDv7etw3oBERIZ/Vm1SlCkAgMyoNRo8MmfHvmWHD4R4zT+kbphq6dKibIethnkFbUnkW2/uZa5nTzuiNgEVJxzL5OQEigxmDcrVdFLKOzHhZj5Bwv2AimJVmC/lv3KW82/JjUhOsIhG+gBBXLpntZixsflPwEJtDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbtTOzlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbtTOzlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F85C43390;
	Tue, 23 Jan 2024 00:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971179;
	bh=3tsJPZszjcbkqklgwkMyoX8JmX1OBIGVFyHKNGk9/DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbtTOzlZs6A/qvt/rrfnDSCiUfTZVTLDIlxIAc7LGq/8yMcdKV/mdfjXtrd99xLpb
	 CDgXK57yDtlmiwy3axtdodN4EtOwDxsXqcbAsGc6RCredjsOTG1Ple48ylDAGvxPIK
	 vRzWgFojjbJ4xjptdx4E9Gl5M0yzFgf5t91LSEQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/286] crypto: scomp - fix req->dst buffer overflow
Date: Mon, 22 Jan 2024 15:56:51 -0800
Message-ID: <20240122235736.136974149@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



