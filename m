Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4204E12DDAE;
	Tue, 23 Jan 2024 00:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968981; cv=none; b=LWk6a7hOVF0IXYZ69WcdKxR6F6LOhbULzNzgZYLXVnl/pjbrvd4ehGSaHcmS8IA4FVy6Smxllo3aHkDBnpBV9cPzQzM+ABg/9TEOVX28xhveQH1+U653UZyY1sRILf9k6A9TezvBZ+J4R/b3xHS14gB47az0/Z8B/5lIlvHfSlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968981; c=relaxed/simple;
	bh=K15wfyEPYY+0HVriZFqkaYvsHNBcEqD5r64cCV6fbjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yyi5CLepVFwvQJRDHbmolzUrAOi3aFdh/2xNvGJXnY0UobabSXvsW2M0dBDZALyTEMpVbc9Il50SdvBL71wTn3NU+ji1VGFmLhWPyW0cYrHxCZK9HV8G9gfChXwlhSgl5hnWMIezqzT7Lc1srqSYj9rEKHHLKg32EJil4kIEBdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmMiC2nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmMiC2nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBADC433F1;
	Tue, 23 Jan 2024 00:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968981;
	bh=K15wfyEPYY+0HVriZFqkaYvsHNBcEqD5r64cCV6fbjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmMiC2nYP6u17uOmc9jP1iKibkDV8fiayRH3uDP/iu0QzFgW6i2K/Fh+55rNb5lJc
	 V+adZVRCC8CsvsSM8S7EbUWvKkENxscER8d77Cd0ICvjvWyeRPADcwscGBBT3EQg83
	 Fd4tACMtZMIHt7DLXlcIB8Z7JTOy/r2cOoF/Ac84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 139/194] binder: fix async space check for 0-sized buffers
Date: Mon, 22 Jan 2024 15:57:49 -0800
Message-ID: <20240122235725.197611649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -378,6 +378,10 @@ static struct binder_buffer *binder_allo
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
@@ -386,9 +390,6 @@ static struct binder_buffer *binder_allo
 		return ERR_PTR(-ENOSPC);
 	}
 
-	/* Pad 0-size buffers so they get assigned unique addresses */
-	size = max(size, sizeof(void *));
-
 	while (n) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
 		BUG_ON(!buffer->free);


