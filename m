Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D929E2327A3;
	Mon, 10 Mar 2025 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627907; cv=none; b=XNJqdiojzJQbt1vhM1o2L8KUexXmgvx/DSBcqpXxFp//dWSw6/3TM7djsT2ivCcmSVe7HjQQ5XHvHk7Ym+ovYWUnuh7I7tvdTehpzzPz+wCNpKaw75TeX3q6qJmy9C/HVJ44p5ZIZiWrrqNmu2NAwq3l2hjns9tTGpCW7+i15O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627907; c=relaxed/simple;
	bh=1eGOkeGb3ar8aiWekpu20nlGgzEsJ8AvIMO6ZylFabg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJTOzB2POSIfCg9kSN2LktmPU0/xPXV11/5kksNg+786kyX5D+0Yu4eLI0pIClXHfBuOaw9twaDJRb7hnJdmNnCYrLl/RtE2j5oKAdVRtUDJE3KIfSREBOmuP6u/oxdHYLnWE3pRt9tWKyxNC0Of/DkSU5HvyVdifZNd1IQywCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPC/Tmtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPC/Tmtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A369C4CEE5;
	Mon, 10 Mar 2025 17:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627907;
	bh=1eGOkeGb3ar8aiWekpu20nlGgzEsJ8AvIMO6ZylFabg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPC/TmtrPelIRSlBbYdsW5R9vMsHczc0kj04hcqExp2KzYywSodLSe2nJ/rhBm9S8
	 F3ZNtf8+aUAJlBJIJ5lmrfI6t3wBkHHZn3uUX0YVFMW+031W85GGGB+53Chfw+XanY
	 KbIZXi1RYZOqX4gUd+s6wmn4QByCg31Lk9QinKC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Zong Li <zong.li@sifive.com>,
	Andy Chiu <andybnac@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/145] riscv: signal: fix signal_minsigstksz
Date: Mon, 10 Mar 2025 18:05:15 +0100
Message-ID: <20250310170435.595243812@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 564fc8eb6f78e01292ff10801f318feae6153fdd ]

The init_rt_signal_env() funciton is called before the alternative patch
is applied, so using the alternative-related API to check the availability
of an extension within this function doesn't have the intended effect.
This patch reorders the init_rt_signal_env() and apply_boot_alternatives()
to get the correct signal_minsigstksz.

Fixes: e92f469b0771 ("riscv: signal: Report signal frame size to userspace via auxv")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241220083926.19453-3-yongxuan.wang@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 89ff6395dadbc..175184b059264 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -306,8 +306,8 @@ void __init setup_arch(char **cmdline_p)
 
 	riscv_init_cbo_blocksizes();
 	riscv_fill_hwcap();
-	init_rt_signal_env();
 	apply_boot_alternatives();
+	init_rt_signal_env();
 
 	if (IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM) &&
 	    riscv_isa_extension_available(NULL, ZICBOM))
-- 
2.39.5



