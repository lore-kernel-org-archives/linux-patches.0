Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6B327C16B;
	Tue,  8 Apr 2025 12:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117007; cv=none; b=hm7JMBG4BSWLJhWXcFzRgjVTTwvak1kV+/d/fJMZ05NmYsMCcIeHfl55t5kzADuvmiKwqJn+UD+kgQu7QIKeX7Cy2+bfju+kxUsJpTEW5bxhEzt5f5BRjmEHJmYH5iuw1qVEAdsNmFfuDNVoOLXMuKkXtPX0KmtsZdPKgHA3ZEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117007; c=relaxed/simple;
	bh=6m1WUX+lB0bJ2E1N7ZVtdo5rXERUhizp8lwa0m5jzD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW6Q8izbJ1TtvA8c0tF4mnxHHiybevqax+yplMvLKiduhfog6m9S5//C8YwBS2nF1O8L8Io0tzniazDo5MC0MDql4AsJ+4/C0ucrRFXVKpKwE54/grnIqEJvtGikB7BkZEtg1ndXxbWDU3VoJGGeW3WHw6hAZIAu5Ymf21dhHMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d43EYcOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d43EYcOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C228C4CEE5;
	Tue,  8 Apr 2025 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117007;
	bh=6m1WUX+lB0bJ2E1N7ZVtdo5rXERUhizp8lwa0m5jzD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d43EYcOlh5aX/UeleKp9DZZox0qeTzWGptL1rUZilq3vXI3HU60UVkGi679x/qWGf
	 JBL2xk12tQ5syYrFQm554efoA0zhiWUrnB0mraDmwiDCTFwgASpvAXUBrZX9u1JmLO
	 9lUgER9CouZB6qtsOZUIhu6828y703uRix1RqH7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/423] RISC-V: errata: Use medany for relocatable builds
Date: Tue,  8 Apr 2025 12:50:36 +0200
Message-ID: <20250408104853.023065118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f0da9d7b39c37..bc6c77ba837d2 100644
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
 
 ifdef CONFIG_RISCV_ALTERNATIVE_EARLY
-- 
2.39.5



