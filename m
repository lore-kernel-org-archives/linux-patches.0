Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D093D8912;
	Wed,  8 Apr 2026 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674484; cv=none; b=gv2FoJDQU+4Vz0DqAvbwuSaFosSJV4Hx0MOkLzOyiqbZVMf1Fvonz6NCqbWQ/2BX6uifAYtApQBLe3I+pPAJA5z1dW2rkU03khBBs3rmYH4iEyh62495S/hWegUdvVFv+C0R3QJ0y0hHQSrjU+cyilldJpFJNyXUVs5j7bXapYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674484; c=relaxed/simple;
	bh=RiOjyAdvrt/jXNgoTZ3uRIh25y1z7NOQXiX2Wur8/Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE/DYRmcRFluwqQOasytlu/hjmgnn2vYJraLd2BIsrJx8EtE+ynBYnhEuD4nIkMK5D6Xyoi3hsi4iqvHBn3fkDP4dmPwuTffD36HHbzmiZ5hGIHvqtnEw5/K7oEKkWHdnV5nN/WthQMmU3HbHN1mxMDHm+maOKFHLQJXMiQjZ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yLKZJkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yLKZJkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F05FC19421;
	Wed,  8 Apr 2026 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674484;
	bh=RiOjyAdvrt/jXNgoTZ3uRIh25y1z7NOQXiX2Wur8/Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yLKZJkLrpUZ8ey24Z3dgBpj8FqpWpR02F5zLaAmSxqx4tvCLHriQUjHn8/7ol7FF
	 imEx2uL0k7+3Ah7HrRjKaH41biOpYjqM7V5lNOB5neXr2wIQ8DLxR+KbxCbKhkQbY6
	 JSSTFstJZ8xKZKD54g9nigQN7KFPKE1+63s9q040=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 116/311] bnxt_en: Restore default stat ctxs for ULP when resource is available
Date: Wed,  8 Apr 2026 20:01:56 +0200
Message-ID: <20260408175943.750212465@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 071dbfa304e85a6b04a593e950d18fa170997288 ]

During resource reservation, if the L2 driver does not have enough
MSIX vectors to provide to the RoCE driver, it sets the stat ctxs for
ULP also to 0 so that we don't have to reserve it unnecessarily.

However, subsequently the user may reduce L2 rings thereby freeing up
some resources that the L2 driver can now earmark for RoCE. In this
case, the driver should restore the default ULP stat ctxs to make
sure that all RoCE resources are ready for use.

The RoCE driver may fail to initialize in this scenario without this
fix.

Fixes: d630624ebd70 ("bnxt_en: Utilize ulp client resources if RoCE is not registered")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260331065138.948205-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b4ad85e183390..d8c42349ded18 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8002,6 +8002,8 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 		ulp_msix = bnxt_get_avail_msix(bp, bp->ulp_num_msix_want);
 		if (!ulp_msix)
 			bnxt_set_ulp_stat_ctxs(bp, 0);
+		else
+			bnxt_set_dflt_ulp_stat_ctxs(bp);
 
 		if (ulp_msix > bp->ulp_num_msix_want)
 			ulp_msix = bp->ulp_num_msix_want;
-- 
2.53.0



