Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012EB36D51C;
	Tue,  6 Jan 2026 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722392; cv=none; b=nk/GKMsDOxTcfZiLSJh8JWKz6wY55j8PaF8g0QjWqHeIfDrVaEcS5NuiVT8E0qbbOmnwtz2F+3kBxiTvtOOBzQXf2M87J1VggoUCMbBTxlC7XifvNFIZLWrNqkPaVKd9DoILimlXjlC0xtnzJvl2o2y5VF3bl4NIFqKh227BNi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722392; c=relaxed/simple;
	bh=5SqM0PuscAmXQpy2KR778QvJoTml+N0Y9t0qij1V7Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hASUpbzHfbFYvEshtyJm7uzkzLjuUfjzc7MGR6NuGJpl77nKMKUp0SuRfdyhJXWnF7ng2k8lIQcPf0faOoCjP578n0IeQnw4WjRBU8dvHRcCCyQUFEMOVNOhSheCOMV7LO+cdDCQz22bFKjxHOdfgtn1RnP5j3nOr66ze+LtiHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gYiwH+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gYiwH+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23384C116C6;
	Tue,  6 Jan 2026 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722391;
	bh=5SqM0PuscAmXQpy2KR778QvJoTml+N0Y9t0qij1V7Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gYiwH+mhLMqociLzppLnqIxPjUdp1hYYEje88sYbbF65WvBkBZA/YHU0gaKgxHQI
	 +2GbeJA4YDLE7eFtaAAo6K+6T4y3kRqBYAeSo0eDF0+IXiXhax5Bga7K+WDBhFcXnG
	 hlmMWkdMhK4nlkLPlIxQrZV9rkjL/dOdjpKTq76c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 250/312] LoongArch: BPF: Adjust the jump offset of tail calls
Date: Tue,  6 Jan 2026 18:05:24 +0100
Message-ID: <20260106170556.893504306@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Chenghao Duan <duanchenghao@kylinos.cn>

commit 61319d15a56093358c6822d30659fe2941f589f1 upstream.

Call the next bpf prog and skip the first instruction of TCC
initialization.

A total of 7 instructions are skipped:
'move t0, ra'			1 inst
'move_imm + jirl'		5 inst
'addid REG_TCC, zero, 0'	1 inst

Relevant test cases: the tailcalls test item in selftests/bpf.

Cc: stable@vger.kernel.org
Fixes: 677e6123e3d2 ("LoongArch: BPF: Disable trampoline for kernel module function trace")
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -239,7 +239,7 @@ static void __build_epilogue(struct jit_
 		 * Call the next bpf prog and skip the first instruction
 		 * of TCC initialization.
 		 */
-		emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_T3, 6);
+		emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_T3, 7);
 	}
 }
 


