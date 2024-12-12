Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656F022A803;
	Thu, 12 Dec 2024 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020782; cv=none; b=QjZxvT88ArUd0XADrhtQRxMAF5bnqcD9+GSjoU3XgtV8C3ueKXzGXCWCqIqEj7OXV1D3z42Jt+HX+XpVnLYedclHfRYr6h0CMRrO0+rfXQ9ZVxkSUgx9Nt9wY9R+WWm+ProFGGu/mbsJnVM1YjHXe/XRr20TB6Fpk28ledwakv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020782; c=relaxed/simple;
	bh=QSvtpMEiATseWQOoa/p1//zeh74G0UPozH+2yIvtVj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McZUWR2+xiHZOK+HPQOU4Y2ZDAYakHtCU+O1VHnckUrKvc5sVpew/g+kG5gahmduqHGF/OlCJCLYcjRwGqUVhGaQpZOSP8SR9ASmwZvrc9yRk6usG94upKD3OwlMpJxPwTuiGrZAP9Roi14lLyS14Xu66e3pZE7VLoaOkgoC2OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdg9GMSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdg9GMSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5EFC4CECE;
	Thu, 12 Dec 2024 16:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020782;
	bh=QSvtpMEiATseWQOoa/p1//zeh74G0UPozH+2yIvtVj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdg9GMSi38kspiDFUXs6cvuZMw58MSFYv8R1j9WuhduWae7yNIQLBqlsSfnt3hFqb
	 IMjsH/Nj2egQIxfa94GzhyGGfD3h3A90vWZzS4seNmxFMGsskOW9UtLxOiBDxIsEhH
	 dU0KtMsgokCjzj5NjcVaHqKetusu24BjRxhKzd+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 559/772] powerpc/vdso: Remove an unsupported flag from vgettimeofday-32.o with clang
Date: Thu, 12 Dec 2024 15:58:24 +0100
Message-ID: <20241212144413.062784249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 05e05bfc92d196669a3d087fc34d3998b6ddb758 ]

When clang's -Qunused-arguments is dropped from KBUILD_CPPFLAGS, it
warns:

  clang-16: error: argument unused during compilation: '-fno-stack-clash-protection' [-Werror,-Wunused-command-line-argument]

This warning happens because vgettimeofday-32.c gets its base CFLAGS
from the main kernel, which may contain flags that are only supported on
a 64-bit target but not a 32-bit one, which is the case here.
-fstack-clash-protection and its negation are only suppported by the
64-bit powerpc target but that flag is included in an invocation for a
32-bit powerpc target, so clang points out that while the flag is one
that it recognizes, it is not actually used by this compiler job.

To eliminate the warning, remove -fno-stack-clash-protection from
vgettimeofday-32.c's CFLAGS when using clang, as has been done for other
flags previously.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: d677ce521334 ("powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index d4023bceec348..7e69e87fbf744 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -16,6 +16,11 @@ ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday-32.o += -ffreestanding -fasynchronous-unwind-tables
   CFLAGS_REMOVE_vgettimeofday-32.o = $(CC_FLAGS_FTRACE)
   CFLAGS_REMOVE_vgettimeofday-32.o += -mcmodel=medium -mabi=elfv1 -mabi=elfv2 -mcall-aixdesc
+  # This flag is supported by clang for 64-bit but not 32-bit so it will cause
+  # an unused command line flag warning for this file.
+  ifdef CONFIG_CC_IS_CLANG
+  CFLAGS_REMOVE_vgettimeofday-32.o += -fno-stack-clash-protection
+  endif
   CFLAGS_vgettimeofday-64.o += -include $(c-gettimeofday-y)
   CFLAGS_vgettimeofday-64.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
   CFLAGS_vgettimeofday-64.o += $(call cc-option, -fno-stack-protector)
-- 
2.43.0



