Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07048604AA;
	Tue, 23 Jan 2024 01:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974677; cv=none; b=sxe6mCTOvxCPZ/T4PY3y5wlmAzu2Olb72CccLPs+DTmOxD8QlZsJXda+tlBfUyYXX/P5n7VCwW57Ld5/RP5UMm7GwUn531vNvPa8XhnLuY0RriCtNvr3Pg2dKcZind7w4UEswKotE7Z576wYBJyagcR0R7s3G9kLRUNLJEF7E74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974677; c=relaxed/simple;
	bh=9kkv2p362I5Sg6MT8qi44AlzsAIH8dvrZTXoQBskAuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnmRXbZkGxyScV9QFYODiVSlciHV6Ja/rQQQdmG89udLgX68a5dzZ2odtvPFuvxHlwECUNSGMpymakoky4cc6QL4ExZlbwbNtueoaWd+ZvMATH4ZdFVnwWCRIdz0xm3NAfCXykspYoNptezR7GJm3DJL57P5DTDXOFKr8TdP3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+FFawOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+FFawOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D45C433C7;
	Tue, 23 Jan 2024 01:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974676;
	bh=9kkv2p362I5Sg6MT8qi44AlzsAIH8dvrZTXoQBskAuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+FFawOZPTvEF0KimOEd3Pw9eSyTo22GW12W6dhSs4IIHtA27KLTA9J2mBuuTQwPz
	 7GSsgkSF51gnYVJcoC4H3cHnVbFQbRSeER2hucIhdayfNobrYmv+3cIi8h4fGORNml
	 jJHzgRlBwrB8VASn9wE6CYIew70vk3Hq/IU6cXyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 245/374] binder: fix async space check for 0-sized buffers
Date: Mon, 22 Jan 2024 15:58:21 -0800
Message-ID: <20240122235753.287317475@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


