Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0857C23C510;
	Mon, 12 May 2025 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072920; cv=none; b=oRN69KWGWR5k4csAK4ZOPJQeKeJAGQTKRR6CJsPoqhDTQhp/NGquBp8mXSGn76ZiZTv5e2Jf1COZqk8k/2gdLMirV9DI2LwBUFGRqcb0NCSH/kUy1OxXoMmCN2j9CtkC/eMOKyz/qXmtQohKc67kGtjklKpGPqQhoYzOt5uiriA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072920; c=relaxed/simple;
	bh=tD7uwiAda4sNaGX0Gm3syPuZYUxWM/qmBRkC646SJ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OT0PQV2VBSXvyKYEzwYqOV0SHEt4FKXmt/PNsjmm0Yl4Xue9AkAvriWZmykr1Bo1664hRqbOu29BVmspMCfi9QXwYnyveGaO2r5tKlP1QScJ0Zem/tmYx8rh+HVIVeBVQzUEGhTJqZ9RqvfUpXBi7Oky3zRxnESPqpPRCTOn/wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRnfPePb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRnfPePb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A9FC4CEE7;
	Mon, 12 May 2025 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072919;
	bh=tD7uwiAda4sNaGX0Gm3syPuZYUxWM/qmBRkC646SJ0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRnfPePbUga2DBuxNBNNSkgtVfnJHzbwjQStB8N6n5teCz3ZJLjw2iq3WBPzm/Emk
	 9jidbXv1PcuGgMPHNUA7f5UUsL42teU1ulYNOIYMx7Gyc14S5SJDBhkw0qBkxkdAgY
	 Db+F6LaZQQe/0C2g5wEA4t8CgThvx7RDM1pYjcd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 067/184] rust: clean Rust 1.88.0s warning about `clippy::disallowed_macros` configuration
Date: Mon, 12 May 2025 19:44:28 +0200
Message-ID: <20250512172044.563585242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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
@@ -5,5 +5,5 @@ check-private-items = true
 disallowed-macros = [
     # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
     # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
-    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
+    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool", allow-invalid = true },
 ]


