Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8162C697;
	Mon, 28 Oct 2024 06:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097588; cv=none; b=nQJRSdg3j5PkElGwcd228PYxd3M4KJdWb6h7QRXT3KHv60O8/lxvZWrTiVc2wwtdY9ioGlAX2n7TT5K8WZFp2XLJ8TcqB3dJLqslOu34L6Xb6Llo3sTU7sD6vnZy3oYOLICikV/2bJC35JAqDfzF5TNWWWx2UDJYKNzUn7Mv1ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097588; c=relaxed/simple;
	bh=utKjMbNYSAvEiTUvHuMgUfG7YbTSlHO81jWOBZWbTB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia3oL+aw5OKG4VF19CHlKSRp5IMg/aTDRvpaYcnX4QtM/M7Eln4VSwHmZlNfEUY76jF9R7LmvCQ61pRGabrLxcN+qfq21unIerV802+ay8OvyYRpKxcuHpK3ckJKnGpHfJRSYs+9nzZknBfnmJsgGxmZL43l4Xlg6+c3Iux8O3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7JA6Sjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7JA6Sjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B499C4CEC3;
	Mon, 28 Oct 2024 06:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097588;
	bh=utKjMbNYSAvEiTUvHuMgUfG7YbTSlHO81jWOBZWbTB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7JA6Sjd/NJ4Mk/ArCQHwyyHB7fBJifHm/98Ooyzsaxa9LySpYXjUCW3KMVp9uBmF
	 IcDW9aetr51VXdpfdEs1fZh4hpSLpSCRHTYe3mghS5z0tDO0aS/fYuaN0Du1XCioCn
	 kq1RO4puyBsf3X1RXtNwerYi5s+MiVPkPj101Pg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Zac Ecob <zacecob@protonmail.com>,
	Dimitar Kanaliev <dimitar.kanaliev@siteground.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/208] bpf: Fix truncation bug in coerce_reg_to_size_sx()
Date: Mon, 28 Oct 2024 07:23:58 +0100
Message-ID: <20241028062308.084694705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Dimitar Kanaliev <dimitar.kanaliev@siteground.com>

[ Upstream commit ae67b9fb8c4e981e929a665dcaa070f4b05ebdb4 ]

coerce_reg_to_size_sx() updates the register state after a sign-extension
operation. However, there's a bug in the assignment order of the unsigned
min/max values, leading to incorrect truncation:

  0: (85) call bpf_get_prandom_u32#7    ; R0_w=scalar()
  1: (57) r0 &= 1                       ; R0_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=1,var_off=(0x0; 0x1))
  2: (07) r0 += 254                     ; R0_w=scalar(smin=umin=smin32=umin32=254,smax=umax=smax32=umax32=255,var_off=(0xfe; 0x1))
  3: (bf) r0 = (s8)r0                   ; R0_w=scalar(smin=smin32=-2,smax=smax32=-1,umin=umin32=0xfffffffe,umax=0xffffffff,var_off=(0xfffffffffffffffe; 0x1))

In the current implementation, the unsigned 32-bit min/max values
(u32_min_value and u32_max_value) are assigned directly from the 64-bit
signed min/max values (s64_min and s64_max):

  reg->umin_value = reg->u32_min_value = s64_min;
  reg->umax_value = reg->u32_max_value = s64_max;

Due to the chain assigmnent, this is equivalent to:

  reg->u32_min_value = s64_min;  // Unintended truncation
  reg->umin_value = reg->u32_min_value;
  reg->u32_max_value = s64_max;  // Unintended truncation
  reg->umax_value = reg->u32_max_value;

Fixes: 1f9a1ea821ff ("bpf: Support new sign-extension load insns")
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Reported-by: Zac Ecob <zacecob@protonmail.com>
Signed-off-by: Dimitar Kanaliev <dimitar.kanaliev@siteground.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Reviewed-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20241014121155.92887-2-dimitar.kanaliev@siteground.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d1050479cbb33..28b09ca5525f0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6143,10 +6143,10 @@ static void coerce_reg_to_size_sx(struct bpf_reg_state *reg, int size)
 
 	/* both of s64_max/s64_min positive or negative */
 	if ((s64_max >= 0) == (s64_min >= 0)) {
-		reg->smin_value = reg->s32_min_value = s64_min;
-		reg->smax_value = reg->s32_max_value = s64_max;
-		reg->umin_value = reg->u32_min_value = s64_min;
-		reg->umax_value = reg->u32_max_value = s64_max;
+		reg->s32_min_value = reg->smin_value = s64_min;
+		reg->s32_max_value = reg->smax_value = s64_max;
+		reg->u32_min_value = reg->umin_value = s64_min;
+		reg->u32_max_value = reg->umax_value = s64_max;
 		reg->var_off = tnum_range(s64_min, s64_max);
 		return;
 	}
-- 
2.43.0



