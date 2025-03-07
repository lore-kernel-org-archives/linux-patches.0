Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C42C20DD67;
	Fri,  7 Mar 2025 22:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387958; cv=none; b=PfEm7wmkqoDexzfBLnmNhjQAXHJ+1PXV0ahSFKp3717JlGM8Fpuf40eIHcreEjbnqFBwnt/y+7kLhotwJJa/f3vPg9I6RBPkUdhxHC7+f081wkSPaHvQTTCeXTSfSFGSRp4ZHuwx7CY/S78V0cNaWbbkgSIwa5xbOWJdahNGWfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387958; c=relaxed/simple;
	bh=Z6lXjfzEZTu0VoX9ev9NPtxWKkZi6oQLb8rPKzc6bH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyCWz5Jql84CVXi1GHWwfhYyWXaa5zST70MVeK98quy2ftwZR/wMK1AsUn2pERO7qYgCf7fBswCNgHaUOesOG0tjft5xS4b9+6evUa8ygk6UAFe+FFXHAi2udT+9EHZaFCb2DPkJhEBbVkmygYx+C8PK4b2k5BEG1XwrIxxrPpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6BBNb56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6BBNb56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A25DC4CEE3;
	Fri,  7 Mar 2025 22:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387958;
	bh=Z6lXjfzEZTu0VoX9ev9NPtxWKkZi6oQLb8rPKzc6bH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6BBNb56TtWWUT3QsOa+6xG1nbQ2bRhl1tRl5WKThyz77ulCsZazKpUUzqLVNn/y+
	 rU/KZw1lsjcA0MboFFFWkE/b/DYyrDmaI5/dKukLT+hZt8/ju9DInXCQEKRof0HyLl
	 o3iCa0sebWZyL2dhQw65jB9E8MX+bHhxZvcTZlLyKi1au4SDXVpzDk86yMKh8/8VMy
	 pl0Nv8TGc38mldOAbtDooamiIef7QOk4odWTsz7IWVKzPnRwPSK4BrbaswfFLgnH+1
	 Vmznor8tpnY86ScAnejUMd1+P/42jFPrlzhr60quTIUA+6/6tep9i4vPGKvepWG2xD
	 UYhmj7Faa7dNA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 45/60] rust: str: test: replace `alloc::format`
Date: Fri,  7 Mar 2025 23:49:52 +0100
Message-ID: <20250307225008.779961-46-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit eb6f92cd3f755c179204ea1f933b07cf992892fd upstream.

The current implementation of tests in str.rs use `format!` to format
strings for comparison, which, internally, creates a new `String`.

In order to prepare for getting rid of Rust's alloc crate, we have to
cut this dependency. Instead, implement `format!` for `CString`.

Note that for userspace tests, `Kmalloc`, which is backing `CString`'s
memory, is just a type alias to `Cmalloc`.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-27-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/str.rs | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 6053bc7a98d1..aff6baa521d4 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -524,7 +524,28 @@ macro_rules! c_str {
 #[cfg(test)]
 mod tests {
     use super::*;
-    use alloc::format;
+
+    struct String(CString);
+
+    impl String {
+        fn from_fmt(args: fmt::Arguments<'_>) -> Self {
+            String(CString::try_from_fmt(args).unwrap())
+        }
+    }
+
+    impl Deref for String {
+        type Target = str;
+
+        fn deref(&self) -> &str {
+            self.0.to_str().unwrap()
+        }
+    }
+
+    macro_rules! format {
+        ($($f:tt)*) => ({
+            &*String::from_fmt(kernel::fmt!($($f)*))
+        })
+    }
 
     const ALL_ASCII_CHARS: &'static str =
         "\\x01\\x02\\x03\\x04\\x05\\x06\\x07\\x08\\x09\\x0a\\x0b\\x0c\\x0d\\x0e\\x0f\
-- 
2.48.1

