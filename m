Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BA28289B;
	Mon, 15 Apr 2024 14:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191650; cv=none; b=Jp87WM0rPnlJYddygctLmEI1lWf1lMDzz6pAoArboVNJ96Jr/XFfZnBUUMXDToP9w2GUn4TehWN7DawzAsMrDRP+dXfmfmvpo3igXk6P5ZFgTQMKHEv7x73P3sLv45ZvxweaNArLEsYW9C/GOpcDEWjpNt9/0aeB5+sFhoHGS34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191650; c=relaxed/simple;
	bh=ImgJsV+SJ8WOTJK2NUQRHL1S1y5y8dMegV4cJI2wGgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpe7g6iGBZqYtPqR0DNIrtZl/f8jO6wN+PovBDhOpb28mQfB06v655bMr8LbJUuLcxcgrkx8XGqhEfy66UeqtwyvC+gaTevcCeYY7lwObhFltJ4/yGb7yds0x02tdG9pV1bxwwfh0s2qzFRb53GRbLNGgHzgQJWOXOLlX7BkINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3E9M9SE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3E9M9SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188F2C113CC;
	Mon, 15 Apr 2024 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191649;
	bh=ImgJsV+SJ8WOTJK2NUQRHL1S1y5y8dMegV4cJI2wGgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3E9M9SE5KgLSENEKXv1aF6PV09Pdpas5u+et735pm3hjA9oHa4P2lGt2mVM1Rfg/
	 ACW7IxNgP8JgZnmQT0OTbsldUAHqMIeX+ntEDbzP07Fd6LLy41k590FD+idBfDfHEp
	 qd7ZDnsbsprUSITVzr+sXErr1xA690H8bdKG+kTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/122] bnxt_en: Fix error recovery for RoCE ulp client
Date: Mon, 15 Apr 2024 16:20:04 +0200
Message-ID: <20240415141954.541296982@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit b5ea7d33ba2a42b95b4298d08d2af9cdeeaf0090 ]

Since runtime MSIXs vector allocation/free has been removed,
the L2 driver needs to repopulate the MSIX entries for the
ulp client as the irq table may change during the recovery
process.

Fixes: 303432211324 ("bnxt_en: Remove runtime interrupt vector allocation")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 7188ea81401de..7689086371e03 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -213,6 +213,9 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 	if (err)
 		return;
 
+	if (edev->ulp_tbl->msix_requested)
+		bnxt_fill_msix_vecs(bp, edev->msix_entries);
+
 	if (aux_priv) {
 		struct auxiliary_device *adev;
 
-- 
2.43.0



