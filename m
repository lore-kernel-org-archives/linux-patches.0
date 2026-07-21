Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D2A46D0A4;
	Tue, 21 Jul 2026 18:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658526; cv=none; b=m0PnXXFmCamq6F4pR1tIgdzbJnEl0HC3vAvKQfzaWeNXK4cjnqHxzK058v+H5VRP7ASuGrui0mk030PXvcjh7TPPLMUylTxzfdM0zQZb2Tg/K9H2GVj6V2PUMvr6UTxoOpSy2lo0b/WkIIrNMSHORbVZGpfpavqOkfXg8lk5f6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658526; c=relaxed/simple;
	bh=b0GFSHNbta/LSMxT79uF8jIvAOc+pyREPgd06TljAsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWaiJ0RVHKqBxW5LNu8kgdRr9DCT4Kt0sO/as6am/NCb+UtAQoWTygWNLSvU9SfziI28WtefJBf5w2wtMGwUg2+QC5XIO+uvMJTce7cuFC2yB7OmIlXfttVJdCAZJqggGPTWHHS4dhX8HSXNRD0ktpLP9msXYTihWmsmK1UYtYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ymcuvcmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ymcuvcmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24871F00A3A;
	Tue, 21 Jul 2026 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658521;
	bh=jJZqZ7spdRiv9SfcLqLIRRvI1ZcqPjLLXwHWQfS64yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmcuvcmbYK/DhJcIMajUu9riN8KAbneK9gxyyJTxW7wfjuvA/0lpTAOT3EQfJBWQx
	 d/YIEQOV66EWkDSBVZGT6Z5V1kBclFxcvKunjPjavVgsr2mhT2Gb07EOwsjTy8e9D0
	 XoGonkrHP5f+RpzmjF7erfcUGaCcGjLbHKSAn/t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 6.18 1176/1611] gpu: nova-core: simplify and_then with condition to filter
Date: Tue, 21 Jul 2026 17:21:32 +0200
Message-ID: <20260721152541.883236996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Eliot Courtney <ecourtney@nvidia.com>

commit 16df3873c80388a71c4695909a51be0c809b889c upstream.

This code is more simply expressed using Option::filter instead of the
and_then with conditional.

This fixes the following warning with latest nightly Rust clippy build:

warning: manual implementation of `Option::filter`
   --> drivers/gpu/nova-core/firmware.rs:391:14
    |
391 |               .and_then(|hdr| {
    |  ______________^
392 | |                 if hdr.bin_magic == BIN_MAGIC {
393 | |                     Some(hdr)
394 | |                 } else {
...   |
397 | |             })
    | |______________^ help: try: `filter(|hdr| hdr.bin_magic == BIN_MAGIC)`
    |
    = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_filter
    = note: `-D clippy::manual-filter` implied by `-D warnings`
    = help: to override `-D warnings` add `#[allow(clippy::manual_filter)]`

Cc: stable@vger.kernel.org
Fixes: d6cb7319e64e ("gpu: nova-core: firmware: add support for common firmware header")
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260423-fix-filter-v1-1-b3b197c65daf@nvidia.com
[aliceryhl: add Fixes: tag and quote the warning it fixes]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/nova-core/firmware.rs |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/nova-core/firmware.rs
+++ b/drivers/gpu/nova-core/firmware.rs
@@ -176,13 +176,7 @@ impl<'a> BinFirmware<'a> {
             // Extract header.
             .and_then(BinHdr::from_bytes_copy)
             // Validate header.
-            .and_then(|hdr| {
-                if hdr.bin_magic == BIN_MAGIC {
-                    Some(hdr)
-                } else {
-                    None
-                }
-            })
+            .filter(|hdr| hdr.bin_magic == BIN_MAGIC)
             .map(|hdr| Self { hdr, fw })
             .ok_or(EINVAL)
     }


