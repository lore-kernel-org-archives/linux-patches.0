Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA312DAFAA;
	Wed,  8 Apr 2026 18:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672421; cv=none; b=UGEl0WrYVJqMGCJeUrBnDFRLBOc4lhpp1BYtn4qICceBWDvaz30ozMTq67LOltdv+bd0lA5b+NQETBt/3hSNwtr0fGUBN6o3b9qDIHaGeayUgep9WcYDnfISVnYdrjQ4up/cF2VnXKNQVXotpcc56IXpSv4/Qb9ZghH5UHx1i68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672421; c=relaxed/simple;
	bh=pP1axe5F+JQfEb/FFWu4Qczr7FjZbOdkMVS3EeWkugs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpCrmCx0vl4F87my/UtfpmaBmKXWrN24ZxYVABav2D9uZKakwUpyOv+FHeIEZwY0AMThg+0rZTQ31fUMgn7aifxB8YY2TvKG9BrdgY+jQAvR1yqj8bM/32dCOhck17coGKY9mOmRhGdRL76tnrmFKDPDp8a0ohyRiw0UYXOB+go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Op2I5oy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Op2I5oy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4173EC19421;
	Wed,  8 Apr 2026 18:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672421;
	bh=pP1axe5F+JQfEb/FFWu4Qczr7FjZbOdkMVS3EeWkugs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Op2I5oy2JjfPAYAYZ+1b9FH3LkZfqaYoLtIvWzJWPhDvDGkeq1rvl7Ih/FBc2NADD
	 BdVV39juSZFJjmuBs4oJ154qlW1d2RCSU6OGz+kZz9tMj7IrV6VuWyfo4AfhnAMY2j
	 UK4veU4SZIjnIoH97zYTyWZhATXoAEEVAvj9BabY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b886a2e03529dbcef81@syzkaller.appspotmail.com,
	Denis Arefev <arefev@swemel.ru>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 299/312] erofs: Fix the slab-out-of-bounds in drop_buffers()
Date: Wed,  8 Apr 2026 20:03:36 +0200
Message-ID: <20260408175944.936467763@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Denis Arefev <arefev@swemel.ru>

commit ce529cc25b184e93397b94a8a322128fc0095cbb upstream.

This was accidentally fixed in commit ce529cc25b18, but it's not possible
to accept all the changes, due to the lack of large folios support for 
Linux 6.1 kernels, so this is only the actual bug fix that's needed.

[Background]

Syzbot reported that a KASAN slab-out-of-bounds bug was discovered in
the drop_buffers() function [1].

The root cause is that erofs_raw_access_aops does not define .release_folio
and .invalidate_folio. When using iomap-based operations, folio->private
may contain iomap-specific data rather than buffer_heads. Without special
handlers, the kernel may fall back to generic functions (such as 
drop_buffers), which incorrectly treat folio->private as a list of
buffer_head structures, leading to incorrect memory interpretation and
out-of-bounds access.

Fix this by explicitly setting .release_folio and .invalidate_folio to the
values of iomap_release_folio and iomap_invalidate_folio, respectively.

[1] https://syzkaller.appspot.com/x/report.txt?x=12e5a142580000 

Fixes: 7479c505b4ab ("fs: Convert iomap_readpage to iomap_read_folio")
Reported-by: syzbot+5b886a2e03529dbcef81@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=c6aeabd0c4ad2466f63a274faf2a123103f8fbf7
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/data.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -406,6 +406,8 @@ const struct address_space_operations er
 	.readahead = erofs_readahead,
 	.bmap = erofs_bmap,
 	.direct_IO = noop_direct_IO,
+	.release_folio = iomap_release_folio,
+	.invalidate_folio = iomap_invalidate_folio,
 };
 
 #ifdef CONFIG_FS_DAX


