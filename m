Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D8D3C4576;
	Wed, 20 May 2026 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299819; cv=none; b=cBCTn0sfRQlbHoo8w0qLIrK0nOcI4J5HWk0loWSSCRBo5n1f7vZJokmrd5UrqAQG2ndT+xGnpFb2oL/IfhfhBKlK3EdRZV1Qzpb5Hl7PConEH/A3hOuzdV25zC8Nlj0UnsdNISDPIVolU0ip/k5eZjgpClVXlA5WWNE8QwkPhVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299819; c=relaxed/simple;
	bh=b9T6dwu7P+VHlx80j42hMdPGBV+mp1NXakT8Gi2zerc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLHJEwQh9bOa8xePPP6xaSQtGEM61t5oxEoaEYyKDkdK9iivLKMlXItsqdMXaMMPgLAbygkX2uWGQhYtERIMxnbERIDQC+vYdjyIKiJrbioI3RldoUMoQg9BZycxY/p0KUKzlqUHzbipz65biUY3oBjatdeOkwE2gLliJQ1PDM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atCJhNq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atCJhNq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2911F000E9;
	Wed, 20 May 2026 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299818;
	bh=ZLxrbNNW/dai/Yb6GJSXoHc90cFtUxtmIsEL0N3wC1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atCJhNq4a6MqO9/3pxT/b2aZFupInayIwiEw7fuU44rIvd/2MPz5FwfXQsE6bDCU9
	 sxil75mzwyQVyk4E/7jU+CzihbB4o8SV9HRkQmnnLQPcwO1ZMTx4NP4RYK86QdRmF8
	 8DhO/7iGhp7vrcOpirp6EdS2KbsVRsaVAdFxRx4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 899/957] ata: libata-scsi: fix requeue of deferred ATA PASS-THROUGH commands
Date: Wed, 20 May 2026 18:23:02 +0200
Message-ID: <20260520162154.069397634@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 88689369db03d..e7c78b8d3c2c0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1691,7 +1691,7 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
 	/*
 	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
 	 * do not try to be smart about what to do with this deferred command
-	 * and simply retry it by completing it with DID_SOFT_ERROR.
+	 * and simply requeue it by completing it with DID_REQUEUE.
 	 */
 	if (!qc)
 		return;
@@ -1700,7 +1700,7 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
 	ap->deferred_qc = NULL;
 	cancel_work(&ap->deferred_qc_work);
 	ata_qc_free(qc);
-	scmd->result = (DID_SOFT_ERROR << 16);
+	scmd->result = (DID_REQUEUE << 16);
 	scsi_done(scmd);
 }
 
-- 
2.53.0



