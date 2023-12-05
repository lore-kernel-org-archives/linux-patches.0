Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E9141220;
	Tue,  5 Dec 2023 23:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnO/23+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD91C433C7;
	Tue,  5 Dec 2023 23:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701820439;
	bh=y/jqertrO7frvcmMbzQv5qp/lLtbm42FIUi32gqKKTY=;
	h=From:Subject:Date:To:Cc:From;
	b=HnO/23+J7Z0MsuTFQi1T5wWU6invgYUs70iS/MAR4gtRjF5ObSqqHmVtULa5Ojcvk
	 3erW/Oa/ZZncJ9/8DlrHRRUTMDI3oK8RlfkfD5mhEa0zB3v7CIXTVRH3FnPWPJcvXF
	 J3bLveJlNDLck1gUDuiNW8rxPkXPpCwnr8A2fhssmxuhe9Z2V6SD73s4S4gGGtM04W
	 DA7S3xg75s0ioAS3eivrpa1fI6cTtXwuBCtK2SQJwneXBuvu6zF8HXHnZ2oMwaz7FG
	 qBYx04GN+6ejn5HE4AFBdDY7p8jh96eyYzdIorgO4hkO6ovKPnRSJ99588+2qh/N5I
	 p0P6xPYDEivFA==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 0/3] RISC-V: Disable DWARF5 with known broken LLVM
 versions
Date: Tue, 05 Dec 2023 16:53:49 -0700
Message-Id: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA24b2UC/43NQQ6CMBCF4auQWTumLaDgynsYFrRMYSKCmZKqI
 dzdyglcfm/xvxUCCVOAS7aCUOTA85RgDhm4oZ16Qu6SwSiTa21qFA4uolBYhN2C3asVX+I4xge
 2dWUKa+tz4SykwFPI83uP35rkgcMyy2f/ivq3/pWNGhWSU11+qrwt8+p6J5loPM7SQ7Nt2xdtc
 XClxQAAAA==
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: maskray@google.com, ndesaulniers@google.com, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=1298; i=nathan@kernel.org;
 h=from:subject:message-id; bh=y/jqertrO7frvcmMbzQv5qp/lLtbm42FIUi32gqKKTY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKn5O8Re5h0w0Dxz3u2i223Ro88ZF37uDCwSubE6dce2N
 6aLizdZdJSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJLDzHyPC1OO1An+EljfDY
 dztfHFjfzsnEmLH13WGHWzGzv3BO8r7O8L+y98uGVXZiRbLs6d+UNERkT/7N3XY7Msj4xzbZDQw
 6XhwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series disables DWARF5 for LLVM versions where it is known to be
broken due to linker relaxation:

https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6

If I understand correctly, it sounds like GNU binutils has a similar
issue but I am not sure of the status of the fixes and such, so I did
not bother with checking for it but it should be easy to add if so
desired.

---
Changes in v2:
- Added patch 3 with Fangrui's suggested improvements around
  CONFIG_AS_HAS_NON_CONST_LEB128.
- Pick up Fangrui's Reviewed-by on patch 1.
- Link to v1: https://lore.kernel.org/r/20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org

---
Nathan Chancellor (3):
      riscv: Hoist linker relaxation disabling logic into Kconfig
      riscv: Restrict DWARF5 when building with LLVM to known working versions
      lib/Kconfig.debug: Update AS_HAS_NON_CONST_LEB128 comment and name

 arch/riscv/Kconfig  | 14 ++++++++++++++
 arch/riscv/Makefile |  4 +---
 lib/Kconfig.debug   | 12 +++++++-----
 3 files changed, 22 insertions(+), 8 deletions(-)
---
base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
change-id: 20231129-riscv-restrict-dwarf5-llvm-a9824bb974cb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

