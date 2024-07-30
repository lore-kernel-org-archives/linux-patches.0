Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E5B189535;
	Tue, 30 Jul 2024 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357136; cv=none; b=D8/FcoXuA+rMqYduRWHR3my1IUy5I5iJ9BGCTAHE+nk/pq2EPW6A13VZ4cHfARjCmsvqsX4L9C5Dtn/Bv39Ao5ORoqt9vDiCKmJuHU12Ti/nAAoNv2s9uwX8ndiSEdE0YodFImC927OsKyB1SiCl98JZRzEKyHUXSfzR9yq2V+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357136; c=relaxed/simple;
	bh=/GnFvHZ3+oT9tOLeFRwAf9nrDIgHjtC8lJIl0dLdr0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUnuH+hBMKhKXLhBTjWxYleiif54exGikxOJMt0JQEk20/vj2NBZeBGcK1ijeHJNzcGYzq5e+ykdhNLOxi1ZNV1QpFu2i63KeSn+hUOmZWZhq3oDS6gKcuwTdMaaEHQe+SYoXJl6GhGEJExzV5DfSUaagE1oNkE4LSrWf+eb4sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiuHrK9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiuHrK9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D500BC32782;
	Tue, 30 Jul 2024 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357136;
	bh=/GnFvHZ3+oT9tOLeFRwAf9nrDIgHjtC8lJIl0dLdr0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiuHrK9b5THrQ9HLccMCLUfyZ9XCUXcPdtvxcc3d5hgYkX8UyGFlTjcWowXqfnLfn
	 aIjjAd/PNKCxyybX6WFTmQfjcbTzB2UWVXfcLV6ytglLJOW7Fn8S/Vsey0D/0jMlSp
	 9UUilTGf37+2oiH/4w4GmFsQaDCyuCh4hSWgtDaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 221/809] bpf: Fix atomic probe zero-extension
Date: Tue, 30 Jul 2024 17:41:37 +0200
Message-ID: <20240730151733.336647020@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit df34ec9db6f521118895f22795da49f2ec01f8cf ]

Zero-extending results of atomic probe operations fails with:

    verifier bug. zext_dst is set, but no reg is defined

The problem is that insn_def_regno() handles BPF_ATOMICs, but not
BPF_PROBE_ATOMICs. Fix by adding the missing condition.

Fixes: d503a04f8bc0 ("bpf: Add support for certain atomics in bpf_arena to x86 JIT")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240701234304.14336-2-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 214a9fa8c6fb7..e1e08e62a2f2f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3215,7 +3215,8 @@ static int insn_def_regno(const struct bpf_insn *insn)
 	case BPF_ST:
 		return -1;
 	case BPF_STX:
-		if (BPF_MODE(insn->code) == BPF_ATOMIC &&
+		if ((BPF_MODE(insn->code) == BPF_ATOMIC ||
+		     BPF_MODE(insn->code) == BPF_PROBE_ATOMIC) &&
 		    (insn->imm & BPF_FETCH)) {
 			if (insn->imm == BPF_CMPXCHG)
 				return BPF_REG_0;
-- 
2.43.0



