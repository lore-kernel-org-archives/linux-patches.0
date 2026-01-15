Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA962C3268;
	Thu, 15 Jan 2026 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499027; cv=none; b=cCRl6FZOievYuDZ6gmgK4eHO7FhXQQjSw27cijCaNhX83s9D7FYNzvP10idB9fDCKXkLl54v7FF6zgOxICCXJmZNZsBPcTJPeyaFyg7Vuyn2dFmqLUz4o93mglMgPtCyHFN7SRW2RuR/rdQE7rWl/7S8EmiJ7EXjrKmPChyHk5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499027; c=relaxed/simple;
	bh=Lp7dYrd8eIm3MEZCcpQ3fXVxL4GHHjdc3EfVsGbyago=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgBBuBDQ6xY24uyobn/qSz03t1TJGZslaiHt2lUicFC1js+H2R/dMMXxl79bawJnzXqEeCVHrYCTrBC+1GvoZPXYOpthT3woGoVsnDUf9mx7txdBTqZrDgPYpSecEnubQAWrtQ0Jpxk5Ftnj1g4MnXgFGGDis/dt8EJhvircL0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjtkcLNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjtkcLNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9249C116D0;
	Thu, 15 Jan 2026 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499027;
	bh=Lp7dYrd8eIm3MEZCcpQ3fXVxL4GHHjdc3EfVsGbyago=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjtkcLNc3VtUSr4un46abOSBzdujKeZSLvBS18yWt6OS4E0n7OVvxidXrio4MmKTB
	 StKr9+vQ4BAcSFJl0zLxqrhzlF3oRT4hWYPUAne/FNYQX0wHAD67zY+9E/mL5kMIUQ
	 ygBhTmneg+U2/V8U4UKS8HNmxCj+gPyw/XfpWr9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/451] NFSD/blocklayout: Fix minlength check in proc_layoutget
Date: Thu, 15 Jan 2026 17:44:42 +0100
Message-ID: <20260115164233.846290941@linuxfoundation.org>
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
index aa9b7ae59a076..e01b141ac7334 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -27,6 +27,7 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
 {
 	struct nfsd4_layout_seg *seg = &args->lg_seg;
 	struct super_block *sb = inode->i_sb;
+	u64 length;
 	u32 block_size = i_blocksize(inode);
 	struct pnfs_block_extent *bex;
 	struct iomap iomap;
@@ -57,7 +58,8 @@ nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
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



