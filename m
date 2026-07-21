Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB9F1A683A;
	Tue, 21 Jul 2026 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664023; cv=none; b=RSatsLK8h9yh52hv1oHyvAgbV6YKCtgPeaKbPwSze8Wtx5ZrDAm6e6yCGp03p/7r+HtiHpFa1AZYA8fJm1DYxOmjbLOBf1rh6CsNqvDDLcuc16mluO4bdkL6W2yg/Z+T1HrPAszoNLpKOLiVIPyDCe5/UV8zbTEsQ6CvldVx4Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664023; c=relaxed/simple;
	bh=B7I5BykW9o7kuxC/Ef+8667DbPb0ygHtVN4p9SfzYJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6o/tIPBbqZ6RGm4AuMl/AgAKG0wa2q6kZ+1cpYLCmhwX5AEKKYVMYiT1CsqP8ujZnGmG5iqBSbd7Gmac0IZnHgyqqew8Fw3Hb0QcG+ZFRP/262fczQxXKI6Bh34gO3wcehlL8Mv3ZKyFnSKZukqU8+RDQWUh+4nVqwNHFkrR2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3cehrl0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3cehrl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668A91F000E9;
	Tue, 21 Jul 2026 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664021;
	bh=jY/ee1H2ND68u0V2aFkviduomZ6I01EqUUyjCbin3/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3cehrl0ji4Grq4hBZz8PO4M+oH1J3iezzjesjbzzrGlm7u4SpufY5MrUUeN2rJbW
	 Z96csfuc3SdQnueAOpTjq16U3T6WnHUFfqvPY+xN17q8Tzd2RpC4B7d4gTBYsnRmqh
	 SYf6PBbRga6GK0vpgPzm8H/yNUAPCdStreayXSY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 1016/1276] scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path
Date: Tue, 21 Jul 2026 17:24:19 +0200
Message-ID: <20260721152508.737838645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e166bafc483e927150cb9b5f286c9191ea0df84e upstream.

If phys_disk->in_reset is set, the function returns directly without
undoing the resources acquired for the command. Add the missing error
cleanup by unmapping the IOACCEL2 SG chain block when needed, unmapping
the SCSI command, and dropping the outstanding IOACCEL command count
before returning.

Fixes: c5dfd106414f ("scsi: hpsa: correct device resets")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Don Brace <don.brace@microchip.com>
Link: https://patch.msgid.link/20260622160028.1240496-1-haoxiang_li2024@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hpsa.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5031,6 +5031,10 @@ static int hpsa_scsi_ioaccel2_queue_comm
 
 	if (phys_disk->in_reset) {
 		cmd->result = DID_RESET << 16;
+		atomic_dec(&phys_disk->ioaccel_cmds_out);
+		scsi_dma_unmap(cmd);
+		if (use_sg > h->ioaccel_maxsg)
+			hpsa_unmap_ioaccel2_sg_chain_block(h, cp);
 		return -1;
 	}
 


