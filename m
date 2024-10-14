Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789EE4595B;
	Mon, 14 Oct 2024 14:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916449; cv=none; b=nIXFopURK9rtJPM3VeIgQ/KPjbzlMvFzWqHBgJZ4R41uOj6nt3bE5rozVw8Ryps0x0c9VnDLE0dHngV+ZHUdj5QSomenuhiB7TbLUJMx10ASGl3stT3z4SYmFbK5EQv1jvinPUIK+JZ4hEjJ7Yeye2K7TzVTU6U2dhQnblihlxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916449; c=relaxed/simple;
	bh=uCnS4DiiRhL6pEezC8AfYVnHbTkAvhI4RtOfLSnxrSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzUPNwEQhnp8uwu2NvuP+ZT6RKFTKrvSGSQtYc+PnwvgNfAlkCEqymMhpsQI2o+F5GGKaCRkLylrPSsd6NxXGCWsApugz3ErOc+F/nXwer6YgYpz6Fxq/2nX3wKWDMBWrB15dqZ753FISqstretddIRH/7nGuzTL+iiyqxw7n2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjbs4TWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjbs4TWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CD9C4CEC3;
	Mon, 14 Oct 2024 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916449;
	bh=uCnS4DiiRhL6pEezC8AfYVnHbTkAvhI4RtOfLSnxrSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tjbs4TWgukgN+HVCncf54dqIDuU22NyWZiiyEOmyXbnxAhkwRZZlHztd/ikKYOip8
	 ZBbg24uYJDRt7eUBIwtIkh/HJbeWpbYTrHdtHVQrA4TJONwC4nUkeqz18ATKc0P6xW
	 iK9R0knF2C+mY3od4zKMd8aJ9UPUJtb6lXc5QP1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 186/214] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()
Date: Mon, 14 Oct 2024 16:20:49 +0200
Message-ID: <20241014141052.238282012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

commit d5130c5a093257aa4542aaded8034ef116a7624a upstream.

Replace manual offset calculations for response_upiu and prd_table in
ufshcd_init_lrb() with pre-calculated offsets already stored in the
utp_transfer_req_desc structure. The pre-calculated offsets are set
differently in ufshcd_host_memory_configure() based on the
UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk, ensuring correct alignment and
access.

Fixes: 26f968d7de82 ("scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk")
Cc: stable@vger.kernel.org
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20240910044543.3812642-1-avri.altman@wdc.com
Acked-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2920,9 +2920,8 @@ static void ufshcd_init_lrb(struct ufs_h
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
 	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
 		i * ufshcd_get_ucd_size(hba);
-	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
-				       response_upiu);
-	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
+	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
+	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
 
 	lrb->utr_descriptor_ptr = utrdlp + i;
 	lrb->utrd_dma_addr = hba->utrdl_dma_addr +


