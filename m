Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C9626B0A5;
	Tue,  8 Apr 2025 12:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113650; cv=none; b=gmRU2C10OFPJRlgAkOS7wsNhKORNxvE43SKYJrUtatMBFyw9YfUI+K5ynySoFTYWuFzcuTl67OiZH2wyjWfA6R07tyV/HunEQLUwkTM/Kw0lIY7DSnxT0TQQCQXi7LSSNCO/BCCRET4bwmQ0htjE7bBGKvK/Fjhu1L0KGRKeB40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113650; c=relaxed/simple;
	bh=SxYiOli6mArQx1NxrTBrjOJkP32NzkFAubMtQ4rr0qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as3PHYi5piVE7OiqMYVJPMCakWF8fRhm66c40jzkKb75w9cPspXKo13HaMJw/xGyTglywu2D/eK1rOxI5ZTIElHAKQfgn2ck5ZaLmFI6vC6VISc3Yal5ZmPBtsoUEVAFX2CKgx6J/ngCwn3XXAPY/POQXsjCEo2svsB43iLcCQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVzv8e9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVzv8e9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BB4C4CEE5;
	Tue,  8 Apr 2025 12:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113649;
	bh=SxYiOli6mArQx1NxrTBrjOJkP32NzkFAubMtQ4rr0qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVzv8e9PPFFsxwmzSkPTFwE3vaz6Rsa3KORW9Ci736q8bm+MT2gKOYMpRZJ0dfIzy
	 fFji9neCFM5XuJKiLrWh3OrQhnYih3C2aYc39PfPXgr6/ZK2hoW/6RaWrPcfmUgABh
	 s4ccv2O4L5dY0jbMK9gAPBNsY+LJLhh6W/39F7t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/268] RISC-V: errata: Use medany for relocatable builds
Date: Tue,  8 Apr 2025 12:50:10 +0200
Message-ID: <20250408104833.921937893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit bb58e1579f431d42469b6aed0f03eff383ba6db5 ]

We're trying to mix non-PIC/PIE objects into the otherwise-PIE
relocatable kernels, to avoid GOT/PLT references during early boot
alternative resolution (which happens before the GOT/PLT are set up).

riscv64-unknown-linux-gnu-ld: arch/riscv/errata/sifive/errata.o: relocation R_RISCV_HI20 against `tlb_flush_all_threshold' can not be used when making a shared object; recompile with -fPIC
riscv64-unknown-linux-gnu-ld: arch/riscv/errata/thead/errata.o: relocation R_RISCV_HI20 against `riscv_cbom_block_size' can not be used when making a shared object; recompile with -fPIC

Fixes: 8dc2a7e8027f ("riscv: Fix relocatable kernels with early alternatives using -fno-pie")
Link: https://lore.kernel.org/r/20250326224506.27165-2-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/errata/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/errata/Makefile b/arch/riscv/errata/Makefile
index 8a27394851233..f96ace8ea1df1 100644
--- a/arch/riscv/errata/Makefile
+++ b/arch/riscv/errata/Makefile
@@ -1,5 +1,9 @@
 ifdef CONFIG_RELOCATABLE
-KBUILD_CFLAGS += -fno-pie
+# We can't use PIC/PIE when handling early-boot errata parsing, as the kernel
+# doesn't have a GOT setup at that point.  So instead just use medany: it's
+# usually position-independent, so it should be good enough for the errata
+# handling.
+KBUILD_CFLAGS += -fno-pie -mcmodel=medany
 endif
 
 obj-$(CONFIG_ERRATA_ANDES) += andes/
-- 
2.39.5



