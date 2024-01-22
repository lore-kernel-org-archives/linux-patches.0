Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7552D50272;
	Tue, 23 Jan 2024 00:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968468; cv=none; b=U0tTk79GElahI8Mxoe3SFaqkFJY2qdWfrYhMYq4w1BAM1yyDyznXTB2mkwBo7ww11ZtTSeXaELtB5rjl8qywC6v2pAo+yKpRt6XajRHfnJDqaTcbD81W/el8/c5kB5GReF/MnlFxZiEKr2nG5xwKmygJTpASnhkMK0YPJ7Kcv6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968468; c=relaxed/simple;
	bh=cd2EK8m4eL6DuwogKp1HwC0fDDWtBeCu0pQ4MquQ53Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLK2bfv1sXW9oyG9l0zdq3ol2rx7ng7guMwWxBN44sXKO7uG/vLqCyF671ddR2Z/yrpx7BmRCsDeoO2jXx3kGm+gZ/s3ss1QTfe67SL5WX2H0c4thmwjxPd8yH0Q8tICmPfVGW4s/bxAulIfx0JnT7daV3HwtMClU+2xJzDns2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoK3v7Lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoK3v7Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4E3C433C7;
	Tue, 23 Jan 2024 00:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968468;
	bh=cd2EK8m4eL6DuwogKp1HwC0fDDWtBeCu0pQ4MquQ53Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoK3v7LfOrjzTLO71Jej8/D39K58VS33ddmXch1azhT3Xms4dIE13hHHtCnGosP19
	 typjOgSaJo8x+CtDuwMJZ7F3rjkhe1d/sc/H5P4RLK/LrXdfB4PQ6tTyUQjh1Jywp+
	 UyukKXiR2INr76/5AO5D6FkVFFDzNKwnCqA1F5iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 4.19 117/148] binder: fix unused alloc->free_async_space
Date: Mon, 22 Jan 2024 15:57:53 -0800
Message-ID: <20240122235717.219703943@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
[cmllamas: fix trivial conflict with missing 261e7818f06e.]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -402,8 +402,7 @@ static struct binder_buffer *binder_allo
 	/* Pad 0-size buffers so they get assigned unique addresses */
 	size = max(size, sizeof(void *));
 
-	if (is_async &&
-	    alloc->free_async_space < size + sizeof(struct binder_buffer)) {
+	if (is_async && alloc->free_async_space < size) {
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
 			     "%d: binder_alloc_buf size %zd failed, no async space left\n",
 			      alloc->pid, size);
@@ -509,7 +508,7 @@ static struct binder_buffer *binder_allo
 	buffer->async_transaction = is_async;
 	buffer->extra_buffers_size = extra_buffers_size;
 	if (is_async) {
-		alloc->free_async_space -= size + sizeof(struct binder_buffer);
+		alloc->free_async_space -= size;
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_alloc_buf size %zd async free %zd\n",
 			      alloc->pid, size, alloc->free_async_space);
@@ -631,8 +630,7 @@ static void binder_free_buf_locked(struc
 	BUG_ON(buffer->data > alloc->buffer + alloc->buffer_size);
 
 	if (buffer->async_transaction) {
-		alloc->free_async_space += buffer_size + sizeof(struct binder_buffer);
-
+		alloc->free_async_space += buffer_size;
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_free_buf size %zd async free %zd\n",
 			      alloc->pid, size, alloc->free_async_space);


