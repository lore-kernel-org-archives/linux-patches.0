Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159163515D2;
	Fri,  4 Sep 2026 05:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498342; cv=none; b=ERfmlSnVYUWqAZgis69147fxueOFo3gr3yRmWGc+tcTPFDS3apmthTYl34IarbhleHfZT8+r9r9WQ3s2iuw6qU4zVfnK7BwZR98E29bY6UhbzzEZ+5ITE9EQGr9V9E7bWJnOMLNemXysWkBz6GbBbIpAc6oc4Mul6mhX93WO1qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498342; c=relaxed/simple;
	bh=QYv+1EJwAVAC5o1/2SekDePNhhF4j4IVBacmrqf5eyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hvb+L37s0u5wX/5jR0QsrAgC0fcGUiWPZR/oUB1zWBteg/4uJFpq/8h01qnXR6NPHqNXYVYBKiXssqvJ76N3D75a2TbSUuFjmnujYJsCMbC8XSpEQnDkPH5UZxmfzAApvpWV/jwdxaS0/EAR5d0f9EfpLJxvhnQxMdg70IWUKh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LS/rRHJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LS/rRHJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6DB1F00A3E;
	Fri,  4 Sep 2026 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498341;
	bh=P62HMlfCNpzgHe70+bFUf1obsR1C7GC2E36wYSXL0A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LS/rRHJBWNJgTrylszccinYXEU9a0sKGU/44ztVAi/NVVZHSDP1TMG79zAk15sZ1q
	 R66hrbRN87twwVNMZGzyW5kG9fStRQo+0q9W/wEG6nZ47/DFfgtTubsu0IqguDxZrN
	 zkIDixa8SbQhInEgHI6gtmdjwhU6ApfrwDELHDoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 028/713] rust: bug: fix warn_on macro build error on UML
Date: Fri,  4 Sep 2026 06:49:56 +0200
Message-ID: <20260904045804.460058901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


