Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00D4221F26;
	Sat, 12 Sep 2026 11:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211045; cv=none; b=ag+uTQJNxV+xphhbDBRaRvdtTDNC+WnFmiwqJbqUZZ03nZSlNaUE9OvLPT+5tODOcLGyiWkCgTIxkfBo4XXo6PUbSpZIT3vKwKMIP8094bCe+uzoXHuNFN+w576XqKY53B4sbwuOJfAXyRcxP/VGjVqU3TrnX/sDPrgRXfxmADo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211045; c=relaxed/simple;
	bh=0D7hsOxey968Tw2YHcVYAKlJnCnACiIJ2yRsTbF3210=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLPyTrK9GsMMtz5FX4CgwLaPmeUySTge6Ko6ukgTVs+UotzCUcIbeYwXDyrF5mAOjAS83KHuBGdm+8aoN2gxzRwH3ZJF/GyzGuwMxY+TA1M9KvGG7tt58K4uEwKjQPMbjzupUq1hXzGLr7bE0A6RwsOhBgRonptc9n0qJ4mf8Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvFT5q0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvFT5q0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2985E1F000FF;
	Sat, 12 Sep 2026 11:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211043;
	bh=Vjv7MIMhV7uDEGzR/rutTz2lvRaKM5IpsPjVuYnHh0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvFT5q0iz5EmZ2pKYGcOXRFwNpdEcVXwcwNVZZI6trmbCaBn0GhXFvCGN3UM1J+zR
	 gXNHa6jWNyoCrs6Hwr6PTja/tf2uf/EAj2AyjPX48woTtB1HAwPA9FSKgb9U8MTfLN
	 A3aDGWTNbSsRf1S6XTWRzN0SsnAM8s/CvymZIJ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1107/1518] arm64: bti: Disable in-kernel BTI with recent versions of Clang
Date: Sat, 12 Sep 2026 08:54:36 +0200
Message-ID: <20260912065648.493010200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9e834f0f8dd09..f7c4cb4fbaf1b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2112,6 +2112,8 @@ config ARM64_BTI_KERNEL
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



