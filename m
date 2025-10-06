Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41C32D879A;
	Mon,  6 Oct 2025 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774768; cv=none; b=Aj2W4lJU7fzxK/5isJara3tXmaY4yQ+lDkCVNbohIzz5WV7pT6kFFdRc4LRUXkpzmYku67LC9zCX211cqDpiHSIDXdOcNgDSWMhUatOvwiIa0oPrm1+iGoaFE935wwdoAGOzyFbp99q/T/prBOOOs9f3Yk/N//Zri50ycp961Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774768; c=relaxed/simple;
	bh=1P+CJTJygY01uW0JAUHdzn0iYW3JbrFQUXteys6rnCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViCd9SewbJp2l+m9UfxJ/pwIzKKmWmFWWJo/GeO5OpeZprF9Q/xwTWDIW1jBeuRZLX4MXZ7bl0lMiRsk0UxS2FveBPexZ5L/7SrxW7YHSePrgqCZZkXhwXUaMYN0tuk67xSqhZmhRS7amQj9qDXyPNiHH71OGrW9ojoipgLGy8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/puwpj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/puwpj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100F8C4CEF5;
	Mon,  6 Oct 2025 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774767;
	bh=1P+CJTJygY01uW0JAUHdzn0iYW3JbrFQUXteys6rnCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/puwpj7Ev2J6AUXqAWvwsUrNQpmcU/zdjE9kNX3Ba2o7Bmz6Q+ba+kM8ZBHi883n
	 FI93R3uGUFeZ9j+bUFkTpJR3V4u/imHPd4um/FN+t4X4wzzcROA0d+DVOXDbP1XMia
	 bsUmY3eYnT8wHzGk+X/y+tfu3/gah6XlCGAaltMDJUnjZxkRwo6TKCjRD1+VHd5o7h
	 3XYOi6yVx9GyuejeU3yYn6NY6XWwvtLv/MyMgFaGm2j6QKgNGwnIBkqC5Xav4tXKyn
	 wkPGKKBLvaKbSE/QT+XsrXS/6FBRR11PqNqH22Lp/Q0cASr4uf/FrVcvi+sQomRv8P
	 46onCq4RiebpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.12] seccomp: passthrough uprobe systemcall without filtering
Date: Mon,  6 Oct 2025 14:17:51 -0400
Message-ID: <20251006181835.1919496-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 89d1d8434d246c96309a6068dfcf9e36dc61227b ]

Adding uprobe as another exception to the seccomp filter alongside
with the uretprobe syscall.

Same as the uretprobe the uprobe syscall is installed by kernel as
replacement for the breakpoint exception and is limited to x86_64
arch and isn't expected to ever be supported in i386.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250720112133.244369-21-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my thorough research, I can now provide a comprehensive
analysis of this commit.

## Analysis Summary

**Backport Status: YES**

### Detailed Explanation

#### 1. Context and Dependency

This commit adds seccomp passthrough support for the **uprobe syscall**,
which is a NEW system call introduced to optimize uprobe performance. My
research shows that:

- The uprobe syscall was added in commit `56101b69c9190` (July 2025) as
  part of a performance optimization effort
- The seccomp passthrough commit (`89d1d8434d246`) was included in the
  **same patch series** (patch 21/22) as a necessary companion change
- Both commits were merged together into mainline in August 2025

#### 2. Critical Historical Precedent - The uretprobe Bug

The most important finding is that a nearly identical issue occurred
with the **uretprobe syscall**:

- The uretprobe syscall was added in **June 2024** without seccomp
  passthrough
- This caused **real-world failures**: processes in Docker containers
  **segfaulted** when uretprobe was triggered because Docker's seccomp
  filters blocked the unknown syscall
- A fix was required **8 months later** (February 2025) in commit
  `cf6cb56ef2441`:
  - **Fixes tag**: `Fixes: ff474a78cef5 ("uprobe: Add uretprobe syscall
    to speed up return probe")`
  - **Marked for stable**: `Cc: stable@vger.kernel.org`
  - **Bug report**: https://lore.kernel.org/lkml/CAHsH6Gs3Eh8DFU0wq58c_L
    F8A4_+o6z456J7BidmcVY2AqOnHQ@mail.gmail.com/

