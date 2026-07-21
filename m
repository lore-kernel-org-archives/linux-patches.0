Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F895298CC4;
	Tue, 21 Jul 2026 22:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672535; cv=none; b=q5soMTzKpVzBzuk8cg3eGq2/00ZHKDEcC/LCmGA/Wa2YFBxLjWI8UmhULt3EroEpELu1BnV6xAqjA3G6c3OTXaSD6nq1eT+tuBb5vIXwKmABjqDJdbi65spiAHezFmbvDeaMQuytooKfVyIUpAY0HG9jAE8QMPnibO73MrAn0LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672535; c=relaxed/simple;
	bh=8Wssx8XhRCfk+1aoq/Bx/BmGgNwbtLIhO9JZSPUby2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0JEIAHH8UfDw8JR3pGDQWdqK7V7D7M5dX1S9rxbEXsRZupgBs7RBW0m0VYaeGc8PmHLzFfZqfMVYkNYPLTMiNKp10Ulc5xIQzCd4uXuVo7LOeZ1MP5tHTfsZAaMFMNmxskEqwfk+Htp1k/IXwX2UobkvmyUvhwG5FQzmKu6UG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kzO8tnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kzO8tnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64AF1F000E9;
	Tue, 21 Jul 2026 22:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672534;
	bh=fqmoDH2srTxycJiAoqwxLgisrPtCmtpj4UbbarbTznc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kzO8tnS4etL80dbl6r1vVSFWIxqC8DNQLZWzGRneRqFbf14Pd9uVeubTNdccunGR
	 /dreNPmxC9kliCwMESiJY88InJ7BD8PaAYJW/JaBWJ7vR74C0HRbdFbbOU6OJukJwS
	 f/AH7DuKZJGPQ7zTEDE3nz9Ot6xpKLKJu+BJO5Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 660/843] scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path
Date: Tue, 21 Jul 2026 17:24:55 +0200
Message-ID: <20260721152420.911329071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5029,6 +5029,10 @@ static int hpsa_scsi_ioaccel2_queue_comm
 
 	if (phys_disk->in_reset) {
 		cmd->result = DID_RESET << 16;
+		atomic_dec(&phys_disk->ioaccel_cmds_out);
+		scsi_dma_unmap(cmd);
+		if (use_sg > h->ioaccel_maxsg)
+			hpsa_unmap_ioaccel2_sg_chain_block(h, cp);
 		return -1;
 	}
 


