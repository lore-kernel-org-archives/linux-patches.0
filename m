Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBBF14A8F
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8F5C433C9;
	Mon, 26 Jun 2023 18:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804232;
	bh=kjAs3uNrcpoquvQF9SG/ET2HZQJe9FtqFzmbBllLA2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzvyY2bjwc2/6CVsoQCRiLhigxov1NwzbMzpQkRaCpR/8qAWzX8KXXdDC4Kx7dcjM
	 JBIdybOaY13GKTGdw2IN2KrommEPCWzG/yW9rVZ9zR/oqt2Rc6axAzS6xPxTktE7Hx
	 yC/zFIXZlf2wNL/HcOqokty1Vk/0OuXuXtLxAv98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxim@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>,
	Sasha Levin <sashal@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.1 087/170] bpf: Fix verifier id tracking of scalars on spill
Date: Mon, 26 Jun 2023 20:10:56 +0200
Message-ID: <20230626180804.466751339@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Mikityanskiy <maxim@isovalent.com>

[ Upstream commit 713274f1f2c896d37017efee333fd44149710119 ]

The following scenario describes a bug in the verifier where it
incorrectly concludes about equivalent scalar IDs which could lead to
verifier bypass in privileged mode:

1. Prepare a 32-bit rogue number.
2. Put the rogue number into the upper half of a 64-bit register, and
   roll a random (unknown to the verifier) bit in the lower half. The
   rest of the bits should be zero (although variations are possible).
3. Assign an ID to the register by MOVing it to another arbitrary
   register.
4. Perform a 32-bit spill of the register, then perform a 32-bit fill to
   another register. Due to a bug in the verifier, the ID will be
   preserved, although the new register will contain only the lower 32
   bits, i.e. all zeros except one random bit.

At this point there are two registers with different values but the same
ID, which means the integrity of the verifier state has been corrupted.

5. Compare the new 32-bit register with 0. In the branch where it's
   equal to 0, the verifier will believe that the original 64-bit
   register is also 0, because it has the same ID, but its actual value
   still contains the rogue number in the upper half.
   Some optimizations of the verifier prevent the actual bypass, so
   extra care is needed: the comparison must be between two registers,
   and both branches must be reachable (this is why one random bit is
   needed). Both branches are still suitable for the bypass.
6. Right shift the original register by 32 bits to pop the rogue number.
7. Use the rogue number as an offset with any pointer. The verifier will
   believe that the offset is 0, while in reality it's the given number.

The fix is similar to the 32-bit BPF_MOV handling in check_alu_op for
SCALAR_VALUE. If the spill is narrowing the actual register value, don't
keep the ID, make sure it's reset to 0.

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Andrii Nakryiko <andrii@kernel.org> # Checked veristat delta
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20230607123951.558971-2-maxtram95@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4ceb4166528b..49c6b5e0855cd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3128,6 +3128,9 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 				return err;
 		}
 		save_register_state(state, spi, reg, size);
+		/* Break the relation on a narrowing spill. */
+		if (fls64(reg->umax_value) > BITS_PER_BYTE * size)
+			state->stack[spi].spilled_ptr.id = 0;
 	} else if (!reg && !(off % BPF_REG_SIZE) && is_bpf_st_mem(insn) &&
 		   insn->imm != 0 && env->bpf_capable) {
 		struct bpf_reg_state fake_reg = {};
-- 
2.39.2



