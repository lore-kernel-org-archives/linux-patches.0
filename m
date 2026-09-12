Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7055520ED;
	Sat, 12 Sep 2026 08:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203094; cv=none; b=dYVlH2AJk2ME+XmXVaTuqhZjrcRntHXVdtUK6W1n5wtyZF4uzl4m7OSpPEa7gkY4KMBb1yW39KVYFnxkfZz0homiCu3qxJvBwx6NknEdHuTFehrdvjrYAFE37pbFjfK6fiVzK58ESOxmudvkMRDNV8ruWp95TZDJfNvpxPmxQ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203094; c=relaxed/simple;
	bh=fXUVwtVUbSdrRGzFc9j+gm4Lp5y9sHvRaosHZMhnErg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyavdFyfL8+g/bhXzC6Gqd2lptBSrgF5zUmqOJKx6KnckAYWc3I0DiiH5l9vQ2mgrqepY9CGThfzQ2y3zSHqlAtr88iLunnCDi46lpwmzyuC5vGE7DhEJCU0yJN/If/Ry/8hwPohgSDxVi30oixHvIONO7PlLvPO/vu/cBiWUyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILta3SCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILta3SCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A35A1F000FF;
	Sat, 12 Sep 2026 08:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203093;
	bh=BROI/gVOYAnf8Bl+YkheHjM9VzoxR9/HJG9S3lIIPpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILta3SCblSAAIiUc/zz7lPN4JWTQyOnlLZMcUbb0/L9idGF+1sk61FvmL4R6Ggprq
	 hNwwrqKSbLUUPpIEigGYyXursYGghWOHVtxR/00z59hbfA10c1BDr5Hb06PVdbjpzC
	 MVHzOdmL81hs4eu1kCXNe5M1aZwLnTlQRaplmwAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1339/1815] arm64: bti: Disable in-kernel BTI with recent versions of Clang
Date: Sat, 12 Sep 2026 08:51:29 +0200
Message-ID: <20260912065720.456236268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit d3359af21fc9e7a47577ff90e821b6510ec34dee ]

The following BTI exception was seen when loading a livepatch module:

  Internal error: Oops - BTI: 0000000036000001 [#1]  SMP
  pstate: 634004c9 (nZCv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=jc)
  pc : kill_orphaned_pgrp+0x0/0x150
  lr : do_exit+0x498/0xaf0 [livepatch_combined]

The problem is that the patch module's do_exit() is branching to a
static function in vmlinux using a module PLT veneer (indirect branch),
but the target function doesn't have a BTI landing pad.

Clang 21+ omits the landing pad for static functions which can only be
reached by a direct branch.  That's normally fine for ordinary modules
which only branch to global exported functions, but Mark Brown points
out [1] that this isn't guaranteed if the module branches between
sections. Futhermore, livepatch modules use klp relocations to reference
arbitrary kernel symbols, so with CONFIG_RANDOMIZE_MODULE_REGION_FULL
the module is far enough from the kernel that every R_AARCH64_CALL26
needs a PLT.

Put Clang 21+ in the naughty corner alongside GCC, which suffers from
the same issue, by disabling CONFIG_ARM64_BTI_KERNEL until we have a
version of the toolchain with the problem resolved.

Cc: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/da06bbd3-d04b-4d0f-b331-f5b91bc373a5@sirena.org.uk [1]
Fixes: fd1e0fd71f65 ("arm64: Implement HAVE_LIVEPATCH")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
[will: Stitched together commit message, diff and bug number]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919b..fc57d90d92c1d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2116,6 +2116,8 @@ config ARM64_BTI_KERNEL
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106671
 	depends on !CC_IS_GCC
+	# https://github.com/llvm/llvm-project/issues/215547
+	depends on !CC_IS_CLANG || CLANG_VERSION < 210000
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_ARGS)
 	help
 	  Build the kernel with Branch Target Identification annotations
-- 
2.53.0



