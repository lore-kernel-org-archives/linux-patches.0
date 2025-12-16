Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F44358D27;
	Tue, 16 Dec 2025 12:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888475; cv=none; b=mjzY8B0j6LGknR1Byg67xwNObaxtIHu5indRaUL2GzsM6Zh59KLgVMGE8gku6yQo1iGsyYtK4gKYZERMZ5Zo/gTd8qoSlWRSvrgkGloqOoctGcszhXWp/ANy1M9eqFPcNzkrxqGgdogl40jsIkEUtZxpkzzUtkEo/yEgO67BHmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888475; c=relaxed/simple;
	bh=rWqH1bnjbUqPDLluTzVmXWbthumyKSL4DhJEX528tZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIQyAjIM3tb3whhn6ibYLsSaFzeHwr9ewcxWhqXsIMtSDgdNrQzcZPb94fkdy69X4yp4Thgz24K/75L0s0IgudFXMyETHV2jANu/nNBdEaXS1bM6K+WUO/RlaBzybEYUsJXqKt5O3mTo/wgOhasiVhqnO36UML4DW5h20KUUlaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFUTh/Mi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFUTh/Mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332D0C4CEF1;
	Tue, 16 Dec 2025 12:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888475;
	bh=rWqH1bnjbUqPDLluTzVmXWbthumyKSL4DhJEX528tZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFUTh/Miyp7e6QhX7EkquB7hZjLynutepiFqZpBa0ngk+4vJaTA83HkSj9yKrIkIl
	 4ECcx+YJX4KVph0KNE19ePP5PVK8TTi/ufvvCdQKU62bGQX78R2lA5xvWPQF2cFIKE
	 VtiP08teJmMPk+H7CjjOcDLtWS/Y9P0LNKC94YiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 545/614] NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_invalid
Date: Tue, 16 Dec 2025 12:15:12 +0100
Message-ID: <20251216111421.126609590@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



