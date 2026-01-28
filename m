Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A5C306B06;
	Wed, 28 Jan 2026 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616015; cv=none; b=ejjx/u2MKZNGkFRKG7dBBiRDq+UkJJalB7XcuSGvys1Nzlc10cmo2A48SQ4TrFcpZrczouVzH8RSboN3n+/m3C0KWxItEKcPD5aU8Q4bUHPDgi+Vzjr4EQyNixBjo3t+NHd+p4jCQnmhYYY5qlZaL3HxlMiKb4QciDueDQGh3mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616015; c=relaxed/simple;
	bh=6C8/MlCuc5kVwFRFCRLY2rMKPkPyvWc1wT0Zm2sYT0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqpVsc61AdKtlRkLZ6bV+LAmzT4+f2f+50XfG1lQZ7X9cttrHZCSGaKHRvP/WYGcgozArsgovMzhEYUHxYrgd7wHz5ACwXc2gpz4prL6vUPeoXD9tcP/4r57tQa8oEB4x7BA8Bnqx5Sapw1XoXpojLpeG3rB000keqywIFnCqVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3kE+4fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3kE+4fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D8C4CEF7;
	Wed, 28 Jan 2026 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616014;
	bh=6C8/MlCuc5kVwFRFCRLY2rMKPkPyvWc1wT0Zm2sYT0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3kE+4frn+4J5AiLDiw6S8JAkn1g0c6MYA4lMS+ElLWciV1G8nIYZz3t0nZL3uciQ
	 LXgopSeMwdTWEtw5maHA1v/wzyNj6TfWmJIZ51qUY/nEJXhyMGVppdD6zvA2JHjKAY
	 3AmZp/c7qDHj2XEGO9euCmCOSWDrzesiP/XdmTBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 182/227] ksmbd: smbd: fix dma_unmap_sg() nents
Date: Wed, 28 Jan 2026 16:23:47 +0100
Message-ID: <20260128145350.995653846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 98e3e2b561bc88f4dd218d1c05890672874692f6 upstream.

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1251,14 +1251,12 @@ static int get_sg_list(void *buf, int si
 
 static int get_mapped_sg_list(struct ib_device *device, void *buf, int size,
 			      struct scatterlist *sg_list, int nentries,
-			      enum dma_data_direction dir)
+			      enum dma_data_direction dir, int *npages)
 {
-	int npages;
-
-	npages = get_sg_list(buf, size, sg_list, nentries);
-	if (npages < 0)
+	*npages = get_sg_list(buf, size, sg_list, nentries);
+	if (*npages < 0)
 		return -EINVAL;
-	return ib_dma_map_sg(device, sg_list, npages, dir);
+	return ib_dma_map_sg(device, sg_list, *npages, dir);
 }
 
 static int post_sendmsg(struct smbdirect_socket *sc,
@@ -1329,12 +1327,13 @@ static int smb_direct_post_send_data(str
 	for (i = 0; i < niov; i++) {
 		struct ib_sge *sge;
 		int sg_cnt;
+		int npages;
 
 		sg_init_table(sg, SMBDIRECT_SEND_IO_MAX_SGE - 1);
 		sg_cnt = get_mapped_sg_list(sc->ib.dev,
 					    iov[i].iov_base, iov[i].iov_len,
 					    sg, SMBDIRECT_SEND_IO_MAX_SGE - 1,
-					    DMA_TO_DEVICE);
+					    DMA_TO_DEVICE, &npages);
 		if (sg_cnt <= 0) {
 			pr_err("failed to map buffer\n");
 			ret = -ENOMEM;
@@ -1342,7 +1341,7 @@ static int smb_direct_post_send_data(str
 		} else if (sg_cnt + msg->num_sge > SMBDIRECT_SEND_IO_MAX_SGE) {
 			pr_err("buffer not fitted into sges\n");
 			ret = -E2BIG;
-			ib_dma_unmap_sg(sc->ib.dev, sg, sg_cnt,
+			ib_dma_unmap_sg(sc->ib.dev, sg, npages,
 					DMA_TO_DEVICE);
 			goto err;
 		}