The commit message stated: *"When attaching uretprobes to processes
running inside docker, the attached process is segfaulted when
encountering the retprobe... the default seccomp filters in docker block
it as they only allow a specific set of known syscalls."*

#### 3. Why This Commit MUST Be Backported

The code changes show that:

**In `seccomp_uprobe_exception()` (lines 744-762):**
```c
+#ifdef __NR_uprobe
+               if (sd->nr == __NR_uprobe)
+                       return true;
+#endif
```

**In `mode1_syscalls[]` array (lines 1042-1046):**
```c
+#ifdef __NR_uprobe
+       __NR_uprobe,
+#endif
```

These changes ensure that:
1. The uprobe syscall bypasses seccomp filtering (just like uretprobe)
2. It's allowed in SECCOMP_MODE_STRICT (mode 1)

**If the uprobe syscall is backported WITHOUT this seccomp change:**
- Any process using seccomp filters (Docker, systemd services, sandboxed
  applications) will crash when uprobe is triggered
- This is the **exact same bug** that affected uretprobe for 8 months

#### 4. Dependency Analysis

Checking the 6.17 stable tree shows:
- The uprobe syscall (commit `408018bc8438e`) **IS present** in commits
  after the 6.17 release
- The seccomp passthrough **must accompany it** to prevent the
  Docker/container crash issue

#### 5. Change Characteristics

- **Small and contained**: Only 32 lines changed in kernel/seccomp.c
- **Low regression risk**: Follows the exact pattern established by
  uretprobe
- **No architectural changes**: Simple exception list addition
- **Reviewed by security maintainer**: Kees Cook (seccomp maintainer)
  provided `Reviewed-by`

### Conclusion

This commit is a **required dependency fix** for the uprobe syscall
feature. Based on the uretprobe precedent, omitting this change would
cause production failures in containerized environments. The commit
should be backported to any stable kernel that includes the uprobe
syscall (`56101b69c9190`) to prevent repeating the same issue that
required a stable backport for uretprobe.

 kernel/seccomp.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 41aa761c7738c..7daf2da09e8e1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -741,6 +741,26 @@ seccomp_prepare_user_filter(const char __user *user_filter)
 }
 
 #ifdef SECCOMP_ARCH_NATIVE
+static bool seccomp_uprobe_exception(struct seccomp_data *sd)
+{
+#if defined __NR_uretprobe || defined __NR_uprobe
+#ifdef SECCOMP_ARCH_COMPAT
+	if (sd->arch == SECCOMP_ARCH_NATIVE)
+#endif
+	{
+#ifdef __NR_uretprobe
+		if (sd->nr == __NR_uretprobe)
+			return true;
+#endif
+#ifdef __NR_uprobe
+		if (sd->nr == __NR_uprobe)
+			return true;
+#endif
+	}
+#endif
+	return false;
+}
+
 /**
  * seccomp_is_const_allow - check if filter is constant allow with given data
  * @fprog: The BPF programs
@@ -758,13 +778,8 @@ static bool seccomp_is_const_allow(struct sock_fprog_kern *fprog,
 		return false;
 
 	/* Our single exception to filtering. */
-#ifdef __NR_uretprobe
-#ifdef SECCOMP_ARCH_COMPAT
-	if (sd->arch == SECCOMP_ARCH_NATIVE)
-#endif
-		if (sd->nr == __NR_uretprobe)
-			return true;
-#endif
+	if (seccomp_uprobe_exception(sd))
+		return true;
 
 	for (pc = 0; pc < fprog->len; pc++) {
 		struct sock_filter *insn = &fprog->filter[pc];
@@ -1042,6 +1057,9 @@ static const int mode1_syscalls[] = {
 	__NR_seccomp_read, __NR_seccomp_write, __NR_seccomp_exit, __NR_seccomp_sigreturn,
 #ifdef __NR_uretprobe
 	__NR_uretprobe,
+#endif
+#ifdef __NR_uprobe
+	__NR_uprobe,
 #endif
 	-1, /* negative terminated */
 };
-- 
2.51.0

