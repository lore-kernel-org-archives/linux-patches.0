Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141223BF309;
	Thu, 15 Jan 2026 17:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499229; cv=none; b=cvTLrQwuTcBjoVvMzkXupagKXW0rZjxqWAl4PQaIqMB3f+G35jbJ1CuR4WiTYff5nh9AVMDH+qGyvczudywSUManS8+dwLnpz7FofXmgH1q4DJKI72+WNdPBTg9NSfkRUBa4ukIn9OAjWYqj6AE3EIUIjQI+PNGoHVdlb5cgYAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499229; c=relaxed/simple;
	bh=gy5Tf/IJ8LXgZXsf49X0ZUq20OhGRPtde5TEEvkPiRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAfFVuzK0YKRjl9laip/8K/91biAM/XnqGsHB7cBUQ3qQc3fefeMGTbL7osGkN6AExnRW/jm2Wqi5eYsZ/kukRuOVuPTj05hEzDGFKBkLX+aqqUXcN+jDJq5sOvg7PAGzctgAZSVJUANxdENrfgxPHYLH1BwQ6BD6YH4NsAqAkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJz5W0W1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJz5W0W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F314C16AAE;
	Thu, 15 Jan 2026 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499228;
	bh=gy5Tf/IJ8LXgZXsf49X0ZUq20OhGRPtde5TEEvkPiRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJz5W0W1lYL6rx7gGmmrpeEQo3UjIqSZqwK68A2qPWXvUubyyEkxaYfIxefgEEcHH
	 wB9i5BDt5CDaTWiDwhPB/3blPQvC0Pxv5tiE5zWhipMIEn9cfWhTa7ePyth7b4bG/E
	 k/xnH7CkXu/gflNRRcBerk+s3zt4m8ZTXQb0RQuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/451] NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_invalid
Date: Thu, 15 Jan 2026 17:45:27 +0100
Message-ID: <20260115164235.480027998@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Curley <jcurley@purestorage.com>

[ Upstream commit e0f8058f2cb56de0b7572f51cd563ca5debce746 ]

Fixes a crash when layout is null during this call stack:

write_inode
    -> nfs4_write_inode
        -> pnfs_layoutcommit_inode

pnfs_set_layoutcommit relies on the lseg refcount to keep the layout
around. Need to clear NFS_INO_LAYOUTCOMMIT otherwise we might attempt
to reference a null layout.

Fixes: fe1cf9469d7bc ("pNFS: Clear all layout segment state in pnfs_mark_layout_stateid_invalid")
Signed-off-by: Jonathan Curley <jcurley@purestorage.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index e14cf7140bab4..c5dd301c43d7b 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -465,6 +465,7 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 	struct pnfs_layout_segment *lseg, *next;
 
 	set_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags);
+	clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(lo->plh_inode)->flags);
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list)
 		pnfs_clear_lseg_state(lseg, lseg_list);
 	pnfs_clear_layoutreturn_info(lo);
-- 
2.51.0



