Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC0339BFFE;
	Tue, 21 Jul 2026 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659026; cv=none; b=M6mP9GJ2AFOD7hMVdEKP3DrVml0litoh0QIujrCs6o4fk6oWV2mgcXP+AvXHhBLeA4H4D4lnrJ6+bZBy9OV3FCL9vlYNzhHekwsB70GXOktffPGHPaFboGlc7ohx/t+SjbTD8zLH20hWdMCH7clQGQSKOT6+zsmp8VUwqkX/zHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659026; c=relaxed/simple;
	bh=ahpgA+x4sYPnpI277dCmRYo0KwEHgLNDDdTf1cPfmzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyLOI/QOSerkNWAc5TsOcH7nIDM4Fg3aqzAtlakBkpXHmT8xQM0nLnCxLT178yoH/6MJWS9aTPotBC45yWclcfaa7QbCo8Q9o2Sn/6/umryNzKup+26/bpETbXcEbMrAenhxHkOirqtBtv8bGLO/0jrdqrR0VrgXZb3hFCQi7jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OosE70kU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OosE70kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A050F1F000E9;
	Tue, 21 Jul 2026 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659025;
	bh=E7NhuBhMA/OXB5w1SKVUDjDJBOzH/UotC4Y1MZid8k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OosE70kUKwx7BrqTXFfzSXxYSoRgn0fT6JeJDNYaOrRdJvKZoFc/qLqZsnRr9guoj
	 eDN/jjM1xZHn4GxNb/GStw4Zd2TFuxOkd7sfrB+kgEllsN2FSY5ODW/erziHstq73w
	 by6kpC9ttSt3Y41S8n9PFkX/dhyCQBX5OKdGQDbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 1365/1611] scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path
Date: Tue, 21 Jul 2026 17:24:41 +0200
Message-ID: <20260721152546.154881013@linuxfoundation.org>
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
@@ -5020,6 +5020,10 @@ static int hpsa_scsi_ioaccel2_queue_comm
 
 	if (phys_disk->in_reset) {
 		cmd->result = DID_RESET << 16;
+		atomic_dec(&phys_disk->ioaccel_cmds_out);
+		scsi_dma_unmap(cmd);
+		if (use_sg > h->ioaccel_maxsg)
+			hpsa_unmap_ioaccel2_sg_chain_block(h, cp);
 		return -1;
 	}
 


