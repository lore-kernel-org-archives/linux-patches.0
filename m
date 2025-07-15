Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBF019D09C;
	Tue, 15 Jul 2025 13:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585580; cv=none; b=noEt8ZPks9OqPIQQtWbeBRoEpKJW8Q4dxYUy5ppRmdeAURprSak9p0FnrXpV4an0YoPWqay8scrS4QP2kF1YWuX1s4UAzzHymW4VvyhEV0pibgNFFnGgjLc5VWWBKZQ3udAXr7fN+DufyJ6izcQUu7YamDUS110mH5NU6jRXWDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585580; c=relaxed/simple;
	bh=UMUy+pVoj8xLnSsGvtQhvO6Pe+AbjIvklv7YTFlGbrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6f6NUIHKLtXxKBNmiwERKRCui4XWLLueQToUie1N+rJ7+rY7VD8BxwJaKVN49IBIuoL8StRJQ3VsODUdD2Xq6J3uPT6S/36qoFt2LryDimB5aKNPPoTH00DnVC/WHx3UcT2Xu5aaL9uNAEDLo8vbVJSfr+IO1meR6rBYbcXSuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUr58hT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUr58hT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34014C4CEE3;
	Tue, 15 Jul 2025 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585580;
	bh=UMUy+pVoj8xLnSsGvtQhvO6Pe+AbjIvklv7YTFlGbrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUr58hT9HSNfrpeUtdrWbU8Kyca4lKUr0dCBiA+k85gqIdWOddtCcg3RONL+KgE5V
	 0JEBOwUP26p2ubD8S2W4LI58KuxJ9BKcWzHLZjHn00y2syhLiKNgVA92msBZe2heot
	 1wh0xjQI6RPWZWh0zuJFakMkrjlFLLK/pe2HT/vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 094/163] rust: init: allow `dead_code` warnings for Rust >= 1.89.0
Date: Tue, 15 Jul 2025 15:12:42 +0200
Message-ID: <20250715130812.639666869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

Starting with Rust 1.89.0 (expected 2025-08-07), the Rust compiler
may warn:

    error: trait `MustNotImplDrop` is never used
       --> rust/kernel/init/macros.rs:927:15
        |
    927 |         trait MustNotImplDrop {}
        |               ^^^^^^^^^^^^^^^
        |
       ::: rust/kernel/sync/arc.rs:133:1
        |
    133 | #[pin_data]
        | ----------- in this procedural macro expansion
        |
        = note: `-D dead-code` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(dead_code)]`
        = note: this error originates in the macro `$crate::__pin_data`
                which comes from the expansion of the attribute macro
                `pin_data` (in Nightly builds, run with
                -Z macro-backtrace for more info)

Thus `allow` it to clean it up.

This does not happen in mainline nor 6.15.y, because there the macro was
moved out of the `kernel` crate, and `dead_code` warnings are not
emitted if the macro is foreign to the crate. Thus this patch is
directly sent to stable and intended for 6.12.y only.

Similarly, it is not needed in previous LTSs, because there the Rust
version is pinned.

Acked-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init/macros.rs |    2 ++
 1 file changed, 2 insertions(+)

--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -924,6 +924,7 @@ macro_rules! __pin_data {
         // We prevent this by creating a trait that will be implemented for all types implementing
         // `Drop`. Additionally we will implement this trait for the struct leading to a conflict,
         // if it also implements `Drop`
+        #[allow(dead_code)]
         trait MustNotImplDrop {}
         #[expect(drop_bounds)]
         impl<T: ::core::ops::Drop> MustNotImplDrop for T {}
@@ -932,6 +933,7 @@ macro_rules! __pin_data {
         // We also take care to prevent users from writing a useless `PinnedDrop` implementation.
         // They might implement `PinnedDrop` correctly for the struct, but forget to give
         // `PinnedDrop` as the parameter to `#[pin_data]`.
+        #[allow(dead_code)]
         #[expect(non_camel_case_types)]
         trait UselessPinnedDropImpl_you_need_to_specify_PinnedDrop {}
         impl<T: $crate::init::PinnedDrop>


