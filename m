Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A8C23D298;
	Wed, 23 Apr 2025 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419966; cv=none; b=DBWJXSzVWF3ljkmSeupVa4bcFpRzRe/vLfbchsrrJCL43+HF8aV2V4rFoLYUjZ9dK5RzdxTbHp5tabVk525uf+Lg1eZXq6Bjg2maFU6QX/QvycQ8kDoiDOHGiSEhXLraaPZ4m7okoa7SUy0nANsEPE4DyniCAcqlelESv79n2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419966; c=relaxed/simple;
	bh=QQwv4Y4PZD1m9RjMVjZLqmB1W8Y0g31mrsbL5/XgZvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWvVc9PYG1T0TH8h4Nq1d4QY3+NMKkxlltU4iaZ96wsvUi8XYQrU2z9dk02+kxytAp9zXADklJ8wH66KgAD/+G9+Q/V0oXWvejkOHsi8ksQoXZVpuco9ZsHU9zQSL4J8ZZ0yiUx0pJjV5Yr/ijVXSzyjMgS9RKzU0/e1rtDZjiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdSmjuVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdSmjuVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F1BC4CEE2;
	Wed, 23 Apr 2025 14:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419966;
	bh=QQwv4Y4PZD1m9RjMVjZLqmB1W8Y0g31mrsbL5/XgZvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdSmjuVce3VqFsLxMUgqmmbQhap8GPbwUdP+8yaoyyklmNJdmkXAxYj4eYk1G0PSz
	 zlNFMdNJzVTWNfxgGxRyqBIJ6UyFrwvsxczAf1ZzLcOeI6rtrKTRBpss8mu3VijlG9
	 uTsj4xNH/VYAHmPV84oSpUCBNqoE83nqtMnHoUik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 084/223] rust: kasan/kbuild: fix missing flags on first build
Date: Wed, 23 Apr 2025 16:42:36 +0200
Message-ID: <20250423142620.546723043@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 46e24a545cdb4556f8128c90ecc34eeae52477a0 upstream.

If KASAN is enabled, and one runs in a clean repository e.g.:

    make LLVM=1 prepare
    make LLVM=1 prepare

Then the Rust code gets rebuilt, which should not happen.

The reason is some of the LLVM KASAN `rustc` flags are added in the
second run:

    -Cllvm-args=-asan-instrumentation-with-call-threshold=10000
    -Cllvm-args=-asan-stack=0
    -Cllvm-args=-asan-globals=1
    -Cllvm-args=-asan-kernel-mem-intrinsic-prefix=1

Further runs do not rebuild Rust because the flags do not change anymore.

Rebuilding like that in the second run is bad, even if this just happens
with KASAN enabled, but missing flags in the first one is even worse.

The root issue is that we pass, for some architectures and for the moment,
a generated `target.json` file. That file is not ready by the time `rustc`
gets called for the flag test, and thus the flag test fails just because
the file is not available, e.g.:

    $ ... --target=./scripts/target.json ... -Cllvm-args=...
    error: target file "./scripts/target.json" does not exist

There are a few approaches we could take here to solve this. For instance,
we could ensure that every time that the config is rebuilt, we regenerate
the file and recompute the flags. Or we could use the LLVM version to
check for these flags, instead of testing the flag (which may have other
advantages, such as allowing us to detect renames on the LLVM side).

However, it may be easier than that: `rustc` is aware of the `-Cllvm-args`
regardless of the `--target` (e.g. I checked that the list printed
is the same, plus that I can check for these flags even if I pass
a completely unrelated target), and thus we can just eliminate the
dependency completely.

Thus filter out the target.

This does mean that `rustc-option` cannot be used to test a flag that
requires the right target, but we don't have other users yet, it is a
minimal change and we want to get rid of custom targets in the future.

We could only filter in the case `target.json` is used, to make it work
in more cases, but then it would be harder to notice that it may not
work in a couple architectures.

Cc: Matthew Maurer <mmaurer@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: stable@vger.kernel.org
Fixes: e3117404b411 ("kbuild: rust: Enable KASAN support")
Tested-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250408220311.1033475-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.compiler |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -76,7 +76,7 @@ ld-option = $(call try-run, $(LD) $(KBUI
 # TODO: remove RUSTC_BOOTSTRAP=1 when we raise the minimum GNU Make version to 4.4
 __rustc-option = $(call try-run,\
 	echo '#![allow(missing_docs)]#![feature(no_core)]#![no_core]' | RUSTC_BOOTSTRAP=1\
-	$(1) --sysroot=/dev/null $(filter-out --sysroot=/dev/null,$(2)) $(3)\
+	$(1) --sysroot=/dev/null $(filter-out --sysroot=/dev/null --target=%,$(2)) $(3)\
 	--crate-type=rlib --out-dir=$(TMPOUT) --emit=obj=- - >/dev/null,$(3),$(4))
 
 # rustc-option


