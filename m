Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552E21DE8B5;
	Tue,  8 Oct 2024 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389532; cv=none; b=t3GKe/d/hSgoW8bQlW3wukO6DfYgUWjBvrLmG1Z9Xb6k9oQzubitDgq2rsLcZBNcyCXkyybQkm8sFFeEKR+TTpNOcIv+w4c4SiFgQl01cQIFKdubclRF19qzCC2Alh7k+yu3Tg64juLtmgHhVAXAMcHAlpt13tB78SfhwMyhhQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389532; c=relaxed/simple;
	bh=T5aA+FKKlV1BEqi1wbmGRmuOAVpjbdYGbR9s81StNRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LK1gYKHzalDEJoqd6BVoJej9ll1AFkWsgGHDmgomBok8qUda9t2GmAvVU2luUnDiPVvVAA9Fn4BHURasNdVHE3JaPUemAgbIQyMvPfrx4NNbJ2CT3UdW+MWDBFgRQzKQLX+pfe/JJMaUQWGiRYo34W11fpp1D+Glg7Lwd9ZUBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U77eWgMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U77eWgMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8094C4CECC;
	Tue,  8 Oct 2024 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389532;
	bh=T5aA+FKKlV1BEqi1wbmGRmuOAVpjbdYGbR9s81StNRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U77eWgMJ/E+rNmnd31sax5zalGUIYEA9LxRhbwUdapPYsAt0yvdIrKfLbdonwWTtr
	 EObf0yRMValHwL31srMrk2iZAST8cpoCLu2cQBrWf6Q9aPCI9ACrEP0VoA8ON7itqF
	 ava6itcoS5kZ0Kbdh2dx0w5uTTjLqj98SC22cJ0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 006/482] scsi: pm8001: Do not overwrite PCI queue mapping
Date: Tue,  8 Oct 2024 14:01:09 +0200
Message-ID: <20241008115648.545044420@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit a141c17a543332fc1238eb5cba562bfc66879126 ]

blk_mq_pci_map_queues() maps all queues but right after this, we overwrite
these mappings by calling blk_mq_map_queues(). Just use one helper but not
both.

Fixes: 42f22fe36d51 ("scsi: pm8001: Expose hardware queues for pm80xx")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Link: https://lore.kernel.org/r/20240912-do-not-overwrite-pci-mapping-v1-1-85724b6cec49@suse.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 1e63cb6cd8e32..33e1eba62ca12 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -100,10 +100,12 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
-	if (pm8001_ha->number_of_intr > 1)
+	if (pm8001_ha->number_of_intr > 1) {
 		blk_mq_pci_map_queues(qmap, pm8001_ha->pdev, 1);
+		return;
+	}
 
-	return blk_mq_map_queues(qmap);
+	blk_mq_map_queues(qmap);
 }
 
 /*
-- 
2.43.0



