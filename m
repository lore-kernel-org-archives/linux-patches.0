Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01084746A8;
	Tue, 21 Jul 2026 21:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667670; cv=none; b=emcsLzTskdfiggSYcfd+tzTSNYBT63515Bn8N8Tr2q67vJRudxcnLTeGCFKwipDYwBXzP6pbE8tXoAIutMwwnRhA+HcI1VJrUoH8IJvRachPbzGZYzY28QvvSsDBP91wfh+DekfALgp4gpDJbM6lNjgPIGLmU4iXfHc6ViR7ZZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667670; c=relaxed/simple;
	bh=6Zc2ffhuKIw14HUBKaDgnHw46gkOBGPeX1QzHC/cIAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ8ueCQFaEwj6B27eVhI1RNWmkWoDaZGkoCIWzTTF9C2AK79PAEhHB1Ab4nmc73s9nDebyaCVUh8t5KKR4YdsEudXSoLDCOq88l/v7n8caqY0vJOGVOITwk10sFmvNGuA6GXQ//IDEnFest/lcmbS2XaelAsq8xCurcP7RMosx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWE/jW+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWE/jW+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAAF1F000E9;
	Tue, 21 Jul 2026 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667668;
	bh=YYrzCCLJqQyEVtV72Ohe0ZLyhrGqXOWgT2FTM9pL9WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWE/jW+It/qkajpzDdx839SBYO57cJHjdqKP+79+xve+UKfrJUQoh5cK6jjA7xVi1
	 Zq44+l9jn/gCZUG0xdePRbxtCNn+Espoe3mWOkmAov9JFyzG88w9iWqUQMNX0YrpdV
	 Q20TL8HKK+Pk85Q7CQDeFASyCro5GYysJPLIZFAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 1146/1266] mtd: rawnand: fsl_ifc: return errors for failed page reads
Date: Tue, 21 Jul 2026 17:26:23 +0200
Message-ID: <20260721152507.429829714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -683,8 +683,15 @@ static int fsl_ifc_read_page(struct nand
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


