Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D5434405B;
	Tue, 12 May 2026 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608979; cv=none; b=cSZPyzWRRJPsFB0nkn/W/vABSAsmvGlPdl0iIQUUtTR5TUUB9PCMiCNsjtlif99gAlmXOFEfkIpOxv4g2Cg6fDObABTFUUaexakL0593IlaH2HmZvR1lMoI1++Zr5WHPN0Yl948iOXIZ/INjQwb4ADKkamY76kvFg2q0wYdaKWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608979; c=relaxed/simple;
	bh=59gPDQxGOu9VkbuboEJNjpC9MB30d17qnoiq0OAwCu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKpex5xh03bgsovaAnGgLXiivagI5OWjhZQuBq5Gwd0LLGAvly8gy6ZvCn1ZFgaealLbFmna/vsriqkqrx9AE8I/0v7XBuwsXYF+0LpSYJwTQ2KKzkXvFyzk96tR3WSZ1w4uzaPvFpc0RoZXiMxR9qQ5/IcupYGoo8uRck3Zjnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yn9rDdFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yn9rDdFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15610C2BCB0;
	Tue, 12 May 2026 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608979;
	bh=59gPDQxGOu9VkbuboEJNjpC9MB30d17qnoiq0OAwCu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yn9rDdFGkvbx8LFAeNHUKIfFn/N9qcA7Pk1vPT6gXnggxl0lJkV01va57ZeFjv44n
	 5bXzsC2mRmcZbrZYNb68aOx0Di/LRitwedZPAiXXTI48uPtYqUD9MptAKglT0vmfbO
	 lSzjnPXOUA7WFoA2WMy7icW/2wKcWycW9y9q3d14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yi Kuo <yi@yikuo.dev>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 019/307] smb: client/smbdirect: fix MR registration for coalesced SG lists
Date: Tue, 12 May 2026 19:36:54 +0200
Message-ID: <20260512173940.531817447@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 4616581050133..d0fcc77794156 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2920,7 +2920,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *mr;
-	int rc, num_pages;
+	int rc, num_pages, num_mapped;
 	struct ib_reg_wr *reg_wr;
 
 	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
@@ -2948,18 +2948,21 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
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



