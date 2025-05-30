Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AE2238C2F;
	Fri, 30 May 2025 12:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608771; cv=none; b=irPI2csDJCY72Y0BjutqmNoaZaqolqrlo0O321PyqHgDxHfVoM2elqLiOeXhCqcZvcZVoPze9CzOrc+Y1Hv+OFK6vC4CqLNt4vXG6JbVuvCdEyITaz4T4IF6hHosKlhU4zVGcrXf9xD0WJ7RjfSXAU44GzszY6+vThZkg2nwqHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608771; c=relaxed/simple;
	bh=l1S7Wox3ofs0VnCAD2exLHvL21BHgJOzzd/Omvusnbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/ZgkbKArHlrRBioa9wancfFMJS/4nhaAjbQSRsdGEWCS/TQ4kywsdOQ2A28gxn8Nnr8fBL9zh5eHqmssxC+c9wGePuFv4Rjqx0JJydEoS6mUFypX+z+bbqL834GMU8LwmF46BrSE/ooG2vnPNuCvTF+ikzJO/p/Yv31/QF1VPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddgpayCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddgpayCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62CBC4CEEB;
	Fri, 30 May 2025 12:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608770;
	bh=l1S7Wox3ofs0VnCAD2exLHvL21BHgJOzzd/Omvusnbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddgpayCGsYuzdYWSuOrW38ETvuled1bZ3c8R8XXd+tHevm02T6ExdC4Bfiyf/+FRB
	 5Qh9GBN7SfFp/U6ahqIJ4+IFFwJ3EV3BSF3DlZh8mDF90b9Obru3XUviAH5WIh2YDR
	 T6lhwsS0KjcS4IpBooiPUj18xexUSMLUtnLi9hxStI0UUM1JBBDICvYiBTW6bNLQ0l
	 zq4VNUnJwddV4rNuNPfj3d7l94qIQTDIz7kPAWMgRVWnH2Kjv68+clBA9C9BD6KwDB
	 u8xkAs0VtM0LUWwzQSBNTZnM6n/gTbubVH8WyP396ZOv6yTcHFMrNc8E9kOfQiPg1x
	 uxqmiekFHMEHA==
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
Subject: [PATCH AUTOSEL 6.15 28/30] tools/nolibc: use pselect6_time64 if available
Date: Fri, 30 May 2025 08:38:50 -0400
Message-Id: <20250530123852.2574030-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123852.2574030-1-sashal@kernel.org>
References: <20250530123852.2574030-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
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
index 08c1c074bec89..a5decdba40223 100644
--- a/tools/include/nolibc/sys.h
+++ b/tools/include/nolibc/sys.h
@@ -1023,6 +1023,14 @@ int sys_select(int nfds, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeva
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

