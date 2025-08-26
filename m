Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C996721ABDC;
	Tue, 26 Aug 2025 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216705; cv=none; b=SfmZgLKYoY9Ay6FXsAroYWgbkQwaick38OnXwFt3NY4YDPjr2UB0Z1ZHeBTE7x5cMy7lcC4XpmKy4T5o8dDVs5lnim4QUa9fo1neODwVK5cFlx3MQFHfJd7G0x+EaUNgdGVedvKZfUMqrnVF3egoOlCieYeRG28BADXs9GMDPcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216705; c=relaxed/simple;
	bh=52kyHoJrkUgSE2B1CNyIO6ffBNwj/B6e00e6LMZWTII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzlCaqf0l9BbW/y409aRNYqp65l0s/Pu7n0qLil+ejJ2PvDs/KgPDCjQ0AE8Sgp6WQVIr+r8rc0mmV5MrEJeDzdGqqRXLXQ0PgkF0SrhQxyW2+8h68l91u0PvBJIGNtue3zBiEMfnXxijVdeLzDfcvxg1SAXfzJp4om26lKYgK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piVJux3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piVJux3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB77C4CEF1;
	Tue, 26 Aug 2025 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216705;
	bh=52kyHoJrkUgSE2B1CNyIO6ffBNwj/B6e00e6LMZWTII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piVJux3U1JS5lnh6ClvcrkPb1/eswHKeSkJmRQaXsuKlm5Xtc6VAGjfpJgMH0AX0M
	 lcN4ulAu4MZ6YLLlmJnUefd0P9yCZJZWOlgriWlA9FRXQMP1AMPWIMO8ijsQ2gtHe7
	 dJm2pfCvvtc8lcq4nBlGbXQIO8ohTyNQSKDLzrrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KernelCI bot <bot@kernelci.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/644] ARM: 9448/1: Use an absolute path to unified.h in KBUILD_AFLAGS
Date: Tue, 26 Aug 2025 13:10:04 +0200
Message-ID: <20250826110959.217522769@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 87c4e1459e80bf65066f864c762ef4dc932fad4b ]

After commit d5c8d6e0fa61 ("kbuild: Update assembler calls to use proper
flags and language target"), which updated as-instr to use the
'assembler-with-cpp' language option, the Kbuild version of as-instr
always fails internally for arch/arm with

  <command-line>: fatal error: asm/unified.h: No such file or directory
  compilation terminated.

because '-include' flags are now taken into account by the compiler
driver and as-instr does not have '$(LINUXINCLUDE)', so unified.h is not
found.

This went unnoticed at the time of the Kbuild change because the last
use of as-instr in Kbuild that arch/arm could reach was removed in 5.7
by commit 541ad0150ca4 ("arm: Remove 32bit KVM host support") but a
stable backport of the Kbuild change to before that point exposed this
potential issue if one were to be reintroduced.

Follow the general pattern of '-include' paths throughout the tree and
make unified.h absolute using '$(srctree)' to ensure KBUILD_AFLAGS can
be used independently.

Closes: https://lore.kernel.org/CACo-S-1qbCX4WAVFA63dWfHtrRHZBTyyr2js8Lx=Az03XHTTHg@mail.gmail.com/

Cc: stable@vger.kernel.org
Fixes: d5c8d6e0fa61 ("kbuild: Update assembler calls to use proper flags and language target")
Reported-by: KernelCI bot <bot@kernelci.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[ adapted to missing -Wa ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -126,7 +126,7 @@ endif
 
 # Need -Uarm for gcc < 3.x
 KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uarm
-KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y) -include asm/unified.h -msoft-float
+KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y) -include $(srctree)/arch/arm/include/asm/unified.h -msoft-float
 
 CHECKFLAGS	+= -D__arm__
 


