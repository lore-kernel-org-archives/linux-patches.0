Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1433097;
	Tue, 23 Jan 2024 00:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969649; cv=none; b=HGk43lzGL/09RMBluF/M3yH/oNViIxlU4JdFCkq0fBlfMjxdRYYL+YnTGZQHaOavU6brU2PDJNFIHUHxq07MVfBAEy2o4ZjtsfwEOp+a0jneWTVZCJ3+P4vF5aTaCzXWgbJnWO5y8Qt4Uiv5M5zXrcX55EetnzHAWUCPmKKg3O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969649; c=relaxed/simple;
	bh=wgn140Goj3vjQqW7jIw9cKkGWzJBaSc4CORzPeCpZlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFgyJHlhwdmH5YwvD5+V26SrgLLByMiZXqhZVF8WF78cizutJWzcVH5QRI04MCngH+ZxtelwHg/QpGsck622YvE4gpwmFeSb+0fvjblea/OJUPAf3ukG9KKT5F0yzK87IS+ie0rOH8KfO0YXgJyXzQp3p4aVQBvoQdEziyzNTkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBpl46LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBpl46LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEB2C43390;
	Tue, 23 Jan 2024 00:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969649;
	bh=wgn140Goj3vjQqW7jIw9cKkGWzJBaSc4CORzPeCpZlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBpl46LAVNowjwbRTIaST+Gsx73EOMvqVD6xuydEZtN/sQj5wpCtAjLrgN6nkhnUV
	 qUk5H7SMnPtvbnyLpOD9+xJJ/5J3h9tJ/lLsYvnWUkpXghbWuinQwMrPizNWklZGU9
	 dhgRosPH3M2CPO30dR/5gHUTEyJ5192/av5s+IKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.7 382/641] binder: fix unused alloc->free_async_space
Date: Mon, 22 Jan 2024 15:54:46 -0800
Message-ID: <20240122235829.911526574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit c6d05e0762ab276102246d24affd1e116a46aa0c upstream.

Each transaction is associated with a 'struct binder_buffer' that stores
the metadata about its buffer area. Since commit 74310e06be4d ("android:
binder: Move buffer out of area shared with user space") this struct is
no longer embedded within the buffer itself but is instead allocated on
the heap to prevent userspace access to this driver-exclusive info.

Unfortunately, the space of this struct is still being accounted for in
the total buffer size calculation, specifically for async transactions.
This results in an additional 104 bytes added to every async buffer
request, and this area is never used.

This wasted space can be substantial. If we consider the maximum mmap
buffer space of SZ_4M, the driver will reserve half of it for async
transactions, or 0x200000. This area should, in theory, accommodate up
to 262,144 buffers of the minimum 8-byte size. However, after adding
the extra 'sizeof(struct binder_buffer)', the total number of buffers
drops to only 18,724, which is a sad 7.14% of the actual capacity.

This patch fixes the buffer size calculation to enable the utilization
of the entire async buffer space. This is expected to reduce the number
of -ENOSPC errors that are seen on the field.

Fixes: 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-6-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -344,8 +344,7 @@ static bool debug_low_async_space_locked
 			continue;
 		if (!buffer->async_transaction)
 			continue;
-		total_alloc_size += binder_alloc_buffer_size(alloc, buffer)
-			+ sizeof(struct binder_buffer);
+		total_alloc_size += binder_alloc_buffer_size(alloc, buffer);
 		num_buffers++;
 	}
 
@@ -411,8 +410,7 @@ static struct binder_buffer *binder_allo
 	/* Pad 0-size buffers so they get assigned unique addresses */
 	size = max(size, sizeof(void *));
 
-	if (is_async &&
-	    alloc->free_async_space < size + sizeof(struct binder_buffer)) {
+	if (is_async && alloc->free_async_space < size) {
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
 			     "%d: binder_alloc_buf size %zd failed, no async space left\n",
 			      alloc->pid, size);
@@ -520,7 +518,7 @@ static struct binder_buffer *binder_allo
 	buffer->pid = pid;
 	buffer->oneway_spam_suspect = false;
 	if (is_async) {
-		alloc->free_async_space -= size + sizeof(struct binder_buffer);
+		alloc->free_async_space -= size;
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_alloc_buf size %zd async free %zd\n",
 			      alloc->pid, size, alloc->free_async_space);
@@ -658,8 +656,7 @@ static void binder_free_buf_locked(struc
 	BUG_ON(buffer->user_data > alloc->buffer + alloc->buffer_size);
 
 	if (buffer->async_transaction) {
-		alloc->free_async_space += buffer_size + sizeof(struct binder_buffer);
-
+		alloc->free_async_space += buffer_size;
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_free_buf size %zd async free %zd\n",
 			      alloc->pid, size, alloc->free_async_space);


