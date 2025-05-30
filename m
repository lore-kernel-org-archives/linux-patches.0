Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC59F25FA0B;
	Fri, 30 May 2025 12:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608844; cv=none; b=IN8yoJK2JR8ksflPvwEasp9cx9lFQl47QUtnVwZP59H1Pjv/IoLzYOBdCge1264g9p5dGVlc3nvEpOL36Xz3fd4VjBRKePEm//3ksPNBWhZzn4b8/N8IdLMuUDzmX+YCdNBvIPKU+h7h2jAarNlkZG9fJkkIGPT82RqNm1Zp88Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608844; c=relaxed/simple;
	bh=NmCknZ1dgOU6tT3IPlVIZOmSwinfpoOWL0s8rcnW3uY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPHsZJBp+i7Aga2LpRdmPW+h2beKIpKLGYrHfopcLaiO4erW4n6zptgO60Y9WTIHJuE1hFyNRGg2pNekDC4qPr2xTnrD5b9/5yw00nvXAMqBbTvCcX0pRb3UF+H08sb0O3ZnPU+gfOw1AWqv0//6gnBszxBM3c+s9G0N9XMPOMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEXfn+W0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEXfn+W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA964C4CEE9;
	Fri, 30 May 2025 12:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608844;
	bh=NmCknZ1dgOU6tT3IPlVIZOmSwinfpoOWL0s8rcnW3uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEXfn+W0fEzsr13pJk4bu7I+onrb7RiJZxVxGxFrrdcRZaIp+dM45LtC3XbUl2DXX
	 OR90jAWPz0u+rfI1u9cmEUpDsuCUVSGlaSvu/ZhG5nbC7MsnXEr13ErMalnMyQF1CH
	 rWVP0Ct08Xf7LE3fNdsBFowLiEFxSE08oeJsMQK8fCjocvggZ38O+6cTGPifJpVYiP
	 9W6dYzoGcFHBxF8CmZAIcA4KIWcryb6fJI7aIX7lzjAAEK3J2suLg5F9z9BGkijKFI
	 p9vrmnXvhjzHenExklvBymcCJqHBJz9zf9JDLNRThpn+JQTaFtCkMSl8YpFulKbSTK
	 Yw9IXeckH/04w==
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
Subject: [PATCH AUTOSEL 6.12 24/26] tools/nolibc: use pselect6_time64 if available
Date: Fri, 30 May 2025 08:40:10 -0400
Message-Id: <20250530124012.2575409-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124012.2575409-1-sashal@kernel.org>
References: <20250530124012.2575409-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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
index 7b82bc3cf1074..ab5b9ff285c03 100644
--- a/tools/include/nolibc/sys.h
+++ b/tools/include/nolibc/sys.h
@@ -981,6 +981,14 @@ int sys_select(int nfds, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeva
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

