Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F93C3EDE7B;
	Tue, 12 May 2026 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608286; cv=none; b=pBQjc4XX6I4oUOCFzUmiMUGFXda+qn1hb1q33icGIrhkADXTVGALsokgqLePrhpYAuziEdkCetqV0pJTkPik9+wGG7yBougJGGqhLdFmVF2UihpEKlJq/DTONzE8Le12ktV1oDzf17GtoPwkgM41a5EyKEbC+WN9XJtoik6ru9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608286; c=relaxed/simple;
	bh=+bb8TxnSxIhe6iqSt/n07ufhMbZn0/7krSTTLIvhOSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jxkxp8FzNA4MPY7mIw12UP/Z9OuUE3Tue+xB24pHd5Nx6f7ZVhoLAHQP43N6fUcpFvucSNDM3gCm8Nb2MayKBsvY77DYCoEi7ljpxAXZ2GlfRS8l/o0o/65rJCB/2QPzphls44ZXJaUWvTLGngiArncuc1GvvXfvh3Su76BuuAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8y8z4jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8y8z4jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90B7C2BCB0;
	Tue, 12 May 2026 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608286;
	bh=+bb8TxnSxIhe6iqSt/n07ufhMbZn0/7krSTTLIvhOSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8y8z4jfVwyfNra8zy14eL/Ej5oKgjHJloX3aaUrMVcgeod6Gk0UCMsq/Rq+CQqBj
	 5Wq1WooG3uxk616gbPym8o4qMUbZ4LDAhSeod0WMVIqxcsj6Hfe7G5zJt0pjAo7eWT
	 jXcgM6fwFb5hLR761xkCxCR3lqmvfn+syUxxKwvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yi Kuo <yi@yikuo.dev>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/270] smb: client/smbdirect: fix MR registration for coalesced SG lists
Date: Tue, 12 May 2026 19:37:01 +0200
Message-ID: <20260512173938.883135006@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Yi Kuo <yi@yikuo.dev>

commit 9900b9fee5a0e0f72d7c744b37c7c851d5785ac6 upstream.
The stable backport to < 7.1 patches a different file. Also
the Fixes tag below is adjusted for the old code path.

ib_dma_map_sg() modifies the provided scatterlist and returns the
number of mapped entries, which can be fewer than the requested
mr->sgt.nents if the DMA controller coalesces contiguous memory
segments. Passing the original, uncoalesced count to ib_map_mr_sg()
causes memory registration failures if coalescing actually occurs.

Capture the actual mapped count returned by ib_dma_map_sg() and pass it
to ib_map_mr_sg() to ensure correct MR registration.

Also update the ib_dma_map_sg() error logging to drop the error
pointer formatting, since the return value is an integer count
rather than an error code.

Ensure a proper error code (-EIO) is assigned when DMA mapping or
MR registration fails.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221408
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yi Kuo <yi@yikuo.dev>
Signed-off-by: Steve French <stfrench@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ff44a2dc49938..e2b20219ba2c7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2895,7 +2895,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *mr;
-	int rc, num_pages;
+	int rc, num_pages, num_mapped;
 	struct ib_reg_wr *reg_wr;
 
 	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
@@ -2923,18 +2923,21 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 		    num_pages, iov_iter_count(iter), sp->max_frmr_depth);
 	smbd_iter_to_mr(iter, &mr->sgt, sp->max_frmr_depth);
 
-	rc = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-	if (!rc) {
-		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
-			    num_pages, mr->dir, rc);
+	num_mapped = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+	if (!num_mapped) {
+		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x num_mapped=%x\n",
+			    num_pages, mr->dir, num_mapped);
+		rc = -EIO;
 		goto dma_map_error;
 	}
 
-	rc = ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE);
-	if (rc != mr->sgt.nents) {
+	rc = ib_map_mr_sg(mr->mr, mr->sgt.sgl, num_mapped, NULL, PAGE_SIZE);
+	if (rc != num_mapped) {
 		log_rdma_mr(ERR,
-			    "ib_map_mr_sg failed rc = %d nents = %x\n",
-			    rc, mr->sgt.nents);
+			    "ib_map_mr_sg failed rc = %d num_mapped = %x\n",
+			    rc, num_mapped);
+		if (rc >= 0)
+			rc = -EIO;
 		goto map_mr_error;
 	}
 
-- 
2.53.0



