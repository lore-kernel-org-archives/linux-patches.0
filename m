Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F44E433A9;
	Tue, 30 Jul 2024 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357367; cv=none; b=s9dCrJJMAgl02gKG90Kr6urfWvaUGcYgv8qMKd0VF522rXfKCGKb28VblwSJhea2f7gMW0DvGH2D4xrg3nqpW8wmhq5euoHa8+hFISatcZ1hayZ8H/55Nk6IgdunCQtP7xDNDZRmrp1qdFqzBBPVDyIN1j+bDiHFhLTBLEH+hhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357367; c=relaxed/simple;
	bh=FmtZ1JT7Ma+69melpQWpUSvprCLInWk6IDMj8Neqbcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFNnp1Gcc3M4VJpWOQGXIwaJe4kKg2dG+0OoxIiV8Sa1W23mwDslAN1CCVYY7Xa+FE3NwPOjpkoOTu5FRnI5FWEGUT165CRN53fD+J7Y9Mibd/nlPe/S1CTZwIPwB21Px0xlD6cIa3qhvcqtHhbEvBzIpJh90knEqSmWxF06NAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdxJTytN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdxJTytN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F9CC4AF0E;
	Tue, 30 Jul 2024 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357367;
	bh=FmtZ1JT7Ma+69melpQWpUSvprCLInWk6IDMj8Neqbcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdxJTytNPQXR2+DREo3uW7dtL82kcy/2zbTARUmIFqJfmTAp9k/Geit8637OjCqMU
	 Ecco0HlO51qqDDR1o+TUhX5ra6VuejbMu4cT0XDE7bH0iJDl/P37Ho1GOu6D8c8qFS
	 19kC4+MZdbIkh0L2IRgjEHyaLpYjycAaorfbpQRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 247/809] bpf: fix overflow check in adjust_jmp_off()
Date: Tue, 30 Jul 2024 17:42:03 +0200
Message-ID: <20240730151734.355061063@linuxfoundation.org>
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

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

[ Upstream commit 4a04b4f0de59dd5c621e78f15803ee0b0544eeb8 ]

adjust_jmp_off() incorrectly used the insn->imm field for all overflow check,
which is incorrect as that should only be done or the BPF_JMP32 | BPF_JA case,
not the general jump instruction case. Fix it by using insn->off for overflow
check in the general case.

Fixes: 5337ac4c9b80 ("bpf: Fix the corner case with may_goto and jump to the 1st insn.")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20240712080127.136608-2-shung-hsi.yu@suse.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e1e08e62a2f2f..6b422c275f78c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18768,7 +18768,7 @@ static int adjust_jmp_off(struct bpf_prog *prog, u32 tgt_idx, u32 delta)
 		} else {
 			if (i + 1 + insn->off != tgt_idx)
 				continue;
-			if (signed_add16_overflows(insn->imm, delta))
+			if (signed_add16_overflows(insn->off, delta))
 				return -ERANGE;
 			insn->off += delta;
 		}
-- 
2.43.0



