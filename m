Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94262274FED;
	Thu, 24 Jul 2025 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753376098; cv=none; b=uGABJsD0F7wFKkQw1zTAxZBj/vd+wJHYHxzTUAbYCfvDoqj5+ocZr7+Vo5qoKs7Kj7mOU2U1AZPhBo9otZTTv3P7niVFysppiYBRMset+xpviCtyAXzNOdXqy//pjvHIVujYny9pKgTBtrBnFLIp4KNxCFNgxsr6CZM0karOOvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753376098; c=relaxed/simple;
	bh=+8vMFcg7Tsq0mO858hZbLULWT+KkS4qq2g4dlZowKp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FD9sa7Vi8EOpctOSrBV/LKSMvQfckfvSsx/oKOA31e5S/nhd5gEDD8wZa7s7pZKcK6E8hBinop0xXrXulmbGJLGiiu+rSu8oN6/ex3Mjhyb1/1zxvwPLCYnhsNncRcAud3GluLwmZ867mVHt1vmKC6MRPc3lJ2rHsnvA1+d1gVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JT8cmGuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JT8cmGuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C2BC4CEED;
	Thu, 24 Jul 2025 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753376098;
	bh=+8vMFcg7Tsq0mO858hZbLULWT+KkS4qq2g4dlZowKp0=;
	h=From:To:Cc:Subject:Date:From;
	b=JT8cmGuIREx1jz6ZKLidnrP3vP9wPZx5FmQO9CyMH5soqG65rEsumGoy4WN8AjO/U
	 7WsBfIfnZIm1ggedysQicNr1LPjOapqk3qhhU9l1rerj4X+QcSa3Ix6/GvflBrclNj
	 Z2gR8+K+BhKr71/Ra9zSNujcESjfYviYz3sfjXMX3OwH+LQM2yzpGffprDW3h7ik1N
	 WXj+rIl/FRCFyUgMsZ4yhcC/gHsqCJRzU/qHooOZzjU38AJuOLmZBZV/X2yA9801w8
	 ywA0I2dtPAWwQEkilqnoVpGAn2+EHUopUPGgpRkcQ6k6emfEWPp5Tlj+jqB67IfJt4
	 ZFj8Vc46xiugA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] drm: nova-drm: fix 32-bit arm build
Date: Thu, 24 Jul 2025 18:54:41 +0200
Message-ID: <20250724165441.2105632-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 32-bit arm, the build fails with:

    error[E0308]: mismatched types
      --> drivers/gpu/drm/nova/file.rs:42:28
       |
    42 |         getparam.set_value(value);
       |                  --------- ^^^^^ expected `u64`, found `u32`
       |                  |
       |                  arguments to this method are incorrect
       |
    note: method defined here
      --> drivers/gpu/drm/nova/uapi.rs:29:12
       |
    29 |     pub fn set_value(&self, v: u64) {
       |            ^^^^^^^^^        ------
    help: you can convert a `u32` to a `u64`
       |
    42 |         getparam.set_value(value.into());
       |                                 +++++++

The reason is that `Getparam::set_value` takes a `u64` (from the UAPI),
but `pci::Device::resource_len()` returns a `resource_size_t`, which is a
`phys_addr_t`, which may be 32- or 64-bit.

Thus add an `into()` call to support the 32-bit case, while allowing the
Clippy lint that complains in the 64-bit case where the type is the same.

Fixes: cdeaeb9dd762 ("drm: nova-drm: add initial driver skeleton")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
As discussed, it may be best to have a newtype, or at least a function
to perform this -- here it is the minimal fix nevertheless.

 drivers/gpu/drm/nova/file.rs | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nova/file.rs b/drivers/gpu/drm/nova/file.rs
index 7e59a34b830d..4fe62cf98a23 100644
--- a/drivers/gpu/drm/nova/file.rs
+++ b/drivers/gpu/drm/nova/file.rs
@@ -39,7 +39,8 @@ pub(crate) fn get_param(
             _ => return Err(EINVAL),
         };

-        getparam.set_value(value);
+        #[allow(clippy::useless_conversion)]
+        getparam.set_value(value.into());

         Ok(0)
     }

base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
--
2.50.1
