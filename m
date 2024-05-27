Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D117E90E;
	Mon, 27 May 2024 19:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836964; cv=none; b=F9mlLnDTpFVhTcYQ0ttq6JsFdcwO57gntBP/j7PatNYxpl45gxjd/RtOMZV71lIKkUExE7S08TGZKGb8DixPC6jibNCL3NJTbBhV59IewgM6Ym8+iJUmNfz6GxkpjlmSdFoEvlRwZBf2dloxG5+3h3gdzHn58rv/yzulR6Nx9/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836964; c=relaxed/simple;
	bh=d2z3QPmZ24nOmz2Tpv9nCQ2zPQum72eVUxkXyLmqur0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/IEXugQFZyJaALrl6WhiTF2QXRDFxAaSUkuQiYYh/soBETu+toLW2RL6Be23D5iYrYRC6YQsOR6Dkz2idOqcHHaT8zumnRZj77OKpzl9sUbArpJbXo9ZhddSfjzQjTSp53syVcwXaMAE192pYLVlIZPcD2rYoFSdBwi39K/C+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfYjQ4pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfYjQ4pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF15C2BBFC;
	Mon, 27 May 2024 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836964;
	bh=d2z3QPmZ24nOmz2Tpv9nCQ2zPQum72eVUxkXyLmqur0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfYjQ4peTBBlxW5LFkwER/fYKCWgJnmD/9nyihkiBbhJgJXW5+DPHAhynfYo01sv7
	 b5Sam60C/2ZOHZZqW2ID4Xw/qkdX5M47vKMYQ1GrTXsL8VM/1CNXAMUw35i7aijta7
	 HqiACQAekTHQf1d9Nx8njG6O7LACkWL7sxZSW/X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay12@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 256/427] s390/bpf: Emit a barrier for BPF_FETCH instructions
Date: Mon, 27 May 2024 20:55:03 +0200
Message-ID: <20240527185626.404498050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 68378982f0b21de02ac3c6a11e2420badefcb4bc ]

BPF_ATOMIC_OP() macro documentation states that "BPF_ADD | BPF_FETCH"
should be the same as atomic_fetch_add(), which is currently not the
case on s390x: the serialization instruction "bcr 14,0" is missing.
This applies to "and", "or" and "xor" variants too.

s390x is allowed to reorder stores with subsequent fetches from
different addresses, so code relying on BPF_FETCH acting as a barrier,
for example:

  stw [%r0], 1
  afadd [%r1], %r2
  ldxw %r3, [%r4]

may be broken. Fix it by emitting "bcr 14,0".

Note that a separate serialization instruction is not needed for
BPF_XCHG and BPF_CMPXCHG, because COMPARE AND SWAP performs
serialization itself.

Fixes: ba3b86b9cef0 ("s390/bpf: Implement new atomic ops")
Reported-by: Puranjay Mohan <puranjay12@gmail.com>
Closes: https://lore.kernel.org/bpf/mb61p34qvq3wf.fsf@kernel.org/
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20240507000557.12048-1-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 5af0402e94b88..1d168a98ae21b 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1427,8 +1427,12 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 	EMIT6_DISP_LH(0xeb000000, is32 ? (op32) : (op64),		\
 		      (insn->imm & BPF_FETCH) ? src_reg : REG_W0,	\
 		      src_reg, dst_reg, off);				\
-	if (is32 && (insn->imm & BPF_FETCH))				\
-		EMIT_ZERO(src_reg);					\
+	if (insn->imm & BPF_FETCH) {					\
+		/* bcr 14,0 - see atomic_fetch_{add,and,or,xor}() */	\
+		_EMIT2(0x07e0);						\
+		if (is32)                                               \
+			EMIT_ZERO(src_reg);				\
+	}								\
 } while (0)
 		case BPF_ADD:
 		case BPF_ADD | BPF_FETCH:
-- 
2.43.0



