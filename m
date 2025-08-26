Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F27C29D291;
	Tue, 26 Aug 2025 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215835; cv=none; b=TQvjnsjba0nay9FMNnqhnK88iRmcWlzf3l/PF5mzsbQkLUY+l7rU/vRJo7qpFj3AtNlxTI9pMOxx0mpjm/6YPjwPOOKpR7XcDNFKp+SqXKRwyOF4T0N4+PO1gv2UxVgjbbeiymnfcQHaYToKXwYkzwgMz0IlrBU3X7MavYMUTok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215835; c=relaxed/simple;
	bh=YMNP+I3SUFl8QKi1NnjPbwIcWnXnrja2h+eBUaQ+wJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y06JXchUXrtgN099ttMIZkbpvJ/z1E33TVnUjSuwDLWCSRyI19zId6C6BjkhtoyXnIWBOuEtqs7ZEemn0DBhGdufcD5bmggwWuRyE6USUx4d9rUgoaw87SYAFomkSzy3rFF7sSwSEbVAr5qDudpmbVXJXem3SAeTWvX6V140qv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioKkqSxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioKkqSxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9279AC4CEF1;
	Tue, 26 Aug 2025 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215833;
	bh=YMNP+I3SUFl8QKi1NnjPbwIcWnXnrja2h+eBUaQ+wJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioKkqSxZSpxWNDgRfPXjoQ169tmQtqgrqWmD0mPe9rVEfFs0By0OHJPaIMFMV3TM9
	 AP7RKGGR+ibUspd+cJ6MG/Vl+zAAKKpphDSfz4JuTS14Z/lRcC8cF2uOU2NJdpGbVB
	 06nDQYiYgw/YPVII7sDDcd7nVqMI9Rqt6RRJcOMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/644] scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:04:34 +0200
Message-ID: <20250826110950.998635663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 023a293b9cd0bb86a9b50cd7688a3d9d266826db ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 88a678bbc34c ("ibmvscsis: Initial commit of IBM VSCSI Tgt Driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250630111803.94389-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi_tgt/libsrp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/libsrp.c b/drivers/scsi/ibmvscsi_tgt/libsrp.c
index 8a0e28aec928..0ecad398ed3d 100644
--- a/drivers/scsi/ibmvscsi_tgt/libsrp.c
+++ b/drivers/scsi/ibmvscsi_tgt/libsrp.c
@@ -184,7 +184,8 @@ static int srp_direct_data(struct ibmvscsis_cmd *cmd, struct srp_direct_buf *md,
 	err = rdma_io(cmd, sg, nsg, md, 1, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+			     DMA_BIDIRECTIONAL);
 
 	return err;
 }
@@ -256,7 +257,8 @@ static int srp_indirect_data(struct ibmvscsis_cmd *cmd, struct srp_cmd *srp_cmd,
 	err = rdma_io(cmd, sg, nsg, md, nmd, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+			     DMA_BIDIRECTIONAL);
 
 free_mem:
 	if (token && dma_map) {
-- 
2.39.5



