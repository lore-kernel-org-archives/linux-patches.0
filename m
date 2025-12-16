Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C0D355026;
	Tue, 16 Dec 2025 11:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885820; cv=none; b=fmvtHme3b+E2wwWQvsY/Ya76z1a7UyOqCEnok7ckjsXjc3l8UwM4HtNruX1GRm6y57EXyWlf5EH52JrmbPyitZxFezVbjzlRJxmXI19CzZD11ekWl074Iw0Dr7mZ4nqx5I2wRI8Yj7SmdUAJnPHkC5AN1AlJK2SbYYNcmmE0+qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885820; c=relaxed/simple;
	bh=6dISjpMt4D24aWgahCr7UnIvdOBBE6Cr+CSfvs0tSuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iByd2tc/+5rS8LPVdOjWChI8svVLIHZvphKupRpgqParMGlIOxsLDrSJvHH5C4UbQ2PoKmVqr1Gb1T9s2qLuj7uHpy3ylkD6cSXZCChd+w/ZCOjzmewf/VR3R0ZWuxf4BaRPPnTmfch5NjnSAB+Y/KTdiBA24i5Yr4ldycdxTvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bU+hjrUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bU+hjrUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F4FC4CEF1;
	Tue, 16 Dec 2025 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885820;
	bh=6dISjpMt4D24aWgahCr7UnIvdOBBE6Cr+CSfvs0tSuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bU+hjrUhm/F+HvVMmB4WpABreLF7xUN5eADaTpw47TtSflKoI4l3l8lhAUcALnydw
	 9o4gGEJMu6a5O+1PkA2rfNbp1MNNC6L91gb0SNHk9k7YubUIUcjnogkUVB2/LK37vs
	 Btl+4oYmiiLs6snWctxqoZCh7kI36xkBGv1JMB9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 255/507] NFSD/blocklayout: Fix minlength check in proc_layoutget
Date: Tue, 16 Dec 2025 12:11:36 +0100
Message-ID: <20251216111354.729193475@linuxfoundation.org>
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
index 0822d8a119c6f..eefe50a17c4a0 100644
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



