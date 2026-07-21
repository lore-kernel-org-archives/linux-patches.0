Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D400E46D09E;
	Tue, 21 Jul 2026 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655370; cv=none; b=GhkR9ixsBo3WVTH1JFhiOqsMPnp0Bcx0H3UGUqFvAmd/vWKvLOwRjGEq81r5O8bEG0pVQ/3wzZrwnuoP6mUWvxL6S+2sCGn8Xw8KYucmAd2IZAkOSHIjfCJ7Ue4IoVOK9W9DaH+yOB5/r/eA49ArXnGkjjQq2ZaVPsKdDT7RzYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655370; c=relaxed/simple;
	bh=XMv6ZReD3UF4LL8j1I7jH0x6D5rvYMsKNvagf8RTo6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWjk7Dy/aPNSdMNJnr+PgF9pMMKWqi7dopO51iicYyaiDrEnVEv3ljMIDZIp4wWo3dWScNdsHwH/1ZW4rztU763nc+rovbckPgfEklzzhxRcmgcFYtU8Co64EflQpOj2N7qP4M5YMc8s17qNi8SyzBc4lAJ9oZQkJfpUP3jRneY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S962Cfrs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S962Cfrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4764B1F000E9;
	Tue, 21 Jul 2026 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655369;
	bh=yeBBP54lPiUWPlyluxqEqDcuZyO82w4lDB044LgWr0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S962Cfrs6v0ZYmzO0L8y91L8pMSA42FIMtme3ssgqAWaxentqRdQ8pkuUA/Dgb5E2
	 4OW6o5+IIZvt77pcBaYlue4MeIZcL+Xeoi7Yop3/HUy4cDq+LwMXIa05rasDdJ3Nst
	 b/I3M6kWOcUQUh8vTBtu7v/4UXgushbdr9xxL1KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 2031/2077] mtd: rawnand: fsl_ifc: return errors for failed page reads
Date: Tue, 21 Jul 2026 17:28:24 +0200
Message-ID: <20260721152640.601523437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -684,8 +684,15 @@ static int fsl_ifc_read_page(struct nand
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


