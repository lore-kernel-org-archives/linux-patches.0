Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27215348C4A;
	Tue, 21 Jul 2026 20:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664256; cv=none; b=eNSEx0WYTfYqeXRsY35b7m7IjvloES2j0ulo8VZAJv17UkTTLIFV7H6iQkxdHSLyMjNBITiatsAZypd9rzpQuqhIlnjePSy5bwH4uiuASWO6tB/Jgip+CIPopxmPbYU9etatWTqBsRW4U5nRmFTWjsBTFW9BfuXaQqn3Czf1fQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664256; c=relaxed/simple;
	bh=22ufjDlLGFBKuDvsRrSsJ4Wv7GVePUSxCry6VTJJuQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4lKFT0qfATp/l/P1y2sUyTOfKTzAjgBCO0sCZLB7MLfsXGVXRhD+o444/lbz64/sQ07Do8hUFVCrXSc1xaKIxNzxN0bTHhBi1es3mYdlXdwIxjJosfkBxzq05UAkqBBolXoTZz5X+93RlY0tqg//V4tXmbGg8psoI/t25u3RVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C17lUZBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C17lUZBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9160C1F000E9;
	Tue, 21 Jul 2026 20:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664255;
	bh=Ct4YI6U4I//9GoMifx9i5HeHU+n5ZScNdbjUqPYPkEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C17lUZBndOTj8jhggh9qmWmMpYiTDy/v2u2j4hQJ5BkLDFmtHu/fs8NaouldDOIMr
	 mNMXzPqHUUXNbctzAW8CTx6Y3OBf038YH9NfLIWPX4H/PZhNwOnLYqUVudjTBgoBnI
	 F6JXcu90nNi0K1WvSChw5oP38aP//SMEyG54x91I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Haoze Xie <royenheart@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1131/1276] rust: block: fix GenDisk cleanup paths
Date: Tue, 21 Jul 2026 17:26:14 +0200
Message-ID: <20260721152511.304114262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoze Xie <royenheart@gmail.com>

[ Upstream commit 2957771379fa335103a4b539db57bb2271e12142 ]

GenDiskBuilder::build() still has fallible work after
__blk_mq_alloc_disk(), but its error path only recovers the
foreign queue data. That leaks the temporary gendisk and
request_queue until later teardown. If the caller moved the last
Arc<TagSet<T>> into build(), the leaked queue can retain blk-mq
state after the tag set is dropped.

Fix the pre-registration failure path by dropping the temporary
gendisk reference with put_disk() before recovering queue_data,
so disk_release() can tear down the owned queue.

Also pair GenDisk::drop() with put_disk() after del_gendisk().
Once a Rust GenDisk has been added with device_add_disk(),
del_gendisk() only unregisters it; the final gendisk reference
still has to be dropped to complete the release path.

Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/b70aff9a920cc42110fe5cf454c3099561863519.1780063368.git.royenheart@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ no queue-data recovery or recover_data.dismiss() in 6.12 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/block/mq/gen_disk.rs |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -6,7 +6,7 @@
 //! C header: [`include/linux/blk-mq.h`](srctree/include/linux/blk-mq.h)
 
 use crate::block::mq::{raw_writer::RawWriter, Operations, TagSet};
-use crate::{bindings, error::from_err_ptr, error::Result, sync::Arc};
+use crate::{bindings, error::from_err_ptr, error::Result, sync::Arc, types::ScopeGuard};
 use crate::{error, static_lock_class};
 use core::fmt::{self, Write};
 
@@ -139,6 +139,12 @@ impl GenDiskBuilder {
         // SAFETY: `gendisk` is a valid pointer as we initialized it above
         unsafe { (*gendisk).fops = &TABLE };
 
+        let cleanup_failure = ScopeGuard::new_with_data(gendisk, |gendisk| {
+            // SAFETY: `gendisk` came from `__blk_mq_alloc_disk()` above and
+            // has not been added to the VFS on this cleanup path.
+            unsafe { bindings::put_disk(gendisk) };
+        });
+
         let mut raw_writer = RawWriter::from_array(
             // SAFETY: `gendisk` points to a valid and initialized instance. We
             // have exclusive access, since the disk is not added to the VFS
@@ -161,6 +167,8 @@ impl GenDiskBuilder {
             },
         )?;
 
+        cleanup_failure.dismiss();
+
         // INVARIANT: `gendisk` was initialized above.
         // INVARIANT: `gendisk` was added to the VFS via `device_add_disk` above.
         Ok(GenDisk {
@@ -192,5 +200,10 @@ impl<T: Operations> Drop for GenDisk<T>
         // initialized instance of `struct gendisk`, and it was previously added
         // to the VFS.
         unsafe { bindings::del_gendisk(self.gendisk) };
+
+        // SAFETY: By type invariant, `self.gendisk` was added to the VFS, so
+        // `put_disk()` must follow `del_gendisk()` to drop the final gendisk
+        // reference and trigger the remaining release path.
+        unsafe { bindings::put_disk(self.gendisk) };
     }
 }


