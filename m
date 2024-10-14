Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720981A76A5;
	Mon, 14 Oct 2024 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918646; cv=none; b=AB+0QSEZGZMhKSBPQ8fqPsMXVwK57/l6i+OkpGCSmyQLht6JvE0nG3YchBOEUtFabEQyoQF4Icfms4mZ+z/SX3qftZeaecUbvxPaXLEfUTY+4o4vn6M7dgF2/WKla3MelCdsoT2NWDUHii7Iomhok70uamjJU+WDl//gvKgJLvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918646; c=relaxed/simple;
	bh=fQaTX9KLFgi8LYxMoPq+b1VoWzIAYmMV+9REjhan3y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4yMkz8RWV/mgYwyc0imS0jtjRFutNxsVq4cyOmucMbA+T+si3fRtrvkPamey2PvN4Zy1UoWTem/hBqI+GAAd1ibzDQmcJsdhVbvPAQZ3QD4JmRgrJ9IWj6HgUmEmHbBh/naGDvn/RJ3k77L/pTdiQX16I71BG1b10TqyoL2id0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejxHmePj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejxHmePj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5533C4CEC3;
	Mon, 14 Oct 2024 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918646;
	bh=fQaTX9KLFgi8LYxMoPq+b1VoWzIAYmMV+9REjhan3y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejxHmePjcT7o1DGMxVuIzIGini1t+fFg4YM5xnB442SUPNLzN8MGCv6wOKhEWYhEl
	 /AGXHUXYe2K/IKdcTf/c+bs6Ae7Ouxhbla0VIR6sqTi7ZWKwRucBkYECINpgrDRYWu
	 6pti3ivCRSltWN9wwb7ojrMbyRg9jJtvPA8IL5j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 381/798] scsi: pm8001: Do not overwrite PCI queue mapping
Date: Mon, 14 Oct 2024 16:15:35 +0200
Message-ID: <20241014141232.921001494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index da65234add432..18b150f27c868 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -87,10 +87,12 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
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



