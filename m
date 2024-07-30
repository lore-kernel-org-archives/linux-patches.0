Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB36F757FC;
	Tue, 30 Jul 2024 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357921; cv=none; b=gG72yfTXO6u16sDAOGsPr67yf5EDmqs1NFbXMnZ8enCAuSf/UHIcLTzXWrAfAUodSE7Rv1klEPkVGGgT7mFkm6laV7P14rPeYUZrPizB9euOm77S13ssR4iG7Sj1yNWJHLnDm8pbXnfTc4kylErZGE5aI/j6+0YrR43s9/ZXiOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357921; c=relaxed/simple;
	bh=E2Bqsep+WYpAplFqRh4LaT/Ssz9rs6aE6CgIkBSEbKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwI1y2mmPxO4C9RIxnSOYW9fkzpxl/8V0gCieS9744PQkOLIFE4US0L4EL0deXQq461FLyU1oT0rKPmIqA5GH+Kaqv/YTE+AJnv8IuXDrYrFtcR1hg8hjcFzrufuyoM+u9rbLJS75+ziK16GHqELAzxCDWPxBKbOEEIItlc8BBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWT7BNep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWT7BNep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274E4C4AF0C;
	Tue, 30 Jul 2024 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357921;
	bh=E2Bqsep+WYpAplFqRh4LaT/Ssz9rs6aE6CgIkBSEbKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWT7BNepz8W8OINOyYgRC5zBEmYNtON9zd/uusD1PBPPo+/sbYT1Rdd9Ejn++5tQh
	 TA6MHr2McqkmjIaFc3V6ZTV6CM71jB5Pu3GUFIzhklHvAHjdS2hvOhKJxIVLOCrOtz
	 Qg/Uzoa/dpKDfUQRodH5Oe9RgpjerAYVD3rni0AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/568] PCI: endpoint: Fix error handling in epf_ntb_epc_cleanup()
Date: Tue, 30 Jul 2024 17:46:33 +0200
Message-ID: <20240730151651.051558142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6bba3c0ac5dc54737998a0982b2e272242c87e0f ]

There are two issues related to epf_ntb_epc_cleanup():

  1) It should call epf_ntb_config_sspad_bar_clear()
  2) The epf_ntb_bind() function should call epf_ntb_epc_cleanup()
     to cleanup.

I also changed the ordering a bit.  Unwinding should be done in the
mirror order from how they are allocated.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Link: https://lore.kernel.org/linux-pci/aaffbe8d-7094-4083-8146-185f4a84e8a1@moroto.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 1a4cdf98df703..3368f483f818d 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -810,8 +810,9 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
  */
 static void epf_ntb_epc_cleanup(struct epf_ntb *ntb)
 {
-	epf_ntb_db_bar_clear(ntb);
 	epf_ntb_mw_bar_clear(ntb, ntb->num_mws);
+	epf_ntb_db_bar_clear(ntb);
+	epf_ntb_config_sspad_bar_clear(ntb);
 }
 
 #define EPF_NTB_R(_name)						\
@@ -1351,7 +1352,7 @@ static int epf_ntb_bind(struct pci_epf *epf)
 	ret = pci_register_driver(&vntb_pci_driver);
 	if (ret) {
 		dev_err(dev, "failure register vntb pci driver\n");
-		goto err_bar_alloc;
+		goto err_epc_cleanup;
 	}
 
 	ret = vpci_scan_bus(ntb);
@@ -1362,6 +1363,8 @@ static int epf_ntb_bind(struct pci_epf *epf)
 
 err_unregister:
 	pci_unregister_driver(&vntb_pci_driver);
+err_epc_cleanup:
+	epf_ntb_epc_cleanup(ntb);
 err_bar_alloc:
 	epf_ntb_config_spad_bar_free(ntb);
 
-- 
2.43.0



