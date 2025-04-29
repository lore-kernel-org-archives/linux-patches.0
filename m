Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4005B269CE4;
	Tue, 29 Apr 2025 21:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745960801; cv=none; b=K7578lUgv/9M74gfu6kOt0eOHzv1HdAKjKQrTMWQQbPjFEbaBg7DP13nKeT1hh0WFjrqUNFRDOAF8EjKcj+jGduXsuKabqupoFQSHCAbY56KNo68eeeE6VdaKPmGMstt+NURPLcHshnsYxiVLWxRREDbxV1yYOr2mXpAqE0cE08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745960801; c=relaxed/simple;
	bh=w9w+NGcAG0cOCJ1juicpu39Kb3YKDU/ff1a+IGkziY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kj9iT9rHrPiM8sEby+r8iEP1Zyen5qiHwbfQ5DIH2lMmIH87n1LCeWUhMuDXVF+ECxshvMoSCfUL9wi93Z9O5ieTrurayoSoGW6Lhjq9o5VttBMLYmEvq5NTiHymRPyQyyDCfkzBIa3sMjqsjxT4/oUVX+/1MjWro1kN6GSsUV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRSKAs0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRSKAs0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E44C4CEE3;
	Tue, 29 Apr 2025 21:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745960800;
	bh=w9w+NGcAG0cOCJ1juicpu39Kb3YKDU/ff1a+IGkziY4=;
	h=From:To:Cc:Subject:Date:From;
	b=pRSKAs0G6QWTb4YoNC2hvhaNxfCBL1O2BFI9Outq5NNPI5Q3wW3i37nqxBnAmWT/U
	 Gbhu/121B3AhA10LrAa7xj9L/lIIrramyQCUt8drcfgf2IGzlXiZAUUM7atqhc8PZf
	 YsGDLrlzje4sBvVwS0Q1NjIfk7svZugklDtUMfzqlvFROHNK4hZqGY5i0Tc/ysfUj2
	 8EGDrdsUEOSxpn9jAaSpai7zG7nJ0VCs2MC/p7cHCbnVN478hkWGnxUEsiKYh+WnIm
	 6vLk15bzkPvnP2Zjqd6zEexHo3dhcjJKVQrpF75ohWlAkMEgwYYUZAAYaE9TiQ1kIa
	 Dlxi4fvt84MnQ==
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
Subject: [PATCH v2] rust: device: allow `Device<DeviceContext>::parent()`
Date: Tue, 29 Apr 2025 23:06:29 +0200
Message-ID: <20250429210629.513521-1-ojeda@kernel.org>
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

Thus reintroduce the `expect`, but now as a conditional one. Do so as
`dead_code` since that is narrower.

An `allow` would also be possible, but Danilo wants to catch new users
in the future [1].

Link: https://lore.kernel.org/rust-for-linux/aBE8qQrpXOfru_K3@pollux/ [1]
Fixes: ce735e73dd59 ("rust: auxiliary: add auxiliary device / driver abstractions")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/device.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 40c1f549b0ba..f08583fa39c9 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -68,6 +68,7 @@ pub(crate) fn as_raw(&self) -> *mut bindings::device {
     }
 
     /// Returns a reference to the parent device, if any.
+    #[cfg_attr(not(CONFIG_AUXILIARY_BUS), expect(dead_code))]
     pub(crate) fn parent(&self) -> Option<&Self> {
         // SAFETY:
         // - By the type invariant `self.as_raw()` is always valid.

base-commit: ce735e73dd59b169b877cedd0753297c81c2a091
-- 
2.49.0

