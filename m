Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C5C33097;
	Tue, 23 Jan 2024 00:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969648; cv=none; b=eBlI/Xb6A6ll7Mrc5Bv+n+6ymqnURK0x6FScCS6wrD9MK8UewmipCDbWA9QTNvkGuIh+VJJx7sGRkzBStJfDhOt+M7gsQf66HEIXmXl+CK1vX9RMKE2+gpyinPj3ZrW+Kqc0rQmWi0d0v1eRPGUr86TfTnyixCQ0VXccAOJSp8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969648; c=relaxed/simple;
	bh=caD1ugqz5KYX3v+Ki7zLPscwtL9dJ4kF/zAeXa4UYgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKhfsGo+DRibjh4f0sbAvcnI2WolEZ0S8kDvbZqoxXBbXvGrZOelW2t2nv21Vb4gPkoamTvTkiHnXkOhdLV5JMWDXJGbGM8NmYKCco9qxNuvQYTaaQG3p6HkWdjphuVv4BFBFupZG1rg+AWEXe59wQGfPHi6uFVGk0gjS66rk8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsayEKVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsayEKVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53974C433F1;
	Tue, 23 Jan 2024 00:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969647;
	bh=caD1ugqz5KYX3v+Ki7zLPscwtL9dJ4kF/zAeXa4UYgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsayEKVfB8Mm4kNZ66AQs8h7FaApxq2rrSzfocuPcoygO2bZ9An9rqXrPFcpQFs9X
	 F7n0gG8nx0byV2nFZrkeVdWYbiYY112soTjWfe4UMBciJYFCs/4FKaEgPYcEz3vn2C
	 LfKHDLzyu1BOB3o49fatn3q9sUOvNF6XdNBK8d9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.7 381/641] binder: fix async space check for 0-sized buffers
Date: Mon, 22 Jan 2024 15:54:45 -0800
Message-ID: <20240122235829.882700601@linuxfoundation.org>
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

commit 3091c21d3e9322428691ce0b7a0cfa9c0b239eeb upstream.

Move the padding of 0-sized buffers to an earlier stage to account for
this round up during the alloc->free_async_space check.

Fixes: 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-5-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -407,6 +407,10 @@ static struct binder_buffer *binder_allo
 				alloc->pid, extra_buffers_size);
 		return ERR_PTR(-EINVAL);
 	}
+
+	/* Pad 0-size buffers so they get assigned unique addresses */
+	size = max(size, sizeof(void *));
+
 	if (is_async &&
 	    alloc->free_async_space < size + sizeof(struct binder_buffer)) {
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
@@ -415,9 +419,6 @@ static struct binder_buffer *binder_allo
 		return ERR_PTR(-ENOSPC);
 	}
 
-	/* Pad 0-size buffers so they get assigned unique addresses */
-	size = max(size, sizeof(void *));
-
 	while (n) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
 		BUG_ON(!buffer->free);


