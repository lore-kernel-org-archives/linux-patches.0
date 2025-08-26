Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD86350D7C;
	Tue, 26 Aug 2025 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218845; cv=none; b=koLdewqUnPCK7D67/xAxhC3N/J8Qaa6/3bACkeeNFJv+x9gH9+pjgNDUNzwMo1WXBlIEUK8Is4JOReXd2g/wtnhvd/MidSG5DSsw2rUP9y6cN8uIswOnQD3OkIvVxGkpeG6TsMsqzgxg1QTlHy8DOwjg3k/Suj/Pnd0cqx2f2L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218845; c=relaxed/simple;
	bh=DN3PSFwHBpY+fhHaMudo7O6eqT3t5jlhcYwe+tvCieY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+PX5nH3qyj0XLjPM+LGnNiewuJK/V7yN7GBCGrvRwmUIK66K1gxfJwg3vSEIEPOJAaDDxHF09mUWrD0hgBcZ8MT9fKJYYTS5YO8BBfBOEkjZJs5Lfakg8sKTW99x1q88JjOKyLSODUeTWOOWy7qpP0Lc/XUkeIfoIrsuDxxZgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEWj+gFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEWj+gFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1F5C4CEF1;
	Tue, 26 Aug 2025 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218845;
	bh=DN3PSFwHBpY+fhHaMudo7O6eqT3t5jlhcYwe+tvCieY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEWj+gFBPGMU8hu1gvVYi8LUQV8/iyC7gmxxgZms55I97+PGzqCPrQXzKPrzyeYCL
	 VKpLR7EXMXgUGwrybYRZ6tyXcQ50V8mR5hS0JV20jTt6hapiK4GjPrpPgZnYEp8MoD
	 jDRwGcYTf9/BM8ab9ytpwc4Ft80O6QdrViw3FL0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/403] scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:07:20 +0200
Message-ID: <20250826110909.881506866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



