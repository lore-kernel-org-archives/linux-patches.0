Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C5736C0B9;
	Tue, 17 Mar 2026 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765840; cv=none; b=o8An2UV5G9i0KzF0axvYDn+e8l74Mg/NzkE1Ikw6hom3QZqzr+gXwkqqLti791M+HqeZbFJj/tDL1PLhmTADsdWst/rzmTtJD0Ktu6OyfqtrCP5H1g79Z0JwoXbO4/RaNIJlEMQRaA1plE1CO5193LpByFkuk+xtknEcBPiOjbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765840; c=relaxed/simple;
	bh=73UDHyLNPfxZ54E8bT9dhdd+OQRSs7ACpmRBFjCA5LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWAzEUvD9EB57kb0KnFH1TaUFPjbts8SrZRtBTXtSPGYdj2D7m5CpxyEHrKTe+OHI3haxErqxPMuUyznSfm6d7fdJLzv7bG0Oc67r38bpng/smbZVXxU3fb4jDLw/UMS5mx9jbwcFM/cVR6WlZEgChWRj/iRrH1z6pnXxT7BA3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HisNgucZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HisNgucZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A233C4CEF7;
	Tue, 17 Mar 2026 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765840;
	bh=73UDHyLNPfxZ54E8bT9dhdd+OQRSs7ACpmRBFjCA5LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HisNgucZp3KTrws6P8Wnqbehv4WD+zmQimDt2QBYv8wLouZpwbSqEM+kA5h6zkvvh
	 oOO0099Yjp5CA0cbGBC/fs5lky84Ms3mJsqpVTRjhcDaUkF70179aB68vKE2J1z3Do
	 LhIp7+AoSnyJhQ4VEWzGvrO0fnAKYw4+Qwd4fPns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 107/378] net/mana: Null service_wq on setup error to prevent double destroy
Date: Tue, 17 Mar 2026 17:31:04 +0100
Message-ID: <20260317163010.953287624@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit 87c2302813abc55c46485711a678e3c312b00666 ]

In mana_gd_setup() error path, set gc->service_wq to NULL after
destroy_workqueue() to match the cleanup in mana_gd_cleanup().
This prevents a use-after-free if the workqueue pointer is checked
after a failed setup.

Fixes: f975a0955276 ("net: mana: Fix double destroy_workqueue on service rescan PCI path")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260309172443.688392-1-kotaranov@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 3926d18f1840b..cbea0ea242c26 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1934,6 +1934,7 @@ static int mana_gd_setup(struct pci_dev *pdev)
 	mana_gd_remove_irqs(pdev);
 free_workqueue:
 	destroy_workqueue(gc->service_wq);
+	gc->service_wq = NULL;
 	dev_err(&pdev->dev, "%s failed (error %d)\n", __func__, err);
 	return err;
 }
-- 
2.51.0



