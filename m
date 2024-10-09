Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB5217837F;
	Wed,  9 Oct 2024 19:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501979; cv=none; b=Ru6bkx/JwGQcccsqZYr5jL9oT6g4G41Z7VGyx7jAg1KV4qLaDnA7r0XA8V2Y9HPxPdDghcCp9A5cFjnfadzp/Cum5rxnd2HhCJVCMqAFN6M20UYinRoi4zgDSMy+qmpXMNFPUvMDA68l2gRZKRDuL0W+Elhefl5UoQgyPIuckRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501979; c=relaxed/simple;
	bh=Vuglrov0S5KUMROzD8A+tpB0125ZTYYW7D7CNFqovC4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=MibPScZzA5LwYUqhl1oYWtztw5YpdMLTZXIB3E86YIhc5IHhuJf0vPzuZhlqXUkZD3Ak0DFjjXHxDYaeZ1rG40uKLuHdLICggNpjP0EbUN7DnRtYEnB9zpWIaaXjbiMRFflJdo5cA/YyHeT5OsrATpfJZ7DiWSEOXMljdK+AHlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IASgu2YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IASgu2YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA2C4CEC3;
	Wed,  9 Oct 2024 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728501977;
	bh=Vuglrov0S5KUMROzD8A+tpB0125ZTYYW7D7CNFqovC4=;
	h=From:Subject:Date:To:Cc:From;
	b=IASgu2YCRbcdjzxnkpBu7W5HXlRtuNGZaSsq5eRYRR8GXqrpMYXQ5hDQvdUcoue0u
	 MgR788e9SCBga+F2f7ZMxoUJka9SQuLBTzDZJETdTRXlZuruAcSHZo53CrZrJNq8zY
	 ScjnPastRxDgzDVG/9enS48TYznrcTNy1iXg0FzX9qzLivy+oYouyabJiv6TmRjBkl
	 peSe/sJBjgVfUTvVuHf93ppRwCTfEe6edBMf/tKcojFqzscHlUgP4Jnoqep2rpQMQ5
	 vpBcV0dw3sm2Y1V1LtYYAJLzEgHzqLv/GT4YLa9GBFb9WVehrihdRBxQWX8L+sh4AQ
	 Nv0M80CXQ0GgQ==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 0/2] powerpc: Prepare for clang's per-task stack
 protector support
Date: Wed, 09 Oct 2024 12:26:07 -0700
Message-Id: <20241009-powerpc-fix-stackprotector-test-clang-v2-0-12fb86b31857@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM/YBmcC/42NQQ6CMBBFr2Jm7Zi2qYCuvIdhgWWABkKbaYMaw
 t0dSdy7fD95/62QiD0luB5WYFp88mEWMMcDuKGZe0LfCoNRxmqlLMbwJI4OO//ClBs3Rg6ZXA6
 MmVJGN4mFlaWipLYyXWFAviKTCHvnXgsPPonx3rOL/q6/QvlnYdGoUFVOnx+muFiyt5F4pukUu
 Id627YPm2g979sAAAA=
X-Change-ID: 20241004-powerpc-fix-stackprotector-test-clang-84e67ed82f62
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2108; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Vuglrov0S5KUMROzD8A+tpB0125ZTYYW7D7CNFqovC4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlsN268aNQ6/+7BYqXi5rD1M+MLLVc8iD1ir7Bh5wv34
 H9LpSQ1O0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBE1rYxMlwwNKtqdll99LuI
 fvnqfydjcib/uJG2al5bbJxJ/qxpivsY/umWnKp/ufPhUuUzxmqp3/tvKS9mm/H5q8aPnf5WXLN
 1ijgB
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

This series prepares the powerpc Kconfig and Kbuild files for clang's
per-task stack protector support. clang requires
'-mstack-protector-guard-offset' to always be passed with the other
'-mstack-protector-guard' flags, which does not always happen with the
powerpc implementation, unlike arm, arm64, and riscv implementations.
This series brings powerpc in line with those other architectures, which
allows clang's support to work right away when it is merged.
Additionally, there is one other fix needed for the Kconfig test to work
correctly when targeting 32-bit.

I have tested this series in QEMU against LKDTM's REPORT_STACK_CANARY
with ppc64le_guest_defconfig and pmac32_defconfig built with a toolchain
that contains Keith's in-progress pull request, which should land for
LLVM 20:

https://github.com/llvm/llvm-project/pull/110928

---
Changes in v2:
- Combined patch 1 and 3, as they are fixing the same test for similar
  reasons; adjust commit message accordingly (Christophe)
- Moved stack protector guard flags on one line in Makefile (Christophe)
- Add 'Cc: stable' targeting 6.1 and newer for the sake of simplicity,
  as it is the oldest stable release where this series applies cleanly
  (folks who want it on earlier releases can request or perform a
  backport separately).
- Pick up Keith's Reviewed-by and Tested-by on both patches.
- Add a blurb to commit message of patch 1 explaining why clang's
  register selection behavior differs from GCC.
- Link to v1: https://lore.kernel.org/r/20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org

---
Nathan Chancellor (2):
      powerpc: Fix stack protector Kconfig test for clang
      powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clang

 arch/powerpc/Kconfig  |  4 ++--
 arch/powerpc/Makefile | 13 ++++---------
 2 files changed, 6 insertions(+), 11 deletions(-)
---
base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
change-id: 20241004-powerpc-fix-stackprotector-test-clang-84e67ed82f62

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

