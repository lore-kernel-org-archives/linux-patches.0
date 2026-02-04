Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D3528853A;
	Wed,  4 Feb 2026 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217377; cv=none; b=f4phyd1mjUOMRh5TN7FPi0t5ZhtoqWh0tC0qdqI3SGIWOXhGw8q59iXU7aw1jtpwqvLCzPOJhimm9UwBFGvAEwUiJd1XRAY8hK8fFgkftEJWv/XPClHZem9EeqqOvoasZv63x1hFa63wcghHyklgda1cP55Mkq80g61Pbo0IU+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217377; c=relaxed/simple;
	bh=TBNXBYeMQ7wYNs5aoxKryPyll6zJfA7GpJ5KWTOF90o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQK1kqix73f9+Yz+XJXlWkyuIcZ4cvus/3/NEYgE3czF5PPUDxBCCJ70cLMNnscm1J1SldG1xGAVkLorbjWcluOBTRDtAYc4cqhaWH0IrfptGJQTfcBzjQeFt5xkBuhOOKZSXGrr0q8f6Id3HvAnlSf8u1XrftE7FH0RTALVmlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dg10JrmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dg10JrmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7C9C4CEF7;
	Wed,  4 Feb 2026 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217377;
	bh=TBNXBYeMQ7wYNs5aoxKryPyll6zJfA7GpJ5KWTOF90o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dg10JrmWEKdcBUhlysUDJ89VHa9Glxs8SXmJHI2UMb0ojqYK4lTJuta3R4a+B5MDv
	 D8HmPtt8+LiiPMUvU0dYGwtxpboFx3md+jqx/UyKDpPkUYqrxrGUZbTepuX/WuVyTg
	 dreY9XdTJIsZlgpmPX5RL+hV+WEUpYW9yWDVhjag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/206] ksmbd: smbd: fix dma_unmap_sg() nents
Date: Wed,  4 Feb 2026 15:40:03 +0100
Message-ID: <20260204143904.404092534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 98e3e2b561bc88f4dd218d1c05890672874692f6 ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1086,14 +1086,12 @@ static int get_sg_list(void *buf, int si
 
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
 
 static int post_sendmsg(struct smb_direct_transport *t,
@@ -1162,12 +1160,13 @@ static int smb_direct_post_send_data(str
 	for (i = 0; i < niov; i++) {
 		struct ib_sge *sge;
 		int sg_cnt;
+		int npages;
 
 		sg_init_table(sg, SMB_DIRECT_MAX_SEND_SGES - 1);
 		sg_cnt = get_mapped_sg_list(t->cm_id->device,
 					    iov[i].iov_base, iov[i].iov_len,
 					    sg, SMB_DIRECT_MAX_SEND_SGES - 1,
-					    DMA_TO_DEVICE);
+					    DMA_TO_DEVICE, &npages);
 		if (sg_cnt <= 0) {
 			pr_err("failed to map buffer\n");
 			ret = -ENOMEM;
@@ -1175,7 +1174,7 @@ static int smb_direct_post_send_data(str
 		} else if (sg_cnt + msg->num_sge > SMB_DIRECT_MAX_SEND_SGES) {
 			pr_err("buffer not fitted into sges\n");
 			ret = -E2BIG;
-			ib_dma_unmap_sg(t->cm_id->device, sg, sg_cnt,
+			ib_dma_unmap_sg(t->cm_id->device, sg, npages,
 					DMA_TO_DEVICE);
 			goto err;
 		}


