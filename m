Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71175471262;
	Tue, 21 Jul 2026 18:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659392; cv=none; b=vCnRalrKDAbXW8LCNZRlM8Hw9QhAbXkG/o4BS7ngCQaA9oMN5rw/nWdyJmRziYGYlbZqrN7ndQHaXOpT9yxrMQhgE0N3lQw4RtzBS1UaIyBngHyRKH2f3hQpvu7OrKBxQfkeE9zfYIMvXqab+Fr28bf6K4wE2+yC/eiZ7QPCMYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659392; c=relaxed/simple;
	bh=B3gb/t2ERIXDTQWpzchVSGjgqcAFpVK5kTuVXc5q76U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj2zeF3sKdovDR6pd1QCZiMWbFZ+e+X9ddYHlgMhqGzatqPPbXcJoP3YRAkB9NI5ApYYRLkth8LKeLlhY7YN+iJuOw3wzsKfEFPg7beu1wD/FaMUiCKNXaH/ruzlYoHMWypdTS0+QNhA1scNPPa6sIiFpjn75ESxblSAyhRtlhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jd5htVbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jd5htVbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C7F1F000E9;
	Tue, 21 Jul 2026 18:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659391;
	bh=avefa/jDnxe6F/C/cVSLnBRWLFLM/q+8ee/ODWYeVNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jd5htVbHvNV1nogHEoW7st2Trq1LG/Gsw0C9MlG64XrEy9BDz4R1s9ISn5CXF7Exd
	 38iQiJ3PAGJHemC/1LNLhq58zQybd4cAjw5z7YhI+OZnDgdRY6AtsarBgLpZvc/yCR
	 nO3aE2Fvc8FvEiVJjN9iy9vOERGq62khk1GbDGrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 1503/1611] mtd: rawnand: fsl_ifc: return errors for failed page reads
Date: Tue, 21 Jul 2026 17:26:59 +0200
Message-ID: <20260721152549.247740934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


