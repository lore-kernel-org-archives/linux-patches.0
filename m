Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BD515ECD7;
	Tue, 29 Apr 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939073; cv=none; b=jQ8PFy2baGGQKUTZDxvdwPl4ximRggO2knv1c09HSjscmfpQhB/vy2EdexopA4U422jfxZS0OTKHd+KyzajScqu+i5pQtnqvOxpjMHdVGbuOFetYopBDUoWJTCHwiCJMeLtnDDODX2kccHR0Ym2+mmf4eHW76gKyoX553qfasRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939073; c=relaxed/simple;
	bh=s+dqfUER89a3JkvdwJj38VZEwi2MYDoscKEOg30Hc2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qtww1vUyoUhLnv/cncyXWXjuSJOTFhH4lhWBb8FFwqRc/8VXaTl/ZAq9Vzz6AV24A4sWOlpkGctr4RdIndAXueWil/VyjoKlNzA5CGZjCk8l18SoJ5/r2PN8lOGwBdDdnFMptIkJOmXJ5164iLiNfFnVKAW04B9vWwRi544axK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNPrl6JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNPrl6JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86A4C4CEE3;
	Tue, 29 Apr 2025 15:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745939072;
	bh=s+dqfUER89a3JkvdwJj38VZEwi2MYDoscKEOg30Hc2k=;
	h=From:To:Cc:Subject:Date:From;
	b=XNPrl6JGv+VPNanarkk/lmzMuu6C6MbsA/LPJZquW9xxwX3kaRXRQYY2x0hKn3O7T
	 ofcUwG30PxA3YlubAEOXm9hFwAOD//lYJ1OZZkZSYYYP9XlWmulhG1lTdqAvstPsDS
	 FBtaWO3JNFSFvBiZ5Ixz4vMl5YHvp1Qwi9TlgZ9LTOiRTro1Qy5NR7m+gNsE+6/1tz
	 h9sfv25yRbubVlLko7k9dwwS2reCPYxIrT3PBL0KnwTYXaQtiUzuFrWyEz6YaSrhsi
	 8g6LECvMGlFyvT1Nt3hiBVHhgKkM7r4+F7HpTTVhjhyRjC4nJCCZZuWcBWHt+6rjfJ
	 CN81DIHHvvY0Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: device: allow `dead_code` for `Device<>::parent()`
Date: Tue, 29 Apr 2025 17:03:46 +0200
Message-ID: <20250429150346.392050-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When `CONFIG_AUXILIARY_BUS` is disabled, `parent()` is still dead code:

    error: method `parent` is never used
      --> rust/kernel/device.rs:71:19
       |
    64 | impl<Ctx: DeviceContext> Device<Ctx> {
       | ------------------------------------ method in this implementation
    ...
    71 |     pub(crate) fn parent(&self) -> Option<&Self> {
       |                   ^^^^^^
       |
       = note: `-D dead-code` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(dead_code)]`

Thus reintroduce the `expect`, but now as an `allow`, and do so as
`dead_code` since that is narrower.

Fixes: ce735e73dd59 ("rust: auxiliary: add auxiliary device / driver abstractions")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I should have noticed this earlier, sorry. Please feel free to rebase to
fix it directly there if you prefer.

 rust/kernel/device.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 40c1f549b0ba..e8ab4b9617db 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -68,6 +68,7 @@ pub(crate) fn as_raw(&self) -> *mut bindings::device {
     }

     /// Returns a reference to the parent device, if any.
+    #[allow(dead_code)]
     pub(crate) fn parent(&self) -> Option<&Self> {
         // SAFETY:
         // - By the type invariant `self.as_raw()` is always valid.

base-commit: ce735e73dd59b169b877cedd0753297c81c2a091
--
2.49.0
