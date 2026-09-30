Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C1D511235;
	Wed, 30 Sep 2026 18:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792844; cv=none; b=YjVE6e2wcHtsas7Mo1UyUhsUX5abQLqxJ6q5DKe2dpIbzKWKAs6wE5ijEiaWhg/diFLJN1jFp31Kdxj5+MCwVtcQAtY2m0XjZVoQYGNJBrK/4N2mFB2wBg+q+TIU4GubTt5y1gu4agGv/2S895IBKfVHMwPxjewTja7N8NmG7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792844; c=relaxed/simple;
	bh=Q74DEczoS2BXPeN2sU7fuzRvnC99ZmO9UarAImZHrhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzruZuA5x9M1DXwLvw2ESJMIJ9kKp1ltIDmgV6CcxApTXi75J0zM5a6gT7PtZOkt9iyvSTa6Fm7Y3JJGykPbZULcoo/So/vJRTACmAQNwrS91HAC4Fdtpia6qW2H41xlqx+Ka9sOzYb0viwsjoqJatKML8A3qFzlWow1rWycqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYo5shXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYo5shXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E490F1F000FF;
	Wed, 30 Sep 2026 18:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792843;
	bh=/84vuT2g5nJFIdggDvy21Q6PD1usmSpoDEZw6qNXcOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYo5shXyk0nEqptIgyjrWE06TnHoF24GT20H0KYv4dVEKKVtPBgpRvantT/5Li0nM
	 RcJOjMXhzn27A2EEuUKNGIqNIJ4DBTaU7SJxr+pmA6Q6AmjYA9nHMMJjP2YY/cTtGp
	 FNNpnMUP36Bj7MPuTmUA0XUF/E5QIqEnlz2vu93w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/395] KVM: riscv: Fix NACL hfence entry update order
Date: Wed, 30 Sep 2026 17:24:50 +0200
Message-ID: <20260930152341.229260751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 08a95ad9ada2c..f922e9f62fee3 100644
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



