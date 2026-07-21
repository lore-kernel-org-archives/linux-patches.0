Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106E03B52FF;
	Tue, 21 Jul 2026 22:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672808; cv=none; b=QKtLtdt+X+9SiKlQHereZxWlb9Ggv+p2V8MtDSuWO5yXlqsS6n7OGg64bKTTlIc134jFR1VNiSLd+adgo0I++GwALLv1W3v6L8lgK5onQ7ThaDkvIRKbNYJsYVfTn5CNW3QAJXT236E/p2AO9KCaOJPmzJAMtga5UFZvNiq+KEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672808; c=relaxed/simple;
	bh=xMnuhMN1CcYRTguKiaI8igmiD4455MedNN00svxfZ1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuD1FvIpYxhsY4pfaV9p+GB6o/qKL8K1Tvv/48u5llE6sl0Azwc4C/Y4SfEWhOuvSxEVlkL5iA3aEGQfZP1hPre4nX9N7UHGIpP2g+YioJ29R8Qzo3mHAu1p7j0wkPQH4Wt23/KCzj4+jmpgiCLavsEXTZbBPDWH/vbjMjw2rOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdWIk6sW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdWIk6sW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749F11F000E9;
	Tue, 21 Jul 2026 22:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672807;
	bh=9V3higYKrcIyuuVJP1Jgayf7W+JzSeJJyuogM6aTN28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdWIk6sWzNsZIEcAgeBXsB8FlEwvgO+RdSGGPYRvmQtghG7yIg87m5/sG3BxvUIW1
	 tql+mWK7cpiBo1rVGgdIdL4olXwTZ5JCOrLTRyuxw7+26GplnfbZ2pHr9iV8YWIyUx
	 UR2iKS3vHKjj9hkQTlhWh7m8JWFf6S0m8p9aL7/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 727/843] mtd: rawnand: fsl_ifc: return errors for failed page reads
Date: Tue, 21 Jul 2026 17:26:02 +0200
Message-ID: <20260721152422.396146569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit f9a13e05a327080c3a1c8165adf9e678fb68fef2 upstream.

fsl_ifc_run_command() logs controller timeout and other non-OPC
completion states in ctrl->nand_stat. fsl_ifc_read_page() then only
increments the ECC failure counter for non-OPC status and still returns
max_bitflips, which can be zero.

Return -ETIMEDOUT when the command did not complete at all and -EIO for
other non-OPC read completions so the NAND core does not treat a failed
page read as a clean page.

Fixes: 82771882d960 ("NAND Machine support for Integrated Flash Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsl_ifc_nand.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -682,8 +682,15 @@ static int fsl_ifc_read_page(struct nand
 		return check_erased_page(chip, buf);
 	}
 
-	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC)
+	if (!ctrl->nand_stat) {
 		mtd->ecc_stats.failed++;
+		return -ETIMEDOUT;
+	}
+
+	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC) {
+		mtd->ecc_stats.failed++;
+		return -EIO;
+	}
 
 	return nctrl->max_bitflips;
 }


