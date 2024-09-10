Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82D7190664;
	Tue, 10 Sep 2024 10:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964682; cv=none; b=fPhHD9uNBov+82g9iOhOYtgD5/NPql0EonoD8dTpTN5jWw3i+o6gIBfjvH8+t1bAvTbVQWUrsrs3sdEvbL+oiKjQ197ZWwsIrw5mSoWf2hk2kYrBvPdgpy2nhMfmgjlmZwn3LXqQRuW1qGVhoRkeTk0PHLJ6kTmCToutPpsBE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964682; c=relaxed/simple;
	bh=EjtcW/bvlVYrwIKkRkB0opE/i8WUPHNkCMz2Pm+Ahlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+U7/3w2oUXcUN6985ZFSQOvkyNhNb0maT+6sCw84rv+Rpk4BLNGGH6nPooNLFr0Ii+aP09THtuZAMwotzQ0So9ltusOx14mx2Fmpi6/UUjYzC2op8o8duDC8uajQakc9np/Za6DlsQH8gVgjyUG/t4ziX50bp2A8vucBknuuRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifV+8xhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifV+8xhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD7EC4CEC3;
	Tue, 10 Sep 2024 10:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964682;
	bh=EjtcW/bvlVYrwIKkRkB0opE/i8WUPHNkCMz2Pm+Ahlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifV+8xhcyIvuGxkD/RXcsDxQMII/UKdi6YXUKIHtKqt2TTSP3krrfwWGTTMz7Jl9q
	 06ksLmZhLymFQFyPYoYbSHnVriz0YnAhapKlE6AVpt6JZfCsvm9u/gnlLyGZotV3Cr
	 gk8RbmMME+QK5EtLEF5RTnYvc6NltLuxGiecWofg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/269] ata: libata-scsi: Remove redundant sense_buffer memsets
Date: Tue, 10 Sep 2024 11:33:46 +0200
Message-ID: <20240910092616.391479057@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 3f6d903b54a137e9e438d9c3b774b5d0432917bc ]

SCSI layer clears sense_buffer in scsi_queue_rq() so there is no need for
libata to clear it again.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20240702024735.1152293-5-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 277bf0e8ed09..27e0c87236ac 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -926,11 +926,8 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
-	unsigned char *sb = cmd->sense_buffer;
 	u8 sense_key, asc, ascq;
 
-	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
-
 	/*
 	 * Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
@@ -976,8 +973,6 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	u64 block;
 	u8 sense_key, asc, ascq;
 
-	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
-
 	if (ata_dev_disabled(dev)) {
 		/* Device disabled after error recovery */
 		/* LOGICAL UNIT NOT READY, HARD RESET REQUIRED */
-- 
2.43.0



