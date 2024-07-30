Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E5A1E86F;
	Tue, 30 Jul 2024 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359152; cv=none; b=DXOtAAL1xv1cjm+uFkqZgVwAuWQCxm7BqlABiHDKkwchv+EQV+bzYFMTP/vrff+LocyD3aq4BXlBaGCagzhizIgpFCMjaDkT07WL6yOC8bV3dwQWMzvayIiIdyo62BnMmC+O1hJREaAoK55GWXvvj5/4OGdmwJdjMdf8H5FNSBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359152; c=relaxed/simple;
	bh=Y/2XbTHug7uQw4GVhJ4kpaz+oikuGbVjNhR+ckFCP6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlW9nZ3W4Swk8lWvtqvCHQv6xJaytC/1FUZMQmr7PNJ3zS14I3WU6VHeFxSF2lFsFQIOsqP6e+Vz28yglhHeeNP005biWe1ljHT7Pk3wMNWjAvJ3xkOxvvG4UKThxyf+crFMLEoz6RCQ6M9fjQzk7SgZMJ83eQtI9kKdn44/mJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryoxetvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryoxetvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297BDC4AF0A;
	Tue, 30 Jul 2024 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359152;
	bh=Y/2XbTHug7uQw4GVhJ4kpaz+oikuGbVjNhR+ckFCP6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryoxetvy7dNNSXVHHROb6AHxqdz/KZUlWnK5PGNV0riyEFQWZ+DV+ISpm3b3Xp93H
	 pifjhjvLIMPSrDXgAMDllSbOwoJL9qtAeMbhxrxLWcKa6bPez44PqfMBkqRE6y8ZTY
	 i8x5R5AMYvSJHKp/L7/efaDOARq59GFq/ncEn75I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 443/809] PCI: endpoint: Fix error handling in epf_ntb_epc_cleanup()
Date: Tue, 30 Jul 2024 17:45:19 +0200
Message-ID: <20240730151742.200043002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7f05a44e9a9fd..874cb097b093a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -799,8 +799,9 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
  */
 static void epf_ntb_epc_cleanup(struct epf_ntb *ntb)
 {
-	epf_ntb_db_bar_clear(ntb);
 	epf_ntb_mw_bar_clear(ntb, ntb->num_mws);
+	epf_ntb_db_bar_clear(ntb);
+	epf_ntb_config_sspad_bar_clear(ntb);
 }
 
 #define EPF_NTB_R(_name)						\
@@ -1337,7 +1338,7 @@ static int epf_ntb_bind(struct pci_epf *epf)
 	ret = pci_register_driver(&vntb_pci_driver);
 	if (ret) {
 		dev_err(dev, "failure register vntb pci driver\n");
-		goto err_bar_alloc;
+		goto err_epc_cleanup;
 	}
 
 	ret = vpci_scan_bus(ntb);
@@ -1348,6 +1349,8 @@ static int epf_ntb_bind(struct pci_epf *epf)
 
 err_unregister:
 	pci_unregister_driver(&vntb_pci_driver);
+err_epc_cleanup:
+	epf_ntb_epc_cleanup(ntb);
 err_bar_alloc:
 	epf_ntb_config_spad_bar_free(ntb);
 
-- 
2.43.0



