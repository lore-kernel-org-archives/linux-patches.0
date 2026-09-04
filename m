Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E91372B4B;
	Fri,  4 Sep 2026 05:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500497; cv=none; b=C1w5BB5jBj/r44g2SrsS6i5EcJ//wfPZRprSmRlNNyT3GhsBXrWPFqJZZT6rgIB71sT3u73xV1xmamd4Gq870RDK00/+WmpU+sRvaVhXUZHbX1972HJlvu571UmFcksvApTQsghnMGjvA+4Vfw14Hd87niu4Szt9Xyk7gKAyBI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500497; c=relaxed/simple;
	bh=Ujrhl6Vn5JCbIZ8u5iX78cYvbzPJqQxzx0liO/rmy7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlqVX5vrJbWiI9S4NPxvWhF/oTgaxN8OCsqvr0dneFnPKJHgWRw62KHiDwi3IB4IQW72UC0GexWaeQs6LYubW7T+V2i46iOj1EKQjn9RUjCSH/Ln6v9EbRP8TOtiEyTEO8HRnO85jWzk5uADmXQW6Nm7wyu9tYcsHobA+KwnjW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1t8H8UU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1t8H8UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3591F00A3D;
	Fri,  4 Sep 2026 05:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500495;
	bh=YnqXNRfTXfD1pNsy+pD6vSB3I30N94DOyuMFTbUrMFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1t8H8UU/zpGxljs44e8wuUTzJcIHDtoYwWwlN0iWwDS7VUNm7TJ+iQF8mD+6Z4b/
	 Y9Y8g6ZsrtWLNXzNrSgvvsuUH6D3NLoByB8NxKk9j3k9Tdo/JYkhZtiYRoA5z6r0yK
	 QqBGSlTNpZU43Pkmcj1E4p8u2inFdICjxxHYUoNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 024/552] rust: bug: fix warn_on macro build error on UML
Date: Fri,  4 Sep 2026 06:53:01 +0200
Message-ID: <20260904045748.373148168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 30a449e04a32033d8e4844fdb4938a0ebccfa37b upstream.

Callers that go through `kernel::prelude` have `CStrExt` in scope, but
code inside the `kernel` crate imports explicitly and may not. Using
`warn_on!` from such a module fails to build on UML, which is the only
configuration where `warn_flags!` needs a C string pointer rather than an
inline asm bug entry:

error[E0599]: no method named `as_char_ptr` found for reference `&ffi::CStr` in the current scope
   --> linux/rust/kernel/bug.rs:83:49
    |
 83 |                 $crate::c_str!(::core::file!()).as_char_ptr(),
    |                                                 ^^^^^^^^^^^
    |
   ::: linux/rust/kernel/time.rs:427:9
    |
427 |         warn_on!(self.nanos < 0);
    |         ------------------------ in this macro invocation
    |
    = help: items from traits can only be used if the trait is in scope
    = note: this error originates in the macro `$crate::warn_flags` which comes from the expansion of the macro `warn_on` (in Nightly builds, run with -Z mac)
help: trait `CStrExt` which provides `as_char_ptr` is implemented but not in scope; perhaps you want to import it
   --> linux/rust/kernel/time.rs:27:1
    |
 27 + use crate::str::CStrExt;

Call the method through its fully qualified path, which resolves
without any import at the expansion site.

Cc: stable@vger.kernel.org
Fixes: dff64b072708 ("rust: Add warn_on macro")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Link: https://patch.msgid.link/20260807112427.1039056-1-tomo@flapping.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bug.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -83,7 +83,7 @@ macro_rules! warn_flags {
         // with a valid null-terminated string.
         unsafe {
             $crate::bindings::warn_slowpath_fmt(
-                $crate::c_str!(::core::file!()).as_char_ptr(),
+                $crate::str::CStrExt::as_char_ptr($crate::c_str!(::core::file!())),
                 line!() as $crate::ffi::c_int,
                 $flags as $crate::ffi::c_uint,
                 ::core::ptr::null(),


