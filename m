Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBA3347BA9;
	Mon,  4 May 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903229; cv=none; b=YiKeXyxMgIVYbYHdotQOLpMd4TJR4dXiu7LIthvkgx1NDOPcJKR1TBULxf5HPaly4fpLE/+tE5D2OiwdikhZMabMewz2r9oEBbzpTbiCTZ9nJgF/6D5By6FZhNPjzYR7ZsvOS6Jh2b6HDMcs0Knm3xkfvYdKxbzYxt1XD/8Ao6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903229; c=relaxed/simple;
	bh=00Fh116Z23T5r6tgjo3x2I880gTe9PyZ5U0pJtPosXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh+Qb3wQ0dKcg+DPJZNeNhfZwLLOXsoB7iTMqCztfn8Jwhcyn36SLpofnsJzLyusEvSR8qiTHyFwGuRrKckTpUMv07JgGU2+9pS/O2K6MfofjsLUKp6bvfQq1Esiu6q1OhrZoPw6rShYqfo7a9xHTCUHJHERaRGNkAnXBHhcbYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pse3SM23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pse3SM23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D003AC2BCB8;
	Mon,  4 May 2026 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903229;
	bh=00Fh116Z23T5r6tgjo3x2I880gTe9PyZ5U0pJtPosXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pse3SM23ptybtbmnssZjMIyVJCPmBkPEOWbnbOC+Ui+PuiNkQk/47cdydOWWA3G1l
	 oPSUJIZpYeHCai+PD0zCrwTo3J4xj2+r5QPco5YK+7BdcNlOkeP6V3whr6YXBFLBjg
	 BJBGNpgnEhyKEHG7Z+KnSPyaz57j64MGSc8JOQpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 7.0 153/307] printf: Compile the kunit test with DISABLE_BRANCH_PROFILING DISABLE_BRANCH_PROFILING
Date: Mon,  4 May 2026 15:50:38 +0200
Message-ID: <20260504135148.543151259@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.com>

commit 8901ac9d2c7eb8ed7ae5e749bf13ecb3b6062488 upstream.

GCC < 12.1 can miscompile printf_kunit's errptr() test when branch
profiling is enabled. BUILD_BUG_ON(IS_ERR(PTR)) is a constant false
expression, but CONFIG_TRACE_BRANCH_PROFILING and
CONFIG_PROFILE_ALL_BRANCHES make the IS_ERR() path side-effectful.
GCC's IPA splitter can then outline the cold assert arm into
errptr.part.* and leave that clone with an unconditional
__compiletime_assert_*() call, causing a false build failure.

This started showing up after test_hashed() became a macro and moved its
local buffer into errptr(), which changed GCC's inlining and splitting
decisions enough to expose the compiler bug.

Workaround the problem by disabling the branch profiling for
printf_kunit.o. It is a straightforward and acceptable solution.

The workaround can be removed once the minimum GCC includes commit
76fe49423047 ("Fix tree-optimization/101941: IPA splitting out
function with error attribute"), which first shipped in GCC 12.1.

Fixes: 9bfa52dac27a ("printf: convert test_hashed into macro")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604030636.NqjaJvYp-lkp@intel.com/
Cc: stable@vger.kernel.org
Acked-by: Tamir Duberstein <tamird@kernel.org>
Link: https://patch.msgid.link/ad5gJAX9f6dSQluz@pathway.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/tests/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 05f74edbc62b..7e9c2fa52e35 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -40,6 +40,8 @@ obj-$(CONFIG_MEMCPY_KUNIT_TEST) += memcpy_kunit.o
 obj-$(CONFIG_MIN_HEAP_KUNIT_TEST) += min_heap_kunit.o
 CFLAGS_overflow_kunit.o = $(call cc-disable-warning, tautological-constant-out-of-range-compare)
 obj-$(CONFIG_OVERFLOW_KUNIT_TEST) += overflow_kunit.o
+# GCC < 12.1 can miscompile errptr() test when branch profiling is enabled.
+CFLAGS_printf_kunit.o += -DDISABLE_BRANCH_PROFILING
 obj-$(CONFIG_PRINTF_KUNIT_TEST) += printf_kunit.o
 obj-$(CONFIG_RANDSTRUCT_KUNIT_TEST) += randstruct_kunit.o
 obj-$(CONFIG_SCANF_KUNIT_TEST) += scanf_kunit.o
-- 
2.54.0



