Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CC4314A86;
	Wed, 30 Sep 2026 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791620; cv=none; b=sBR3I9+xV0S1Do+vTkp7gKgMsd5n6oKzHIFgVIW+6UtTMaGrGCUCgpm3aVdSvR/pthXiPokd46lb3512EcrOytIvwsPUqQUp2ogKLWg1t0j9IdT8TlqeKyoMUCtkZwC10lXOm7DsUXVGhGc5NTCLdk1fZIQhH/QEiCfvmHFYe8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791620; c=relaxed/simple;
	bh=/XMsYqZzY1eR+m7gabuYNGRFFa/3/RvSm3abHXVWoXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDTiwxKH5a40rHkbisM5iY1W798m+r4nn0hC/rq3bwA0azAaY3krkjFvmSGRXhfrKs5ajPF4pI/SL59nvA9mUQMJQb8CSFQh5bYdV98/8JjMDKkSc99BvisJRFc9LYID4bf/XvjKjIq6nGrYFHSidu2g2o/LUKXBtjmIVJvC4S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AcJNjIHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcJNjIHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616D41F000FF;
	Wed, 30 Sep 2026 18:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791618;
	bh=7bC39LfmLVo/+S015jO8EQj1fJjzS/Zl7cuhZkR2F7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcJNjIHOybAevvNOJp5hjimE0doiMrLkSlmiMToquRe8AD88GBlIkgV76MyMOWfCp
	 oXtUsobWhiDEbJ0SpayGys7xNMLkDqf6dVuOuAeUL6yu7aJBD8fBy/CFjfnnN4dS8V
	 94pjsSuHlt/M6NGgbmCcPN7cdSyqmPAtK7NtJsyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 364/752] Revert "scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches."
Date: Wed, 30 Sep 2026 17:23:54 +0200
Message-ID: <20260930152406.157950972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 9349b8c77be9d50625d12b58dca4ee2b91f12017.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 05ea8bea81841..7ecc62fc572aa 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -63,12 +63,6 @@ static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
 	return scsi_cmd_priv(cmd);
 }
 
-static int pqi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	memset(pqi_cmd_priv(cmd), 0, sizeof(struct pqi_cmd_priv));
-	return 0;
-}
-
 static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
@@ -5641,17 +5635,6 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 {
 	struct pqi_scsi_dev *device;
 
-	/*
-	 * Clear the AIO-retry marker on final completion so the tag
-	 * starts clean on its next dispatch.  On DID_IMM_RETRY leave
-	 * it intact: pqi_aio_io_complete() sets DID_IMM_RETRY and
-	 * bumps the marker to steer the requeue onto the RAID path,
-	 * and pqi_process_raid_io_error() consumes the non-zero
-	 * marker to offline a misbehaving drive.
-	 */
-	if (host_byte(scmd->result) != DID_IMM_RETRY)
-		pqi_cmd_priv(scmd)->this_residual = 0;
-
 	if (!scmd->device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
 		return;
@@ -7007,7 +6990,6 @@ static struct scsi_host_template pqi_driver_template = {
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
 	.cmd_size = sizeof(struct pqi_cmd_priv),
-	.init_cmd_priv = pqi_init_cmd_priv,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.53.0



