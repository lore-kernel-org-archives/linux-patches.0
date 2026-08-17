Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949D3AEF2A;
	Mon, 17 Aug 2026 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974679; cv=none; b=pFlVm2ir40fI5iAlpB0PEfY49xaGO6/vJkg/6QALAiLIFmnph+R4grwOW/WJ3BS7XB9U0Z1VJ44KDoszAv8h6+HnmyxJDfz0eVRwL5cbV1/seehfYw0wsiTsfvwx69Fe1fctKOyg8hG1aLxG1GO77/JnjLZziKzXa8+rKot2xqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974679; c=relaxed/simple;
	bh=Jb/XXMmKPL1ZGEB4RH7EMCX6qbluf2znM0zkI6WkA6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgt1OgL8gViQmRMYLJcyCYoT/3v8nmMAlfjmR6DrJfKhcKxh7MDBSjju50L4fq4777DwDa4/AM1EKncAzhIttUnI6YUwm9z7TAtuSOolhrcpn3ilSVypAJrCW5F6GYV+aQpCD92n5PpmiPZQi3MLkTcXC66NCYFp8J+KufSdadk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+fRAPX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+fRAPX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3131F00A3A;
	Mon, 17 Aug 2026 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974672;
	bh=u6u1IBD9ydDiWGxO2Z4kNV549t6Nnnq5+ATsQcj75OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+fRAPX42XGjB6S90Rxb75gbhcUfUrPaJUFvopY6YEKmsLvY378GkLgwSVY4oHgcW
	 /CukCxAUIn01/WVk0aCWKHPXWbE74zNiWmIufEhoyO/9CkiCTOcAV9s79jBN/FX2vb
	 t9D9u1V1/hRTmvQW+8S3LaAYzcWK89uEhS2RTHc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/250] xfs: handle NULL b_addr in xfs_buf_free
Date: Mon, 17 Aug 2026 15:29:36 +0200
Message-ID: <20260817132537.079003746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit d852729c5f4f830fbe7413df032e29459b3daf83 ]

When xfs_buf_alloc_backing_mem() fails, xfs_buf_free() is called with
bp->b_addr still NULL.  The code falls through to the folio_put path
which calls virt_to_folio(NULL), dereferencing an invalid address and
causing a kernel crash.

 Call Trace:
  xfs_buf_free+0x25f/0x510
  xfs_buf_alloc+0xc98/0x19b0
  xfs_buf_find_insert+0x55/0x14d0
  xfs_buf_get_map+0x122b/0x17c0
  xfbtree_init_leaf_block+0x11c/0x4a0
  xfbtree_init+0x1bb/0x460
  xrep_rmap_setup_scan+0x100/0x1f0
  xrep_rmapbt+0x41/0xc0

Fix this by skipping folio_put() when bp->b_addr is NULL.

Fixes: 5076a6040ca1 ("xfs: support in-memory buffer cache targets")
Reported-by: syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94c22d92f72f5a235b7d
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1ca95ef46a73d..441631c736c1c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -117,7 +117,7 @@ xfs_buf_free(
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
-	else
+	else if (bp->b_addr)
 		folio_put(virt_to_folio(bp->b_addr));
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
-- 
2.53.0



