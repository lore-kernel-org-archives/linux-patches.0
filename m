Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581DE1ACEDE;
	Tue, 26 Aug 2025 12:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213069; cv=none; b=sWLoauaaPOW4/SF+uQ4Ue7CYY06YblpLGYJNlHui3ECBfv+v1qdX8Y9k2XzXn3Irg9Fos28PWGGdThRLm7lUA2jz54agCGYifxaI8VudDp4rZO1SnIesV30W9XMh3krMBEL3RMyhU1Y4Wy5jSoWt56eE0HoEqTCE/loQ+vinfUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213069; c=relaxed/simple;
	bh=SSHR8omCJ3ZqFae/j5ZlnPsLx7LobKpvJrk3Teh6XOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdtTMwJZHV9k2ddNqNdmr35ySdv7exa5gdZoJgix0gWzcJu2h1ehE8uN10KQT66KxivukXi5jn4DujgERQBMDMBpGF7iPMrPajMTnP/pvy9p5MwUNr1UIw9JdFLnOpfLfLX4L0pUyfQp2HthdLo1VghcA5QoBBOqYSh9khZxUWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szCjlizh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szCjlizh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05DBC4CEF1;
	Tue, 26 Aug 2025 12:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213069;
	bh=SSHR8omCJ3ZqFae/j5ZlnPsLx7LobKpvJrk3Teh6XOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szCjlizhsv0+jXMww2oUeDOT6FNwW+dDzLnPZPFCiZ1TXTjVwq2NjFwpCk59refXs
	 PMqA//rwUM9WVh4V8E1XwmzfBHnhEZja2PG3e3faaIy1An/IhjV7Zmm/UISXSM25BH
	 m23EIpipf0u9PZrOjsvp+AmdcPtWFyycf9SEmYtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <isolodrai@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/587] bpf: Make reg_not_null() true for CONST_PTR_TO_MAP
Date: Tue, 26 Aug 2025 13:05:58 +0200
Message-ID: <20250826110958.254390301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1f9ae600e445..7d6ee41f4b4f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -460,7 +460,8 @@ static bool reg_not_null(const struct bpf_reg_state *reg)
 		type == PTR_TO_MAP_KEY ||
 		type == PTR_TO_SOCK_COMMON ||
 		(type == PTR_TO_BTF_ID && is_trusted_reg(reg)) ||
-		type == PTR_TO_MEM;
+		type == PTR_TO_MEM ||
+		type == CONST_PTR_TO_MAP;
 }
 
 static bool type_is_ptr_alloc_obj(u32 type)
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



