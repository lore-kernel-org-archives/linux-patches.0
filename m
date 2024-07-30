Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865111A6197;
	Tue, 30 Jul 2024 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356579; cv=none; b=b4h033iZuOD1FnhHIEJXOoXtDZjd12UiQaAAaqchy35GOxtVFn/HqSGcHpb+cPwh+yNQCp35CpAjuYTVzmA2dSiAJ1xa74pbhCH1bzgdW+MpThStvBRkoFJWZTgtF0I1lK2h0sCyfNDIvlACkLCaIApCRs2GzW7L0k2HJV2JqcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356579; c=relaxed/simple;
	bh=wnY5JqX3buzkCVhHWRAzCA/dni9AjDekmU6QC/gGEZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMiSnsz/W9SqNjvy5+PuoOcenS1fg2nM+7PGCG+Z8ls64/3uLYa+3Rvghp0XhI/FExXIaUa+itqzQGft674+dOAxkrTTul94DJSyQBOVpCXv/xkGXUlYBj/tBPwo8ZImUG939Vj46pRzeWYC2ADiM2QgPeTyLgdnY6mLb+W12P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nozq4Y63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nozq4Y63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECF2C32782;
	Tue, 30 Jul 2024 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356579;
	bh=wnY5JqX3buzkCVhHWRAzCA/dni9AjDekmU6QC/gGEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nozq4Y63ENrEdWDBqbdz/3MTDas+lLkWtT4fsbCFsjR9UwzdDOWtCKvkHYg1bZIGd
	 1NYsCx7zSoYTEGN+iJRzkR8uIhEvljvUm2m1r8PKjEz4+ObY1KJ6KM+vmTpA8keVJV
	 Zem1/qjuTAdXkE/wSNB+rzq2MtHAdnAFoOU6+OzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/440] PCI: endpoint: Clean up error handling in vpci_scan_bus()
Date: Tue, 30 Jul 2024 17:47:22 +0200
Message-ID: <20240730151624.029528121@linuxfoundation.org>
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

[ Upstream commit 8e0f5a96c534f781e8c57ca30459448b3bfe5429 ]

Smatch complains about inconsistent NULL checking in vpci_scan_bus():

    drivers/pci/endpoint/functions/pci-epf-vntb.c:1024 vpci_scan_bus() error: we previously assumed 'vpci_bus' could be null (see line 1021)

Instead of printing an error message and then crashing we should return
an error code and clean up.

Also the NULL check is reversed so it prints an error for success
instead of failure.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Link: https://lore.kernel.org/linux-pci/68e0f6a4-fd57-45d0-945b-0876f2c8cb86@moroto.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index b4c1a4f6029d4..3725cdfae1efa 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1032,8 +1032,10 @@ static int vpci_scan_bus(void *sysdata)
 	struct epf_ntb *ndev = sysdata;
 
 	vpci_bus = pci_scan_bus(ndev->vbus_number, &vpci_ops, sysdata);
-	if (vpci_bus)
-		pr_err("create pci bus\n");
+	if (!vpci_bus) {
+		pr_err("create pci bus failed\n");
+		return -EINVAL;
+	}
 
 	pci_bus_add_devices(vpci_bus);
 
@@ -1355,10 +1357,14 @@ static int epf_ntb_bind(struct pci_epf *epf)
 		goto err_bar_alloc;
 	}
 
-	vpci_scan_bus(ntb);
+	ret = vpci_scan_bus(ntb);
+	if (ret)
+		goto err_unregister;
 
 	return 0;
 
+err_unregister:
+	pci_unregister_driver(&vntb_pci_driver);
 err_bar_alloc:
 	epf_ntb_config_spad_bar_free(ntb);
 
-- 
2.43.0



