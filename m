Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDFC3F23DD;
	Tue, 17 Mar 2026 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766774; cv=none; b=DExKcoD64D6EkEOTRm3AZzIZNFDtNneIUYaUrQtQPn2LHsIKxwQg9nJUNyoY1FxhgyqmKNQY/KUEB+87BKLjSW1puzREn84E24rgNXHkbOGUNMHhif3mdeqboZlQViCyhuJFbkZ5PkXpPo1eq9BYIxxudPtQ6cM7a0b7rXab+DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766774; c=relaxed/simple;
	bh=g2z9iGDrT+oXJ2lJlJs9DXUv9z5c0kYfj5teWWOCAZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvGDzeWlVBK/sZQKt3ktUv5Nbz2AF3FNEGxfROLTH4VfX6DmTwgOm4OIoljHTg6sRzduByXTwu3wOUPy8oa0fFCP0z8123593TD69wEPrfSFcp9GkV4CBewrp5jY8ZdHPUhFt8UM9cBsV7eLVCYz+A/g1ERolth3MpMvml5H91k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSgJK/GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSgJK/GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068B2C4CEF7;
	Tue, 17 Mar 2026 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766774;
	bh=g2z9iGDrT+oXJ2lJlJs9DXUv9z5c0kYfj5teWWOCAZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSgJK/GNz9bCkEXvfE/pIcZQ3XdAykakmJD6E9vZDqUgRS2KuBtnWfX6qqK2Mjt9y
	 M7F1NzIBt7RQoV25lyc9jC+nlB0dYHB+RVVgrAERcXzn433NUXREyZbSj3TmsakD81
	 paeuZwy2PcdHqZqLJ0pm7G815f5TvXq5Y4N1V71w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.19 319/378] xfs: fix integer overflow in bmap intent sort comparator
Date: Tue, 17 Mar 2026 17:34:36 +0100
Message-ID: <20260317163018.725991316@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

commit 362c490980867930a098b99f421268fbd7ca05fd upstream.

xfs_bmap_update_diff_items() sorts bmap intents by inode number using
a subtraction of two xfs_ino_t (uint64_t) values, with the result
truncated to int. This is incorrect when two inode numbers differ by
more than INT_MAX (2^31 - 1), which is entirely possible on large XFS
filesystems.

Fix this by replacing the subtraction with cmp_int().

Cc: <stable@vger.kernel.org> # v4.9
Fixes: 9f3afb57d5f1 ("xfs: implement deferred bmbt map/unmap operations")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -247,7 +247,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
 }
 
 /* Log bmap updates in the intent item. */


