Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B88A29B799;
	Sat, 12 Sep 2026 07:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199494; cv=none; b=Wvg1jea8dQKarOoLC0hhc2pOLB9lNkzOiXOpC81RFrlqwzSEXDKfm8LArpIlvcYuAiYH2c6tvcASGIiE44PkpiJi0CESV7aIU1JcwCH2P25oZH5z19iQ7Bc2PC0i3qynT+m6mialieZG6GPGrsuA15d3uGK/bkcrs1ezlv6iu6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199494; c=relaxed/simple;
	bh=zPKNkn3DNo9IM9w/aXGqrhIB7C5X84Ob4+8waRnBgqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeJIP9cDsOy5w92m/eo5cM6kQZz9yfzKj5qt36cvIeJvZmoGStYT3rs2wM90jTzqXJqHYjNlLXnTFzqZTpgSBHcp6H3OB/e6MgqdwTxoo74jHJEq6+Hebzg4L/6Z30zPerlbUowxZ2qHenbPeCInN3deAHXN9hP65J5CyY7nJDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHbvz+nJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHbvz+nJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9431F000FF;
	Sat, 12 Sep 2026 07:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199493;
	bh=M/ccjKpgxkYdFLof/xKE3ID2rRcVwuSn9CRhrmN+Fag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHbvz+nJusCkLfJPhd31eNfs+kP/F8R3K+e26vVhOzyEvzFC7xRlic5MMC1nUL+dj
	 3eWAmjBOMtd7gwgcRzxCZATKCn+E0m/X8cN8azVPfQiGiOM76UP/Z9p024w1BRavUJ
	 4t7uQcTic/ZJU/XFWBUgYdpeNgIMJjwGscdIigcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0553/1815] samples: rust: debugfs: fix excessive stack use
Date: Sat, 12 Sep 2026 08:38:23 +0200
Message-ID: <20260912065701.866181575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit f5256ad60651fc010e2cf6dc7fe195415f496fc9 ]

The current implementation creates a 4K array and move it into the box.
Klint reports that this causes excesssive stack usage:

warning: stack size of `create_file_write` is 4472 bytes, exceeds the 2048-byte limit
  --> samples/rust/rust_debugfs_scoped.rs:54:1
   |
54 | / fn create_file_write(
55 | |     mod_data: &ModuleData,
56 | |     reader: &mut kernel::uaccess::UserSliceReader,
57 | | ) -> Result {
   | |___________^
   |
   = note: the stack size is inferred from instruction `sub $0x1178,%rsp` at .text+2205

Use pin-init to create the array in-place instead.

Fixes: f656279afde1 ("samples: rust: debugfs_scoped: add example for blobs")
Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260716144144.3665719-1-gary@kernel.org
[ Make the patch rustfmtcheck complient. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/rust/rust_debugfs_scoped.rs | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/samples/rust/rust_debugfs_scoped.rs b/samples/rust/rust_debugfs_scoped.rs
index 6a575a15a2c2f..ca2b154be3842 100644
--- a/samples/rust/rust_debugfs_scoped.rs
+++ b/samples/rust/rust_debugfs_scoped.rs
@@ -75,7 +75,10 @@ fn create_file_write(
             GFP_KERNEL,
         )?;
     }
-    let blob = KBox::pin_init(new_mutex!([0x42; SZ_4K]), GFP_KERNEL)?;
+    let blob = KBox::pin_init(
+        new_mutex!(pin_init::init_array_from_fn(|_| 0x42)),
+        GFP_KERNEL,
+    )?;
 
     let scope = KBox::pin_init(
         mod_data.device_dir.scope(
-- 
2.53.0



