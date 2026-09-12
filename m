Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605A02576E;
	Sat, 12 Sep 2026 07:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199861; cv=none; b=LmMUIpIZ1HbvawkUBcfpUmwmxe7CN6hp2NzWRBTgzIweRP6GtTQhMb9wMeQDU5usykdbU1uqg/xbo6V3RlGYSYdsyY1FMHW9dgsJFsDZfSg9NDTbSc7YRb6yCc9BJ7nD3qlE4wse/VwB6zpowr+IUFpqsDIKeaXwYSmNEGGZl5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199861; c=relaxed/simple;
	bh=Ou67iaXqQ0lx10+nwEF9xJQeqqNOxN4/W2108uxcJO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/CDkY6JE//hXMwAWTYSxI+I7B7nJvUcKdaNFcbxzKq+hyh4JcDoE8MwZwoy/u+mbt3xmdd6vCCvYyg7DMAAJZxxTxjXdfK9WgWvBSmRKHXSGwjRax03KKLADh7NywqcJewmCV9E7ZpRz+KpkpsVL4rem/KOd+UcJlLJ4C2TXYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SudhrTVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SudhrTVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1701F000FF;
	Sat, 12 Sep 2026 07:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199858;
	bh=Ybe05jnq1HZwL5qZ4irmW0iRQVFIcYBSrFnySXfbeB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SudhrTVF3P7EMr+LeNbZTzQ5+EXC+If+i8T0cH0Fn/6/B9gCVkWEbS5ZESvl9fPFI
	 4n08MJJyz+n2Vcg7G3kZpVhwj6A8UOOPqdH5JMl43BMHC/R/jF8vbCjk6lruc5sdom
	 uMRjuGUGjJ8sLBHyXEVznespJix7o90G0LHR/peo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0670/1815] scsi: ufs: core: Validate connected lane counts
Date: Sat, 12 Sep 2026 08:40:20 +0200
Message-ID: <20260912065704.616285660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 9e6dd452f1affb5c412ca64bf5809ce9fde3174d ]

The connected lane count is used by TX equalization code to index arrays
sized by UFS_MAX_LANES. Reject zero and out-of-range RX or TX lane counts
before they can be propagated.

Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Link: https://patch.msgid.link/20260717153914.26321-4-liqiang01@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 355393ac562b7..686c21301e026 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4729,7 +4729,9 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
 			&pwr_info->lane_tx);
 
-	if (!pwr_info->lane_rx || !pwr_info->lane_tx) {
+	if (!pwr_info->lane_rx || !pwr_info->lane_tx ||
+	    pwr_info->lane_rx > UFS_MAX_LANES ||
+	    pwr_info->lane_tx > UFS_MAX_LANES) {
 		dev_err(hba->dev, "%s: invalid connected lanes value. rx=%d, tx=%d\n",
 				__func__,
 				pwr_info->lane_rx,
-- 
2.53.0



