Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67169322DB7;
	Tue, 21 Jul 2026 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653397; cv=none; b=am4Ka8RprRvaOhiiSz7UyhuppiqjN35NJfum8NeXsRGed0UThhqJOovl6Sx/Q7SO4t1YaIhRjUGK7+0uOrIYNR7h8qDorR5CurglCDdPydQNU05zh27KLrysZIxFNqVHTS5KvFRFUzIt+yQbWZSY77FEti3ul7WDYEE58F0gW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653397; c=relaxed/simple;
	bh=+EB6wZmSsBEUGhXJcXt0Nhzhqt2aVvKZ3VWrDheKRd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VorPAxWnJ5uIPSV9pLzJcAvrHmAaCIagaQaFo/l5ccU5zfBYjexpYUG9xr1gg7PpeyOUwlfc1f1S01L+iRNm3GNvwlapzu3EP0evyeAnB+hcuhVmWOETt8uDnxtD2mNIgSGcbmvFksU94LqBGpTYYhrxHD6pJDSZ3hEb7w+5Dn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJRPS3aT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJRPS3aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4EF1F000E9;
	Tue, 21 Jul 2026 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653396;
	bh=ofDs5IjxX3ZLg9zYY09tP1+XxEu9zaHtpV0hWLdFLAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJRPS3aTqF6TGfReaOqBTLi9bqicqXLNen4lW79Lu3P4olDYC2K5sZbvI2/UGgxVO
	 cOOrqOlqqatY6k5wCA4BohLMZAmUsmlGgvxAsya2iJl80siuRPOyTa7bWmQn9AeMhH
	 Fw19MZ/6l8xP5rVuOSRMHGCq6pSaGI74ihiII0l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1311/2077] bpf: Fix insn_aux_data leak on verifier err_free_env path
Date: Tue, 21 Jul 2026 17:16:24 +0200
Message-ID: <20260721152623.742845050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit 26490a375cb9be9bac96b5171610fd85ca6c2305 ]

When bpf_check() allocates env->insn_aux_data successfully but later
fails to allocate env->succ, it jumps directly to err_free_env.

The existing vfree(env->insn_aux_data) sits before the err_free_env
label, so that direct jump bypasses it and leaks insn_aux_data.

Move vfree(env->insn_aux_data) into err_free_env so all early and late
exit paths release it consistently.

Fixes: 2f69c5685427 ("bpf: make bpf_insn_successors to return a pointer")
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Reviewed-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260624123536.114757-1-kafai.wan@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bda2b2f149468b..e3a4fdc8acd929 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20221,13 +20221,13 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr, __u3
 	if (!is_priv)
 		mutex_unlock(&bpf_verifier_lock);
 	bpf_clear_insn_aux_data(env, 0, env->prog->len);
-	vfree(env->insn_aux_data);
 err_free_env:
 	bpf_stack_liveness_free(env);
 	kvfree(env->cfg.insn_postorder);
 	kvfree(env->scc_info);
 	kvfree(env->succ);
 	kvfree(env->gotox_tmp_buf);
+	vfree(env->insn_aux_data);
 	kvfree(env);
 	return ret;
 }
-- 
2.53.0



