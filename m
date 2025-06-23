Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10D52236EF;
	Mon, 23 Jun 2025 21:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713453; cv=none; b=ZWGo8B4hwpv7Ll4r5VGVxLdTkMCm1Wk/1Kx2x+he0w1lAl1c9AjgVeDl2sVdvOuzm+I8AXWfmJgIdEFNTIpgf0OsojLDOukycQUNfhmb77n5fPUZC9A1FYuZXiq9yDnZ3HjJdzC9LfOvz/ry9V9k/4v54XMKcKu/vHjcpssEfdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713453; c=relaxed/simple;
	bh=e6vfMvgjGyrHiejPiHzmCVcEMGQJyBDSUajrTwiQ1AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giCqgU0rSq56ZelifALcXaq7/NY4X9jrjb3BkEW5UZbCLN8EuzNmQQIwKA7vU8Za/IFITdV1gU0udl0VgPApzVrgmFPoKIETXcyeLbeMQZWAuElyWF7a8BwoTHOus1GGI5xAvSdqR6xFBXjU5NMFviI1sMPHiFJg1QVr0Ru0070=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Szn+M2ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Szn+M2ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38270C4CEEA;
	Mon, 23 Jun 2025 21:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713453;
	bh=e6vfMvgjGyrHiejPiHzmCVcEMGQJyBDSUajrTwiQ1AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Szn+M2eap4UH4O5wsD+V46svmH07jQpOeX4TGiynjMdYWFgfg0mkzCdD+ScEg6s4Q
	 6D/L+u1e+dIAsDkWdqnG2TH7y35TSBhkeIkxT1sDbUlb67tef/e+L8wWYSDssE4jaH
	 9LV//VU5qNJ2mmXK94b6J492WCvBOihBRNkbZ8GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Lakshmi Sowjanya D <quic_laksd@quicinc.com>,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 091/290] mtd: rawnand: qcom: Fix read len for onfi param page
Date: Mon, 23 Jun 2025 15:05:52 +0200
Message-ID: <20250623130629.711402471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Md Sadre Alam <quic_mdalam@quicinc.com>

commit e6031b11544b44966ba020c867fe438bccd3bdfa upstream.

The minimum size to fetch the data from device to QPIC buffer
is 512-bytes. If size is less than 512-bytes the data will not be
protected by ECC as per QPIC standard. So while reading onfi parameter
page from NAND device set nandc->buf_count = 512.

Cc: stable@vger.kernel.org
Fixes: 89550beb098e ("mtd: rawnand: qcom: Implement exec_op()")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Lakshmi Sowjanya D <quic_laksd@quicinc.com>
Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2917,7 +2917,7 @@ static int qcom_param_page_type_exec(str
 		write_reg_dma(nandc, NAND_DEV_CMD1, 1, NAND_BAM_NEXT_SGL);
 	}
 
-	nandc->buf_count = len;
+	nandc->buf_count = 512;
 	memset(nandc->data_buffer, 0xff, nandc->buf_count);
 
 	config_nand_single_cw_page_read(chip, false, 0);


