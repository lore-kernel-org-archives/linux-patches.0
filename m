Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5478306483;
	Fri,  9 Jan 2026 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961740; cv=none; b=JHeQJH7tDyTRJ2SSnLufShe4SF5VqomkFleJ2f+12zYnKhE++o6XsbxG7O0kQzsZFt5DN8DuHqDct3mAsBNBK6ecMTBbZO0RVnzgqiwl/0cjDnVqDorafxcSdcA4SSSmCaY2PQLe1iD/PRN30Y3QUzInjh2hk+jH8Wege7uibGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961740; c=relaxed/simple;
	bh=79xUYWUI6rgdd5jOMdCZVzzChM/dydsgg0JC/cKEk+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ukz0v977qiocaBCIliaXhTba7uO9B323XInxJwOv2jWvJKCeKj6YbaVXqQX3fyfMVPsdT7BKyRpXalmhZ/lsEAoKCfLHRGyDjwimpqMWBydK+FhZpv3cM9TuslQEcrtBNpr0YNgpNeTWT/DmbOkDKtkD9ZmCl/23j3U4isaRf8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykFL+8Lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykFL+8Lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E77CC4CEF1;
	Fri,  9 Jan 2026 12:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961739;
	bh=79xUYWUI6rgdd5jOMdCZVzzChM/dydsgg0JC/cKEk+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykFL+8LwhQk+Jbsvj0qSTU0+H49yqFa0h83XA2YJkf/KJBzStTrtIlNMVfhQv3vpi
	 17syJjPEW07uGwCE5wap4pthERICeMmBKik46tnHuovKFIyJBJQvskaAwMgrTlMGXp
	 HjxokxxhTxL/tDy93dKUw4H+A/KjHTE+erHM4xcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/634] NFSD/blocklayout: Fix minlength check in proc_layoutget
Date: Fri,  9 Jan 2026 12:36:37 +0100
Message-ID: <20260109112121.915138704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 3524b021b0ec620a76c89aee78e9d4b4130fb711 ]

The extent returned by the file system may have a smaller offset than
the segment offset requested by the client. In this case, the minimum
segment length must be checked against the requested range. Otherwise,
the client may not be able to continue the read/write operation.

Fixes: 8650b8a05850 ("nfsd: pNFS block layout driver")
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/blocklayout.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 59f119cce3dc6..3a9415fd77546 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -23,6 +23,7 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
 {
 	struct nfsd4_layout_seg *seg = &args->lg_seg;
 	struct super_block *sb = inode->i_sb;
+	u64 length;
 	u32 block_size = i_blocksize(inode);
 	struct pnfs_block_extent *bex;
 	struct iomap iomap;
@@ -53,7 +54,8 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
 		goto out_error;
 	}
 
-	if (iomap.length < args->lg_minlength) {
+	length = iomap.offset + iomap.length - seg->offset;
+	if (length < args->lg_minlength) {
 		dprintk("pnfsd: extent smaller than minlength\n");
 		goto out_layoutunavailable;
 	}
-- 
2.51.0



