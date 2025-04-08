Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEEE268685;
	Tue,  8 Apr 2025 12:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115140; cv=none; b=PSCgtMX81KR/fimc+OG6xKnWz08cCX5LrLDb2/fm6GayW6umLdeE8BED0xkTsYY9CrwXr09BF69L32MgKHv34NAl8VQLtTU/WFLHMMWYNgTcJS+Hz2eT1IUGFV+tJ/aPGd/ov/FB7KgyI6F40Mc1Hk1LRJ5SwJxi0UqnR5jQz40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115140; c=relaxed/simple;
	bh=zZr5pehIhnsanQQsjURM03T1XLd2yA0fxnvyj/btWQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLD16m0amnLtq/tfXyjUjP+WaxLyVu6CvvoYsFVZsVwomb/gWunzjU2q0t+BOFVgb32UPAHK2HGz01U8QjawtAxOMoPfJ2VJQU/4ROuW/hQvJmNr7ZXAhsAmyoC/gdbc7WdbaeEP9df7TLbrCYdPjaLoFJFTuG1Rs1VvAlV2pMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpWlaRd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpWlaRd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB68C4CEE5;
	Tue,  8 Apr 2025 12:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115139;
	bh=zZr5pehIhnsanQQsjURM03T1XLd2yA0fxnvyj/btWQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpWlaRd2U1epp24w1MsemwKqeN9KszJvT3mvG18RytxT7YRlQukrMnzk+6gqk6PLd
	 5qyQId0WuNzsBKOBlrRfzmNuT8GAHjSUbKubAGJ30t3XxbsoaprQyuCGLGlJ6Ogw8s
	 NG4e5kVSUD/Gx9rsVYmV+Ql93hoR4vWqiI+ri/og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 364/499] riscv: Fix riscv_online_cpu_vec
Date: Tue,  8 Apr 2025 12:49:36 +0200
Message-ID: <20250408104900.307694640@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 5af72a818612332a11171b16f27a62ec0a0f91d7 ]

We shouldn't probe when we already know vector is unsupported and
we should probe when we see we don't yet know whether it's supported.
Furthermore, we should ensure we've set the access type to
unsupported when we don't have vector at all.

Fixes: e7c9d66e313b ("RISC-V: Report vector unaligned access speed hwprobe")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250304120014.143628-12-ajones@ventanamicro.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/unaligned_access_speed.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 85c868a8cee63..2e41b42498c76 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -370,10 +370,12 @@ static void check_vector_unaligned_access(struct work_struct *work __always_unus
 
 static int riscv_online_cpu_vec(unsigned int cpu)
 {
-	if (!has_vector())
+	if (!has_vector()) {
+		per_cpu(vector_misaligned_access, cpu) = RISCV_HWPROBE_MISALIGNED_VECTOR_UNSUPPORTED;
 		return 0;
+	}
 
-	if (per_cpu(vector_misaligned_access, cpu) != RISCV_HWPROBE_MISALIGNED_VECTOR_UNSUPPORTED)
+	if (per_cpu(vector_misaligned_access, cpu) != RISCV_HWPROBE_MISALIGNED_VECTOR_UNKNOWN)
 		return 0;
 
 	check_vector_unaligned_access_emulated(NULL);
-- 
2.39.5



