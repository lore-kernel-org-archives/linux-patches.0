Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28F27F749;
	Wed,  4 Feb 2026 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216796; cv=none; b=GGdSLFboMEqEElylY2VdUknw/7dA8SE5OTJdV339068GQQqiQqXVBJ1ugKaz8efr5o4qpgtkB9YLEsYGA4cCbNlrt50bMWPrcHd5R6R9x/BQxF3zM+dgGnFN9bXOfR2kcckBvm+F9MmnVXZZIIe5/h+wajqLMs5Ds4Wi9So5VwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216796; c=relaxed/simple;
	bh=7opBluwRBChvs+/WeJH3fkQ1UoQYZD4Yvxa/taEzz5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdQ7KfLt3yyazF8VxwFM+hHlf91zzl4Ux42NWDqbOKEuvKVnmNO19ZnEnJyEWdBOIsqBNW1zc08EDpNf8dn844PJFWgJJVi35I/RZMjX1erl+0pkjau0JOg01U2HUY9eG7Juw2ZplNyySU//tZqZEow+i2Y+U94Mc5q4gqfqWlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/uwZVyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/uwZVyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729FBC4CEF7;
	Wed,  4 Feb 2026 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216795;
	bh=7opBluwRBChvs+/WeJH3fkQ1UoQYZD4Yvxa/taEzz5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/uwZVyvEGOBCEGvl605cL0jEdm6caY01RdhO/2TX7YYzp+SqxwTdcaqKQjveh8tc
	 Gb7twb84HtdQmu9G8iTzEhpdfCdCG5uc1WtpWvy8q3mfdbj1POGDgkbJbZ89RlDvnM
	 dGfnk3oQSvBtVp0/57goFW/kgJwNMb7eQ90bB8lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 034/206] ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref
Date: Wed,  4 Feb 2026 15:37:45 +0100
Message-ID: <20260204143859.437214868@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

commit d250bdf531d9cd4096fedbb9f172bb2ca660c868 upstream.

The error branch for ext4_xattr_inode_update_ref forget to release the
refcount for iloc.bh. Find this when review code.

Fixes: 57295e835408 ("ext4: guard against EA inode refcount underflow in xattr update")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20251213055706.3417529-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -984,6 +984,7 @@ static int ext4_xattr_inode_update_ref(h
 		ext4_error_inode(ea_inode, __func__, __LINE__, 0,
 			"EA inode %lu ref wraparound: ref_count=%lld ref_change=%d",
 			ea_inode->i_ino, ref_count, ref_change);
+		brelse(iloc.bh);
 		ret = -EFSCORRUPTED;
 		goto out;
 	}


