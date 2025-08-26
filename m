Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C07200112;
	Tue, 26 Aug 2025 11:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208885; cv=none; b=riGRKovopUr+/ETFigaGUpio/yEsCWWkD2sPoIYZNV2+34pVtG9WsaaZ4hOgPKq2xivO6H2FAf6cMD/z2qyF+fGkUcH5+2Wns/hrOpB4zpfHPlh7gbUB98CWcwE9TMQU0Bq42HP+u8NfRWKEUTRl8qJ9UIA9mLj1l7POVBot/Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208885; c=relaxed/simple;
	bh=OI4Q8ElkOcT15UjbFAf4sk6bgPWfzwWT7PwqZrwXpds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu3ykRTMCZE+QhXBt7lRoUnZn682WS7+0aKd3waEEWY0x0oNFJuM0AdAzIydMcPTXSdQ3TvVuu/L/ACMbxd1+qEUlpLcQ4jLt6PzdSEXDXQY+Le+0RNZZiM7AXBswcEs4i9DJ3lszmm9TsQCOv6JKWD2Ej7OlsT58XC7acN/dgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yas+L+LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yas+L+LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C72EC4CEF1;
	Tue, 26 Aug 2025 11:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208884;
	bh=OI4Q8ElkOcT15UjbFAf4sk6bgPWfzwWT7PwqZrwXpds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yas+L+LDtu8ng0EzMGuqb/9+cZh5zqk/7S4dpzBi9wcrAw0t55PmZjWiegtp1WZ5+
	 YU6IW9GQ01qh6XKS8IkBCU2PyxJlhpPKNIOfhJjO9jrQo30XV1rKrveJIvuez5zdCa
	 GhTn19c5IReG4YqIdHGvPA2YjFFJm0FNT6CJwHUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/322] rust: alloc: fix `rusttest` by providing `Cmalloc::aligned_layout` too
Date: Tue, 26 Aug 2025 13:11:38 +0200
Message-ID: <20250826110922.908766318@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 0f580d5d3d9d9cd0953695cd32e43aac3a946338 ]

Commit fde578c86281 ("rust: alloc: replace aligned_size() with
Kmalloc::aligned_layout()") provides a public `aligned_layout` function
in `Kamlloc`, but not in `Cmalloc`, and thus uses of it will trigger an
error in `rusttest`.

Such a user appeared in the following commit 22ab0641b939 ("rust: drm:
ensure kmalloc() compatible Layout"):

    error[E0599]: no function or associated item named `aligned_layout` found for struct `alloc::allocator_test::Cmalloc` in the current scope
       --> rust/kernel/drm/device.rs:100:31
        |
    100 |         let layout = Kmalloc::aligned_layout(Layout::new::<Self>());
        |                               ^^^^^^^^^^^^^^ function or associated item not found in `Cmalloc`
        |
       ::: rust/kernel/alloc/allocator_test.rs:19:1
        |
    19  | pub struct Cmalloc;
        | ------------------ function or associated item `aligned_layout` not found for this struct

Thus add an equivalent one for `Cmalloc`.

Fixes: fde578c86281 ("rust: alloc: replace aligned_size() with Kmalloc::aligned_layout()")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/r/20250816204215.2719559-1-ojeda@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/alloc/allocator_test.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index c37d4c0c64e9..ec13385489df 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -22,6 +22,17 @@ pub type Kmalloc = Cmalloc;
 pub type Vmalloc = Kmalloc;
 pub type KVmalloc = Kmalloc;
 
+impl Cmalloc {
+    /// Returns a [`Layout`] that makes [`Kmalloc`] fulfill the requested size and alignment of
+    /// `layout`.
+    pub fn aligned_layout(layout: Layout) -> Layout {
+        // Note that `layout.size()` (after padding) is guaranteed to be a multiple of
+        // `layout.align()` which together with the slab guarantees means that `Kmalloc` will return
+        // a properly aligned object (see comments in `kmalloc()` for more information).
+        layout.pad_to_align()
+    }
+}
+
 extern "C" {
     #[link_name = "aligned_alloc"]
     fn libc_aligned_alloc(align: usize, size: usize) -> *mut crate::ffi::c_void;
-- 
2.50.1



