Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6366FB3;
	Tue, 23 Jan 2024 00:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968449; cv=none; b=qMdwFJyrDT09UK0CddW3vHl492lXm9b4LWw/xqIYCeTxssb8kdvMCMj5bd530QT/8R6zpjt2tth06WiAxhW2TbQKchvjs0shqraEs92L7cPhIgGVTr4soVP16XM6wz2bsX44B1/djVOXyNUp4uvPIq/UDpc1eMpa7xsit2dPdPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968449; c=relaxed/simple;
	bh=CCnLPpGWJO411wsaZLSP+I3V9NJgcJD0LTaG8vObqNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkm7Jw+52Tosog87OkBdJnvlCI3p8TtKRXIcqCIqR4SDK80nhpCU2t01xqgM/zSxm+/dgaNmsm7z2l2HrUQ0zKiwvwZYbSXmytO6LOnSnj+ILQNxku4tf2VD4GUqLCgIw74cj9+z6hjroJl6o6Ymn78ZJWvJVaH6hdpk39ULOmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxHnns86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxHnns86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30041C433C7;
	Tue, 23 Jan 2024 00:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968448;
	bh=CCnLPpGWJO411wsaZLSP+I3V9NJgcJD0LTaG8vObqNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxHnns86J8pNvufGgcD01nrh9HMp5/i/pa9Vz7MqJWyRpf2EX+IDJfZ9ma5n1gqca
	 lEMaPD/Lci3dJG+5oUSdKnUu/dwLp25i/izymw6Jj+8I8vmhQG7zj5KH/cf1zIDL0l
	 2zdk5rndAVbhB2JMo+CPkk/BVYfj8BrIBmVjfCLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 4.19 112/148] binder: fix async space check for 0-sized buffers
Date: Mon, 22 Jan 2024 15:57:48 -0800
Message-ID: <20240122235716.992236739@linuxfoundation.org>
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
@@ -398,6 +398,10 @@ static struct binder_buffer *binder_allo
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
@@ -406,9 +410,6 @@ static struct binder_buffer *binder_allo
 		return ERR_PTR(-ENOSPC);
 	}
 
-	/* Pad 0-size buffers so they get assigned unique addresses */
-	size = max(size, sizeof(void *));
-
 	while (n) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
 		BUG_ON(!buffer->free);


