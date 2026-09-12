Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D1433AD88;
	Sat, 12 Sep 2026 09:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205019; cv=none; b=Q+fdkNRgfsVI3yC0bnsI/l+6NaDpp4bxdVA5oRxPsCuQilcCPlfXRtdWeagR6QG3ZLvMhix0WjRNISeKFYuEbSsQOTeaCcFihWoDOJhqdW3flpbqG0qHJL//0NuLt2nMSN7WJ6i5jPwcsBkxyw6QBmzERNb4/qYZrEs8gpGzPFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205019; c=relaxed/simple;
	bh=2ixLCTAvOSm4KZlyBGtBAREXfYNGm2N/LDSaOpXzLVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Soa0LZzyec2c5MUj7Osk/2/nKnitp+J9SDmEQpUuR1TZ5VFKROX8MKZ24D5DptJlUNWRHQESPvapsBFPZIoCkOfVK9hzLP2qbI0Y37+ab33fxmpZfxsNmAJYjv+DfL9EqV124xy2qv7SdGtCKQnwKdgsE0Uw+RnaidtgaODvfaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGJECHy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGJECHy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED4A1F0089A;
	Sat, 12 Sep 2026 09:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205018;
	bh=pvU6QTFw1w0qnnJvviHyhzeZHLpsOU5+qqppf4xoxLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGJECHy9WkxOSUbAAyH/VAs/pA/WHb3aNbWskxjXH8DvX7T/sta7uXSIEUMrX0ET5
	 iuhLSYi9mqWabcNVIAmgY02Arb+JkR+7lDgLjH3/VquMbjLJQ53dYynwdG0fpons5A
	 cmQ6h+T/H/DWxKsVzRtPanNikMnZZMl9Oqp2W4VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Thomas Walsh <thwalsh@redhat.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1695/1815] bnxt_en: Gate TPH enablement behind BNXT_SUPPORTS_QUEUE_API check
Date: Sat, 12 Sep 2026 08:57:25 +0200
Message-ID: <20260912065728.770733625@linuxfoundation.org>
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

From: Thomas Walsh <thwalsh@redhat.com>

[ Upstream commit a70859cf31214e546cb73da7142f190138dae9ab ]

In bnxt_request_irq(), pcie_enable_tph() is called unconditionally to
enable PCIe TPH when setting up interrupts.

If the NIC hardware or firmware capabilities do not support queue ops,
attempting to enable TPH during bnxt_request_irq() is unnecessary.

As a result a flood of "RX queue restart failed: err=-95"  messages is
seen upon boot.

Older NICs (pre-Thor / BCM57414) do not support TPH or queue management.
TPH requires queue management to restart the queue.  NICs that support
queue management (with updated FW) all support TPH.

Gate the call to pcie_enable_tph() and setting of bp->tph_mode
behind BNXT_SUPPORTS_QUEUE_API(bp) to ensure TPH is only initialized
on devices capable of supporting queue ops. This prevents a guaranteed
-EOPNOTSUPP error from occurring due to NULL operations.

Fixes: c214410c47d6 ("bnxt_en: Add TPH support in BNXT driver")
Suggested-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Thomas Walsh <thwalsh@redhat.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260820220544.1240879-1-thwalsh@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 54bae193d1f63..fd2ee24f3b0bc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11923,9 +11923,11 @@ static int bnxt_request_irq(struct bnxt *bp)
 #endif
 
 	/* Enable TPH support as part of IRQ request */
-	rc = pcie_enable_tph(bp->pdev, PCI_TPH_ST_IV_MODE);
-	if (!rc)
-		bp->tph_mode = PCI_TPH_ST_IV_MODE;
+	if (BNXT_SUPPORTS_QUEUE_API(bp)) {
+		rc = pcie_enable_tph(bp->pdev, PCI_TPH_ST_IV_MODE);
+		if (!rc)
+			bp->tph_mode = PCI_TPH_ST_IV_MODE;
+	}
 
 	for (i = 0, j = 0; i < bp->cp_nr_rings; i++) {
 		int map_idx = bnxt_cp_num_to_irq_num(bp, i);
-- 
2.53.0



