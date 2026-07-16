Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49E041F7D5;
	Thu, 16 Jul 2026 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208999; cv=none; b=HWFIWtK4pWbZOLWdmQedI+BKvw4InNHIhXp79kwR2KVx2HnXzA/zZWGK0vPDTZt/m9NZq78RNVGD3tmCZdSghLvl0CDgQFADeitlRMJdvWEt4sogG+hKAJFZhWxsw2vSC77r682LKZdK+xk4wVmXa4msyE29r0GlcXuL7c7H3oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208999; c=relaxed/simple;
	bh=vFaSiET22ZhNCrRjDJSnDY832HFF1N/+NZ4p1XVEfgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRJBzD1PdVsOrTn1pI2Kw8jR4EsC+1O+dTPXuFD62PZvsZjMhzmuKUT3VUMemmo/HiI9SJp/f9amCgRDqyj5lNeNF0XbJmEX/6oxYhKylwUrnr+dD6wCYVTpmLLBm4Gz/KhH5Y6C1VUnQU1pz7MVC0aLyWYhw5N5ZNTXKFdVZ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnWa7ydN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnWa7ydN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECCE1F000E9;
	Thu, 16 Jul 2026 13:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784208997;
	bh=NWX+Uf7vuzb/w1gB5tAjseIDx0NcVIlr/MFrNGS2XSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnWa7ydNmfv+RFXH5eqwVTRPrWOv13sGjmFXXh/EMRIcleMnnbmMoUm5FYsk0qUyc
	 AF7T+UPm7HUSEizCtumNqXWLaGOLAG9s2sTLu0+4t+CytDrQQYJ1jsyE5N1KUsImQL
	 CYXqjheJR+1LeYNfVX0DuyiPK5rjVyGa14an9z68=
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
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 019/518] rust: block: fix GenDisk cleanup paths
Date: Thu, 16 Jul 2026 15:24:47 +0200
Message-ID: <20260716133048.196970042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoze Xie <royenheart@gmail.com>

commit 2957771379fa335103a4b539db57bb2271e12142 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/block/mq/gen_disk.rs |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -150,6 +150,19 @@ impl GenDiskBuilder {
         // SAFETY: `gendisk` is a valid pointer as we initialized it above
         unsafe { (*gendisk).fops = &TABLE };
 
+        let cleanup_failure = ScopeGuard::new_with_data((gendisk, data), |(gendisk, data)| {
+            // SAFETY: `gendisk` came from `__blk_mq_alloc_disk()` above and
+            // has not been added to the VFS on this cleanup path.
+            unsafe { bindings::put_disk(gendisk) };
+            // SAFETY: `data` came from `into_foreign()` above and has not been
+            // converted back on this cleanup path.
+            drop(unsafe { T::QueueData::from_foreign(data) });
+        });
+
+        // The failure guard now owns both pieces of cleanup; the early guard
+        // must not run on this path anymore.
+        recover_data.dismiss();
+
         let mut writer = NullTerminatedFormatter::new(
             // SAFETY: `gendisk` points to a valid and initialized instance. We
             // have exclusive access, since the disk is not added to the VFS
@@ -172,7 +185,7 @@ impl GenDiskBuilder {
             },
         )?;
 
-        recover_data.dismiss();
+        cleanup_failure.dismiss();
 
         // INVARIANT: `gendisk` was initialized above.
         // INVARIANT: `gendisk` was added to the VFS via `device_add_disk` above.
@@ -215,6 +228,11 @@ impl<T: Operations> Drop for GenDisk<T>
         // to the VFS.
         unsafe { bindings::del_gendisk(self.gendisk) };
 
+        // SAFETY: By type invariant, `self.gendisk` was added to the VFS, so
+        // `put_disk()` must follow `del_gendisk()` to drop the final gendisk
+        // reference and trigger the remaining release path.
+        unsafe { bindings::put_disk(self.gendisk) };
+
         // SAFETY: `queue.queuedata` was created by `GenDiskBuilder::build` with
         // a call to `ForeignOwnable::into_foreign` to create `queuedata`.
         // `ForeignOwnable::from_foreign` is only called here.


