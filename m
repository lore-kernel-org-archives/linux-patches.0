Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4297E320CD0;
	Mon, 18 Aug 2025 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523938; cv=none; b=PjPClkpVr/nVaHnqCnJcmx31gmhzbR0s55WM4ES3aeNKzxhVm90LTYoFeMSBMHVhEZbpZcxDe/8XbD6u62JxYBRAWDt1eZ0jxO9eGqNUce1Dc+dkcDJKhMB048gP29cSpKPE7PsWh06xRQgvEfyny71lbczzCZpDnj9CBO8Uo6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523938; c=relaxed/simple;
	bh=2yfZs2wOtBbK1KJmzEpXaGBBYcazQ7dh7AXqqLxPikk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqCv7eTq4jj8XBhogsRFALso71ga4vxfl08gLSICJyct/EiQMrIXrKPOMOV63bKwaPumU1I2GvTy5ClUREdLU0XoVokW/bYXgtPUFBqJKdzjz2+pvob/N7cDjuS5oZQCs6yGGKdFP5Qy2+j5hKH/csnFXG/xl2XvzhtCzlxGTsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyUEti+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyUEti+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6466C4CEEB;
	Mon, 18 Aug 2025 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523938;
	bh=2yfZs2wOtBbK1KJmzEpXaGBBYcazQ7dh7AXqqLxPikk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyUEti+tHbnep5D8P9u+z4is/m0r6oqywwEq7O6tPEKHizftv7AevzaqlWdTudmMt
	 lmfCAZI04yLKAdJYGOwbnshwfUa8JN2J98QjOP5sG5obsWAF0PjZzvNY6CEs7inAXB
	 h5An/GINkAEWcXpjEKcyZGDY32lmVpHvJNHHcd0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <isolodrai@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 318/515] bpf: Make reg_not_null() true for CONST_PTR_TO_MAP
Date: Mon, 18 Aug 2025 14:45:04 +0200
Message-ID: <20250818124510.675253944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <isolodrai@meta.com>

[ Upstream commit 5534e58f2e9bd72b253d033ee0af6e68eb8ac96b ]

When reg->type is CONST_PTR_TO_MAP, it can not be null. However the
verifier explores the branches under rX == 0 in check_cond_jmp_op()
even if reg->type is CONST_PTR_TO_MAP, because it was not checked for
in reg_not_null().

Fix this by adding CONST_PTR_TO_MAP to the set of types that are
considered non nullable in reg_not_null().

An old "unpriv: cmp map pointer with zero" selftest fails with this
change, because now early out correctly triggers in
check_cond_jmp_op(), making the verification to pass.

In practice verifier may allow pointer to null comparison in unpriv,
since in many cases the relevant branch and comparison op are removed
as dead code. So change the expected test result to __success_unpriv.

Signed-off-by: Ihor Solodrai <isolodrai@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250609183024.359974-2-isolodrai@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                               | 3 ++-
 tools/testing/selftests/bpf/progs/verifier_unpriv.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bdeed2a24910..ef6c108c468d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -404,7 +404,8 @@ static bool reg_not_null(const struct bpf_reg_state *reg)
 		type == PTR_TO_MAP_KEY ||
 		type == PTR_TO_SOCK_COMMON ||
 		(type == PTR_TO_BTF_ID && is_trusted_reg(reg)) ||
-		type == PTR_TO_MEM;
+		type == PTR_TO_MEM ||
+		type == CONST_PTR_TO_MAP;
 }
 
 static struct btf_record *reg_btf_record(const struct bpf_reg_state *reg)
diff --git a/tools/testing/selftests/bpf/progs/verifier_unpriv.c b/tools/testing/selftests/bpf/progs/verifier_unpriv.c
index a4a5e2071604..28200f068ce5 100644
--- a/tools/testing/selftests/bpf/progs/verifier_unpriv.c
+++ b/tools/testing/selftests/bpf/progs/verifier_unpriv.c
@@ -619,7 +619,7 @@ __naked void pass_pointer_to_tail_call(void)
 
 SEC("socket")
 __description("unpriv: cmp map pointer with zero")
-__success __failure_unpriv __msg_unpriv("R1 pointer comparison")
+__success __success_unpriv
 __retval(0)
 __naked void cmp_map_pointer_with_zero(void)
 {
-- 
2.39.5



