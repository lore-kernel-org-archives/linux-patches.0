Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8874B4E73B5;
	Thu, 17 Sep 2026 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660103; cv=none; b=e/41LX7UG0V3rJLLx51yVATysNN9IWmuL1XwhoKMSsdTcLxtu6RpDJ/IgUfrhkxdXDWXnheM6/0XqAySaVXE3fmwfSIS1cJlPHSB+y+D9eSPGB6fTFGljqC1qIPs6GugyRhOfHdJcsKba3N67x1+cZTGjR0ZsPAUdXYs7Xx2AeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660103; c=relaxed/simple;
	bh=6sn82qU6iEvCHkh7wdT3mE4KncfjkdacloZIiFoampE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+tSA2Ys7O2Co5dNn9fYmSIEhD4SZFGJybsNdGBsukf8ZnqC8rTW2WAKhSyXGt/n9xDndpuMC4pB/kky4klklH3orNu9+fwI/LWTy67R+2/YCXSeuyZaQENLaCejeamyDdocBFBxkGm1uSMYUMFjHJaSlNGe/x2UR4TkHFtjWh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojz9WxZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojz9WxZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C901F00898;
	Thu, 17 Sep 2026 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660091;
	bh=bJXe3HqyzdvBRD9b3Eq8moaLI3G5UkB69Vvm7X3ZSms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojz9WxZm7XcsbZkdJ7pvuWcWelHFDxTZWGaxdqbkrrB+7Cm7eMjh9h4Gsve276ea5
	 f/FPUgAEqZhDvknuAH58Vmnafli5AELdbTJFb/dvrY621fr2RZ8NiBZLSJmJRBQcMS
	 hJ9zmQtde8irPofPyBoEupms+K0oSp0QJTLqO2tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Alsadhan <mo@sdhn.cc>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 476/733] rust: pin-init: use irrefutable pattern for `stack_pin_init`
Date: Thu, 17 Sep 2026 16:13:04 +0100
Message-ID: <20260917151403.864121541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

commit b6b9e6d4abe87b16ab55990b887c6fad8e7a01af upstream.

In Rust 1.100.0, `Infallible` will become an alias of `!`. The let
binding in `stack_pin_init` will thus become unreachable and produce
an "unreachable expression" warning for the subsequent match, and thus
will fail a `-Dwarnings` build. For this macro, all we need to know is
that the error type is uninhabited, so replace this with an irrefutable
pattern instead.

[ The error looks like (dummy reproducer):

      error: unreachable expression
         --> rust/kernel/sync.rs:177:5
          |
      177 |     pin_init::stack_pin_init!(let num = 42u32);
          |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          |     |
          |     unreachable expression
          |     any code following this expression is unreachable
          |
          = note: `-D unreachable-code` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(unreachable_code)]`
          = note: this error originates in the macro `pin_init::stack_pin_init` (in Nightly builds, run with -Z macro-backtrace for more info)

    - Miguel ]

Reported-by: Mohamad Alsadhan <mo@sdhn.cc>
Closes: https://github.com/Rust-for-Linux/pin-init/pull/171
Signed-off-by: Gary Guo <gary@garyguo.net>
Cc: stable@vger.kernel.org # Needed in 7.1.y and later (for 6.12.y and 6.18.y a custom one is needed).
Link: https://patch.msgid.link/20260828155033.2101924-1-gary@kernel.org
[ Reworded for typos. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/pin-init/src/lib.rs |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/rust/pin-init/src/lib.rs
+++ b/rust/pin-init/src/lib.rs
@@ -493,13 +493,7 @@ macro_rules! stack_pin_init {
     (let $var:ident $(: $t:ty)? = $val:expr) => {
         let val = $val;
         let mut $var = ::core::pin::pin!($crate::__internal::StackInit$(::<$t>)?::uninit());
-        let mut $var = match $crate::__internal::StackInit::init($var, val) {
-            Ok(res) => res,
-            Err(x) => {
-                let x: ::core::convert::Infallible = x;
-                match x {}
-            }
-        };
+        let Ok(mut $var) = $crate::__internal::StackInit::init($var, val);
     };
 }
 


