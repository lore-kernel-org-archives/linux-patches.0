Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6046853A7;
	Fri,  6 Dec 2024 15:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498211; cv=none; b=hN/yVGyj6MedzMcDmvIiP5rxCEOvCJ2uzWYT3MhttUkSm5zzscaN/4P9xoNxwPrcGr3DcztVghHjGM2YCq5po3tKZAxDNVvVqWk332U2aV4QO4v055VzBdF0q9KknsjzP//VsYVAOYS2LYxI2g4IIlOc4W5sV1ev8ewd3GONp4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498211; c=relaxed/simple;
	bh=TxOiPWUvAJQWmbwh759B/+xzRxyrsXHzj5RbTq+ZqvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8Zc/W54slHaiY3wittDFBCQv4LMMEOYXX2eiEaFjM0+SyjEctvMziaKwE/l48fCSeXzJmU6o4KYmF1KSbdUXoqIE8impJx+TlHgZewdkgG6+5u71W9q+XwvX4ErtuzvlQ8QQ8LZanmKA4k7zu7Vy5VvVGIvWOl4ZjsTsmYhwxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGb6iWZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGb6iWZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CAFC4CED1;
	Fri,  6 Dec 2024 15:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498211;
	bh=TxOiPWUvAJQWmbwh759B/+xzRxyrsXHzj5RbTq+ZqvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGb6iWZIXJxbFlBArmAbFhH1cJK0JmdHRLDEQhu775NF/zRRvv3Ixw850E4cKxIfD
	 wi23BVHC81X/UaL/WZnO5JqgmsAaP6biit+CUA9cheQuP62FHZ1lsCevQK2F65koIq
	 tEBVXniEb6vKnWXXFLCaI4MlnxPkN6Cvv8BS/4dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 486/676] comedi: Flush partial mappings in error case
Date: Fri,  6 Dec 2024 15:35:05 +0100
Message-ID: <20241206143712.345255444@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit ce8f9fb651fac95dd41f69afe54d935420b945bd upstream.

If some remap_pfn_range() calls succeeded before one failed, we still have
buffer pages mapped into the userspace page tables when we drop the buffer
reference with comedi_buf_map_put(bm). The userspace mappings are only
cleaned up later in the mmap error path.

Fix it by explicitly flushing all mappings in our VMA on the error path.

See commit 79a61cc3fc04 ("mm: avoid leaving partial pfn mappings around in
error case").

Cc: stable@vger.kernel.org
Fixes: ed9eccbe8970 ("Staging: add comedi core")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20241017-comedi-tlb-v3-1-16b82f9372ce@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -2407,6 +2407,18 @@ static int comedi_mmap(struct file *file
 
 			start += PAGE_SIZE;
 		}
+
+#ifdef CONFIG_MMU
+		/*
+		 * Leaving behind a partial mapping of a buffer we're about to
+		 * drop is unsafe, see remap_pfn_range_notrack().
+		 * We need to zap the range here ourselves instead of relying
+		 * on the automatic zapping in remap_pfn_range() because we call
+		 * remap_pfn_range() in a loop.
+		 */
+		if (retval)
+			zap_vma_ptes(vma, vma->vm_start, size);
+#endif
 	}
 
 	if (retval == 0) {


