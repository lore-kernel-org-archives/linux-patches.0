Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701311A6166;
	Tue, 30 Jul 2024 16:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356589; cv=none; b=ZNf+nD3H5EeuKX1dD0vpBUqrnEHHAsvW2RpxOjTOqoIanlDPd54znDzQD4phxxlVszE31X2pmsbeTG/Fvv3BzmZTmRKmfNYg/nj102FVb/L5U3whdqVLwqa91XeGCSW6TcZwKT8J3FQiUy6DwxOORymcy1hvl3XfU4VlkRQ9hcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356589; c=relaxed/simple;
	bh=4g/11zIT4BspPKYLwG8yQ8Ng3MMV2Pfq3LJSP4diT3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEwBZzgpodYGdYL/GHn0ivKVXskNGFoj4ktrcZjTggQPWLTOIxN4l7xVxVZo9U7xx7PB1rB0npYFIm0hZF/oR7pXRJS2LOiEh4AEJl/QJxKnqqb53QoIb3clbDOO3R+HUd8v8jgkQTUndFvuB1N8906XXRjri0tnoQ14MbYefl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwQfwJGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwQfwJGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDFAC4AF0E;
	Tue, 30 Jul 2024 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356589;
	bh=4g/11zIT4BspPKYLwG8yQ8Ng3MMV2Pfq3LJSP4diT3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwQfwJGMi/vSosTbK6QKIRuO5kYoOeBNHQlryzC4aaqWUVTNjTgjFy+2dJfxFBR+K
	 AdB/mvun5cKSmv+27JkC5Po9UJ674GaDAWPBJsPwxDSaMY+wWCmwGuOCnvikre7EXb
	 o65Bo7fEoOVMrNSf9cDpXUneNog9JcXyx2/tUCJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/440] PCI: endpoint: Fix error handling in epf_ntb_epc_cleanup()
Date: Tue, 30 Jul 2024 17:47:23 +0200
Message-ID: <20240730151624.067640950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3725cdfae1efa..6708d2e789cb4 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -813,8 +813,9 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
  */
 static void epf_ntb_epc_cleanup(struct epf_ntb *ntb)
 {
-	epf_ntb_db_bar_clear(ntb);
 	epf_ntb_mw_bar_clear(ntb, ntb->num_mws);
+	epf_ntb_db_bar_clear(ntb);
+	epf_ntb_config_sspad_bar_clear(ntb);
 }
 
 #define EPF_NTB_R(_name)						\
@@ -1354,7 +1355,7 @@ static int epf_ntb_bind(struct pci_epf *epf)
 	ret = pci_register_driver(&vntb_pci_driver);
 	if (ret) {
 		dev_err(dev, "failure register vntb pci driver\n");
-		goto err_bar_alloc;
+		goto err_epc_cleanup;
 	}
 
 	ret = vpci_scan_bus(ntb);
@@ -1365,6 +1366,8 @@ static int epf_ntb_bind(struct pci_epf *epf)
 
 err_unregister:
 	pci_unregister_driver(&vntb_pci_driver);
+err_epc_cleanup:
+	epf_ntb_epc_cleanup(ntb);
 err_bar_alloc:
 	epf_ntb_config_spad_bar_free(ntb);
 
-- 
2.43.0



