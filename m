Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C83F221F17;
	Wed,  4 Feb 2026 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218822; cv=none; b=P0SnraWPL/fkEn33TdV3iVZ6q1I5dIGVGkEBl8RDAndk5S0bO3vUMQcshBwQdapQ9rRcobiHoTnpvRfWuzBH+7qSGMyTv2W/kvGupXCWHfCwnQ/2rqT+BXe1prypdkPTZbTnX+JDVzwewn4yY9en+YAzsFRxMCcYTa6OgQwnbWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218822; c=relaxed/simple;
	bh=bT4iEhSzxuJIucQ4a0k/c35KLR3gaQscE3rrro9xjyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qnsnne2ZY00hQjOXGgtBlPRVqc5bLaGZbgEFwMHgzRuTkKVANpQpcM6E3Zagq3zSWWrz0Ht60el5N3A44xc5mLWz4PelOBWQyJeL3bAcSBeKmh5zMcKNxp0ry+MINwq08rlw98klbEwaca0tOP2suV57n4yj3nTbXwPRQzCSDz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY6lBx+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY6lBx+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614DEC4CEF7;
	Wed,  4 Feb 2026 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218822;
	bh=bT4iEhSzxuJIucQ4a0k/c35KLR3gaQscE3rrro9xjyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY6lBx+YhmIokilgbHWhgsPBMU6aBxnTN6zGKhIp1NRDg2+qX8ubV9ZW4ciUi4iiY
	 mHTvTcrC5YfoLeVnPwiJoK5aZHwgns7MLLvWFKRCbRdo5mz3XY+avrJ2WX+TLTCgIO
	 mEiBR5kqejvXn0BWqaTDShoxpp7GAiZxLZ8v8S0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 71/87] ksmbd: smbd: fix dma_unmap_sg() nents
Date: Wed,  4 Feb 2026 15:41:09 +0100
Message-ID: <20260204143849.473431118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/transport_rdma.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1108,14 +1108,12 @@ static int get_sg_list(void *buf, int si
 
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
@@ -1184,12 +1182,13 @@ static int smb_direct_post_send_data(str
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
@@ -1197,7 +1196,7 @@ static int smb_direct_post_send_data(str
 		} else if (sg_cnt + msg->num_sge > SMB_DIRECT_MAX_SEND_SGES) {
 			pr_err("buffer not fitted into sges\n");
 			ret = -E2BIG;
-			ib_dma_unmap_sg(t->cm_id->device, sg, sg_cnt,
+			ib_dma_unmap_sg(t->cm_id->device, sg, npages,
 					DMA_TO_DEVICE);
 			goto err;
 		}


