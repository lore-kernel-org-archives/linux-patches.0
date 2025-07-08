Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DBE217722;
	Tue,  8 Jul 2025 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993373; cv=none; b=UMx1v4Cv9+8aU89Q+5a3gWqzIFi5ktjPKCuUehXycZkYGDyZuh0gqUW8NLwFmeW2Ax+ccDjue76YrXC9LqgJL3P/73tamlHp/HW+1QFLaMUF1qR1dTFj6lbhKCMtcUcq20yZiWLeT4Cn6X+rPL1DSsV/p5vMCmiyrzvLFMsdd/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993373; c=relaxed/simple;
	bh=CajFqJAjf2z8JKj87C1O7WVLes/hmWBSDb/jhspOMm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKoYugptbpR+1EgaPXcac+90tEEdyacM+PxsdckCb0I6dqMwNqLhVyuE4d2giqPYyvfRqgyDqtVjp0kULOxGeIraAmq23vkaFUsnZU7wQeb7+N3X7OfkONwMxNkNQxt5fqXA3TkjhFOMb5oStyPtVv9zzXYLfzjmuSUL8tKFLXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKM2G4gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKM2G4gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BECC4CEED;
	Tue,  8 Jul 2025 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993372;
	bh=CajFqJAjf2z8JKj87C1O7WVLes/hmWBSDb/jhspOMm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKM2G4gsDm2SqwdRN+q4OGE14nMWAEYy7cNQbW1fzv0qEWSzZzLa1GkRnK3aJ0IYs
	 vvuUZN2Xu9pHjQTvxUQj3BOem66vljzVmU1Ae1qwt2lcrnYUsRvj7GTmGbGlMhYYJf
	 XsfDDK0QcM1Omqn/MJL3j5rAwOlNURkJDOXeDUoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 052/178] scsi: core: Enforce unlimited max_segment_size when virt_boundary_mask is set
Date: Tue,  8 Jul 2025 18:21:29 +0200
Message-ID: <20250708162238.041729935@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4937e604ca24c41cae3296d069c871c2f3f519c8 ]

The virt_boundary_mask limit requires an unlimited max_segment_size for
bio splitting to not corrupt data.  Historically, the block layer tried
to validate this, although the check was half-hearted until the addition
of the atomic queue limits API.  The full blown check then triggered
issues with stacked devices incorrectly inheriting limits such as the
virt boundary and got disabled in commit b561ea56a264 ("block: allow
device to have both virt_boundary_mask and max segment size") instead of
fixing the issue properly.

Ensure that the SCSI mid layer doesn't set the default low
max_segment_size limit for this case, and check for invalid
max_segment_size values in the host template, similar to the original
block layer check given that SCSI devices can't be stacked.

This fixes reported data corruption on storvsc, although as far as I can
tell storvsc always failed to properly set the max_segment_size limit as
the SCSI APIs historically applied that when setting up the host, while
storvsc only set the virt_boundary_mask when configuring the scsi_device.

Fixes: 81988a0e6b03 ("storvsc: get rid of bounce buffer")
Fixes: b561ea56a264 ("block: allow device to have both virt_boundary_mask and max segment size")
Reported-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250624125233.219635-3-hch@lst.de
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e021f1106beab..cc5d05dc395c4 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -473,10 +473,17 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	else
 		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
 
-	if (sht->max_segment_size)
-		shost->max_segment_size = sht->max_segment_size;
-	else
-		shost->max_segment_size = BLK_MAX_SEGMENT_SIZE;
+	shost->virt_boundary_mask = sht->virt_boundary_mask;
+	if (shost->virt_boundary_mask) {
+		WARN_ON_ONCE(sht->max_segment_size &&
+			     sht->max_segment_size != UINT_MAX);
+		shost->max_segment_size = UINT_MAX;
+	} else {
+		if (sht->max_segment_size)
+			shost->max_segment_size = sht->max_segment_size;
+		else
+			shost->max_segment_size = BLK_MAX_SEGMENT_SIZE;
+	}
 
 	/* 32-byte (dword) is a common minimum for HBAs. */
 	if (sht->dma_alignment)
@@ -492,9 +499,6 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	if (sht->virt_boundary_mask)
-		shost->virt_boundary_mask = sht->virt_boundary_mask;
-
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
-- 
2.39.5



