Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0013B2BEFEF;
	Wed, 30 Sep 2026 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786889; cv=none; b=NUZeErSINlXFrtTUQxFtGCu/g5R+MTKI6BygTyk+asdsnY1Rewx/2+9LtJmM6WZQIpF+KKgi5ebJ7DAs2T4hyNLbw4CErdPRpSeIv413Xxow9kyTa0c3nFbrPS2YGBPv1tLsyHAWQIM2GKFRrRmmr0WL+LW+Vw/Df09i6SV1Bdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786889; c=relaxed/simple;
	bh=D0W5YiU50itAhutnZHpVDL1/DYnxCKyHmBwLW/FEZf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsUYRaTuExEveYllsuBl7cB5i+bQGEQNQZ8PK5iGRoVKzNXJYA5mYyYMtWJ38rCkuj0U/ChDRSrJHVwm3OtHVBMw+lMslBh7vBeK43+XAQX9r9lujuzR6WOvAI/x/gKxj6ufxeuEG249u3kBOg0zmnpM4CnZz8tjVsDln6hXPQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYxBKcew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYxBKcew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCF41F000FF;
	Wed, 30 Sep 2026 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786887;
	bh=QiYMZO4zHA3ACTJi5ElOLiJxPNifeM15G165bqlGYrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYxBKcew6Km5Euu9MW5MTcZGE9l2xN3WU5Vr6R0c1yCx3LZqF4CwrPyyl/UnWXNf1
	 zr++iS0oHmWUNslc3qM//WQNYVEhfa/cl4XD6swq/d4cc9GunLNFB69dDl9dItKa+Q
	 oYfKXEYiqeZzVPoNFlRpsc7BG8a+GGTEn44GDNtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 037/457] KVM: riscv: Fix NACL hfence entry update order
Date: Wed, 30 Sep 2026 17:22:22 +0200
Message-ID: <20260930152346.836285735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit b3d346838ec65fac7fd83f5dbcedd13cadfffddb ]

The SBI v3.0 specification (section 15.1.2) requires a nested HFENCE
entry to be populated as follows:
1) find an unused entry with Config.Pending == 0
2) update the Page_Number and Page_Count words
3) update the Config word with Config.Pending set

__kvm_riscv_nacl_hfence() writes the Config word first, so the SBI
implementation (or NACL hardware) can observe a pending entry with
pnum/pcount values left over from the previous use of that entry,
resulting in incorrect TLB flush ranges.

Write pnum and pcount first and the Config word last. Since the
consumer is an external agent on coherent shared memory, use
WRITE_ONCE() to stop the compiler from reordering the stores and
smp_wmb() to make the parameter words globally visible before the
Pending bit is set.

Fixes: d466c19cead5 ("RISC-V: KVM: Add common nested acceleration support")
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260826075009.68952-1-min_halo@163.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/nacl.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/nacl.c b/arch/riscv/kvm/nacl.c
index 6f9f8963e9ddc..0a2a50c6ce035 100644
--- a/arch/riscv/kvm/nacl.c
+++ b/arch/riscv/kvm/nacl.c
@@ -42,12 +42,24 @@ void __kvm_riscv_nacl_hfence(void *shmem,
 		}
 	}
 
-	entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(i);
-	*entp = cpu_to_lelong(control);
+	/*
+	 * Per SBI v3.0 section 15.1.2, the Page_Number and Page_Count
+	 * words must be updated before the Config word with its Pending
+	 * bit set. WRITE_ONCE() stops the compiler from reordering the
+	 * stores and smp_wmb() makes the parameter words globally
+	 * visible to the SBI implementation (or NACL hardware) before
+	 * the Pending bit is set.
+	 */
 	entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_PNUM(i);
-	*entp = cpu_to_lelong(page_num);
+	WRITE_ONCE(*entp, cpu_to_lelong(page_num));
 	entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_PCOUNT(i);
-	*entp = cpu_to_lelong(page_count);
+	WRITE_ONCE(*entp, cpu_to_lelong(page_count));
+
+	/* Ensure the parameter words are visible before the Pending bit */
+	smp_wmb();
+
+	entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(i);
+	WRITE_ONCE(*entp, cpu_to_lelong(control));
 }
 
 int kvm_riscv_nacl_enable(void)
-- 
2.53.0



