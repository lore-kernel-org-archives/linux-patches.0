Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93C31A285;
	Wed,  8 Apr 2026 18:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673820; cv=none; b=DP0G/tqonnjdtyJ48f9MTRX6YbknMhN7zYDNH1bu9QdqFWpBiJbMobsemE3Ma5qtGRQsHNV/AQw4muonghvLlu/34JGd96cg8RvzII8m49YnoQhBVYfa83A4i5HDkVcLWh5CQRmAW1qZvQdDfr2KzSmGnh7HKF42URcgLkcDTjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673820; c=relaxed/simple;
	bh=nbrH7GJ1RLqfbA4U/lZAPWXa1drhCgbN1oXbWrR5uLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoxjTqCZaf0bz4cOMI2qJtMUEmeyiMrclfvVvmpfs6SSqZr49ZbrF1R9CQpEZJmzuBhLntkHmA2R1pel9GueA8SXJQSEEohnfdHSMHu6GJbsRTTqoaJZFW7rA9kkqlqMmw9fB44xgfD8ftpZCP7neiaHTcIqjwZbEYPVCk9NEUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ia52a8I3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ia52a8I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E299C2BC87;
	Wed,  8 Apr 2026 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673820;
	bh=nbrH7GJ1RLqfbA4U/lZAPWXa1drhCgbN1oXbWrR5uLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ia52a8I3DHW2ax1J17Zn7JtZIapvHqR7ZJdvCQtX8jGhGnHDBBgVcTkv7ZDg3QSPp
	 BPfr/GGGx9jsoO9nOS0IvTMufdTOniIOI/wlnzJ4AofhOKCYZ0ZksxaMplPV76/HyX
	 2HrhQtDHwiA/ZsAbRzUPTHOlBDd8XBCH5RmDXy1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/242] bpf: reject direct access to nullable PTR_TO_BUF pointers
Date: Wed,  8 Apr 2026 20:02:21 +0200
Message-ID: <20260408175930.865623256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Tang <tpluszz77@gmail.com>

[ Upstream commit b0db1accbc7395657c2b79db59fa9fae0d6656f3 ]

check_mem_access() matches PTR_TO_BUF via base_type() which strips
PTR_MAYBE_NULL, allowing direct dereference without a null check.

Map iterator ctx->key and ctx->value are PTR_TO_BUF | PTR_MAYBE_NULL.
On stop callbacks these are NULL, causing a kernel NULL dereference.

Add a type_may_be_null() guard to the PTR_TO_BUF branch, matching the
existing PTR_TO_BTF_ID pattern.

Fixes: 20b2aff4bc15 ("bpf: Introduce MEM_RDONLY flag")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260402092923.38357-2-tpluszz77@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9bdc19587948c..ff16bc2bff589 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7224,7 +7224,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 	} else if (reg->type == CONST_PTR_TO_MAP) {
 		err = check_ptr_to_map_access(env, regs, regno, off, size, t,
 					      value_regno);
-	} else if (base_type(reg->type) == PTR_TO_BUF) {
+	} else if (base_type(reg->type) == PTR_TO_BUF &&
+		   !type_may_be_null(reg->type)) {
 		bool rdonly_mem = type_is_rdonly_mem(reg->type);
 		u32 *max_access;
 
-- 
2.53.0



