Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48B01779B1;
	Tue,  8 Oct 2024 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391189; cv=none; b=XPdYWnIvV2nfSu/fT05J8Tbfaf85kvc83dXXvdZz4cJET6BQwp90q4F6fIu4UoD2tJBpW1dTeuFiIl8vstXLY0XAL3+XFPoynk9Xxlszkwj5TosY9niXu/RoknxP1Wz4NLvNWK6+7nTDHTKHPyTIilexyX0pO2swe0OohyjZkD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391189; c=relaxed/simple;
	bh=mv1h5SoVHCjoRr9a633HFWFK0DM+SmyHX++O+y/KoPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1MnQ88T3HnAQTGnxi4qjQ+NXA16zAuRFWvTjqWCpZ3cNFO7Yqax8q3DbFggzDmcDLsmhbdp9zgDVdchS+t++4lOuLm6z0Wqln3JcwCU+imIBiNrNOflS4QL5hNz/bVWEutBprqIfS5PPjUPsPm2UW4DJzlq4nVitXv0X/OT3WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOoRz84o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOoRz84o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46704C4CEC7;
	Tue,  8 Oct 2024 12:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391189;
	bh=mv1h5SoVHCjoRr9a633HFWFK0DM+SmyHX++O+y/KoPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOoRz84o46GJYAFue5Suabq661fAiTH9AUjZVTeAWsd1zNpApqS/dgiaQJHF2eAmS
	 5w1D6PXLkqYdxkuziXFV0OjiUIUFwscxjH/hdk6EB0b1jujU82NamEsZ6gdsU7PKEm
	 VGyUhU/KbiWd+gSvF/Lg79uXv99Axy87Z8jAMNKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 005/558] scsi: pm8001: Do not overwrite PCI queue mapping
Date: Tue,  8 Oct 2024 14:00:35 +0200
Message-ID: <20241008115702.432709029@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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



