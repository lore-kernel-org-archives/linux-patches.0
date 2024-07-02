Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B06BE5A;
	Tue,  2 Jul 2024 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940745; cv=none; b=HgQAm7kZJ+cspMi0e3WnqhF5E5cVC8NsHvVgH5qvmtA+Y0u4gDZq+LY3ZGhdPhyFLEYfswfOuOErdVtuj9BRwCkuzxf7B/NjBqrOxjbPOV1J5yfiO/cnzOiWGdO0pYhDrJ6Q5HjtO9YU1R1rZ3xeL//gEwa2WcCWun6eTXtnKac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940745; c=relaxed/simple;
	bh=qGE/k/euiXx/17BStPI8qNorQ/JySKVjZq0jbgKm05Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEk0RnmMDEJYCuh7byK/9WJzB7eiL2CME8im92As3G7EIf0Hufn3TIpqEkurmUVGU0Ko05rN7/zwRKCoYuq8q3wLatq24UN97FufYNJ3aUg9yDq5lMb29quWhVOiFoe8pABIMWYkaVyGtsG00+2P8g7Ahb12YtccE0nDTF9EyHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zwh//HIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zwh//HIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885BEC116B1;
	Tue,  2 Jul 2024 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940745;
	bh=qGE/k/euiXx/17BStPI8qNorQ/JySKVjZq0jbgKm05Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zwh//HIJUDy5CGJrurkSBcv7VQY727M8b4+qNCMS4mmkxayXnqgSp2wwlxA9JSCIk
	 sI3GsA4ndyuOE8eWHv2JfnPzOb9LeW/DZcoddVMkg5ClOW5dZ2YP+MOC8/coAls6mY
	 ZpaJNP4YY4mSCFSHcOwgbQ8fWw1W+Qh1xRW1RoH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/163] bpf: Add missed var_off setting in coerce_subreg_to_size_sx()
Date: Tue,  2 Jul 2024 19:02:17 +0200
Message-ID: <20240702170233.936341721@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 44b7f7151dfc2e0947f39ed4b9bc4b0c2ccd46fc ]

In coerce_subreg_to_size_sx(), for the case where upper
sign extension bits are the same for smax32 and smin32
values, we missed to setup properly. This is especially
problematic if both smax32 and smin32's sign extension
bits are 1.

The following is a simple example illustrating the inconsistent
verifier states due to missed var_off:

  0: (85) call bpf_get_prandom_u32#7    ; R0_w=scalar()
  1: (bf) r3 = r0                       ; R0_w=scalar(id=1) R3_w=scalar(id=1)
  2: (57) r3 &= 15                      ; R3_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=15,var_off=(0x0; 0xf))
  3: (47) r3 |= 128                     ; R3_w=scalar(smin=umin=smin32=umin32=128,smax=umax=smax32=umax32=143,var_off=(0x80; 0xf))
  4: (bc) w7 = (s8)w3
  REG INVARIANTS VIOLATION (alu): range bounds violation u64=[0xffffff80, 0x8f] s64=[0xffffff80, 0x8f]
    u32=[0xffffff80, 0x8f] s32=[0x80, 0xffffff8f] var_off=(0x80, 0xf)

The var_off=(0x80, 0xf) is not correct, and the correct one should
be var_off=(0xffffff80; 0xf) since from insn 3, we know that at
insn 4, the sign extension bits will be 1. This patch fixed this
issue by setting var_off properly.

Fixes: 8100928c8814 ("bpf: Support new sign-extension mov insns")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240615174632.3995278-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 291bda5ef5526..171045b6956d9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6204,6 +6204,7 @@ static void coerce_subreg_to_size_sx(struct bpf_reg_state *reg, int size)
 		reg->s32_max_value = s32_max;
 		reg->u32_min_value = (u32)s32_min;
 		reg->u32_max_value = (u32)s32_max;
+		reg->var_off = tnum_subreg(tnum_range(s32_min, s32_max));
 		return;
 	}
 
-- 
2.43.0



