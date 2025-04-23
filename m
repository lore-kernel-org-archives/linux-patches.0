Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52F28D83D;
	Wed, 23 Apr 2025 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420511; cv=none; b=oNnK6yq6VEReDjhfcZdAF7BgV8EclT6ojX6fsY5vjdEIMcGJ8T1UYIpLSC6XpqOrfxWAScSUFHdBI9bvTW1L1ixSz3JoPzCuJicTZMAOBxkmlo+DyAqfOIu2jUaRAFtQz044O+JFdWADABhitVIBX9k/Ml+vn2uyFTSLqoUjvfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420511; c=relaxed/simple;
	bh=c1R3DZKoSBSPU4SzvZVzKZUIk6/oP2A5mesf2PNqvGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nD3mp4CkhtVO3Y9WP2bGw5KnrvbGRylUXqL5qBVdXSGKRRf/4VwTkhkC6ljNewNLJXwUVPF1K5FrXMX6qpdsClo32okczQxcC/mXL6TczH3fCguWP3S7OCJYVm2PuJuxd5ddOS1XkG6OPm/XWR9W7kHGOqjPu9OgjsQ624Zbi88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmVr7j2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmVr7j2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C4DC4CEE3;
	Wed, 23 Apr 2025 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420511;
	bh=c1R3DZKoSBSPU4SzvZVzKZUIk6/oP2A5mesf2PNqvGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmVr7j2tYes3SCBhnPp8FbXdDnCuLJps+kn6NjlImjaDW6YpHo/Ok2XMzq0LhpD3m
	 2Cuzu6FaXR9eLp7Ig0e0jgV71aV8dc5Y5kHydM5uMj34Z/IJcKn9covprqRtOyilhB
	 SR9Mr3NhHTic7HYYj8XYrmt8AhO+7z/WVLZAhTNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 098/241] rust: kasan/kbuild: fix missing flags on first build
Date: Wed, 23 Apr 2025 16:42:42 +0200
Message-ID: <20250423142624.581858639@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


