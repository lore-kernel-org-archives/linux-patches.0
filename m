Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D261CACC8;
	Mon, 14 Oct 2024 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917241; cv=none; b=PpgghkQ8HmTfgfwIW8ZCC1/ncHu30kKKdGgZ7OxgrMTseGLwDWrE9X4E0TK/OTKOkdXyBudZjO/zzfvi0SrdWsmKS8AlIe3EB5tuRQFJVj3dbasmEePdLuG3W0gymVE7LHtwQNTMSu15CaI7lLyIT3h4P2biOFTTaTb+9I19jD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917241; c=relaxed/simple;
	bh=7H44emfYO7KvLz9Cos3DU5nHDTCmqkRII/DzoIKFUoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+OSdnM4TyPKPY7GJDJdHhecbEw4cfwA+o+bRD1e3VtYP4mmVuJwomAbur1zvtBCVDS06XEe2mUQk4m0BLpJRTnsL6bITWbXdkipQgORKV509sZnChNstAeZnb5qhLuyag9rxN4EkuGStxX+gABAVzeJtfF4tveNYMZzfT7bW54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8ewIf6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8ewIf6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0888CC4CED2;
	Mon, 14 Oct 2024 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917241;
	bh=7H44emfYO7KvLz9Cos3DU5nHDTCmqkRII/DzoIKFUoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8ewIf6fCJnDA9sYYCPs8hZl3+vx9oR1l+YnMWVbPYq8gCIStuHflMN7IU+4Ps7sy
	 a8a4FvSlY0vCvB4QwV/FMqgzq8Zgh+KOBI6vxTdPXAZo80/0EFXBdvHyMgJ1pIh9yI
	 XRQ9jinIv9bJ/aWb8uwleUVSuJiEnpWeYuyFPR1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 193/213] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()
Date: Mon, 14 Oct 2024 16:21:39 +0200
Message-ID: <20241014141050.494150524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2804,9 +2804,8 @@ static void ufshcd_init_lrb(struct ufs_h
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


