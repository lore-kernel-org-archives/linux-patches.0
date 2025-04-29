Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C629521883E;
	Tue, 29 Apr 2025 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939703; cv=none; b=tguIBsUqBgvg+uXGYpLu3585zRBvspW1lcdIJOb3jb359bfCnTOUn5aos1kjtzsHt5jGS7ozOZ5V0uBEpNFh/Re7N83ivwAQkTevP5XBwxvaa748vrIUNrDlM2Rgg1qcMN2Ol/RnJk9i5lPcw0PBdMy7M3T28NoTb3yxTe7Gu7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939703; c=relaxed/simple;
	bh=4rd1e341L6i1cZWsBMYLUAsiEO5EFbOGKdSPZbP0RKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FEdWgIOTu+pszJk/Szti3QrCA5JiPmNf1zcawsjVnanVwcEf7VgcKCzmEMsjgjxd0X1S7/YsmK2t5SGu4YSsuEMEfMYWVzFGr5QCegmaiju6rNYv6K0Lmll87a9/r3Y3w7e9VdRAULzKd+OFtpz+MNuJE0oENnTXlVY7aof4MhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIv2lRzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIv2lRzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4174C4CEED;
	Tue, 29 Apr 2025 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745939703;
	bh=4rd1e341L6i1cZWsBMYLUAsiEO5EFbOGKdSPZbP0RKM=;
	h=From:To:Cc:Subject:Date:From;
	b=AIv2lRztIVYaVUvc1ZaQL5gP4oHxoWz4g73VZFXeaSNNx2mZXBfQ/Bj55G90wyEfH
	 khs+8J0dLg+1mFNni7TddDsZ04Kx9MIpei5ijBQR7KiuJw+OzD4opaZpFNKBZgDPXj
	 dhhFoyJWPWu+tKW4qAXyuiJJ94wUWz0iD09Xd9DMXTPaghx9woogi4R02idzS6+E50
	 D1fgca4EEkPU7nr7vlIoIiTINmMOoIrl5N0aTHF8AXWio6ZD0RboPvbzGRGAwLCfNL
	 eZEby/T/MN1NBU2EmhCfeioCCv5HDYVgQKStanMMocNcqdCLBIBpwBB/yTVAdzQJ+9
	 1AAfyI0km556Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: uaccess: take advantage of the prelude and `Result`'s defaults
Date: Tue, 29 Apr 2025 17:14:45 +0200
Message-ID: <20250429151445.438977-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `kernel` prelude brings `Result` and the error codes; and the prelude
itself is already available in the examples automatically.

In addition, `Result` already defaults to `T = ()`.

Thus simplify.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
A quick thing I noticed looking at something else...

 rust/kernel/uaccess.rs | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/rust/kernel/uaccess.rs b/rust/kernel/uaccess.rs
index 80a9782b1c6e..7e4c953ba8a1 100644
--- a/rust/kernel/uaccess.rs
+++ b/rust/kernel/uaccess.rs
@@ -46,10 +46,9 @@
 ///
 /// ```no_run
 /// use kernel::ffi::c_void;
-/// use kernel::error::Result;
 /// use kernel::uaccess::{UserPtr, UserSlice};
 ///
-/// fn bytes_add_one(uptr: UserPtr, len: usize) -> Result<()> {
+/// fn bytes_add_one(uptr: UserPtr, len: usize) -> Result {
 ///     let (read, mut write) = UserSlice::new(uptr, len).reader_writer();
 ///
 ///     let mut buf = KVec::new();
@@ -68,7 +67,6 @@
 ///
 /// ```no_run
 /// use kernel::ffi::c_void;
-/// use kernel::error::{code::EINVAL, Result};
 /// use kernel::uaccess::{UserPtr, UserSlice};
 ///
 /// /// Returns whether the data in this region is valid.

base-commit: b4432656b36e5cc1d50a1f2dc15357543add530e
--
2.49.0
