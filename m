Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D37D24BCE8;
	Mon, 12 May 2025 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071979; cv=none; b=Z6zbferGvpv0MGoPt4YepV1ic7wCkfhhABXvmd91c+yO8Qy6UFJLHoohP8qy4hM7gtS3o7v1oACl9IL/7T2X6tbBxOdTDhMvi3a38j8y0Vg7zzVOIAibYdvVTLha0nbMrbZpLwQWBsABMH0KuzDKon4+UBN/wKjyL9xE4Zn0M9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071979; c=relaxed/simple;
	bh=528BzJk7ndiSMmvL86cL35/Qiec7eoRpfKHQOerroS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s29uSgnF8O0r1rapqVqnChEWNGCcvKOXO9FxZ3kHCnUXyWTbesfKISoxCtiN1AW0ql6Y0Oksd21+bpmfGqVIM9eqUzOFsf2jACsQqnwP85hzlH3DbCzG1EnJkGMt6dS2RpUHQ5763WI3+NCnIDD/X7brjRpr96KhTA6T0EUr1a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3nwr4Tt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3nwr4Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134E7C4CEE7;
	Mon, 12 May 2025 17:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071978;
	bh=528BzJk7ndiSMmvL86cL35/Qiec7eoRpfKHQOerroS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3nwr4TtrfFY/L31smtGmRizV0H4gqJsa4a1klJV9s8OL71oMb5RTCoBXQplWcVFp
	 u1IVbj9qkb8CVWLA86IpwE+pk0JA44BO9pcFIpdg9W1Y+WXrEvdpueEZnvbI/QjTKO
	 /FRPh0puDfZ+lH6Iea6u9xKZJ9lM6V/2E1a8thjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 067/197] rust: clean Rust 1.88.0s warning about `clippy::disallowed_macros` configuration
Date: Mon, 12 May 2025 19:38:37 +0200
Message-ID: <20250512172047.111979430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

commit c016722fd57551f8a6fcf472c9d2bcf2130ea0ec upstream.

Starting with Rust 1.88.0 (expected 2025-06-26) [1], Clippy may start
warning about paths that do not resolve in the `disallowed_macros`
configuration:

    warning: `kernel::dbg` does not refer to an existing macro
      --> .clippy.toml:10:5
       |
    10 |     { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
       |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is a lint we requested at [2], due to the trouble debugging
the lint due to false negatives (e.g. [3]), which we use to emulate
`clippy::dbg_macro` [4]. See commit 8577c9dca799 ("rust: replace
`clippy::dbg_macro` with `disallowed_macros`") for more details.

Given the false negatives are not resolved yet, it is expected that
Clippy complains about not finding this macro.

Thus, until the false negatives are fixed (and, even then, probably we
will need to wait for the MSRV to raise enough), use the escape hatch
to allow an invalid path.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust-clippy/pull/14397 [1]
Link: https://github.com/rust-lang/rust-clippy/issues/11432 [2]
Link: https://github.com/rust-lang/rust-clippy/issues/11431 [3]
Link: https://github.com/rust-lang/rust-clippy/issues/11303 [4]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250502140237.1659624-5-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .clippy.toml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.clippy.toml
+++ b/.clippy.toml
@@ -7,5 +7,5 @@ check-private-items = true
 disallowed-macros = [
     # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
     # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
-    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
+    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool", allow-invalid = true },
 ]


