Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB343101DE;
	Thu,  3 Jul 2025 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554001; cv=none; b=oyNHqABlMFhXBrun7loWBMa3KRuw4GkHXMSga+jsilKeG13rptMZrXTVCmtwx78VYXhVXUoB2RU5s3FFaA5Ru3GrK5oN1V0rJpdY9rrVkx1SFS8JQa3asGfT9ZDd4QD3aNtPTa3KBb03yg67tyC/VewesZEBj8sP3hCXbQKf4ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554001; c=relaxed/simple;
	bh=geAYmXh4GPQJedRYoGB9CEtYR28VjKUcdFU0H2hFYjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AI/euhJQ1N5gNjTehRhPgPE7XVEkQ14KdtzRxFh7IDFQywaDXNU+cHWqjg0uHPWDX6HwuJ9UYyqb10vUZGM5EOYzhxG+U9+jg9UhiNTEzsvQO84ShWDSQ+SRtU97Jz/s2QYE+Z+c0O1PeUUDlFJUoPL+gjyn+6D6t+DVxt+OxVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw3T6pyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw3T6pyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B21C4CEE3;
	Thu,  3 Jul 2025 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554000;
	bh=geAYmXh4GPQJedRYoGB9CEtYR28VjKUcdFU0H2hFYjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw3T6pyw4uEOml2sofzrhMDmHC1PAY2HU0GG4xyvtuYBCJuNg0s63sFTdj5lt4YfD
	 SMbn/9z4H1BDZ//fJT7+GteKwhULAz1o2CWuoPCstNGGqYfrsYBOo8ik7Vug4OyoX3
	 M8Nh8k5dixNwwkm+XU9zh+rhBljWbm27nFYNoOlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andybnac@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/218] riscv: add a data fence for CMODX in the kernel mode
Date: Thu,  3 Jul 2025 16:39:57 +0200
Message-ID: <20250703143957.896860886@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <andybnac@gmail.com>

[ Upstream commit ca358692de41b273468e625f96926fa53e13bd8c ]

RISC-V spec explicitly calls out that a local fence.i is not enough for
the code modification to be visble from a remote hart. In fact, it
states:

To make a store to instruction memory visible to all RISC-V harts, the
writing hart also has to execute a data FENCE before requesting that all
remote RISC-V harts execute a FENCE.I.

Although current riscv drivers for IPI use ordered MMIO when sending IPIs
in order to synchronize the action between previous csd writes, riscv
does not restrict itself to any particular flavor of IPI. Any driver or
firmware implementation that does not order data writes before the IPI
may pose a risk for code-modifying race.

Thus, add a fence here to order data writes before making the IPI.

Signed-off-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20250407180838.42877-8-andybnac@gmail.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/cacheflush.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/cacheflush.c b/arch/riscv/mm/cacheflush.c
index b816727298872..b2e4b81763f88 100644
--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -24,7 +24,20 @@ void flush_icache_all(void)
 
 	if (num_online_cpus() < 2)
 		return;
-	else if (riscv_use_sbi_for_rfence())
+
+	/*
+	 * Make sure all previous writes to the D$ are ordered before making
+	 * the IPI. The RISC-V spec states that a hart must execute a data fence
+	 * before triggering a remote fence.i in order to make the modification
+	 * visable for remote harts.
+	 *
+	 * IPIs on RISC-V are triggered by MMIO writes to either CLINT or
+	 * S-IMSIC, so the fence ensures previous data writes "happen before"
+	 * the MMIO.
+	 */
+	RISCV_FENCE(w, o);
+
+	if (riscv_use_sbi_for_rfence())
 		sbi_remote_fence_i(NULL);
 	else
 		on_each_cpu(ipi_remote_fence_i, NULL, 1);
-- 
2.39.5



