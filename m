Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA0B3876CC;
	Fri,  4 Sep 2026 05:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498380; cv=none; b=V2lnM/3a0QTWH0vY3unLgDiE08sZLtKsxKlC3+NbC09+JWsZIHF1XeRt3okLKO7I+Ft1W40Stg8xyVIvuZXVg5Kc2PmPduEOasFoFyurA0gRWufQGGuofnP94zSNYWEA8hb9WGtPW68S8Iz4awLtd9USdlhHnIdNcZFfa8ZSTQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498380; c=relaxed/simple;
	bh=XNSCd7eQcaW/BRGvkPPusWDUBcfK0lxSPmnetmKEBW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4xjutzBwyxii+pwyY7XCpl0GfdKJ5MNHzocGI+GPWuXTgV6VilUzJKk9Ns2KHPXj7UBrm09PU0TFlyzRXbgebrDuQ+66b+SDSsFguaTzFfsuBN9KrkttZYwiF0ltFtv3BDSWNzcE5XANYHzUZVopAgUPth/IJ1tX1Iq4bFMsD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tA8wUG8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tA8wUG8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD651F00A3E;
	Fri,  4 Sep 2026 05:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498378;
	bh=soQ58yF8vJfXErXpPfChmO12V644dcyIvDWRa4wXXy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tA8wUG8WXt8ER+jR3Gdp15K9uM6zxrFbGTRDhWZyCyNWyoyqn6iGXlxjBXdGq+IOp
	 1GaThV/xD2wlgxKDn6mi7OfkCcOCo60FZ5o21Tzi2IUpw5fIrGUFszXTpNg0476v3f
	 sGdoPthqhfR4+ix0uSlXVk1Niiz2cTgJnq/xOnyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Boucher <bouanto@zoho.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 034/713] rust: kbuild: disambiguate `zerocopy_derive` for `rusttest`
Date: Fri,  4 Sep 2026 06:50:02 +0200
Message-ID: <20260904045804.595079755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 1b0bab4a873f1034c27573cfc613394cff7e0a5b upstream.

The `rustc-dev` components for Rust 1.82.0 through 1.87.0 include a
precompiled `zerocopy_derive` procedural macro in the sysroot. This
range includes Rust 1.85.0, our minimum supported version.

This makes `rusttest` fail because the compiler finds both the sysroot
copy and the copy built in `rust/test`:

    error[E0464]: multiple candidates for `dylib` dependency `zerocopy_derive` found
      --> rust/kernel/prelude.rs:70:9
       |
    70 | pub use zerocopy_derive::{
       |         ^^^^^^^^^^^^^^^
       |
       = note: candidate #1: .../lib/rustlib/x86_64-unknown-linux-gnu/lib/libzerocopy_derive-54d2b38896fa6bc5.so
       = note: candidate #2: .../rust/test/libzerocopy_derive.so

Commit fe39a233ea52 ("rust: kbuild: disambiguate `zerocopy` for
`rusttest`") fixed the equivalent ambiguity for `zerocopy`.

Thus point to the dependency explicitly in this case too.

Cc: Antoni Boucher <bouanto@zoho.com>
Cc: stable@vger.kernel.org
Fixes: 506054980429 ("rust: zerocopy-derive: enable support in kbuild")
Link: https://patch.msgid.link/20260823193529.156066-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 3afaad4a4a3a..9211d82ac96d 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -350,7 +350,8 @@ rusttestlib-pin_init: $(src)/pin-init/src/lib.rs rusttestlib-macros \
 rusttestlib-kernel: private rustc_target_flags = --extern ffi \
     --extern build_error --extern macros --extern pin_init \
     --extern bindings --extern uapi \
-    --extern zerocopy=$(objtree)/$(obj)/test/libzerocopy.rlib --extern zerocopy_derive
+    --extern zerocopy=$(objtree)/$(obj)/test/libzerocopy.rlib \
+    --extern zerocopy_derive=$(objtree)/$(obj)/test/$(libzerocopy_derive_name)
 rusttestlib-kernel: $(src)/kernel/lib.rs rusttestlib-bindings rusttestlib-uapi \
     rusttestlib-build_error rusttestlib-pin_init $(obj)/$(libmacros_name) \
     $(obj)/bindings.o rusttestlib-zerocopy rusttestlib-zerocopy_derive FORCE
-- 
2.55.0



