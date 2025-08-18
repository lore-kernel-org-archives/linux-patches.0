Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401243074AE;
	Mon, 18 Aug 2025 13:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522257; cv=none; b=rznwVPYW+QR0j6H4L1Gmd5XSw5rI7+i/KdUp2Iusl/maTb/VSSC4g1QJ314ZSW+BnnM3i2z41B49feqIePOqKgSQiW+yEJpaaMdh0Gjwhjk8Woa3AQiPqW+1+UIYtXRHkcxIUWgfQREEN6pEEMKG2F+B2dJlLK6WPDSyS7zYT/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522257; c=relaxed/simple;
	bh=W6phNebxqOv6Pp0d3mkEZh16lGMIrqadZ7R63KzgFG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD7c/4mXLaIzwlMTZjhrO40zxMkd3lYbT28eAJ+Ig1WmjpiVHtZpQGRqiHw5Xa7Anygii3bJKy2vEVhMjc42iXwAHNAIO4u4rpnz3FwDH1Vgz0pwHaTegLvsbLQztxgHJlXlCkiOveB9a5O3xEx1/2R5my6QkhfheKeBO1XoDt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvS3Rnzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvS3Rnzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A162CC4CEEB;
	Mon, 18 Aug 2025 13:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522257;
	bh=W6phNebxqOv6Pp0d3mkEZh16lGMIrqadZ7R63KzgFG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvS3Rnzolr/rCe9YjgfFAh5WipK45o2tyx9MPUfAbBtv6hHAuTqbgzxWUzmEAUfR2
	 WCATTRA+t6w1kNF+K/UidbY4RP7JXG6cret577sOMbG9YGbm5/bEoJKyJlf2k4z0Ks
	 cA1WvkOIet1nNmLYan0usOC2HKvuHAHqqTIXG9h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <isolodrai@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/444] bpf: Make reg_not_null() true for CONST_PTR_TO_MAP
Date: Mon, 18 Aug 2025 14:44:49 +0200
Message-ID: <20250818124458.686453061@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b880dea7d858..24ae8f33e5d7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -400,7 +400,8 @@ static bool reg_not_null(const struct bpf_reg_state *reg)
 		type == PTR_TO_MAP_KEY ||
 		type == PTR_TO_SOCK_COMMON ||
 		(type == PTR_TO_BTF_ID && is_trusted_reg(reg)) ||
-		type == PTR_TO_MEM;
+		type == PTR_TO_MEM ||
+		type == CONST_PTR_TO_MAP;
 }
 
 static struct btf_record *reg_btf_record(const struct bpf_reg_state *reg)
diff --git a/tools/testing/selftests/bpf/progs/verifier_unpriv.c b/tools/testing/selftests/bpf/progs/verifier_unpriv.c
index 7ea535bfbacd..e4ef82a6ee38 100644
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



