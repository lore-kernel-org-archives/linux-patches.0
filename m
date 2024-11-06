Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177961EF08E;
	Wed,  6 Nov 2024 12:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897289; cv=none; b=EaYLo+q9J87hHFDjBPKcXeZgBtSmBEFK80uRdXpZsSw6juhuomFkLjWH3Gs1bo/fsZ5J2AtGvKbDeBg2ZOy6gjpkbxfserUsG/xzcXLZ4yxIVnJfND82wLUqVl3Qewnrvxteq89aSDxnwai7bAdgcXNpTgvNcHTFqXE0VF/BvVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897289; c=relaxed/simple;
	bh=FA3hKEGDHm2bQZVkqlzigMcrEB55zYHm8EKkiJsRbrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6iDSXSDj4fHCqfGhSdGHRw9qIY5AlWbKgrZ5d49LRj9ZLoXkQU4XvYlpVMA2jio5GwOZzO2r+E4l7s5T9UVbb7aH0a7sOrn47upST8pua+aE3PCmb5JJk5SWRYbmEaxA5Duc4ph2HPufU5T3cCnQm3mD3iJ2YmZGANM379ReYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAhui8Fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAhui8Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95535C4CED3;
	Wed,  6 Nov 2024 12:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897289;
	bh=FA3hKEGDHm2bQZVkqlzigMcrEB55zYHm8EKkiJsRbrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAhui8Fkl26UC8inedAXXn3gFJG/x2dLB4q2lXTYy3ToNhuiCswxA+mjjtmQzF3dx
	 ZVVFyQEJICIT+O8d2e9IqRfAGXonUT/iiO4GpAuWtQ4pu5qdulO1u7C4MywFJmF5/w
	 3jhVyWJ3eyxC/K9WlkCVtMJqLBuCJC4rt6QZr7j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 117/126] nilfs2: fix kernel bug due to missing clearing of checked flag
Date: Wed,  6 Nov 2024 13:05:18 +0100
Message-ID: <20241106120309.220148767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -404,6 +404,7 @@ void nilfs_clear_dirty_page(struct page
 
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
+	ClearPageChecked(page);
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;


