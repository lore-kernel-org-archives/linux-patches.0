Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7928F6A354;
	Tue, 23 Jan 2024 02:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975385; cv=none; b=g4zM+OZhQ7vVTd9K+UkWSVY9h/UxI7akDLiTI+R92RCM41n1PQIDoCNNw8xoiu6Kc/A2yD6MEWOa0GMMVWR8uaAJdX/zavJ2Am+ekRVpp92DseEztDjfLa+zg8PwhaHGEysmPC64e0eaxTMYdGupjQ3i4vcuvoqAcBmBJ6xhdPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975385; c=relaxed/simple;
	bh=pw41zEtSEEZULeQUDgzspkVp6S9RbozzGVDAdBGFo1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZCfPHWX2vRcUTZm7BhhlfoMLZ0yomTIXOf7bco8T3keB6etaGzM4ueHmAQJ8uxXaXbY8A6lP6UytcxUpT/XWK1zFT2Z6JJyR7N41imtN/l/sl7DptsTqxSjAG9xctISw9fVF4qR6fd+yg3f0bJPn9IWvk8Q5DiE8uZ7JFXrIOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBQGmOiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBQGmOiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6C0C43390;
	Tue, 23 Jan 2024 02:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975385;
	bh=pw41zEtSEEZULeQUDgzspkVp6S9RbozzGVDAdBGFo1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBQGmOiADiFMaQvTEkyNm2ptZPwj0OEx53c6MHGt4uKPbnHMbQS35AdPe48ii5u01
	 36Ssz3dh3vGxpzo5hd1hqBhar52d67UZiEBnfTXfFdkKmXq/XKzHLelTan4D8u2rQx
	 e7NzZyqFCBYAzuPPSmwxSthrByTN9R+yfwriWhLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.6 346/583] binder: fix async space check for 0-sized buffers
Date: Mon, 22 Jan 2024 15:56:37 -0800
Message-ID: <20240122235822.609890187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


