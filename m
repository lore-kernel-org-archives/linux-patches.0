Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A65643DA26;
	Thu, 30 Jul 2026 15:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426791; cv=none; b=PmXABP/DKddanA1o4We2S1lQiQfajlrPqBD7852NfBVdgrGoHUrEqdDiQdJfkt3T/B/MjM5k/lCMPd92f9XqLyvzGdVTbHy7zMkQPr9fanb4zb5NdKQa6eROlyQBt3i+Kn0t2YajZQiBjINClIfq8kNW7jtyOa1iJoSuK0Qrlxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426791; c=relaxed/simple;
	bh=XIzmeEOQX2FMNHLIphkz9OHzmRFr0UO5On/vDCcDATY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF6/Zx3B789htFemHGQsNgoAUqLxYwb7m3K1fzQTGWU42Sp0oMOd9bvLuWdJhZdxw6F0iPNpvDElWtBc6fTZ1h0SHGbejd2emKNNuQoR3vdnL3f9VZlY/3WtkDDJ27Kd6O+xktnuYNGkvCrwYCMPqkNPSL6UlJ/LLgMS7kGuVnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYSZoL7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYSZoL7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C7C1F000E9;
	Thu, 30 Jul 2026 15:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426789;
	bh=RRpeEXNQUUenb13wvPGurFIal/X47jU2C5arEmZZ9Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYSZoL7vJvYMlVw4vZxZSHdICZAuhTOHaz/kELUsYogJ1b0SDZtH6DdbMHJXc75pc
	 nXTki2zrsAc08PkRdqxKoWvsMbb55PCO6peruOYUvX+X2b03HzxOwORZbzIG0vMGWR
	 eovwA5yR/6jHGFy2Njlmi8bkKOCeml2ctH7MLHcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 543/602] bpf: Reset register bounds before narrowing retval range in check_mem_access()
Date: Thu, 30 Jul 2026 16:15:35 +0200
Message-ID: <20260730141447.438283974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 5e0b273e0a62cc04ec338c7b502797c66c2ed42a ]

When the BPF verifier processes a context load of an LSM hook return
value, it calls __mark_reg_s32_range() to narrow the register to the
hook's valid range. However, __mark_reg_s32_range() intersects the new
range with the register's existing bounds using max_t()/min_t() rather
than replacing them.

If the destination register carries stale bounds from a prior instruction
(e.g. BPF_MOV64_IMM), the intersection can produce a range narrower than
reality. The verifier then believes it knows the register's exact value,
while at runtime the actual hook return value is loaded, creating a
verifier/runtime mismatch that can be used to bypass BPF memory safety
checks.

The else branch already calls mark_reg_unknown() to reset register state
before any narrowing. Apply the same reset in the is_retval path so
stale bounds are cleared before __mark_reg_s32_range() intersects.

Fixes: 5d99e198be27 ("bpf, lsm: Add check for BPF LSM return value")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260622230123.3695446-2-tristmd@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7219,6 +7219,7 @@ static int check_mem_access(struct bpf_v
 			 */
 			if (info.reg_type == SCALAR_VALUE) {
 				if (info.is_retval && get_func_retval_range(env->prog, &range)) {
+					mark_reg_unknown(env, regs, value_regno);
 					err = __mark_reg_s32_range(env, regs, value_regno,
 								   range.minval, range.maxval);
 					if (err)


