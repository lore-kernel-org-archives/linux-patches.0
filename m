Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622A0359718;
	Fri,  9 Jan 2026 11:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959757; cv=none; b=D3alf/YYw8H2Zgljw0Io08S9Q8cUePaBSy57OpacWVJrLX73SBlCj4UfDIDwnfI/7FM9d43TYkTuspO6DHur8fvuEb9oGbKqjQ41o4r7pR2VjfIjjQ9cLSTz/+Hj2qV2U2ntuXvb4X762TDx3hSx8a7cMCLx3GuA5zPx7DfduUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959757; c=relaxed/simple;
	bh=0MCFXCAaW7dgB2Hbk44In9phtDxvt2dhUUaKjt5XpQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NubFKKR7dRoOQ5rHbXdjC3hI/s9EnnVh8rNG8Dzv4a8fhQ29C5oe5+ILOoQBFjOIzdXoF7YE7a8WSKXnA2Mpt5SaMEEZ7tnXhGoPOKxQiWXChohovQXPs6T7XGrUEniRtR5j9zfIjE676gGsW03r0slh1KkPeOFkBIOeJ71YyhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVTKxwrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVTKxwrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1568C19421;
	Fri,  9 Jan 2026 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959757;
	bh=0MCFXCAaW7dgB2Hbk44In9phtDxvt2dhUUaKjt5XpQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVTKxwrkx9W13nCzOWZlmGBCgWijp8xIJxiWuRh11Mww3hNE8q9DUar41LrBG6RMC
	 SGvW3zXR63h6d5Qgh0r2Vo9+73KLXb45/AZKagG1NJ8suZTgnTS3h4tcE5AWwG3Owa
	 mBEu9rGNN8Lws1F1Pi+K8DZxpCHsiDZlUfRnnmP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/737] NFSD/blocklayout: Fix minlength check in proc_layoutget
Date: Fri,  9 Jan 2026 12:35:03 +0100
Message-ID: <20260109112140.163166371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



