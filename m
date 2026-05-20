Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199AC331220;
	Wed, 20 May 2026 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298153; cv=none; b=iyDJeXVQZZ3mYtOd3UKO4lqpnx/bjm8/5XQZua+oUyRk3Ef0DjSRuOzslKy/H7V2BP/BYm4wVM6zanq7wWx0ximItzkNz31MEbWlGdeSw5PBi6+N7ObEcDpOuyKiQv1g5dPfffhObnHHSmUkpuqdozQUNBUnS13KXruBzU0ufEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298153; c=relaxed/simple;
	bh=XvCHcCGXS7WOZxVvwCoZz2LSIMIO0ZKO0QqPsdAFgUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+uIEQhvCVUz3DK3VyLfLfYRfzMcQdYsMoz8wAQ1Eku73T4GlK++ixKKv5uRFzsRfK0FdAo6qicmnrM+bu84brD6TK4HfkbannJcTiSni1EUAhFEEs0aeIK0hTX7cZnqVrR4nbIdDL9oZ4N1sXlp+OnV2/6eFZkTDWZ476qsa+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOxog8vL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOxog8vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B6C1F000E9;
	Wed, 20 May 2026 17:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298152;
	bh=SquYIIW8zxlc/R070UXhIMlb8sFwfHfe9qdAptxkXfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOxog8vLZvbwIYPS/FWGNnGeiFFH3mEFH3ugI9N58HoVyAoUIYjPcDWIuf6rtOqBl
	 4F8FjsldLZYUniGFU6aG5nd0GFjej7YiaIus4hjwEedqtTBqBrj1O3wrwB206Di0LA
	 bhE08yZ0bVB9jWqFHs5sAb97Xh4wWWJf62xG7a6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Wojciech Drewek <wojciech.drewek@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 300/957] crypto: qat - fix compression instance leak
Date: Wed, 20 May 2026 18:13:03 +0200
Message-ID: <20260520162141.038689838@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 795c24c677c7a1c12f5768daf22a874a2890662f ]

qat_comp_alg_init_tfm() acquires a compression instance via
qat_compression_get_instance_node() before calling qat_comp_build_ctx()
to initialize the compression context. If qat_comp_build_ctx() fails, the
function returns an error without releasing the compression instance,
causing a resource leak.

When qat_comp_build_ctx() fails, release the compression instance with
qat_compression_put_instance() and clear the context to avoid leaving a
stale reference to the released instance.

The issue was introduced when build_deflate_ctx() (which always returned
void) was replaced by qat_comp_build_ctx() (which can return an error)
without adding error handling for the failure path.

Fixes: cd0e7160f80f ("crypto: qat - refactor compression template logic")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
index 8b123472b71cc..4273a0ecb6c80 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
@@ -133,7 +133,7 @@ static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
 	struct qat_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct qat_compression_instance *inst;
-	int node;
+	int node, ret;
 
 	if (tfm->node == NUMA_NO_NODE)
 		node = numa_node_id();
@@ -146,7 +146,13 @@ static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 		return -EINVAL;
 	ctx->inst = inst;
 
-	return qat_comp_build_ctx(inst->accel_dev, ctx->comp_ctx, QAT_DEFLATE);
+	ret = qat_comp_build_ctx(inst->accel_dev, ctx->comp_ctx, QAT_DEFLATE);
+	if (ret) {
+		qat_compression_put_instance(inst);
+		memset(ctx, 0, sizeof(*ctx));
+	}
+
+	return ret;
 }
 
 static void qat_comp_alg_exit_tfm(struct crypto_acomp *acomp_tfm)
-- 
2.53.0



