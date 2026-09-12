Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F0D35E92B;
	Sat, 12 Sep 2026 07:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198087; cv=none; b=LhmWREkwOWzOXTY0tt02XG5v0q4QUSUuKDhw7NmbDX6geHT+pG3cJOrYe4qvKrQeQNPXyzml8UtnVTyA/QZAEVqYBsMlxEXkASuRbjDuO7PPK/xaDXgMg2UMLkVYofXzz5NF2bS8WhQbzJ+aQc6FvyOnLPJH+0npR9xsaGY4/84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198087; c=relaxed/simple;
	bh=CGM+cWhandlBu31eVd1j8hGAdQjBw4e7ynhsvJI2XxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AI2qc1M5xStlixdiAAcgzVloIXLMhLrJRZbnn5IEj4m+JWXM2tQ7HUoAmpGffab/e/InGaa/P1tJ7WjgrQqINj3PqTZbNPvY3EZuKpWNULoe0rIpY3wcDky+meVCq2yrEzlSmFdeFQ2Bcd52q8pM2oPPiR4TjCycPOfo2tB1tUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqGuMf1s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqGuMf1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164621F000FF;
	Sat, 12 Sep 2026 07:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198085;
	bh=a6mY8yabhLDsMhUKL7KbwVsnQaWgZAiMYiopr0dsFGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqGuMf1sJnUCeJl0qsIU8/V7InvaijGVETSMuiQSGuSdSwX0uVcdDfPyoVVOGd/5h
	 rbmIsWmBnbs/sclzsGjCvDNl7lvlRHc7tafXx0+K/8L97uhfMVBXv9wZU3hwGoRFDb
	 zbxFODlFdIhxrDl6hgrIF3FIRrn3/Sf30pToMy9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0307/1815] bpf: Drop scalar id on sign-extending narrowing stack fills
Date: Sat, 12 Sep 2026 08:34:17 +0200
Message-ID: <20260912065656.153595974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 2cb5f4ca695ebe552647e5ba4aad6934d6a43bae ]

When a spilled scalar is filled back with a sign-extending narrowing load
(BPF_MEMSX), check_stack_read_fixed_off() copies the spilled register
including its scalar id, but coerce_reg_to_size_sx() then sign-extends the
filled register's value. If the same slot is also filled with a plain
zero-extending load (BPF_MEM), both destination registers share the id yet
hold different values. A later 'if <zext-reg> == const' then refines the
sign-extended register through sync_linked_regs() to a value it does not
have at runtime (e.g. the verifier believes 0x80000000 while the register
is 0xffffffff80000000), which can be turned into an out-of-bounds access.

Drop the shared scalar id at the sign-extension site in check_mem_access()
when sign extension actually changes the value, mirroring the BPF_MOVSX
handling in check_alu_op() (no_sext = reg_umax < 2^(size*8-1)).

Fixes: 3cd5c890652b ("bpf: Let the verifier assign ids on stack fills")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 283fdf6e2f28f..a3b66adbc83c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6328,11 +6328,23 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, struct b
 
 	if (!err && size < BPF_REG_SIZE && value_regno >= 0 && t == BPF_READ &&
 	    regs[value_regno].type == SCALAR_VALUE) {
-		if (!is_ldsx)
+		if (!is_ldsx) {
 			/* b/h/w load zero-extends, mark upper bits as known 0 */
 			coerce_reg_to_size(&regs[value_regno], size);
-		else
+		} else {
+			/*
+			 * Sign-extension can change the register value relative
+			 * to a scalar it is linked with by id (e.g. a zero-
+			 * extending fill of the same spilled stack slot), thus
+			 * drop the shared id in that case.
+			 */
+			bool no_sext = reg_umax(&regs[value_regno]) <
+					(1ULL << (size * BITS_PER_BYTE - 1));
+
 			coerce_reg_to_size_sx(&regs[value_regno], size);
+			if (!no_sext)
+				clear_scalar_id(&regs[value_regno]);
+		}
 	}
 	return err;
 }
-- 
2.53.0



