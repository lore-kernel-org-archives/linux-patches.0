Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2741D3F482E;
	Thu, 16 Jul 2026 13:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209283; cv=none; b=K5SRWpKMQZm8D0wjAxbWW8TRB76yWFUeiyATD8Eo8m/86w0xYAhQlCx9ersapBrqX1IpdhUUhYg+XuQPlS92i8n52TEpluhPqGhQ1eIJ0KGKvXYnwR5K3IHw/n8G/8xmZTysKZzExs3/g+LpbmEgWbSz+UivEa6i4VLwPvMTXYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209283; c=relaxed/simple;
	bh=JniobTQ9T9Cn5zztvm8bkirYgbTDEZ355KlN5fayMnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPg6LN3gx+tqtiYKvdRV+43XeUBowXKWyIzpunMYN2DP7CH5i88Z//rjgmbchnC+xQCGOhLYVcCZTigE5FY+rvVXyX1Do2HpBfhtps528cGS/zbfcX7QEg4CQ+lW81TP5s4aUoEqUhkrwgRSmXtoauYxSXk40Sgujq1attvBwoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfqQWYyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfqQWYyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B18F1F00A3A;
	Thu, 16 Jul 2026 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209282;
	bh=AT8+9W/kuo/QUZHZhDPYbrqmGzH0sNePZz7WT7H4kOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfqQWYyDESzvCVCMUR2IdEobKvXBw4yhVJtx+JS7WGxI9fEdKMkPRM8maBEsHwwVk
	 DqUeuipHATpwbifPd/52/xkQ6+v7bqZ9EeP31SPD1NtQkf8yMFjqqX4p5vU0G6BHcz
	 oycmkE1G0AcA6yYOgKypZN21PtRFBuWZQqyKO0EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.1 119/518] rust_binder: use a u64 stride when cleaning up the offsets array
Date: Thu, 16 Jul 2026 15:26:27 +0200
Message-ID: <20260716133050.457221481@linuxfoundation.org>
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
@@ -259,7 +259,7 @@ impl Drop for Allocation {
 
             if let Some(offsets) = info.offsets.clone() {
                 let view = AllocationView::new(self, offsets.start);
-                for i in offsets.step_by(size_of::<usize>()) {
+                for i in offsets.step_by(size_of::<u64>()) {
                     if view.cleanup_object(i).is_err() {
                         pr_warn!("Error cleaning up object at offset {}\n", i)
                     }
@@ -420,7 +420,8 @@ impl<'a> AllocationView<'a> {
     }
 
     fn cleanup_object(&self, index_offset: usize) -> Result {
-        let offset = self.alloc.read(index_offset)?;
+        let offset = self.alloc.read::<u64>(index_offset)?;
+        let offset: usize = offset.try_into().map_err(|_| EINVAL)?;
         let header = self.read::<BinderObjectHeader>(offset)?;
         match header.type_ {
             BINDER_TYPE_WEAK_BINDER | BINDER_TYPE_BINDER => {


