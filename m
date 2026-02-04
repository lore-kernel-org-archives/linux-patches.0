Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875D341B37C;
	Wed,  4 Feb 2026 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218714; cv=none; b=sDTYkOLx5MzQQs+OvK6hy0HC2SPQwM2XKg9hEw+ig5oCHaUHsUZTT3NCeKLQYzqiX4kcNaMRlqyHEXZzeqtu8KCSzXO8pACundxv102ybEEdowa1HfZw2CFH1m+bEeOWzUDF6W1UqpvHdy+QLLfEq4kWEe2ncAhNFo9F4B1FzhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218714; c=relaxed/simple;
	bh=2WB49iVBKYJyh1VUsQEa0nEI7PNqyZAUW4GcK/WEcHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc+Uog+7ZxAYSg0zkvnOthEaw3tkJnFOOEq6QaJvL/PgwZ+iopoBn+vQDEfn1J4MF7lCnxWDPdHgdIbJRW/beM//RxKfsJJJC8rNubrIXtlvI4g428hgrld8m1ihiPAkEP6MoyhZzSPotmuBHKt09rASn2w4d2Baw/TueEB9TrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yon4PdKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yon4PdKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3E7C4CEF7;
	Wed,  4 Feb 2026 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218714;
	bh=2WB49iVBKYJyh1VUsQEa0nEI7PNqyZAUW4GcK/WEcHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yon4PdKuKGjTX47zBjJVVOHt5us29Rtg/tg4sTr8Km6VvCfKyoF1fwF7PrxSO1m32
	 DnE3ncW+iHuSLPafJzNgAlTfLxrcSxH31ft1ZFZch1OzLAddBKf9/EaxJDFR34fUhd
	 PFnXGDI4ftnPyqkY/Po/fUhy+AdN2n4ZLXyTtF8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 39/87] scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()
Date: Wed,  4 Feb 2026 15:40:37 +0100
Message-ID: <20260204143848.320332758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 4747bafaa50115d9667ece446b1d2d4aba83dc7f upstream.

If nonemb_cmd->va fails to be allocated, free the allocation previously
made by alloc_mcc_wrb().

Fixes: 50a4b824be9e ("scsi: be2iscsi: Fix to make boot discovery non-blocking")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1025,6 +1025,7 @@ unsigned int beiscsi_boot_get_sinfo(stru
 					      &nonemb_cmd->dma,
 					      GFP_KERNEL);
 	if (!nonemb_cmd->va) {
+		free_mcc_wrb(ctrl, tag);
 		mutex_unlock(&ctrl->mbox_lock);
 		return 0;
 	}


