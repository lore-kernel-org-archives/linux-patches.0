Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141391DF278;
	Wed,  6 Nov 2024 13:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899301; cv=none; b=WvGPSxfXEVwtQpXi67blcXY5FMf11Mvil8sJdZYhzXquokXmoESFM3Dk60/bixN6bCsPiBKk7jNklGwjSY2GShclbHoBjvwSuCsm3qcYSCRiRaO94LGhezQ5YAr/8V4B4HhpYczw+42NWPk80Uj7PBA/WDpkB/cHub+CgevjGuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899301; c=relaxed/simple;
	bh=deM71lB36opPSANcMgGVD8D9/m4QSNdDi3fFthqQ8ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0HN+cyGiDX9Xvqq0tIoLhUotEV0u630OC+ldlLg/mKLDzBIn/FK6hzDY6aaVyVFJQxQ/jfO6M8/Z3vb5T90pQyTfpNefrH589YjfNYXyg7dgMD9jfvnwPsEC9OAqKpLov1MWiz0ynw1SicFQ+cPA2/03I+FJTEAHxRkKikECcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AB1DhQxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AB1DhQxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85991C4CED6;
	Wed,  6 Nov 2024 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899300;
	bh=deM71lB36opPSANcMgGVD8D9/m4QSNdDi3fFthqQ8ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AB1DhQxKqZrK3t7X2CHqSM/y2pSs7Lr3ddR7/Ym33f+cpIXA0hkHYKnV7N5Ofisfg
	 633kI6YkLtv0V877DbjXqcG1kpsAC1l3bJAgpHwWP08WOx6Hq2qQCIeQUEGDCM/BV5
	 bPYZEsJlj/vHq2gqwYT1dYdktICXfkjh6pe3yC54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 67/73] nilfs2: fix kernel bug due to missing clearing of checked flag
Date: Wed,  6 Nov 2024 13:06:11 +0100
Message-ID: <20241106120301.949056393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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


