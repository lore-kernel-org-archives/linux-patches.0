Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F94A2522B5;
	Fri, 30 May 2025 12:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608809; cv=none; b=dzuMRdvauk4HROC7Dgal1wTpA9EBO2WEDo4/zcolBrG+/xeyomNeGkwNdUlEYI20F9+AF1IrOlStfAhHh1FtK8QA1mGM34Kw1B53YSnEEOo4SdjpQ0enrhopXPdTvmPHP4OGbVWIxQaOtDVaxP01gJ64jOLHJFp4qEYyNBHTXpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608809; c=relaxed/simple;
	bh=poXFRBoHY/JOXMW1SDPPvXManolaYnkYIJsuOj/kcYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLHgQ9Wtr9woK//9z/2dS3B0jqCwJeDC0+kH3fKWtcNAIEWpcViMSsLBDZAQT0vx8tO0FahDHe6xgjO72QKOpBBdFwunPErm09y3r/GYyn5oMYvhREA8nE6rGRyjvkYzTZx+tLgqt4tg5m9t0iz3rHOc7mhC9Y/PGAERam0q+EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8/R9oiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8/R9oiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF49C4CEEF;
	Fri, 30 May 2025 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608808;
	bh=poXFRBoHY/JOXMW1SDPPvXManolaYnkYIJsuOj/kcYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8/R9oiUgva+JP6n1nzdt+xtCR26k7mbrjCISYAmb/I5HfbJLgwvH2zwOoOezXarc
	 4T7wWgfKWkax06II1j7hdtgd3FbFhqydKYA3tt7GMp/tGIdATZrEcu5VuI3EmKCNZl
	 wW2jQCXhH7nbCTJNMsnGK5i4THM8yblywOYb1FNY9mWjXWoLloknnlbmN7xCq9az01
	 xP7/xecXtCmFwIG8J9U41+dI+Mg0MYRtQqOPnIXdv9JNvvq1BEQiBZJfJL1lX6n984
	 +/jx16pjdKH9FzUB1uruoWqeba1x75yDSCNEjXe99/feiohgqNKc7KxSWcqjrAvaM4
	 RHnsXp+7LKqQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.14 26/28] tools/nolibc: use pselect6_time64 if available
Date: Fri, 30 May 2025 08:39:32 -0400
Message-Id: <20250530123934.2574748-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123934.2574748-1-sashal@kernel.org>
References: <20250530123934.2574748-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 248ddc80b145515286bfb75d08034ad4c0fdb08e ]

riscv32 does not have any of the older select systemcalls.
Use pselect6_time64 instead.
poll() is also used to implement sleep().

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Code Analysis The commit adds support for
`pselect6_time64` syscall as a fallback option in the `sys_select()`
function in `tools/include/nolibc/sys.h`. The change adds 8 lines of
code that implement an additional fallback case: ```c #elif
defined(__NR_pselect6_time64) struct __kernel_timespec t; if (timeout) {
t.tv_sec = timeout->tv_sec; t.tv_nsec = timeout->tv_usec 0001-Fix-
Clippy-warnings.patch 0002-Enhance-inference-prompt-to-utilize-
CVEKERNELDIR-whe.patch 0003-Update-to-latest-version-of-clap.patch
Cargo.lock Cargo.toml LICENSE README.md analyze_merge_commit.sh
io_uring_analysis.txt ksmbd_analysis.txt merge_commit_analysis.txt model
prompt src target test_gpio_cleanup.txt test_patch.txt 1000; } return
my_syscall6(__NR_pselect6_time64, nfds, rfds, wfds, efds, timeout ? &t :
NULL, NULL); ``` This follows the exact same pattern as the existing
`__NR_pselect6` fallback, but uses `__kernel_timespec` instead of
`timespec`. ## Why This Should Be Backported **1. Fixes a Real Bug**:
RISC-V 32-bit systems that don't provide legacy select syscalls
(`__NR_select`, `__NR__newselect`) would fall back to `__NR_pselect6`,
but newer systems may only provide `__NR_pselect6_time64`. Without this
patch, `select()` calls would fail with `ENOSYS` on such systems. **2.
Low Risk**: This is a minimal, targeted fix that: - Only affects systems
that lack both legacy select syscalls AND regular pselect6 - Uses an
identical code pattern to existing fallbacks - Doesn't modify any
existing working code paths - Is self-contained with no dependencies
**3. Consistent with Similar Commits**: Looking at the historical
reference commits, this follows the same pattern as commit #1 (Status:
YES) which added pselect6 support for RISCV, and is much simpler than
commits #2-5 (Status: NO) which involved more complex architectural
changes. **4. Addresses Platform Compatibility**: The commit message
specifically mentions that "riscv32 does not have any of the older
select systemcalls" and this provides necessary compatibility for newer
RISC-V 32-bit platforms. **5. Minimal Scope**: The change only adds one
additional fallback case before the final `ENOSYS` return, making it
extremely safe. **6. Essential for Functionality**: Without this fix,
basic I/O operations using select() would be broken on affected RISC-V
32-bit systems, making tools/nolibc unusable for such platforms. The
commit meets all criteria for stable backporting: it's a clear bugfix,
has minimal risk, doesn't introduce new features, and fixes
functionality that users depend on.

 tools/include/nolibc/sys.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/include/nolibc/sys.h b/tools/include/nolibc/sys.h
index d4a5c2399a66b..977838f2fcf97 100644
--- a/tools/include/nolibc/sys.h
+++ b/tools/include/nolibc/sys.h
@@ -982,6 +982,14 @@ int sys_select(int nfds, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeva
 		t.tv_nsec = timeout->tv_usec * 1000;
 	}
 	return my_syscall6(__NR_pselect6, nfds, rfds, wfds, efds, timeout ? &t : NULL, NULL);
+#elif defined(__NR_pselect6_time64)
+	struct __kernel_timespec t;
+
+	if (timeout) {
+		t.tv_sec  = timeout->tv_sec;
+		t.tv_nsec = timeout->tv_usec * 1000;
+	}
+	return my_syscall6(__NR_pselect6_time64, nfds, rfds, wfds, efds, timeout ? &t : NULL, NULL);
 #else
 	return __nolibc_enosys(__func__, nfds, rfds, wfds, efds, timeout);
 #endif
-- 
2.39.5

