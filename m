Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D41DFE27;
	Wed,  6 Nov 2024 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895827; cv=none; b=BFwz9t+J6Szb7KmZRT29VgtvYomWQTbDHiRSRh/cpb6KC7g6wKWmmIh/SCu56gr1dFgxNVToK5JFddfmzzJoXfsArBtcZzZfk4m08hjeYVPs8Q0KmhQWjGS1w9cacbfLriM2SIqUEm7LIZUq1UluuBAXGnU1ReatVze5PeB0BL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895827; c=relaxed/simple;
	bh=cpLgVAzoVhe9Gk6/uWnMI/sBHkhBLn8AbpHbgXH7ncc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEKIfRr/0JsiDHabwMSh8jJFAaWhpAzWVbDtqnp1jIYRApsNctj3RV13w1gMpv0VLlAXun/4UvWiMNG809sNpIr/IxMXVNix5TvAH3IqP5F5L/PoO6IUAqW8KpM3lfkAR+iP07qEfOOUgxgW17yfMySqPTA149pLbWn/V+yGVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0Uh091i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0Uh091i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C95CC4CECD;
	Wed,  6 Nov 2024 12:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895826;
	bh=cpLgVAzoVhe9Gk6/uWnMI/sBHkhBLn8AbpHbgXH7ncc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0Uh091i5PLhsCfrDwHyi3PMs0eNR4gwV6SdNc9SgZ0f6OrPu5f8Vu8+XjqYCJ/wN
	 wU7csgvIdP9Ft1L2M5VlvY+fCr7hRiJVBs8ETbc21zOWYCmeHUXpVtqk6TJ7xnkWUo
	 7bKZEcBPmZK3gTAAai6bujTLYBtSUWnyeY884jpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 348/350] nilfs2: fix kernel bug due to missing clearing of checked flag
Date: Wed,  6 Nov 2024 13:04:36 +0100
Message-ID: <20241106120329.276396047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 41e192ad2779cae0102879612dfe46726e4396aa upstream.

Syzbot reported that in directory operations after nilfs2 detects
filesystem corruption and degrades to read-only,
__block_write_begin_int(), which is called to prepare block writes, may
fail the BUG_ON check for accesses exceeding the folio/page size,
triggering a kernel bug.

This was found to be because the "checked" flag of a page/folio was not
cleared when it was discarded by nilfs2's own routine, which causes the
sanity check of directory entries to be skipped when the directory
page/folio is reloaded.  So, fix that.

This was necessary when the use of nilfs2's own page discard routine was
applied to more than just metadata files.

Link: https://lkml.kernel.org/r/20241017193359.5051-1-konishi.ryusuke@gmail.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6ca2daf692c7a82f959
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/page.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -407,6 +407,7 @@ void nilfs_clear_dirty_page(struct page
 
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
+	ClearPageChecked(page);
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;


