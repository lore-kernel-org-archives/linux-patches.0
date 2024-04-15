Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614DD76410;
	Mon, 15 Apr 2024 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191209; cv=none; b=FK1bxJFpuR+wHWAChnWdDn7DHsRmMTudgX8BvOKX2MA5lbG5xPhmwxmbPDWoMMl76AhlZhL2Dr6LO8S5CnxMz0YWgHkMAiOfX0jeQLhvRyyse/GPehgSdHxdiaWKKrPiVdoWut4h8GYOQscOcvvlV52BaTXw3mAQ46op/lieavU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191209; c=relaxed/simple;
	bh=uDULF38K2NcNGh2Bcs8tgCs+YnFfkvsWB/hNqo3egSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACd3xE6WpjFSfYcRKIVLmoGDgYVKSTSOwPYo677IP+5Lvl8sXGH79RmI3AeBD1qwsnN/kc471UJ+837z+Lm2DCRrlF6DkAw/QkgpYn7tLpedEvKBa6pID7dwPQ9Q1civzeEPCf7jEIkVOni5MhG6JPtstIQrp/bkOyZhehLLEh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnCBnLlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnCBnLlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04AEC113CC;
	Mon, 15 Apr 2024 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191209;
	bh=uDULF38K2NcNGh2Bcs8tgCs+YnFfkvsWB/hNqo3egSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnCBnLlFvNlGN/g8f2b3NZJDweVUsLjVS++w1/kwC6I+WHW28G5IJGfQ5pRDtV/Md
	 EgePc79i4eKUU6rqsKRGvLNG+QwkkADY41nSSluRx2LENqAYepngtDuGMVbtPao6Aq
	 AVRolFHHPw1xG1SJz8szrvFtMusXiuoyIwbNV94U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 051/172] bnxt_en: Fix possible memory leak in bnxt_rdma_aux_device_init()
Date: Mon, 15 Apr 2024 16:19:10 +0200
Message-ID: <20240415142001.966831916@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 7ac10c7d728d75bc9daaa8fade3c7a3273b9a9ff ]

If ulp = kzalloc() fails, the allocated edev will leak because it is
not properly assigned and the cleanup path will not be able to free it.
Fix it by assigning it properly immediately after allocation.

Fixes: 303432211324 ("bnxt_en: Remove runtime interrupt vector allocation")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 93f9bd55020f2..a5f9c9090a6b0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -392,12 +392,13 @@ void bnxt_rdma_aux_device_init(struct bnxt *bp)
 	if (!edev)
 		goto aux_dev_uninit;
 
+	aux_priv->edev = edev;
+
 	ulp = kzalloc(sizeof(*ulp), GFP_KERNEL);
 	if (!ulp)
 		goto aux_dev_uninit;
 
 	edev->ulp_tbl = ulp;
-	aux_priv->edev = edev;
 	bp->edev = edev;
 	bnxt_set_edev_info(edev, bp);
 
-- 
2.43.0



