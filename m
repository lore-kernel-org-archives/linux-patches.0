Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A231E3C6A5C;
	Sat, 17 Oct 2026 18:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260830; cv=none; b=vB5Ds1ndi9Hjk1lEO+CB9pEEJWD2teGcXJRFh/hoMHXAyA+eetFdKSTLwalm2R3Lllc4C2BsKCl4Muu1rSkk7oGMv9E0ieWHyXObI3HaZ+v4aGRuAbKtu7YRRRA86XDywLBTSIE2Uxrycq08lXsrxDAuBLuXqPZ8emukSUw926Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260830; c=relaxed/simple;
	bh=4i5qKYQnkkPW4o0OQUdipqzL3CqPsuI4cKZupTDbQtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7KjKMyj1inDYy0PWiIUXnEoAZcayw6K8FpGibXpjvHm6JCMQvZGviXtwJWFzhUzDo583RnNbmyaVNSZxBQDCBJdSWUl2f5OhxX+1zLyv2kd8io/9t45YYvffv8nX0waWQCxfUftHiiufRan4WV+0yjVw4N33dlHakUVkfiwf/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAWY5i7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAWY5i7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4871F000C4;
	Sat, 17 Oct 2026 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260829;
	bh=zbvpOsuGIH/hKO9E4QdiWIYTNAYTlPxYk7zUuaxOrpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAWY5i7vG+L0gh+n6doJeJmebadfzkFTvJn0UTy7uh15k08mLAKIu811gmwNMENLE
	 ReFc+w5rfW632l7q8r7HjPXS+muhDTWidq0jSwp1CGAjz9KZvFtMUVfEVCew4bBY9e
	 K8kn3aNvtHxgQT3GCTxXL2+ksMHrrGsR1qeUtPXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1634/1674] bpf: Dont predict JMP32 pointer vs zero comparisons
Date: Sat, 17 Oct 2026 18:05:06 +0200
Message-ID: <20261017160513.022955446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit e51179a4e09846f8fd0f26a05068520de2b301bf ]

Consider the following program:

        r1 = map_value;      /* low 32 bits are zero at runtime */
        r6 = 0xdead000000000000;
        if w1 != 0 goto l1;
    l0: r1 += r6;
        r2 = *(u64 *)(r1 + 0);
        exit;
    l1: r6 = 0;
        goto l0;

At the moment is_branch_taken() reports the jump as always taken,
because it does not distinguish between BPF_JMP and BPF_JMP32
comparisons when processing 'if w1 != 0 ...'.

Fixes: cac616db39c2 ("bpf: Verifier track null pointer branch_taken with JNE and JEQ")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260904083325.2083493-5-eddyz87@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 824b5b2b1d9de..700f14ccf3be8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14273,6 +14273,13 @@ static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg
 	if (__is_pointer_value(false, reg1) || __is_pointer_value(false, reg2)) {
 		u64 val;
 
+		/*
+		 * The low 32 bits of a valid pointer may well be zero, hence
+		 * nothing below applies to a 32-bit comparison.
+		 */
+		if (is_jmp32)
+			return -1;
+
 		/* arrange that reg2 is a scalar, and reg1 is a pointer */
 		if (!is_reg_const(reg2, is_jmp32)) {
 			opcode = flip_opcode(opcode);
-- 
2.53.0



