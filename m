Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDAA3F9F21;
	Wed, 20 May 2026 18:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301616; cv=none; b=bAq9cnhzHTw9m2MGSjXdo0KSTDDxZ/09K1dtB19zHneWrJ07pcX6rRIB5A7496zgyEFjqc5VlBRtnJyEhLu5d/9bE+9brDQ0BR+9nkMgJ8SIwlie/ATHK8A9eQCtWccGSG3dKr+JVf/Pa+ZrDfHqp0ogT7QhEOaqRBd1W7FOX+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301616; c=relaxed/simple;
	bh=C5wYCUxyJxOR5r01S2iTYBh8v9Tiky0MY2feN1mGE10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaH6cV6fszGw4ip/cRwX0esRqMn+X/p/YZXxbDOKbxOYk4gnMLPdYgZKoUamYclCJ5o4fQ/N5x92cqVfKVm1wIKTW1GBBfsYcFqfZBRWPqn+w2IwTyk5kanjVlRvaUdWAnth4zI1Sv5vAh8Hoiq+/anHHtaNb5E84wXLmPCoIok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biG3zvxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biG3zvxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FDE1F00894;
	Wed, 20 May 2026 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301615;
	bh=DOBmwCZWZhU6wYAr9K2SYkJmZDpk5PpGv6AhBkZJab8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biG3zvxJfEzF/1Ze+H+5/bwALZ812/FiCDF74shZLRSE0cX7u7iY5zwUsV9zPHQ8P
	 0FaxCLL/xwHS0oQGEQ5+8yoZ8D1FC5aarAEI0Pd40M34pzjDzp5RvKpjjQq/OxBPCp
	 jjuSvmEDW6PzmGn6WclZTZU25xxcJJhYd7Yq8U5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 623/666] ata: libata-scsi: fix requeue of deferred ATA PASS-THROUGH commands
Date: Wed, 20 May 2026 18:23:54 +0200
Message-ID: <20260520162124.776166106@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 8ebf408e7d463eee02c348a3c8277b95587b710d ]

Commit 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
introduced ata_scsi_requeue_deferred_qc() to handle commands deferred
during resets or NCQ failures. This deferral logic completed commands
with DID_SOFT_ERROR to trigger a retry in the SCSI mid-layer.

However, DID_SOFT_ERROR is subject to scsi_cmd_retry_allowed() checks.
ATA PASS-THROUGH commands sent via SG_IO ioctl have scmd->allowed set
to zero. This causes the mid-layer to fail the command immediately
instead of retrying, even though the command was never actually issued
to the hardware.

Switch to DID_REQUEUE to ensure these commands are inserted back into
the request queue regardless of retry limits.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b55443e31f403..f3d0979082cb5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1705,7 +1705,7 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
 	/*
 	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
 	 * do not try to be smart about what to do with this deferred command
-	 * and simply retry it by completing it with DID_SOFT_ERROR.
+	 * and simply requeue it by completing it with DID_REQUEUE.
 	 */
 	if (!qc)
 		return;
@@ -1714,7 +1714,7 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
 	ap->deferred_qc = NULL;
 	cancel_work(&ap->deferred_qc_work);
 	ata_qc_free(qc);
-	scmd->result = (DID_SOFT_ERROR << 16);
+	scmd->result = (DID_REQUEUE << 16);
 	scsi_done(scmd);
 }
 
-- 
2.53.0



