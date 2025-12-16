Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52FC352F9A;
	Tue, 16 Dec 2025 12:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886468; cv=none; b=BQAwlWb5/R80lbm6wJwI6KtRGx2nOJE/hl/cym1f0d6E6tTauSzfnDyyUTJ5yzjkG4mZtAxOGhTT+DeZlFLPrmH/dM3q6nAl/JIpxcJlZpNmcsU1CTuI7DMFrpHoMuCs0ih0Jj8MUlCQVOkThDwp9o9gDKTFwT/PUZHVyPdxICM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886468; c=relaxed/simple;
	bh=2+LRic2uUhPVAuo928Bj32wWXf/ZmrX6uY4ShFFXP+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma7vcLGVaIOiiFIWLA/KCpeH4G6du7OV7KJV5yVHshSJikJfW/8tmFxcJUXJRgTnOnRt6bkmAII9owP5ZqNtslqz6VQYQQi7t2chcKQY+jsMfI7/EIeW9468+BmQofceuysr5wseSwgD+87Kum9tKnyuv6RfhAavpToSslTyysM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV/XCYau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV/XCYau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1691EC4CEF1;
	Tue, 16 Dec 2025 12:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886468;
	bh=2+LRic2uUhPVAuo928Bj32wWXf/ZmrX6uY4ShFFXP+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZV/XCYauLjtnXtiNP+RI+O71aESDsL5ZcApicMcfevV902RjYq+w789bc083kMHvv
	 Su7LbwbcDi6UsVi1EZH4DLcMrrn0LpoSgq9Iw36aUA3RYYusG4EFdngakPGguaqVTu
	 TV3z0+c8W6j6sC5nPo1cuKzIqx11kMSgOWHUJj/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 445/507] NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_invalid
Date: Tue, 16 Dec 2025 12:14:46 +0100
Message-ID: <20251216111401.576941568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a3135b5af7eec..7ce2e840217cf 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -464,6 +464,7 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 	struct pnfs_layout_segment *lseg, *next;
 
 	set_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags);
+	clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(lo->plh_inode)->flags);
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list)
 		pnfs_clear_lseg_state(lseg, lseg_list);
 	pnfs_clear_layoutreturn_info(lo);
-- 
2.51.0



