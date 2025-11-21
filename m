Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298534B191;
	Fri, 21 Nov 2025 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732054; cv=none; b=ZDUlyzEclPl0O+w04PJ38FCB0LmZVi/VnOCz5C+k74IBBXmlAjJOcHraLwgjvBcSGwQ8DWjobl6nwdLeKADsxb9BjPHo8NwGjs5iii/09wCdhTObq7y7EArnd7KSDEemALl7DSEaHsBbqwAz0KBXdCS3FEEydP5nLWFLIgP6Q8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732054; c=relaxed/simple;
	bh=v+s9Kokfer8ec8eX/sMC7/9CAHaiJu4avqds1Kzd68c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyMXPBaD28tnqggp2GHuktUc1k3pTgQifS81RtrL95HE2Qn+fJDNEejlDao8f5EuUftf1AyX4cTvCmGyn182G9U9G4V055/pCMoFZrEFsaO9iJ5rp1O6RJq7Z9N4QEm5jNacDHJDuOQRGcLxxzN5NEnVndqnb+AJLsqyFxYdaac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jnrliel8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jnrliel8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8550C4CEF1;
	Fri, 21 Nov 2025 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732054;
	bh=v+s9Kokfer8ec8eX/sMC7/9CAHaiJu4avqds1Kzd68c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jnrliel8DLCu0b5pey+73fOm729cnOB5TFT5z1GhuVXY5VAgbFRu0O8Fg9CGXsPAG
	 LsodXrR4W0Sa2igH9oRwcSopSBPTBWyqJj3Kb6+XrIkkXyRQ1SVVaFu0dnMuEnn8NM
	 NlEnKZhu4EV/iL2pXc4Yv/6eDak1gTYRturVkJUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/185] rust: kbuild: workaround `rustdoc` doctests modifier bug
Date: Fri, 21 Nov 2025 14:13:21 +0100
Message-ID: <20251121130150.167755093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit fad472efab0a805dd939f017c5b8669a786a4bcf ]

The `rustdoc` modifiers bug [1] was fixed in Rust 1.90.0 [2], for which
we added a workaround in commit abbf9a449441 ("rust: workaround `rustdoc`
target modifiers bug").

However, `rustdoc`'s doctest generation still has a similar issue [3],
being fixed at [4], which does not affect us because we apply the
workaround to both, and now, starting with Rust 1.91.0 (released
2025-10-30), `-Zsanitizer` is a target modifier too [5], which means we
fail with:

      RUSTDOC TK rust/kernel/lib.rs
    error: mixing `-Zsanitizer` will cause an ABI mismatch in crate `kernel`
     --> rust/kernel/lib.rs:3:1
      |
    3 | //! The `kernel` crate.
      | ^
      |
      = help: the `-Zsanitizer` flag modifies the ABI so Rust crates compiled with different values of this flag cannot be used together safely
      = note: unset `-Zsanitizer` in this crate is incompatible with `-Zsanitizer=kernel-address` in dependency `core`
      = help: set `-Zsanitizer=kernel-address` in this crate or unset `-Zsanitizer` in `core`
      = help: if you are sure this will not cause problems, you may use `-Cunsafe-allow-abi-mismatch=sanitizer` to silence this error

A simple way around is to add the sanitizer to the list in the existing
workaround (especially if we had not started to pass the sanitizer
flags in the previous commit, since in that case that would not be
necessary). However, that still applies the workaround in more cases
than necessary.

Instead, only modify the doctests flags to ignore the check for
sanitizers, so that it is more local (and thus the compiler keeps checking
it for us in the normal `rustdoc` calls). Since the previous commit
already treated the `rustdoc` calls as kernel objects, this should allow
us in the future to easily remove this workaround when the time comes.

By the way, the `-Cunsafe-allow-abi-mismatch` flag overwrites previous
ones rather than appending, so it needs to be all done in the same flag.
Moreover, unknown modifiers are rejected, and thus we have to gate based
on the version too.

Finally, `-Zsanitizer-cfi-normalize-integers` is not affected (in Rust
1.91.0), so it is not needed in the workaround for the moment.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/issues/144521 [1]
Link: https://github.com/rust-lang/rust/pull/144523 [2]
Link: https://github.com/rust-lang/rust/issues/146465 [3]
Link: https://github.com/rust-lang/rust/pull/148068 [4]
Link: https://github.com/rust-lang/rust/pull/138736 [5]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
Link: https://patch.msgid.link/20251102212853.1505384-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ added --remap-path-prefix comments missing in stable branch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -59,6 +59,8 @@ core-edition := $(if $(call rustc-min-ve
 # the time being (https://github.com/rust-lang/rust/issues/144521).
 rustdoc_modifiers_workaround := $(if $(call rustc-min-version,108800),-Cunsafe-allow-abi-mismatch=fixed-x18)
 
+# Similarly, for doctests (https://github.com/rust-lang/rust/issues/146465).
+doctests_modifiers_workaround := $(rustdoc_modifiers_workaround)$(if $(call rustc-min-version,109100),$(comma)sanitizer)
 quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
       cmd_rustdoc = \
 	OBJTREE=$(abspath $(objtree)) \
@@ -189,7 +191,7 @@ quiet_cmd_rustdoc_test_kernel = RUSTDOC
 		--extern bindings --extern uapi \
 		--no-run --crate-name kernel -Zunstable-options \
 		--sysroot=/dev/null \
-		$(rustdoc_modifiers_workaround) \
+		$(doctests_modifiers_workaround) \
 		--test-builder $(objtree)/scripts/rustdoc_test_builder \
 		$< $(rustdoc_test_kernel_quiet); \
 	$(objtree)/scripts/rustdoc_test_gen


