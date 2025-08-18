Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C64E226D0F;
	Mon, 18 Aug 2025 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524331; cv=none; b=nq6qQtIWjAg6yLwUqcgsrckkwr9sHMmCMoB9BJwjEN3YMmkhoTPfcWRL+7fUkpHU8ADSZXzyoNN+CMQ5Y8wUpRsyldwF+yamJ2axqOKFTpNk9XOm8DOxoUzjT2kpMoVCwbj/zZLldIK5PzDwsNyrTu6POLJcdv6ZuH1/HadbsAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524331; c=relaxed/simple;
	bh=Y+wzTHcIi+7fCE5zpYhweowuW6JQT9XNmhcm1kVUNG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLvnzWnLarrj7vovlVpQEM9tGbxa3QpSzOeD2Y6nTay7QWuZyHE4SnguDaN9AW5J+hEX3uf3mqEPa8zoSyXcpwTMkyVu9X3FlfBgYeoc76yvSpfKEzANi53MgvBBgxgfmxj1qXwEkcTycgt/swgJe9A00Xv2HjIjgYB1COryz64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHC5qQyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHC5qQyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04AEC4CEF1;
	Mon, 18 Aug 2025 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524331;
	bh=Y+wzTHcIi+7fCE5zpYhweowuW6JQT9XNmhcm1kVUNG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHC5qQyg1WFR8Ixgdb2/isQSZl9jZQfRt+S0goggSMMKPiYhC4Qets6VZvft4bVjz
	 d8mBIKKQZDwSFQi4x54+wQOALL2Ramw/xR9rJ1nHmX5UnDwnVtoZsjayho+wn+H4PL
	 eff2b/BqH1NfqRUwi4zOw8hVLEfxBeYQdGdh3b50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.15 440/515] rust: workaround `rustdoc` target modifiers bug
Date: Mon, 18 Aug 2025 14:47:06 +0200
Message-ID: <20250818124515.363246915@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit abbf9a44944171ca99c150adad9361a2f517d3b6 upstream.

Starting with Rust 1.88.0 (released 2025-06-26), `rustdoc` complains
about a target modifier mismatch in configurations where `-Zfixed-x18`
is passed:

    error: mixing `-Zfixed-x18` will cause an ABI mismatch in crate `rust_out`
      |
      = help: the `-Zfixed-x18` flag modifies the ABI so Rust crates compiled with different values of this flag cannot be used together safely
      = note: unset `-Zfixed-x18` in this crate is incompatible with `-Zfixed-x18=` in dependency `core`
      = help: set `-Zfixed-x18=` in this crate or unset `-Zfixed-x18` in `core`
      = help: if you are sure this will not cause problems, you may use `-Cunsafe-allow-abi-mismatch=fixed-x18` to silence this error

The reason is that `rustdoc` was not passing the target modifiers when
configuring the session options, and thus it would report a mismatch
that did not exist as soon as a target modifier is used in a dependency.

We did not notice it in the kernel until now because `-Zfixed-x18` has
been a target modifier only since 1.88.0 (and it is the only one we use
so far).

The issue has been reported upstream [1] and a fix has been submitted
[2], including a test similar to the kernel case.

  [ This is now fixed upstream (thanks Guillaume for the quick review),
    so it will be fixed in Rust 1.90.0 (expected 2025-09-18).

      - Miguel ]

Meanwhile, conditionally pass `-Cunsafe-allow-abi-mismatch=fixed-x18`
to workaround the issue on our side.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Closes: https://lore.kernel.org/rust-for-linux/36cdc798-524f-4910-8b77-d7b9fac08d77@oss.qualcomm.com/
Link: https://github.com/rust-lang/rust/issues/144521 [1]
Link: https://github.com/rust-lang/rust/pull/144523 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250727092317.2930617-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -62,6 +62,10 @@ core-cfgs = \
 
 core-edition := $(if $(call rustc-min-version,108700),2024,2021)
 
+# `rustdoc` did not save the target modifiers, thus workaround for
+# the time being (https://github.com/rust-lang/rust/issues/144521).
+rustdoc_modifiers_workaround := $(if $(call rustc-min-version,108800),-Cunsafe-allow-abi-mismatch=fixed-x18)
+
 # `rustc` recognizes `--remap-path-prefix` since 1.26.0, but `rustdoc` only
 # since Rust 1.81.0. Moreover, `rustdoc` ICEs on out-of-tree builds since Rust
 # 1.82.0 (https://github.com/rust-lang/rust/issues/138520). Thus workaround both
@@ -74,6 +78,7 @@ quiet_cmd_rustdoc = RUSTDOC $(if $(rustd
 		-Zunstable-options --generate-link-to-definition \
 		--output $(rustdoc_output) \
 		--crate-name $(subst rustdoc-,,$@) \
+		$(rustdoc_modifiers_workaround) \
 		$(if $(rustdoc_host),,--sysroot=/dev/null) \
 		@$(objtree)/include/generated/rustc_cfg $<
 
@@ -216,6 +221,7 @@ quiet_cmd_rustdoc_test_kernel = RUSTDOC
 		--extern bindings --extern uapi \
 		--no-run --crate-name kernel -Zunstable-options \
 		--sysroot=/dev/null \
+		$(rustdoc_modifiers_workaround) \
 		--test-builder $(objtree)/scripts/rustdoc_test_builder \
 		$< $(rustdoc_test_kernel_quiet); \
 	$(objtree)/scripts/rustdoc_test_gen


