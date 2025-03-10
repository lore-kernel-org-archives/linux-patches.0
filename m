Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B37A2309B0;
	Mon, 10 Mar 2025 17:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627223; cv=none; b=ORozMgehogSDLB0cHqkl/Gn41XoTvB++sCGpl7xnsMEYkrNRCqkNRhf7KealXG9OS6KTr0OeCd3+1DcWduHOWtVHDoo4IOzrwkTC1MuTtg+UP9m9eynToSXSRNibwP6UvGC+SDOUsEi+lVzFLFdc8NIrV3yGtW9/3EGVRn7absE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627223; c=relaxed/simple;
	bh=QhaupgP0vTx9s+//YNBtAmyekElooPYaaS6QsUd4+fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiOp/RAFvO93VcrOHiEUqVo1GvqoEnljDKDjVjnqe0qQ7v27gRfZK2hpbcj+uTs3nKX2RekLBlP2+X/i+DvgI0+6R8sQUxi9sZvcoIHOGzN7p6142opsfyzibUWq9vppoXNjhn+6ml3Q2B3BJqTX+viqJUgUBXT3mNBX2U9PZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpiMyq7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpiMyq7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DBEC4CEE5;
	Mon, 10 Mar 2025 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627222;
	bh=QhaupgP0vTx9s+//YNBtAmyekElooPYaaS6QsUd4+fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpiMyq7m9D5pYIv6JthT2OYYQqe9m2IOL7nw3OQffbnY09KCU/sjt4Sf3QU5Zv0HS
	 GcCYe8DURe1QfqvDGggr3NBmio43m+EkD652iMVYs2WPX6/hka3F/jmbbfsNCRc2kH
	 4eve8oWvvYadhcGtKXaJakSJ53SmexubyTw7XlxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 056/269] rust: str: test: replace `alloc::format`
Date: Mon, 10 Mar 2025 18:03:29 +0100
Message-ID: <20250310170459.959318410@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/str.rs |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

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


