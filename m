Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AFE26B2C0;
	Tue,  8 Apr 2025 12:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115129; cv=none; b=V+SgPScuDuzYZWD6jMKDKLiHlw4g1qwp18HuSLY0T7TVmQuqqTGVVV0xrHml8oCyOMvfl2IE7yuKSqc6zzb1D+9vpebGB/lxAMOGAETsOa+VdESoRuKEa8SaVrq4zsLDjApvSrcQgEcxME+V3DE84pNwF1DnGVBBSPu2JCjivV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115129; c=relaxed/simple;
	bh=Zt7uoJT+nbN2uZjGw077LTzNasot30OQlExSW3OvbHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sqdc9CaWCiyN9Z/UnyuA7QR3ntlbYSez850Fh+2QJ+Ff1t+a/wIfqG5agiF26XkskSsQoH7nDfaGOPDvJRW+nfp/5wsXKu8LGzg04zE9zF2KzRIbtXC3VNw5svbUSDfbzvvWRoar1xWgQo7o/7yVFM/FA5LCplC3fYtCV3VueX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2XzoRen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2XzoRen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD01C4CEE5;
	Tue,  8 Apr 2025 12:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115129;
	bh=Zt7uoJT+nbN2uZjGw077LTzNasot30OQlExSW3OvbHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2XzoRenaFnObiwBPqoq0rPbEgr2vD3FMAwt6fJPZw5U/5oyoXEnQ2pBSSBEcrcks
	 FaOLCENgZ9HamljhYTIfbWDgmXhDs3NUc7uf6jvMJmRnvMEMkwqvTz/V24GnAMqcFS
	 jrtxo1TJ9KxfE9j8y04YPiX+Jxs768SkOjglVf/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 360/499] riscv: Fix missing __free_pages() in check_vector_unaligned_access()
Date: Tue,  8 Apr 2025 12:49:32 +0200
Message-ID: <20250408104900.210061317@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 33981b1c4e499021421686dcfa7b3d23a430d00e ]

The locally allocated pages are never freed up, so add the corresponding
__free_pages().

Fixes: e7c9d66e313b ("RISC-V: Report vector unaligned access speed hwprobe")
Link: https://lore.kernel.org/r/20250228090613.345309-1-alexghiti@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/unaligned_access_speed.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 91f189cf16113..074ac4abd023e 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -349,7 +349,7 @@ static void check_vector_unaligned_access(struct work_struct *work __always_unus
 		pr_warn("cpu%d: rdtime lacks granularity needed to measure unaligned vector access speed\n",
 			cpu);
 
-		return;
+		goto free;
 	}
 
 	if (word_cycles < byte_cycles)
@@ -363,6 +363,9 @@ static void check_vector_unaligned_access(struct work_struct *work __always_unus
 		(speed ==  RISCV_HWPROBE_MISALIGNED_VECTOR_FAST) ? "fast" : "slow");
 
 	per_cpu(vector_misaligned_access, cpu) = speed;
+
+free:
+	__free_pages(page, MISALIGNED_BUFFER_ORDER);
 }
 
 static int riscv_online_cpu_vec(unsigned int cpu)
-- 
2.39.5



