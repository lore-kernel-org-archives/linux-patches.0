Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3481BE23F;
	Tue,  2 Jul 2024 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939997; cv=none; b=TFKFT3WzlecR9VJSwNWIvhTGAWmzVoLGdvy58x5w2MVKYYV846jnD7mkTiC5DriJ3S7D83UMjltR2KPPOnmZfbaIdg81yj2oYuzFWk0QQPiDHrjmNJxQO0rxKl9ygyGJ/k2MgDqskrS+kElncwexi3N63XzST96W6FObaVRNzVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939997; c=relaxed/simple;
	bh=clutMW1RQONjWnJScwAgq+Y0WuYXeSt5X9cuElJmNPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ucf0yfRBnDNl5NHnqPMEd+YmbwcAIMZoNpKl56GHyhjESzoVXM2Eksq77ObNHGNnN7VuzopAHJNXLjrWMgQnZ0OE4ZXI5gUs1Dtj4c5FRRJlSdmMjO8li+n3/BwdL0G16+sBQcmCbEM+Qh6JZ3K27WKcNlL+TfRVeqWbHwa24S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10MYMKEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10MYMKEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69946C4AF07;
	Tue,  2 Jul 2024 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939996;
	bh=clutMW1RQONjWnJScwAgq+Y0WuYXeSt5X9cuElJmNPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10MYMKEUB5OgvWlPyMYyxC5usY6H5Ks73A47TMhlMn4erFxHcRnr2+5Krlqqruf1f
	 QWPiohOmr1TIuErBR6TAerysz7tzKKuSo3ZYErkjAEtL1i8HP3ZHaV4go60Klm04nn
	 TT1sNNOoEFwh6cpoIXuz42BDYHDUHxDQQa3JHSmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 022/222] bpf: Add missed var_off setting in coerce_subreg_to_size_sx()
Date: Tue,  2 Jul 2024 19:01:00 +0200
Message-ID: <20240702170244.826263311@linuxfoundation.org>
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
index 4ad77ed8059e4..add5ccbe87523 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6268,6 +6268,7 @@ static void coerce_subreg_to_size_sx(struct bpf_reg_state *reg, int size)
 		reg->s32_max_value = s32_max;
 		reg->u32_min_value = (u32)s32_min;
 		reg->u32_max_value = (u32)s32_max;
+		reg->var_off = tnum_subreg(tnum_range(s32_min, s32_max));
 		return;
 	}
 
-- 
2.43.0



