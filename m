Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED17B356A0D;
	Sat, 12 Sep 2026 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212125; cv=none; b=D7RMf8SPHNOkBasrGH+WCkrkzOffIFkE6b8ba/pDHOc4oBWmKQsOb7F4OyCSMyi+q0Nq5mGok6jCMVuQi5G9kMZh7CTjCXvR0z6aDzE9ZZd6vzyayi1K5tpDNPLsJoG6p/eWEPkkrvmVNghquKd2trM5c6HOqVDcG9R52zE5HXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212125; c=relaxed/simple;
	bh=m09NV0y5XZl3n2zuAsML1qPUJghhn0MxVqoJMg23QdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqJNbtPX+KmprXVORrjqCenC4HL1Km29CyrWfcUZiWzXPCYSxgSd0Iu/b/E/nHzmSzaNUUwUL8VwIdOoeCAWRwmpJv+Gji7/o2gmxilOwXfkDWk/r2Eha/KrYgfU34p7Ia/y1IpyLUa+MM1lz11Y1dCRPI1kmqOLEUVhH9R9hEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Is2c4KuF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Is2c4KuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BA71F000FF;
	Sat, 12 Sep 2026 11:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212123;
	bh=LptRPpY2UO49xNddrkZCDsgD7eG7BSpZxh1DNSGo6ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Is2c4KuFKo1s/g8DCA655ikPm0c5oMowp3A+edMa/SN6Pvq1vryZlEUV01xc/+lRM
	 XrVPkMuUywiWp8z1TYlX5MhVceF3JIrSFiubVoDmPL9Oo7EIWfN47S2q6aG95Vqk0W
	 KkVyMOaXyae3Hifj08nFwMpl/EwfnZrMsmqTSZ3k=
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
Subject: [PATCH 6.18 1370/1518] bnxt_en: Gate TPH enablement behind BNXT_SUPPORTS_QUEUE_API check
Date: Sat, 12 Sep 2026 08:58:59 +0200
Message-ID: <20260912065654.535469342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 186fc98a555de..e2bceec96932b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11772,9 +11772,11 @@ static int bnxt_request_irq(struct bnxt *bp)
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



