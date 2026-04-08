Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E501A3D890F;
	Wed,  8 Apr 2026 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674508; cv=none; b=iIuXJfPvp2Q4kq6FRO+mAUltxCIr/7s1iel1kvof3lnWQUKJHsXUEMmABwP58T2mBSllkSDVedbus8ENh0+HAhvGGK93wnwb/isUsCNsRxE0AaALwD5O5R6khMnk7uKbvzPhHcMUz/db7tWJOZFQS70bYaGa98TfHgeXpV/b5Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674508; c=relaxed/simple;
	bh=IHKAtkxbcCEZI2rvMJSSQFHEir2gyBfgMdHyq8JxVAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqV9InB5jE/Km6IH3BOwqfzQ7MPUVpqVtpU90ql/CXWUzAZmnZmUntd5Tpa39solYe7nIa2iiObTRfspXyWcdL9D42g1Bw/+VcRGantaxdcVwA8xj6oxIrXEx9R8K/vCzevrbZuVRu5lXxSsRhKn0A0M0Rnay92aalZWiHaGfQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqwpL+7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqwpL+7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A700C19421;
	Wed,  8 Apr 2026 18:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674507;
	bh=IHKAtkxbcCEZI2rvMJSSQFHEir2gyBfgMdHyq8JxVAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqwpL+7nP2/P6p9VdF+VTyjxG7oL8Hpgm/EYLPhYCDrz7Car9VupUxw0SJC58/CTc
	 C7bg9pT8ezSEQUpoxPR5X33YsVwIfSF4nQ5cWdEQgYrGwFwUrp87RhNc/cj3UX3bL9
	 7FGsqzlTFkRqDTRediSZO6uiEapqFugpxzLCve5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 124/311] bpf: reject direct access to nullable PTR_TO_BUF pointers
Date: Wed,  8 Apr 2026 20:02:04 +0200
Message-ID: <20260408175944.046542201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 11fe83d6109d7..0aea870b87a6c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7806,7 +7806,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
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



