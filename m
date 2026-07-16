Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D5231E856;
	Thu, 16 Jul 2026 14:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210654; cv=none; b=c83OvaDhV9dJAR1vqww8JQIiLVp49DQNf7YutHXqcTXC/BNYldqJHs7q4Db56tLXjcV9cPw/x7AyX8kDzAPdj3gEEwcvaTN/zbosqHIIGyooiQwj+vfkRMJm9ALa6PzMrBlzOKVwMv20wLZsVhjeU6cr0wWFfyHCsw+OfTA8S4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210654; c=relaxed/simple;
	bh=ImXlwcsOTCx1B4pFl2xJAh/S2uBbuvRlqEqtZlrqtBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN9//BrU/kGb4FKeMdr17AmdUV9poeKZLcNUX5YLmMKDp5De6dcUSTca95Tb/brdvXQuj8HzC3/sYewBNaxZAPjze5/Lb3Hr6718CL4M9K8+PhNcn9T9x9rIZTCUh+J2A3ySIyFwLnrjE+QDdE6yjJejdtlTExH20Hu9XkxxvqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9nyB5Qn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9nyB5Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688501F000E9;
	Thu, 16 Jul 2026 14:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210652;
	bh=AJgv1BIdZooa0hMkCdQWlJspTcGtAHa0aHAEQ8QtWVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9nyB5QnvUSgNEyHIm9inSE21Mo30uAcJJ7W0U+dxQMQ5byCgupqDnkmPi1By/hPD
	 Xu7vEdgBCzAVqEyGRCGvIx2PXkLaKbuU3bEhs6bsaeUCxRT80gM3ZvH66WidknuIBC
	 U9TXhdjDHpQb24Z7u0ktvT4QONui20KUSsHtb6yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 128/480] rust_binder: use a u64 stride when cleaning up the offsets array
Date: Thu, 16 Jul 2026 15:27:55 +0200
Message-ID: <20260716133047.478141667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 803c8a9502e9b97cd6ae937618ef4a8fd6274343 upstream.

Allocation's Drop walks the offsets array (binder_size_t = u64 entries),
cleaning up the objects, but it used usize instead of u64 for both the
stride and the per-entry read.

On 64-bit kernels (usize == u64) this is harmless, but on 32-bit kernels
it walks the 8-byte entries in 4-byte steps, iterating an N-entry array
2N times, and reads the always-zero high word as offset 0, cleaning up
the object at offset 0 N extra times. As a result the referenced node or
handle ends up with a lower reference count than it actually has (a
refcount over-decrement), and binder's reference accounting is corrupted;
for example, the owner can be notified of a strong reference release
(BR_RELEASE) even though references still remain.

Change the stride to u64, and read each entry as a u64, narrowing it to
usize with try_into().

On 32-bit ARM, when this over-decrement would drive a count below zero,
the driver's existing refcount guard refuses it and fires:

  rust_binder: Failure: refcount underflow!

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/ahw3tFhLz9bMMJAO@v4bel
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/allocation.rs |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/android/binder/allocation.rs
+++ b/drivers/android/binder/allocation.rs
@@ -261,7 +261,7 @@ impl Drop for Allocation {
 
             if let Some(offsets) = info.offsets.clone() {
                 let view = AllocationView::new(self, offsets.start);
-                for i in offsets.step_by(size_of::<usize>()) {
+                for i in offsets.step_by(size_of::<u64>()) {
                     if view.cleanup_object(i).is_err() {
                         pr_warn!("Error cleaning up object at offset {}\n", i)
                     }
@@ -419,7 +419,8 @@ impl<'a> AllocationView<'a> {
     }
 
     fn cleanup_object(&self, index_offset: usize) -> Result {
-        let offset = self.alloc.read(index_offset)?;
+        let offset = self.alloc.read::<u64>(index_offset)?;
+        let offset: usize = offset.try_into().map_err(|_| EINVAL)?;
         let header = self.read::<BinderObjectHeader>(offset)?;
         match header.type_ {
             BINDER_TYPE_WEAK_BINDER | BINDER_TYPE_BINDER => {


