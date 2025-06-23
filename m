Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546F423A9BE;
	Mon, 23 Jun 2025 13:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684695; cv=none; b=G7PaXAXN3EdkM0uVGC//Q1+qC1vqH+qqEmeXQR/3SYtH6AmttXjtdjo3/qA29n2KD7wHbsjZ5OuLLnOUl24pO8nc78hyFNU0uKPGrWzLuKa+8/2Th4TnPdHQNugRBawvvgIxv/2K/0Y9P8rBhpnJ0nok3UbxrxnEyYxmylCdMGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684695; c=relaxed/simple;
	bh=LJECXWd+5pI0qs/jWq2Wnsl/VzXqSN/xGq8lf/nhe5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdWNcXU6ikOKWKw2CPkaM1BkrtjbePOJYKGf103u6SMXo0yEItiUxDU4uCqai4Kb1XsB2wpi17g/3WfSkIkP+td8NDQG3IsjpXeWzoZ6BwXNhoinQYRTddvN/AeXjHyWVWLSHRn+N5Rbq42miyq665PzrMUC6OWo/XsRQnGBLng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbHa7KLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbHa7KLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765FFC4CEEA;
	Mon, 23 Jun 2025 13:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684694;
	bh=LJECXWd+5pI0qs/jWq2Wnsl/VzXqSN/xGq8lf/nhe5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbHa7KLkRJjz8cVjr0SNFdbcCEk2nb5dfhfmUXV1pnc+XE1cdtkD7CTMLTSOExxcY
	 DWdcErn0GwnmdiJeIgw2vDgazj2MSVC+mpgpYQK/OgIE8jfpCipiQH9BfuncV6crl6
	 J8JBdHlTCYoU9X7AaSvDq81Q6iD74VaU16Tbf6nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Lakshmi Sowjanya D <quic_laksd@quicinc.com>,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.15 155/592] mtd: rawnand: qcom: Fix read len for onfi param page
Date: Mon, 23 Jun 2025 15:01:53 +0200
Message-ID: <20250623130703.968630462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1930,7 +1930,7 @@ static int qcom_param_page_type_exec(str
 		qcom_write_reg_dma(nandc, &nandc->regs->cmd1, NAND_DEV_CMD1, 1, NAND_BAM_NEXT_SGL);
 	}
 
-	nandc->buf_count = len;
+	nandc->buf_count = 512;
 	memset(nandc->data_buffer, 0xff, nandc->buf_count);
 
 	config_nand_single_cw_page_read(chip, false, 0);


