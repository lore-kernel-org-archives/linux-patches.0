Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB614306B11;
	Thu, 12 Mar 2026 20:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346956; cv=none; b=uhx0sG/tPPxyj6+QYp6Qx0VUNE9z8Z6V82J8XpI/kYQ/k34+l2dw1fwBWzfAjrmLK4RYzNR0gT8ayIAoNzMPCoLAiMvUfeXpp43rUDcU6s0mlFKNNezrTyQeynN54jmKbNKl/8rdyasWp/jSpKPXBVf33hpCHZOAjfI36kNRZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346956; c=relaxed/simple;
	bh=t6vsqWwR4qkn6vZGOpdWTQQ2J4CtxGt9RvBZqkMad6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j57yHZF3KlM+LFjFSEZ4ye3b69xk3I7+cIBr4vV8zecTjK1epHli1eXS6R07HJQkrFbbFI+1t8eJGNsUJRORsDBSLweX1BimNnVuf/JMP1q9MEVgupASqWtfAHjcgkydjuIA6TXMrzIuOJVkYMt3BOblyl+SScjJPQ5rQdwx7fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw8JCGzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw8JCGzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619F5C4CEF7;
	Thu, 12 Mar 2026 20:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346956;
	bh=t6vsqWwR4qkn6vZGOpdWTQQ2J4CtxGt9RvBZqkMad6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kw8JCGzEjhhYwhOsHdoHcAm8Ybw/XtH4Qpr1M/rr7U/vjH4nD2n6LR5dKqumkD8yg
	 86il/J2KhagiIl6XI73cqCkMisDXbW68Y/6rtSedJXTRlIUliLZq37i0U90XV8NGQJ
	 rmjxBsmmZav6V/ui91/BOyNyGTMHR57MLA0W7fHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/265] ACPI: APEI: GHES: Disable KASAN instrumentation when compile testing with clang < 18
Date: Thu, 12 Mar 2026 21:09:14 +0100
Message-ID: <20260312201024.309826180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit b584bfbd7ec417f257f651cc00a90c66e31dfbf1 ]

After a recent innocuous change to drivers/acpi/apei/ghes.c, building
ARCH=arm64 allmodconfig with clang-17 or older (which has both
CONFIG_KASAN=y and CONFIG_WERROR=y) fails with:

  drivers/acpi/apei/ghes.c:902:13: error: stack frame size (2768) exceeds limit (2048) in 'ghes_do_proc' [-Werror,-Wframe-larger-than]
    902 | static void ghes_do_proc(struct ghes *ghes,
        |             ^

A KASAN pass that removes unneeded stack instrumentation, enabled by
default in clang-18 [1], drastically improves stack usage in this case.

To avoid the warning in the common allmodconfig case when it can break
the build, disable KASAN for ghes.o when compile testing with clang-17
and older. Disabling KASAN outright may hide legitimate runtime issues,
so live with the warning in that case; the user can either increase the
frame warning limit or disable -Werror, which they should probably do
when debugging with KASAN anyways.

Closes: https://github.com/ClangBuiltLinux/linux/issues/2148
Link: https://github.com/llvm/llvm-project/commit/51fbab134560ece663517bf1e8c2a30300d08f1a [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260114-ghes-avoid-wflt-clang-older-than-18-v1-1-9c8248bfe4f4@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index 2c474e6477e12..346cdf0a0ef99 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -1,6 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ACPI_APEI)		+= apei.o
 obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
+# clang versions prior to 18 may blow out the stack with KASAN
+ifeq ($(CONFIG_COMPILE_TEST)_$(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_y_)
+KASAN_SANITIZE_ghes.o := n
+endif
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 einj-y				:= einj-core.o
 einj-$(CONFIG_ACPI_APEI_EINJ_CXL) += einj-cxl.o
-- 
2.51.0



