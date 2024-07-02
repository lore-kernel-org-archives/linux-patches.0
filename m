Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23471BE23E;
	Tue,  2 Jul 2024 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939993; cv=none; b=XelxGGwBxzT8plGULg19YrxFtzPccGrvNDuYrfdy8Ki8YE3hNGZbhJ7z+/9TJ/p/kSuLZZWqavJjIJwHVXjSfLwnbVPQUyEhupBFkglPIl64UHKkxhq6Yw5/Ij07CJhBgZUlQ/5QsYMr3w56S0Borc8bIFiM9C6SENb//Emt7N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939993; c=relaxed/simple;
	bh=/XKiYV7rSAUGX0pMT+Yy6ozpO3xa7B4+uasdpCGJ9Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/76dr6KqNS1QrvJS2mDToXzaO9GrB5UVEdAgfbRHchhSaCYNauQciQ5/9HV9LyKhC4Ax9ma505K0VDHs953zoixvztdK1SuYNx/HwWqFmb56x5CU4AZyidB6gQoLZaO30hQIV8HdJtVClDf0MDmwZ8hZmtNovxoXZnDo+ngfyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZCxoXnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZCxoXnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531D6C4AF07;
	Tue,  2 Jul 2024 17:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939993;
	bh=/XKiYV7rSAUGX0pMT+Yy6ozpO3xa7B4+uasdpCGJ9Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZCxoXnIygLUrNptIyws5uIq6pGd3BdpH5pKKXkviJWyOH0td9/gltbU6gsSqPnxV
	 DkUiTZXwBv6ZRfbfibTHOjqdUoddPAqUJTJxCMBTmoIc9dNM08l8I5LEr/7XV3Xwmh
	 EVGBJqM9JbhgrFI16m81RPMDy22sCZpFJZMmIo2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zac Ecob <zacecob@protonmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 021/222] bpf: Add missed var_off setting in set_sext32_default_val()
Date: Tue,  2 Jul 2024 19:00:59 +0200
Message-ID: <20240702170244.788462698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 380d5f89a4815ff88461a45de2fb6f28533df708 ]

Zac reported a verification failure and Alexei reproduced the issue
with a simple reproducer ([1]). The verification failure is due to missed
setting for var_off.

The following is the reproducer in [1]:
  0: R1=ctx() R10=fp0
  0: (71) r3 = *(u8 *)(r10 -387)        ;
     R3_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=255,var_off=(0x0; 0xff)) R10=fp0
  1: (bc) w7 = (s8)w3                   ;
     R3_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=255,var_off=(0x0; 0xff))
     R7_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=127,var_off=(0x0; 0x7f))
  2: (36) if w7 >= 0x2533823b goto pc-3
     mark_precise: frame0: last_idx 2 first_idx 0 subseq_idx -1
     mark_precise: frame0: regs=r7 stack= before 1: (bc) w7 = (s8)w3
     mark_precise: frame0: regs=r3 stack= before 0: (71) r3 = *(u8 *)(r10 -387)
  2: R7_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=127,var_off=(0x0; 0x7f))
  3: (b4) w0 = 0                        ; R0_w=0
  4: (95) exit

Note that after insn 1, the var_off for R7 is (0x0; 0x7f). This is not correct
since upper 24 bits of w7 could be 0 or 1. So correct var_off should be
(0x0; 0xffffffff). Missing var_off setting in set_sext32_default_val() caused later
incorrect analysis in zext_32_to_64(dst_reg) and reg_bounds_sync(dst_reg).

To fix the issue, set var_off correctly in set_sext32_default_val(). The correct
reg state after insn 1 becomes:
  1: (bc) w7 = (s8)w3                   ;
     R3_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=255,var_off=(0x0; 0xff))
     R7_w=scalar(smin=0,smax=umax=0xffffffff,smin32=-128,smax32=127,var_off=(0x0; 0xffffffff))
and at insn 2, the verifier correctly determines either branch is possible.

  [1] https://lore.kernel.org/bpf/CAADnVQLPU0Shz7dWV4bn2BgtGdxN3uFHPeobGBA72tpg5Xoykw@mail.gmail.com/

Fixes: 8100928c8814 ("bpf: Support new sign-extension mov insns")
Reported-by: Zac Ecob <zacecob@protonmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240615174626.3994813-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0ef18ae40bc5a..4ad77ed8059e4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6223,6 +6223,7 @@ static void set_sext32_default_val(struct bpf_reg_state *reg, int size)
 	}
 	reg->u32_min_value = 0;
 	reg->u32_max_value = U32_MAX;
+	reg->var_off = tnum_subreg(tnum_unknown);
 }
 
 static void coerce_subreg_to_size_sx(struct bpf_reg_state *reg, int size)
-- 
2.43.0



