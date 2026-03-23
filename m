Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D60823DD;
	Mon, 23 Mar 2026 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275553; cv=none; b=aauZG+WT5T1uLGtl1mzGCalfHqDm+gXS2K+vaDW/3lJK4EWThtf8s/ewMp+6GVZbxuFC8RyOflqH+2zIf9vEi/BXPu2e2DryklWHKsoz4s+3LojRkH2851r/u1i6n6DQCa9rL/r01x7NPq2+VcZzrNQYYiYhu1JvTHis72e9q5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275553; c=relaxed/simple;
	bh=RlkTUgz8+dFK9zeQXgfIDFFkFY6nNWFlQFygEaWPHOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0mXYqaNfiBtyDWnJmH621h2yvsZ0kB1kgHnM46Mj0EvMowwQpofTHPhYtPJL2yf5OUJjHIBkUrZfRQU0r+X4z/jhfxvIgnhLZVbjgGxhA6jBo6rAUPS9nHdX8dCRon7PqX0LHWeuBhdw/rv5lUy7IcePQ8rCiGxXYg3VB6Mw04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJrfDIv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJrfDIv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81811C4CEF7;
	Mon, 23 Mar 2026 14:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275552;
	bh=RlkTUgz8+dFK9zeQXgfIDFFkFY6nNWFlQFygEaWPHOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJrfDIv8B/j30BMKz+Zjtgdz6WYsimeWsMOaeMuw37zG1L70SEv47WWo63TeZK44r
	 ri8wC82lM3cKaz9glTEO7K2mPrdoy24RwoKCQJOKBxEPhms4CT9FgT+WbmRvWRDmh8
	 yZJ9nKt+Ndq0++Lz5kZQE1ihpqZvLzQS89fqu2Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/460] kbuild: Disable CC_HAS_ASM_GOTO_OUTPUT on clang < 17
Date: Mon, 23 Mar 2026 14:42:15 +0100
Message-ID: <20260323134530.009032871@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit e2ffa15b9baa447e444d654ffd47123ba6443ae4 ]

clang < 17 fails to use scope local labels with CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y:

     {
     	__label__ local_lbl;
	...
	unsafe_get_user(uval, uaddr, local_lbl);
	...
	return 0;
	local_lbl:
		return -EFAULT;
     }

when two such scopes exist in the same function:

  error: cannot jump from this asm goto statement to one of its possible targets

There are other failure scenarios. Shuffling code around slightly makes it
worse and fail even with one instance.

That issue prevents using local labels for a cleanup based user access
mechanism.

After failed attempts to provide a simple enough test case for the 'depends
on' test in Kconfig, the initial cure was to mark ASM goto broken on clang
versions < 17 to get this road block out of the way.

But Nathan pointed out that this is a known clang issue and indeed affects
clang < version 17 in combination with cleanup(). It's not even required to
use local labels for that.

The clang issue tracker has a small enough test case, which can be used as
a test in the 'depends on' section of CC_HAS_ASM_GOTO_OUTPUT:

void bar(void **);
void* baz(void);

int  foo (void) {
    {
	    asm goto("jmp %l0"::::l0);
	    return 0;
l0:
	    return 1;
    }
    void *x __attribute__((cleanup(bar))) = baz();
    {
	    asm goto("jmp %l0"::::l1);
	    return 42;
l1:
	    return 0xff;
    }
}

Add another dependency to config CC_HAS_ASM_GOTO_OUTPUT for it and use the
clang issue tracker test case for detection by condensing it to obfuscated
C-code contest format. This reliably catches the problem on clang < 17 and
did not show any issues on the non broken GCC versions.

That test might be sufficient to catch all issues and therefore could
replace the existing test, but keeping that around does no harm either.

Thanks to Nathan for pointing to the relevant clang issue!

Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1886
Link: https://github.com/llvm/llvm-project/commit/f023f5cdb2e6c19026f04a15b5a935c041835d14
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 219ccdb0af732..1a39330252c59 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -104,7 +104,10 @@ config GCC_ASM_GOTO_OUTPUT_BROKEN
 config CC_HAS_ASM_GOTO_OUTPUT
 	def_bool y
 	depends on !GCC_ASM_GOTO_OUTPUT_BROKEN
+	# Detect basic support
 	depends on $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
+	# Detect clang (< v17) scoped label issues
+	depends on $(success,echo 'void b(void **);void* c(void);int f(void){{asm goto("jmp %l0"::::l0);return 0;l0:return 1;}void *x __attribute__((cleanup(b)))=c();{asm goto("jmp %l0"::::l1);return 2;l1:return 3;}}' | $(CC) -x c - -c -o /dev/null)
 
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
-- 
2.51.0



