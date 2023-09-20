Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65732208BB
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDB0C433C9;
	Wed, 20 Sep 2023 11:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210733;
	bh=RQDNqqSPjEVrWVypEfmLuk/PPxk6jNcR82KJyH6h8gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMSjSK9L1CxpcGwGHCS2NGAyoDyCIGM3bdjo9GZ61bzLGT+MRSzCMa0KXMjaJATcp
	 75WT/nZkR7BypCkX2YDbXBKYF3uhgL+Qro22P2kwtoMpFA1hZm7et/Df8V+i5LMcwN
	 jpLP/WV1E0FNJ5dTQuSJ3oAXdqJe5Dcdk762o1t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 159/211] ata: libata-core: fetch sense data for successful commands iff CDL enabled
Date: Wed, 20 Sep 2023 13:30:03 +0200
Message-ID: <20230920112850.812529282@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit 5e35a9ac3fe3a0d571b899a16ca84253e53dc70c ]

Currently, we fetch sense data for a _successful_ command if either:
1) Command was NCQ and ATA_DFLAG_CDL_ENABLED flag set (flag
   ATA_DFLAG_CDL_ENABLED will only be set if the Successful NCQ command
   sense data supported bit is set); or
2) Command was non-NCQ and regular sense data reporting is enabled.

This means that case 2) will trigger for a non-NCQ command which has
ATA_SENSE bit set, regardless if CDL is enabled or not.

This decision was by design. If the device reports that it has sense data
available, it makes sense to fetch that sense data, since the sk/asc/ascq
could be important information regardless if CDL is enabled or not.

However, the fetching of sense data for a successful command is done via
ATA EH. Considering how intricate the ATA EH is, we really do not want to
invoke ATA EH unless absolutely needed.

Before commit 18bd7718b5c4 ("scsi: ata: libata: Handle completion of CDL
commands using policy 0xD") we never fetched sense data for successful
commands.

In order to not invoke the ATA EH unless absolutely necessary, even if the
device claims support for sense data reporting, only fetch sense data for
successful (NCQ and non-NCQ commands) commands that are using CDL.

[Damien] Modified the check to test the qc flag ATA_QCFLAG_HAS_CDL
instead of the device support for CDL, which is implied for commands
using CDL.

Fixes: 3ac873c76d79 ("ata: libata-core: fix when to fetch sense data for successful commands")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c7a29c3ac6701..291e128f4d2b4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4919,11 +4919,8 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 	 * been aborted by the device due to a limit timeout using the policy
 	 * 0xD. For these commands, invoke EH to get the command sense data.
 	 */
-	if (qc->result_tf.status & ATA_SENSE &&
-	    ((ata_is_ncq(qc->tf.protocol) &&
-	      dev->flags & ATA_DFLAG_CDL_ENABLED) ||
-	     (!ata_is_ncq(qc->tf.protocol) &&
-	      ata_id_sense_reporting_enabled(dev->id)))) {
+	if (qc->flags & ATA_QCFLAG_HAS_CDL &&
+	    qc->result_tf.status & ATA_SENSE) {
 		/*
 		 * Tell SCSI EH to not overwrite scmd->result even if this
 		 * command is finished with result SAM_STAT_GOOD.
-- 
2.40.1



