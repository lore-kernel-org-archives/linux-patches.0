Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692003B8412;
	Tue, 21 Jul 2026 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670223; cv=none; b=hpYLHy0lYp15Zj77vByY3d6kyVxumwIwo3eF7Y6BVJ8Jfft5djJ/tLOI8Cb5vBu+IQ9TFFPlIB6l3EmFkuRlNDhL+vQ2D6RnNRQnp4uC8jGRR4zdY1lzENciQuK/JhnuzYa3TpRHVEe+Y0lBKnr2o+AYgSS8rOuc8Qv/sL5uBaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670223; c=relaxed/simple;
	bh=Ya+UdjiVhV5FLsnPsJtUDunmG5WyrkVVYQiUQxySZJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quCVSR5FHpMLoPh5PSKUoO6vJBn+ZjAd7koR9kOkQhxZuxg2W0kjx9kEQWtFk0csUWD3anNxmmuDjSsR0syyNqrJy554L5ySN5uWLrD340qezaPWza8BN3QTGsVhxfKAzH4Wyaj80HtF9duwB5G/rYKnjugmDFPEyc6YNU7MBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN1Jq35H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN1Jq35H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BB01F000E9;
	Tue, 21 Jul 2026 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670222;
	bh=H81WrexuUigwCAfc2ADaD9BaI/aXJnUlQB5vcFbm4Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VN1Jq35Hq2eqUC0xe8QQOhn7hPTWSNNBUrQNOkTpe6U0u1O27qFlR+CW3nks5Ojcv
	 F1OjUjFgEsLjUASQyy9wfNtinqlqkgjjIyjIfGhMXXdtGuCi2q5OGp6vyz//1bx6gP
	 qQxyqCfjfLIVkd4DUMO1DPAWD78igKyHxHb6AWDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 0852/1067] scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path
Date: Tue, 21 Jul 2026 17:24:13 +0200
Message-ID: <20260721152443.602783653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


