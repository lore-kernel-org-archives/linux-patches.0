Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18FE3F23C1;
	Tue, 17 Mar 2026 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765991; cv=none; b=iudsHsOakaWrYLHq0PCKhE7N9l63V42RECSW/fNMbb9eSPfxcaxqgMz177FOsIp8W/manoFpOaumPWETI78R4W9a3+hxV/h0KRXtUtGJxlJO11klOHHinmjaPZ5i0hwfIXPmcdkB9BRv3qprcOCcPzgKNHkpBHFoTL9o4qx2zZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765991; c=relaxed/simple;
	bh=nYj+2I+geqOKO/SBD7GqmqBAuypNiErzOA3kJGgw1/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqYZLrg1gJNxB0o2aA0qcLyOMvEwgGDhRSCS/eAyQHPUioUAoA3wfYXqCQ6650qgEp4XLiFRY3YckgKkI1xib6QPesPowFfSJDPP0xd/0gXxKJ5p6Eq1QzqhCehzmcgReE1nJwgkdBGziVr5CjQnrQWWCdlGhFeeiVMxnaC+Adk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pC0rkF2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pC0rkF2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2613C2BCAF;
	Tue, 17 Mar 2026 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765991;
	bh=nYj+2I+geqOKO/SBD7GqmqBAuypNiErzOA3kJGgw1/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pC0rkF2thKK4wFmOuWHdyu2P0/ZwyTbBmSwm3F2WuY6YcC96lFSfNkgK1OSUSu5/3
	 nWYfgVFdSiZHvzb+996LFZLOEjlM6lDmO32Q2U1B8uuyhTof/UbPsCrRvlJZYb/aaN
	 r5MBt3ArU9gFfGN83DY6XjiAH6vseLQRSlLAjGKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.19 128/378] rust_binder: avoid reading the written value in offsets array
Date: Tue, 17 Mar 2026 17:31:25 +0100
Message-ID: <20260317163011.724070004@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 4cb9e13fec0de7c942f5f927469beb8e48ddd20f upstream.

When sending a transaction, its offsets array is first copied into the
target proc's vma, and then the values are read back from there. This is
normally fine because the vma is a read-only mapping, so the target
process cannot change the value under us.

However, if the target process somehow gains the ability to write to its
own vma, it could change the offset before it's read back, causing the
kernel to misinterpret what the sender meant. If the sender happens to
send a payload with a specific shape, this could in the worst case lead
to the receiver being able to privilege escalate into the sender.

The intent is that gaining the ability to change the read-only vma of
your own process should not be exploitable, so remove this TOCTOU read
even though it's unexploitable without another Binder bug.

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Link: https://patch.msgid.link/20260218-binder-vma-check-v2-2-60f9d695a990@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/thread.rs |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -1018,12 +1018,9 @@ impl Thread {
 
         // Copy offsets if there are any.
         if offsets_size > 0 {
-            {
-                let mut reader =
-                    UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
-                        .reader();
-                alloc.copy_into(&mut reader, aligned_data_size, offsets_size)?;
-            }
+            let mut offsets_reader =
+                UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
+                    .reader();
 
             let offsets_start = aligned_data_size;
             let offsets_end = aligned_data_size + offsets_size;
@@ -1044,11 +1041,9 @@ impl Thread {
                 .step_by(size_of::<u64>())
                 .enumerate()
             {
-                let offset: usize = view
-                    .alloc
-                    .read::<u64>(index_offset)?
-                    .try_into()
-                    .map_err(|_| EINVAL)?;
+                let offset = offsets_reader.read::<u64>()?;
+                view.alloc.write(index_offset, &offset)?;
+                let offset: usize = offset.try_into().map_err(|_| EINVAL)?;
 
                 if offset < end_of_previous_object || !is_aligned(offset, size_of::<u32>()) {
                     pr_warn!("Got transaction with invalid offset.");


