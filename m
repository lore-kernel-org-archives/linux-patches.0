Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FC3451B0;
	Tue, 26 Aug 2025 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208051; cv=none; b=gHrLaNzAVPztSJRnViiIPZ0wA/JYX9K2EP/7S1ohcBC5qymNuyZT3df2VOsaV2ufZlW7iBvLIOcMM1cySjfssY//IJ+c/V0/6BAQMHvupLz0t5kW68ypd39UoYGUIYwUZRcjGFmB3ut3h/2/BpQT1/V7+kkpjOvpEBC2WMeXu1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208051; c=relaxed/simple;
	bh=TUi38SWBbJY5IQFUnfqULMvQTCOLNHozF8AbccA2tCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jA+kHU2RGdWbtW9s9jKqj70NjM9pmepBZuab0mo2Xc6YncSBh3IpRmLWqurMFLO6R8u2bHyKAR6gfstxAZa08kTxlT77r24DU3h/vZV7z7Wi7AIgVOKe5V05Ln6Az5voDyjzHnEDOvc2WzhmQ8115cCuZhiNvIefoNbQ+WnGqt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAvh/hw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAvh/hw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F07C4CEF1;
	Tue, 26 Aug 2025 11:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208050;
	bh=TUi38SWBbJY5IQFUnfqULMvQTCOLNHozF8AbccA2tCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAvh/hw/aalZk2MZuwe5RhcbeHlLxklVJsm6XOim9JMGaEr2vrWgZIKekBNr7dBbU
	 xkhbYjInjSQXWVz3wbkFudo929MrnSNZk5d3MPxU7l/Mp99PLwdqYHReEsOQREt+zR
	 w8MWlfFBLzfUa08oY7TDxIPQYuQuU6L9IsrboHKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 387/457] rust: alloc: fix `rusttest` by providing `Cmalloc::aligned_layout` too
Date: Tue, 26 Aug 2025 13:11:11 +0200
Message-ID: <20250826110946.863543490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d19c06ef0498..981e002ae3fc 100644
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



