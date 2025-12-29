Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62062571BE;
	Mon, 29 Dec 2025 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025463; cv=none; b=eHEsSVRBPzX/s9FJhQlpbWb2k7wQl4Mx6T+0Gl/XUQalwUcebw5JbY27zVOsHI3x9jjrFjjAvxzZDmw35byh7ffuSPsgiwnfzbne3x2+aFODe7wGUBX6ylIfSrNzQB0wlEsM0txUfNUqn8KR8t0zjtmjGRTi4EVgg0OCKFjYTcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025463; c=relaxed/simple;
	bh=ygWqS+4KBUzGAMu4TtFlWfkJIt51Ihs42Zgfo7VCd5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJiGpxLxZNYEhsk2VAyiVCHqOtDosjZg6mcTlaZ4SPj6+hFh4v8GS80kZOz8dniB1r3gs+DZHBC/N6+R0vyvSxqK0QACs55fTHk5r8Qxd+L2Mqj+ktg9YOeT+ZpXCeI4vOHtYfajSKrgnqZ/VQ2VnCkq6zzKv8vDpMzYdCIHE6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lalkXEP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lalkXEP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14EFC4CEF7;
	Mon, 29 Dec 2025 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025463;
	bh=ygWqS+4KBUzGAMu4TtFlWfkJIt51Ihs42Zgfo7VCd5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lalkXEP/AT5bExI+HG540HSf6SINDc1QHJ/c+OqXAfPoXQgWTFfi2mnMLwsNdNgxP
	 wnwZQzofickXeIJduB384u5JzuTl3Q0jT9Lu3eSI0ZEpABPqjXj00dWriUXZPD1aRY
	 6act8+T/4eNvQhBwJsDs1E95YY0Vqu4yI6zBAIO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	David Gow <davidgow@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 222/430] rust: dma: add helpers for architectures without CONFIG_HAS_DMA
Date: Mon, 29 Dec 2025 17:10:24 +0100
Message-ID: <20251229160732.522001905@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

commit d8932355f8c5673106eca49abd142f8fe0c1fe8b upstream.

Add dma_set_mask(), dma_set_coherent_mask(), dma_map_sgtable(), and
dma_max_mapping_size() helpers to fix a build error when
CONFIG_HAS_DMA is not enabled.

Note that when CONFIG_HAS_DMA is enabled, they are included in both
bindings_generated.rs and bindings_helpers_generated.rs. The former
takes precedence so behavior remains unchanged in that case.

This fixes the following build error on UML:

error[E0425]: cannot find function `dma_set_mask` in crate `bindings`
     --> rust/kernel/dma.rs:46:38
      |
   46 |         to_result(unsafe { bindings::dma_set_mask(self.as_ref().as_raw(), mask.value()) })
      |                                      ^^^^^^^^^^^^ help: a function with a similar name exists: `xa_set_mark`
      |
     ::: rust/bindings/bindings_generated.rs:24690:5
      |
24690 |     pub fn xa_set_mark(arg1: *mut xarray, index: ffi::c_ulong, arg2: xa_mark_t);
      |     ---------------------------------------------------------------------------- similarly named function `xa_set_mark` defined here

error[E0425]: cannot find function `dma_set_coherent_mask` in crate `bindings`
     --> rust/kernel/dma.rs:63:38
      |
   63 |         to_result(unsafe { bindings::dma_set_coherent_mask(self.as_ref().as_raw(), mask.value()) })
      |                                      ^^^^^^^^^^^^^^^^^^^^^ help: a function with a similar name exists: `dma_coherent_ok`
      |
     ::: rust/bindings/bindings_generated.rs:52745:5
      |
52745 |     pub fn dma_coherent_ok(dev: *mut device, phys: phys_addr_t, size: usize) -> bool_;
      |     ---------------------------------------------------------------------------------- similarly named function `dma_coherent_ok` defined here

error[E0425]: cannot find function `dma_map_sgtable` in crate `bindings`
    --> rust/kernel/scatterlist.rs:212:23
     |
 212 |               bindings::dma_map_sgtable(dev.as_raw(), sgt.as_ptr(), dir.into(), 0)
     |                         ^^^^^^^^^^^^^^^ help: a function with a similar name exists: `dma_unmap_sgtable`
     |
    ::: rust/bindings/bindings_helpers_generated.rs:1351:5
     |
1351 | /     pub fn dma_unmap_sgtable(
1352 | |         dev: *mut device,
1353 | |         sgt: *mut sg_table,
1354 | |         dir: dma_data_direction,
1355 | |         attrs: ffi::c_ulong,
1356 | |     );
     | |______- similarly named function `dma_unmap_sgtable` defined here

error[E0425]: cannot find function `dma_max_mapping_size` in crate `bindings`
   --> rust/kernel/scatterlist.rs:356:52
    |
356 |         let max_segment = match unsafe { bindings::dma_max_mapping_size(dev.as_raw()) } {
    |                                                    ^^^^^^^^^^^^^^^^^^^^ not found in `bindings`

error: aborting due to 4 previous errors

Cc: stable@vger.kernel.org # v6.17+
Fixes: 101d66828a4ee ("rust: dma: add DMA addressing capabilities")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251204160639.364936-1-fujita.tomonori@gmail.com
[ Use relative paths in the error splat; add 'dma' prefix. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/helpers/dma.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/rust/helpers/dma.c b/rust/helpers/dma.c
index 6e741c197242..2afa32c21c94 100644
--- a/rust/helpers/dma.c
+++ b/rust/helpers/dma.c
@@ -19,3 +19,24 @@ int rust_helper_dma_set_mask_and_coherent(struct device *dev, u64 mask)
 {
 	return dma_set_mask_and_coherent(dev, mask);
 }
+
+int rust_helper_dma_set_mask(struct device *dev, u64 mask)
+{
+	return dma_set_mask(dev, mask);
+}
+
+int rust_helper_dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	return dma_set_coherent_mask(dev, mask);
+}
+
+int rust_helper_dma_map_sgtable(struct device *dev, struct sg_table *sgt,
+				enum dma_data_direction dir, unsigned long attrs)
+{
+	return dma_map_sgtable(dev, sgt, dir, attrs);
+}
+
+size_t rust_helper_dma_max_mapping_size(struct device *dev)
+{
+	return dma_max_mapping_size(dev);
+}
-- 
2.52.0



