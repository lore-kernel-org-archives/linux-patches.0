Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41DD221727;
	Thu, 13 Feb 2025 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457962; cv=none; b=AtCVQjvT+f15MLIvRQBIfbREzZZcTy85RwqwALBhB20ECADr7Uyrk6rDrpy2tjK67eYjS+ydtS8Dncx/NcP/W0mzmpg+zLUrryqSZI6haaFzyVbFntAyl9rqvPCeu23+zf2a+YRcV1x+36niqCPVGPBYwVP3tL/OJPAXE+EBVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457962; c=relaxed/simple;
	bh=21fTHBH7UCsJjugyuvZcWYu9PX5KsufWjV/77jYGBrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRoTC45EbLOQkGP8FimU99xNSMiJ28PNkXvklDQ3W1jx7v5UhIuH87iTTtChdhhDOFzcZfh5E4q3MEVrRgrLfbCAhnRMdFW0jpQpLZ19hR0FbHwOg6mUL12Q/3hwLNJUTnVsh0QI5GdTllK+fGkCzb6Wua8SHss7Is9kwc0AbdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFLRSEf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFLRSEf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7099EC4CED1;
	Thu, 13 Feb 2025 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457961;
	bh=21fTHBH7UCsJjugyuvZcWYu9PX5KsufWjV/77jYGBrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFLRSEf2tAmMuJiktvq04IvC5t4HTIZcMLOuSyR2fUEKqp+XQMdL7KY+zLgwjaSW2
	 I0GLM31eQ+URbVorh2x3WRVAFRBfws1VoYqvxjjjQVfh+sjvw1+QY6XLRDw1b1bgyW
	 6CRIgvrDqHJuTFdu6PYzsPk82XPqdnzUZ3NkgN3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Fiona Behrens <me@kloenk.dev>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 261/422] rust: init: use explicit ABI to clean warning in future compilers
Date: Thu, 13 Feb 2025 15:26:50 +0100
Message-ID: <20250213142446.612180717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

commit c21bdb3d8a850afdfa4afe77eea39ae9533629b0 upstream.

Starting with Rust 1.86.0 (currently in nightly, to be released on
2025-04-03), the `missing_abi` lint is warn-by-default [1]:

    error: extern declarations without an explicit ABI are deprecated
        --> rust/doctests_kernel_generated.rs:3158:1
         |
    3158 | extern {
         | ^^^^^^ help: explicitly specify the C ABI: `extern "C"`
         |
         = note: `-D missing-abi` implied by `-D warnings`
         = help: to override `-D warnings` add `#[allow(missing_abi)]`

Thus clean it up.

Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Fixes: 7f8977a7fe6d ("rust: init: add `{pin_}chain` functions to `{Pin}Init<T, E>`")
Link: https://github.com/rust-lang/rust/pull/132397 [1]
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Fiona Behrens <me@kloenk.dev>
Link: https://lore.kernel.org/r/20250121200934.222075-1-ojeda@kernel.org
[ Added 6.13.y to Cc: stable tag. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -858,7 +858,7 @@ pub unsafe trait PinInit<T: ?Sized, E =
     /// use kernel::{types::Opaque, init::pin_init_from_closure};
     /// #[repr(C)]
     /// struct RawFoo([u8; 16]);
-    /// extern {
+    /// extern "C" {
     ///     fn init_foo(_: *mut RawFoo);
     /// }
     ///


