Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE1231C91;
	Fri,  9 Oct 2026 14:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556341; cv=none; b=vCa3+TaqW6l6wojeDfjeORoslGYNvI1YI7jrtdBpVgDQ3ftHUqtM5WlmGFotz3xWbef49suwOKtruay+Db8XbLbc5iOKWh9T26Bk0F0rBPINN2NnNYppVfUamrL/k02NjawnYFNtf+nhH4L+OhMCt5PSN11NM4XjN3BDjZS38VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556341; c=relaxed/simple;
	bh=KL1pYGPlWQaZk1S0D5ilZpPNDNRfqrRYH/8t4qVn1Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8s6OlRlCw+n4sA1QuuZnPADCOwrFrscfIM0OCCPAfpj6FcSDteEhTtJ9N4BFqwTUxQbBADvFkAuUt6kDAWf7mnTxIonkBsUDdH53TMY+TNgQvqiWTzwmKSa5mBlqRBjO77epWweIDg8QJ+UjRnY44qDh8ciE0s8EeFVTopThhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrYQAzgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrYQAzgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807791F000FF;
	Fri,  9 Oct 2026 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556340;
	bh=5xemPlx7SW5gwogTg5rpV4tDoLzw2WMs8eKaYTaD8bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrYQAzgSS5PwHdkR2Ccb5D83Nu3g9TUQMmkfu5S+Wkb6WE5CAOC91duu3xOkfG67t
	 T0a97MoXuQGCHAhq97m0ukSQDDvrxfEIRGCo3OaaO8edXEhtjqFlLc8WT1J2b/jR5y
	 7oC2mwE6fiOaFRQwYgHephWJPgqeiEB0yrCgaW3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 218/403] EDAC/altera: Do not allow driver unbinding
Date: Fri,  9 Oct 2026 16:09:39 +0200
Message-ID: <20261009140957.242813331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Dinh Nguyen <dinguyen@kernel.org>

commit 19a4f1a6ed00286d70229f4fd5f690cc2fb033dc upstream.

The driver must remain bound; unbinding and re-binding it would erase active
system memory.

Remove the .remove functions because they will not ever get used.

Fixes: 588cb03ea208 ("EDAC, altera: Add Arria10 L2 Cache ECC handling")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260911120627.2634225-2-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -453,15 +453,6 @@ free:
 	return res;
 }
 
-static void altr_sdram_remove(struct platform_device *pdev)
-{
-	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
-
-	edac_mc_del_mc(&pdev->dev);
-	edac_mc_free(mci);
-	platform_set_drvdata(pdev, NULL);
-}
-
 /*
  * If you want to suspend, need to disable EDAC by removing it
  * from the device tree or defconfig.
@@ -481,13 +472,13 @@ static const struct dev_pm_ops altr_sdra
 
 static struct platform_driver altr_sdram_edac_driver = {
 	.probe = altr_sdram_probe,
-	.remove = altr_sdram_remove,
 	.driver = {
 		.name = "altr_sdram_edac",
 #ifdef CONFIG_PM
 		.pm = &altr_sdram_pm_ops,
 #endif
 		.of_match_table = altr_sdram_ctrl_of_match,
+		.suppress_bind_attrs = true,
 	},
 };
 
@@ -517,6 +508,7 @@ static struct platform_driver altr_edac_
 	.driver = {
 		.name = "socfpga_ecc_manager",
 		.of_match_table = altr_edac_of_match,
+		.suppress_bind_attrs = true,
 	},
 };
 module_platform_driver(altr_edac_driver);
@@ -803,22 +795,12 @@ fail:
 	return res;
 }
 
-static void altr_edac_device_remove(struct platform_device *pdev)
-{
-	struct edac_device_ctl_info *dci = platform_get_drvdata(pdev);
-	struct altr_edac_device_dev *drvdata = dci->pvt_info;
-
-	debugfs_remove_recursive(drvdata->debugfs_dir);
-	edac_device_del_device(&pdev->dev);
-	edac_device_free_ctl_info(dci);
-}
-
 static struct platform_driver altr_edac_device_driver = {
 	.probe =  altr_edac_device_probe,
-	.remove = altr_edac_device_remove,
 	.driver = {
 		.name = "altr_edac_device",
 		.of_match_table = altr_edac_device_of_match,
+		.suppress_bind_attrs = true,
 	},
 };
 module_platform_driver(altr_edac_device_driver);
@@ -2218,6 +2200,7 @@ static struct platform_driver altr_edac_
 	.driver = {
 		.name = "socfpga_a10_ecc_manager",
 		.of_match_table = altr_edac_a10_of_match,
+		.suppress_bind_attrs = true,
 	},
 };
 module_platform_driver(altr_edac_a10_driver);


