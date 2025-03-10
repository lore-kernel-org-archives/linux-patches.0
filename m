Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61262230BC3;
	Mon, 10 Mar 2025 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627263; cv=none; b=hDSr2Gq0CJxMhIhiNhDdoOfjZy+GwYQCcj5Ymm/fh5DjvkW0YJhoHHGNzJ5AmZxT8+ZT5Au5fHkSWbpjoCwIt27bJjnCbCsncSHXETqkAMA9YMC9xZKfgaOeeZkdCKB+a8Td1MDcWssTiMl/f/ZvOt+ffACJSjCBz7U0nR34evU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627263; c=relaxed/simple;
	bh=hQhbVSVp/WrSrf/FnRZeoMV+qb2M4YV8zfRdQx6dw/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLeFnu5xf2ePcOKVVX8WvpmSsUmSmmADf+RBDw3NW6fjqQ/uAzydTXc9RnCiATT+yybp+alZbiQXCOOGG61bs06S1WwWdL1QafDwiLF3fbFhtLf9TaG4oeKSbx4Qyi6mSNhAkyeU8Hxz1tW/6MfCzxDlWvEkI4xduEMGulQHv5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YON47DH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YON47DH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF46BC4CEE5;
	Mon, 10 Mar 2025 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627263;
	bh=hQhbVSVp/WrSrf/FnRZeoMV+qb2M4YV8zfRdQx6dw/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YON47DH5CcjSUiEYwjxKqRAduUUCdBBbElAVpgdWc4S6tHOIp1uU4+XBNVx2pmLk1
	 HFU+XiZBqUUiZNxeNFjUMQ5pRWIpIruLqpoGx8hsRg6ZKz7L3XECqVnhoEdyDsWGaV
	 modtHlc6b810u7E764c8kcJ5/AQfqvieGYDQwZVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 069/269] rust: map `__kernel_size_t` and friends also to usize/isize
Date: Mon, 10 Mar 2025 18:03:42 +0100
Message-ID: <20250310170500.480250839@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

commit 2fd6f55c048d0c863ffbc8590b1bd2edb5ff13e5 upstream.

Currently bindgen has special logic to recognise `size_t` and `ssize_t`
and map them to Rust `usize` and `isize`. Similarly, `ptrdiff_t` is
mapped to `isize`.

However this falls short for `__kernel_size_t`, `__kernel_ssize_t` and
`__kernel_ptrdiff_t`. To ensure that they are mapped to usize/isize
rather than 32/64 integers depending on platform, blocklist them in
bindgen parameters and manually provide their definition.

Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Link: https://lore.kernel.org/r/20240913213041.395655-3-gary@garyguo.net
[ Formatted comment. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindgen_parameters |    5 +++++
 rust/bindings/lib.rs    |    5 +++++
 rust/uapi/lib.rs        |    5 +++++
 3 files changed, 15 insertions(+)

--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -1,5 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 
+# We want to map these types to `isize`/`usize` manually, instead of
+# define them as `int`/`long` depending on platform bitwidth.
+--blocklist-type __kernel_s?size_t
+--blocklist-type __kernel_ptrdiff_t
+
 --opaque-type xregs_state
 --opaque-type desc_struct
 --opaque-type arch_lbr_state
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -27,6 +27,11 @@
 #[allow(dead_code)]
 #[allow(clippy::undocumented_unsafe_blocks)]
 mod bindings_raw {
+    // Manual definition for blocklisted types.
+    type __kernel_size_t = usize;
+    type __kernel_ssize_t = isize;
+    type __kernel_ptrdiff_t = isize;
+
     // Use glob import here to expose all helpers.
     // Symbols defined within the module will take precedence to the glob import.
     pub use super::bindings_helper::*;
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -25,4 +25,9 @@
     unsafe_op_in_unsafe_fn
 )]
 
+// Manual definition of blocklisted types.
+type __kernel_size_t = usize;
+type __kernel_ssize_t = isize;
+type __kernel_ptrdiff_t = isize;
+
 include!(concat!(env!("OBJTREE"), "/rust/uapi/uapi_generated.rs"));


