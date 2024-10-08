Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C397A3C0C;
	Tue,  8 Oct 2024 04:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728361353; cv=none; b=HpPMEjcTN3XtyzjzfbmP7ewum+RCUiS0RXsXM9nWNO1po79XqSjQRKXpsXGcd07g8SygN7yjoil4+7zrELD4cnuN3lRjGhLFM86P8jxudIqVam7qHLjBXSiKE8pr8bXh3XeEJr3teTyMGnfILPVxu2bqjTeOycLehLxBLiwzcWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728361353; c=relaxed/simple;
	bh=aBvIzYi0nH04voZ88M0abn2Dncgwg/QRfL20zKWDxJo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=uuKJU0sSom2Fld06nlyqONxjIzhDEgA9lqceMQupDfSRFpYOxopOxctc71MyKbXzdq0lBkN1coU3OL4Yw/Vrc5n1+XAD3Sb4loe/bXmMTCh+2Dh8iYwHiednoHX79OwC/4w7Sw1kj1X8wSN9t/BDnKIejWUWN85ReMm0GUmWjk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ve9n/Y1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ve9n/Y1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42311C4CEC7;
	Tue,  8 Oct 2024 04:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728361353;
	bh=aBvIzYi0nH04voZ88M0abn2Dncgwg/QRfL20zKWDxJo=;
	h=From:Subject:Date:To:Cc:From;
	b=Ve9n/Y1F9k4nH7wnf3JglV3EwQET6h3j44/aUFstDg5nF3LjVEpm++oYa+FuvzgW3
	 l8/ecdPMiKVCZmoMk2J+/97VbaWOLo+shCPcKb5XgD3UJ8s+eCWyB4Gtrfwb0pzkb8
	 2P7/JP4HZBu0dz5NQghKwMrSQnCZtG2N3tGGun/ZL464Mkoz9I6XgwcYUyzVfHZQZ1
	 8Ks0H3GrWqU0d7DnYzmRpp/iD2mlb1meotsKCATSIU+tuVj9phsXr+9kvFhJ0yAqSQ
	 OFn0OeSIS4AmoyoeVj6oWzaaO+MjH0iP8T2FC1G0MSNvignB0tiUbFn0KrYQQx0OHR
	 PnFFIYnjrEuqQ==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/3] powerpc: Prepare for clang's per-task stack protector
 support
Date: Mon, 07 Oct 2024 21:22:02 -0700
Message-Id: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGqzBGcC/x2NQQqDQAwAvyI5N7Aui5V+pfQgMWpocZcktAXx7
 w09zmFmDjBWYYNbd4DyW0zqHtBfOqBt2ldGmYMhp1z6lAq2+mFthIt80XyiZ9PqTF4Vnc2RXmH
 hWHi48jzmZcgQraYcwv9zf5znD+0UJWN3AAAA
X-Change-ID: 20241004-powerpc-fix-stackprotector-test-clang-84e67ed82f62
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1420; i=nathan@kernel.org;
 h=from:subject:message-id; bh=aBvIzYi0nH04voZ88M0abn2Dncgwg/QRfL20zKWDxJo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOksm9vzT1remzgzOefTgnUyqVO0dh9irn/K/eRy3HPlQ
 0b3VHj+d5SyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJrOZk+Gfxzubds+OMK24o
 te2pDi1vaOctvJd/zWLVzwZXr+vbNjYx/NPM/yyQlf815K1X8tJ+uyUWtzU+zPjdm3O//OeBN/d
 +rWYCAA==
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
Nathan Chancellor (3):
      powerpc: Fix stack protector Kconfig test for clang
      powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clang
      powerpc: Include -m32 / -m64 for stack protector Kconfig test

 arch/powerpc/Kconfig  |  4 ++--
 arch/powerpc/Makefile | 15 ++++++---------
 2 files changed, 8 insertions(+), 11 deletions(-)
---
base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
change-id: 20241004-powerpc-fix-stackprotector-test-clang-84e67ed82f62

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

