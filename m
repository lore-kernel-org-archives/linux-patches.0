Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A12E4248;
	Tue, 12 Aug 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020746; cv=none; b=BwnpYRtrKYCCVsgwX+rfz8+WWzISMcKEZVI0sT7S71q7OGa8g9O2P0cCs9N8eXT8pmwdzOtb+Ndb5Dw9Xn4m9vLP4Rt03NItmkG1xi6RKp0ncHUpHoBPFjPN8Fi4+SkZuUTdXr91F1XPma3X+k51ggYuuMzT8vTPW9W1pEG9GAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020746; c=relaxed/simple;
	bh=do2l3Oxe2SideZJtP9GZOPr5cO1owpNnaRW0wPOtRJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3iau9tXOgbw+po8E/Djnwz1U+TvWAlBXbkNBClrqMq4ugoDqDKE0Kxt2N4pamYEKHsBXtcRFoo8btiw7BgIPW84DfhWbz3ccmSAp+QbErQmhdJDbUtWo5ZvLhKVc3F7+qo4es4B4hZ8cHeERxGJWNlKVO+Euy6kCsZlMVkmbNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvjkk9S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvjkk9S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD06C4CEF0;
	Tue, 12 Aug 2025 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020746;
	bh=do2l3Oxe2SideZJtP9GZOPr5cO1owpNnaRW0wPOtRJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvjkk9S3ygIj61ihjboG31k8Gy5LcwIna7wnLp6m5GVuxWJrmUofc1SLqfTS+a7i2
	 VYm62uTnJZSUGvKdN+uP6CckCgk12ewVXIVmXgFB7k4L8neKiuImOz8HTIEBFTcrLy
	 mvdgig4tIdaYp+v6IiH3HGzxNIT9zxX3rUrVGR3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/253] scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:29:09 +0200
Message-ID: <20250812172955.568708270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



