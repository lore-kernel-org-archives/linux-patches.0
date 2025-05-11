Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BCB7E105;
	Sun, 11 May 2025 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746987963; cv=none; b=sh+jNQkh8b5Iwz7jpb8Kb4I5Laq3cKSfdBW+BtBPADupEHLesf51bIMA3MlLT/8+hPunnpNTb2S2ART9g5VeORXr2ElSb2JAonPk+1t/FJY/CspDBndtdYSqsw6jDWv8gEEmZdCm9G+YeutZ58b0sFUy/OCeKsD+RHMgJomYqfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746987963; c=relaxed/simple;
	bh=Vg6u9/IFXxBubadIvDcmyQ6DIw76avxYML9JI0CWC00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AzqOEVcRtpw+7dRAWyn0b3kh/IWUcArRhy7QbPJ//Nzl2t2+TsncpXogECxqCtP59jGMrlL5UXSDIE/6POZc0NSCnDGcvym/g1fOHsfITQ+SzZiTYcMolldb+Nu0WoYL9cDXwD181MlEPul8oi4oPjW+Oy19nlwctGuASDADOKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNGUd5My; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNGUd5My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9586AC4CEE4;
	Sun, 11 May 2025 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746987963;
	bh=Vg6u9/IFXxBubadIvDcmyQ6DIw76avxYML9JI0CWC00=;
	h=From:To:Cc:Subject:Date:From;
	b=PNGUd5Myfp0PSafl2xeXQVwUusGITiPA+51T45C7gYLzlHNjoT3fVQXgk4BZSl0UA
	 o0rcGC8r9QRLQqYrCdHGF+jbW8N3q0y0Z8EtiVBq9LbpvMvIJ8nk4mquFfDXczwKSb
	 WSYHmsF7I5RxnUyyojeK6IMCUUqu/FTKIPRNImsef5t8PdVuNQFZHUAu9j7htyEUPh
	 X70pE8l5iascLLWwJJi5hA9RhzLbAVWzQ3nw4ghWepR2V7qQ6bZRzCd32Z/QTjq5E/
	 qpj6YPBmeErVxLZ6fZEtH7s0SZxkuWC1+MJxtTqgmYA8JU7kFdJdRDSpDv19m0aTQL
	 6CtepYtBBYusg==
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
Subject: [PATCH] rust: devres: fix doctest build under `!CONFIG_PCI`
Date: Sun, 11 May 2025 20:25:33 +0200
Message-ID: <20250511182533.1016163-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The doctest requires `CONFIG_PCI`:

    error[E0432]: unresolved import `kernel::pci`
        --> rust/doctests_kernel_generated.rs:2689:44
         |
    2689 | use kernel::{device::Core, devres::Devres, pci};
         |                                            ^^^ no `pci` in the root
         |
    note: found an item that was configured out
        --> rust/kernel/lib.rs:96:9
    note: the item is gated here
        --> rust/kernel/lib.rs:95:1

Thus conditionally compile it (which still checks the syntax).

Fixes: f301cb978c06 ("rust: devres: implement Devres::access()")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I noticed this in next-20250509 -- as usual, please feel free to fixup
it (or not) as preferred. Thanks!

 rust/kernel/devres.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index b67247db92c7..0f79a2ec9474 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -195,6 +195,7 @@ pub fn new_foreign_owned(dev: &Device<Bound>, data: T, flags: Flags) -> Result {
     /// # Example
     ///
     /// ```no_run
+    /// # #![cfg(CONFIG_PCI)]
     /// # use kernel::{device::Core, devres::Devres, pci};
     ///
     /// fn from_core(dev: &pci::Device<Core>, devres: Devres<pci::Bar<0x4>>) -> Result {

base-commit: ed61cb3d78d585209ec775933078e268544fe9a4
--
2.49.0
