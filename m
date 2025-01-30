Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110461BDA95;
	Thu, 30 Jan 2025 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246744; cv=none; b=ekWFQyypueWg6Vx2fwDuMFbExKTlAlH+K1GYrb/q31T3qUUlaTtceXbHkZ7Bx5SJ4HYaPuT9r+hU+ww6A2WvrwEo1GJm/grK9+H189lcvu12XmNJ/aniPD9QG7hPkWqIsiZkgBp1KD8MaiTanskrG4OgFFKuzZMpQiAy23qMQRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246744; c=relaxed/simple;
	bh=eSn608g5A6J7il4PaWZF24HGp2OZbg1CIDrGb/3YtxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6vqkF8GSCcBwmf/oe+j7g6eFCVtOaVyDwj+NilEm9qWgGRLh6y45j1+uV30jvuUDWwhdGIt4bDoPNEhYsqJ7uR+l2mGFlF5cDw+VKlneBNhfuHM92Sp9IKrTiMvl3eW3rXZRF+8ETg17YoeBf8tECYzotAKB9o5DYpuOdCp5Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeI2332T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeI2332T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E32DC4CEE2;
	Thu, 30 Jan 2025 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246743;
	bh=eSn608g5A6J7il4PaWZF24HGp2OZbg1CIDrGb/3YtxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeI2332T+MhfmMr+GXPFiuGpRg69nO1JaMYFXCLvfKNpgap/e5GUQCPQBJVVaitOe
	 B6NhgmGqo9mhnCgCP1YUaxXVMCdLLJVzFKkJrZF0VLI/voP+05IpaAQo5UM15MLpk0
	 F4sV4LEJdfwOF4jprOzfkF5bmu1CuZRsJQatJLFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <anup.patel@wdc.com>,
	Atish Patra <atish.patra@wdc.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.4 53/91] RISC-V: Dont enable all interrupts in trap_init()
Date: Thu, 30 Jan 2025 15:01:12 +0100
Message-ID: <20250130140135.795712284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <anup.patel@wdc.com>

commit 6a1ce99dc4bde564e4a072936f9d41f4a439140e upstream.

Historically, we have been enabling all interrupts for each
HART in trap_init(). Ideally, we should only enable M-mode
interrupts for M-mode kernel and S-mode interrupts for S-mode
kernel in trap_init().

Currently, we get suprious S-mode interrupts on Kendryte K210
board running M-mode NO-MMU kernel because we are enabling all
interrupts in trap_init(). To fix this, we only enable software
and external interrupt in trap_init(). In future, trap_init()
will only enable software interrupt and PLIC driver will enable
external interrupt using CPU notifiers.

Fixes: a4c3733d32a7 ("riscv: abstract out CSR names for supervisor vs machine mode")
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Tested-by: Palmer Dabbelt <palmerdabbelt@google.com> [QMEU virt machine with SMP]
[Palmer: Move the Fixes up to a newer commit]
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -162,6 +162,6 @@ void __init trap_init(void)
 	csr_write(CSR_SCRATCH, 0);
 	/* Set the exception vector address */
 	csr_write(CSR_TVEC, &handle_exception);
-	/* Enable all interrupts */
-	csr_write(CSR_IE, -1);
+	/* Enable interrupts */
+	csr_write(CSR_IE, IE_SIE | IE_EIE);
 }


