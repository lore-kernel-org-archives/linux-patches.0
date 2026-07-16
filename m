Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8D433BDE;
	Thu, 16 Jul 2026 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212391; cv=none; b=SeTanUMw/mr22YVjdrqSPUjm6sJH54Mdte+QolmaUf5SKKR/dq0ofyckuLMAbk0IN2/o1tuK+B3umAmvoloI5gyJljkCnVpyJKfKsr6dyAlYCeanyq20x3hodoQG+PHdnRplZgwoBduVIVDoND7w562prtl2rbu3pKFPxvkFmmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212391; c=relaxed/simple;
	bh=akvRBUNIdq7R/tRIuRAJ0k5LrBn6OnsO+bDv3z22cwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0MyxHr1S3hyaFfr/nQsuIhrjYemwYFDvf2nLK+LtcAJZWP2rOWtpPdeR+nM/kqTglGMwjEvqwCPtJ9XEFkzlYMeACbwKwrhP0/vtPMlfBjVyLlufcYqLkrDkq2tdfJ8SIC6CJjbjpRPB46kuBvVKKzt4lIJGYuKSngnQRfo0zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8ekEZa+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8ekEZa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C20D1F000E9;
	Thu, 16 Jul 2026 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212389;
	bh=jCbox+FOQS2m/7rYJ049DCEa+EXrExg1of7fnaDdrFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8ekEZa+/76Z4uwvx3zXNsACGhqgWRQjdv3J+Z+m2Hb+H1o0iCqzvZVB1jRlHfqSy
	 7+Yvyy+KzLKz8/zM2I5tzFdfGMWwInWHyyOh8EOQDLRoPXWF09OBTuw7jGqa4PpVwN
	 YZybExL97P3U2mFfpdsu9x8lPuuyiRLDF4PVUCaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.12 309/349] NTB: epf: Fix request_irq() unwind in ntb_epf_init_isr()
Date: Thu, 16 Jul 2026 15:34:03 +0200
Message-ID: <20260716133040.231775693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit fcba26efe5efc7441f5505f4ccc69791214b40be upstream.

ntb_epf_init_isr() requests multiple MSI/MSI-X vectors in a loop. If
request_irq() fails part-way through, it jumps straight to
pci_free_irq_vectors() without freeing already requested IRQs.

Fix the error path by freeing any successfully requested IRQs before
releasing the vectors.

Fixes: 812ce2f8d14e ("NTB: Add support for EPF PCI Non-Transparent Bridge")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Cc: stable@vger.kernel.org # v5.12+
Link: https://patch.msgid.link/20260304083028.1391068-2-den@valinux.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -357,7 +357,7 @@ static int ntb_epf_init_isr(struct ntb_e
 				  0, "ntb_epf", ndev);
 		if (ret) {
 			dev_err(dev, "Failed to request irq\n");
-			goto err_request_irq;
+			goto err_free_irq;
 		}
 	}
 
@@ -367,16 +367,14 @@ static int ntb_epf_init_isr(struct ntb_e
 				   argument | irq);
 	if (ret) {
 		dev_err(dev, "Failed to configure doorbell\n");
-		goto err_configure_db;
+		goto err_free_irq;
 	}
 
 	return 0;
 
-err_configure_db:
-	for (i = 0; i < ndev->db_count + 1; i++)
+err_free_irq:
+	while (i--)
 		free_irq(pci_irq_vector(pdev, i), ndev);
-
-err_request_irq:
 	pci_free_irq_vectors(pdev);
 
 	return ret;


