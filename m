Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D4F230BC3;
	Mon, 10 Mar 2025 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627214; cv=none; b=g7CXqjLQFqebM0AK3/AVInDI+WC64Mtclg6YeA2EzC7+iit66wLA2SkirATdrRscIGKtKCYqDw2puaAynpd3Kv/0euFvmNHOCdzIBP46KuHD2rJTw6tn+VJhevs/DM8pW0MFlEYOl3Uew+hyGzHgNzV2LRyiAQdZNcj82Py8i44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627214; c=relaxed/simple;
	bh=V0N4r8++I6evdcIb3Ubs0vOmAWmGqtDRjKVJVNY7fgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffFEtUyg9jIRS3ajXxFsSeM8pz0T8z7wnK7j6CHkqDMYrIT7wUpLKhVrGeb5us9hTrld5jyllLJMjy/+MPmnKBfjkgSXYe3S6TFtdrdePOMqqu5XerF/wUUZqyuQPHxUZ8CWfALKAMs2ZWZMOu9LXLVcXL3Kjf2js0KIczgeuP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcTXnktZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcTXnktZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDC2C4CEE5;
	Mon, 10 Mar 2025 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627214;
	bh=V0N4r8++I6evdcIb3Ubs0vOmAWmGqtDRjKVJVNY7fgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcTXnktZYQ7ljfKMgj1YhQiCjr7NlftxfYVBZZKFwAqrF1bP/MgtNfNGlndzu2NGS
	 USq9cpImFgzkD5ZDWVr7dPLkKeCVmiZ9mQHuDw1YLffbXrBJ0EoQueigUzo0pdjBcT
	 7NOyIIMviKxug4vwEJCsgnZuxxJrJWqfzq2iDT4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 053/269] rust: error: check for config `test` in `Error::name`
Date: Mon, 10 Mar 2025 18:03:26 +0100
Message-ID: <20250310170459.839104689@linuxfoundation.org>
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

commit 4a28ab469ff01855eb819dfd94754d1792f03f2a upstream.

Additional to `testlib` also check for `test` in `Error::name`. This is
required by a subsequent patch that (indirectly) uses `Error` in test
cases.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-24-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/error.rs |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -161,7 +161,7 @@ impl Error {
     }
 
     /// Returns a string representing the error, if one exists.
-    #[cfg(not(testlib))]
+    #[cfg(not(any(test, testlib)))]
     pub fn name(&self) -> Option<&'static CStr> {
         // SAFETY: Just an FFI call, there are no extra safety requirements.
         let ptr = unsafe { bindings::errname(-self.0.get()) };
@@ -178,7 +178,7 @@ impl Error {
     /// When `testlib` is configured, this always returns `None` to avoid the dependency on a
     /// kernel function so that tests that use this (e.g., by calling [`Result::unwrap`]) can still
     /// run in userspace.
-    #[cfg(testlib)]
+    #[cfg(any(test, testlib))]
     pub fn name(&self) -> Option<&'static CStr> {
         None
     }


