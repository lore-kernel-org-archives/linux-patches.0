Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6230158545;
	Tue, 11 Nov 2025 01:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824626; cv=none; b=G+gJ9YtRTU4J8R9M98EL1KNGT7+2qOoU1oJBODWyxFITrzjZwBLtTTm29kI+GpT1zYLCEz70w9hx1VkzBTiGynlj1fpuJaJmbBh7eMMgo6NSJgL5NnP/xZmMCDbsTn/Ejg/meIpWUvdNx9SCJUVACtLnEw4eCW/2DerfcjH8KLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824626; c=relaxed/simple;
	bh=lwNYMtVa9GHZAXtZj/otFTtdzeAA2w8PjmTr6Hf59nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z37EbpHFHysCAbex9f68qLNUNzK93XmeFaB0xVsd+iPCiWGRcyVnrbrgm9Yu90xPK9Vnr14eo321EbC4Ic4jSENXPmOi+yqkbya0E2C8h/FY4atx9gsJd/xV65RVu9/oCtMV0nAeKDxLJCEUDqNTOkOB9RsDF6Vn2eavrwK4BOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9xlGqsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9xlGqsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307FFC19425;
	Tue, 11 Nov 2025 01:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824626;
	bh=lwNYMtVa9GHZAXtZj/otFTtdzeAA2w8PjmTr6Hf59nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9xlGqsdye3JS4CUCDMmWRVUV2D8P5P3NK0qIhE+REqjvBIGuRHrkzUk8fKdIakbI
	 QP3kckYpSwTI4J4ERTLKNvhodvIT6Joyx4zrlNcKkCGHEmrD44sTpXIIa5kTsMToNI
	 nOlR6C3pVNWsBXr0aVEygxn+4qrYIIPgcGx3qKWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 499/849] scsi: ufs: host: mediatek: Fix adapt issue after PA_Init
Date: Tue, 11 Nov 2025 09:41:09 +0900
Message-ID: <20251111004548.498090391@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Chao <alice.chao@mediatek.com>

[ Upstream commit d73836cb8535b3078e4d2a57913f301baec58a33 ]

Address the issue where the host does not send adapt to the device after
PA_Init success. Ensure the adapt process is correctly initiated for
devices with IP version MT6899 and above, resolving communication issues
between the host and device.

Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3defb5f135e33..c0acbd3f8fc36 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1503,8 +1503,19 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
 
 	return ret;
 }
+
 static void ufs_mtk_post_link(struct ufs_hba *hba)
 {
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 tmp;
+
+	/* fix device PA_INIT no adapt */
+	if (host->ip_ver >= IP_VER_MT6899) {
+		ufshcd_dme_get(hba, UIC_ARG_MIB(VS_DEBUGOMC), &tmp);
+		tmp |= 0x100;
+		ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), tmp);
+	}
+
 	/* enable unipro clock gating feature */
 	ufs_mtk_cfg_unipro_cg(hba, true);
 }
-- 
2.51.0



