Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38F1F4709;
	Tue,  3 Dec 2024 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238935; cv=none; b=bxQKZmV7h8hzU+xIu9xpCY37T8oe0poA7BxKPLERqWFWluGyIOmQjirLPACn8I8JoAX7O1IimwXgTONqFJQ+Hr5PIWJoilU2ZHGpm1RproFNykGcnqoi4G9RoAvmBzpYLVJTKlVjNMjBzqRJZrdlA/uVTWjxAllTBgugEp/4FTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238935; c=relaxed/simple;
	bh=7or15xdQG9Z2OP+PbyLKC8V5RzjxPDV14zbduAg0yRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt3L3/d15Z/6mkR70agt1t0Ul3M2gNwv6VrZddBIHBDwhwBFiq0MlpNbh9BXnTVJVOtJxpC99uMzvbr9iWPqUFeBUIShjnq7o6rutwN8yWSlYrVAWjyVODEJHRO0oRCkyYVNkeflaYxDSrRz3fjMhAXbn75OWGIwcDGrRvxPnAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWjVm7Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWjVm7Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BFCC4CED6;
	Tue,  3 Dec 2024 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238934;
	bh=7or15xdQG9Z2OP+PbyLKC8V5RzjxPDV14zbduAg0yRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWjVm7YlUMjwJV0/p5/Ys9ULMzE4fnTnBu6utaL4ozpIhkqbiwA81thZQCv696JJs
	 vpgTrYpXdgtXVoL/ZA7yLRERKax+LMvjbTa1eYwIE5dxjWVBqvBh0ifNrVgeUQlbIB
	 Rux9/lKrM+sJ98Zo1JN/aPBmy7bU0P1/FTWsA4C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 440/817] scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
Date: Tue,  3 Dec 2024 15:40:12 +0100
Message-ID: <20241203144013.055508605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit c62c30429db3eb4ced35c7fcf6f04a61ce3a01bb ]

Hook "qed_ops->common->sb_init = qed_sb_init" does not release the DMA
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20241026125711.484-2-thunder.leizhen@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 4813087e58a15..6f1fc88c59fc0 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2738,6 +2738,7 @@ static int qedf_alloc_and_init_sb(struct qedf_ctx *qedf,
 	    sb_id, QED_SB_TYPE_STORAGE);
 
 	if (ret) {
+		dma_free_coherent(&qedf->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "Status block initialization failed (0x%x) for id = %d.\n",
 			 ret, sb_id);
-- 
2.43.0



