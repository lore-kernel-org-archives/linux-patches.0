Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA961DF246;
	Sun,  7 Sep 2025 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277326; cv=none; b=Tv/XkTsAdITRtLfrjTig9bWRtBgEI7hRhkMmmBrKdc9WHSqHorNmQaWWNQwZF4mCwzw1egcpMgO0c+yQvJsnLvXq62zk8gUFTQqJzmvJJjYaePwDb/yytR/Ai8G59wwgNchczMdCmuKMYTuc8FmQV9XdeMXtpVGms3JvuPPj/ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277326; c=relaxed/simple;
	bh=s2s+Le9BmIgncpaMsBieYJPsVlLR1qrne/Ed9xKgV6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZVoNR//hZ8soqoYewC6ewUfk6vrHWB77PmqauMI7Qyfyr1g0LDZ+M2HSfIhhKghNQHYComVg8Irjton0rWiMZpPrKlwH+irjxbLPlOhelWLAvdv9ZjPtqHljCZkJmfZDSwIp6Tg23uP0+rq7MqEKKby0QoCm5jpLHV5OvF50Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00VqISR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00VqISR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9898AC4CEF0;
	Sun,  7 Sep 2025 20:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277326;
	bh=s2s+Le9BmIgncpaMsBieYJPsVlLR1qrne/Ed9xKgV6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00VqISR7SNxMaHN48YlSe9S125OaIkPAH0ZwXOCKqxIFM3je3e4/Xfsc6pGoEv+05
	 Th4o0pyQfkatT3UNQFz5AYwRU4l3rgucVJNvBpO6u5LFHiJW5f71IM/9l/Dh3kajju
	 LSuT82T6VBeRY8QV8ur67a0iZCdWpZTNCm8bQaBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/175] scsi: sr: Reinstate rotational media flag
Date: Sun,  7 Sep 2025 21:59:11 +0200
Message-ID: <20250907195618.547160410@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 708e2371f77a9d3f2f1d54d1ec835d71b9d0dafe ]

Reinstate the rotational media flag for the CD-ROM driver. The flag has
been cleared since commit bd4a633b6f7c ("block: move the nonrot flag to
queue_limits") and this breaks some applications.

Move queue limit configuration from get_sectorsize() to
sr_revalidate_disk() and set the rotational flag.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: bd4a633b6f7c ("block: move the nonrot flag to queue_limits")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250827113550.2614535-1-ming.lei@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index b17796d5ee665..add13e3068983 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -475,13 +475,21 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 
 static int sr_revalidate_disk(struct scsi_cd *cd)
 {
+	struct request_queue *q = cd->device->request_queue;
 	struct scsi_sense_hdr sshdr;
+	struct queue_limits lim;
+	int sector_size;
 
 	/* if the unit is not ready, nothing more to do */
 	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
 		return 0;
 	sr_cd_check(&cd->cdi);
-	return get_sectorsize(cd);
+	sector_size = get_sectorsize(cd);
+
+	lim = queue_limits_start_update(q);
+	lim.logical_block_size = sector_size;
+	lim.features |= BLK_FEAT_ROTATIONAL;
+	return queue_limits_commit_update_frozen(q, &lim);
 }
 
 static int sr_block_open(struct gendisk *disk, blk_mode_t mode)
@@ -721,10 +729,8 @@ static int sr_probe(struct device *dev)
 
 static int get_sectorsize(struct scsi_cd *cd)
 {
-	struct request_queue *q = cd->device->request_queue;
 	static const u8 cmd[10] = { READ_CAPACITY };
 	unsigned char buffer[8] = { };
-	struct queue_limits lim;
 	int err;
 	int sector_size;
 	struct scsi_failure failure_defs[] = {
@@ -795,9 +801,7 @@ static int get_sectorsize(struct scsi_cd *cd)
 		set_capacity(cd->disk, cd->capacity);
 	}
 
-	lim = queue_limits_start_update(q);
-	lim.logical_block_size = sector_size;
-	return queue_limits_commit_update_frozen(q, &lim);
+	return sector_size;
 }
 
 static int get_capabilities(struct scsi_cd *cd)
-- 
2.51.0



