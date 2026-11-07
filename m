Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062895;
	b=qsUFavZlrE9UI54D3PnoCxkGqG02m1p0UsbRj8pveEpwNfPVvoWJUkciMShZIniK8WO+
	 3+s5I71cAAEEzKKj1mZuKcWkYfmnW8r4l+sEbZClApBEzuoS1vjoFya5vPdo2W+6os1EG
	 cQKntRFPDIzQgpiycsuUUgoepXbo+toKK4MWhKT694aUsz5sjSuwjd7PmPqE28xeMan1g
	 bX8FRyiBp0vkH0YQiPfey6srRJMmnFutEDJuPFz2aRdndlqgwfxazL7T6d81pIqPUQuEM
	 jDfgvRMXrwwxVRAixZ7+t29Rqm8SjN2J57tlZ4WC+APcgJAvHO+PW7fCAF9nPIxgrOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=elJ/5WwpnrxIOXxqV7PzDUSJASCdeYtZb4clZJp+RZo=;
	b=znZV30msw2QrIXKJJKPVD9wO0/tWHY8o2jHFy60x4weOd9KsiD2PXyB7IUQbptCNywEQ
	 3sINIO3MedhAyesEtauYZKByI/O9qM1xAG90ZW6IzNk4KHBJIA0FYMp+omlgxAH8+FR8f
	 ofIBRvgr6Nyrn7G5zHixhczul+rxEzc2MtfLxpwzkXFPFqZCxQ6q5bH4CkUk0dfKKL45a
	 EDjYZ6YtcRDnEbNEviLPcK4x4ogkfgLxyPBdChuBaLR2rgXPJRlncC1Loii90wgpPHu5v
	 vDV6roc1YQMwPPgKR5zwBenslO2pmtOst47vrHtH1hhNQc42X6tJdPqec67HSGmlCIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rg6x1fc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E0606A32C;
	Sat,  7 Nov 2026 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rg6x1fc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38731F0089F;
	Sat,  7 Nov 2026 14:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062895;
	bh=elJ/5WwpnrxIOXxqV7PzDUSJASCdeYtZb4clZJp+RZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rg6x1fcM35l6DEvynvZQO0sElRlDyERXcBo6hvX5SQRN8hRDZQ2co36WdqNDp+s0
	 egB0GFt7lpG4fKgh+dU+MY0hNIrnAp6oiGvAL0ptrRSzVl/Abl5NNejayMAOwFt6Vz
	 1Bp2U1VVGMYGJQmm3gSD/D/drcsLXoq2JCqy7+pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/869] ata: libata-scsi: abort multi-sector pass-through commands when multi_count is 0
Date: Sat,  7 Nov 2026 08:47:34 -0500
Message-ID: <20261107134858.034581346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 3bab8c7e0c6ba187a47163a1f71477213a278c48 ]

When an ATA_12, ATA_16, or ATA_32 pass-through command with a
multi-sector PIO command opcode (ATA_CMD_READ_MULTI,
ATA_CMD_WRITE_MULTI, ATA_CMD_READ_MULTI_EXT, ATA_CMD_WRITE_MULTI_EXT, or
ATA_CMD_WRITE_MULTI_FUA_EXT) is submitted via SG_IO on a device where
multiple-sector mode is not configured (dev->multi_count == 0),
ata_scsi_pass_thru() currently logs a warning and still dispatches the
taskfile. When the DRQ interrupt fires, ata_pio_sectors() triggers
WARN_ON_ONCE(qc->dev->multi_count == 0) and computes
nsect = min((qc->nbytes - qc->curbytes) / qc->sect_size, 0) = 0, failing
to transfer any sectors:

  ata1.00: invalid multi_count 1 ignored
  WARNING: drivers/ata/libata-sff.c:666 at ata_pio_sectors+0x27d/0x300
  Call Trace:
   <IRQ>
   ata_sff_hsm_move+0x211/0x22e0
   __ata_sff_port_intr+0x1c8/0x520
   ata_bmdma_port_intr+0xa1/0x5b0
   ata_bmdma_interrupt+0x1f5/0x550

Per ACS-3 section 7.12.7.21, if IDENTIFY DEVICE word 59 bit 8 is cleared
to zero (multi_count == 0) and a READ MULTIPLE or WRITE MULTIPLE command
is received without a preceding successful SET MULTIPLE MODE command, the
device returns command aborted (ABRT). Per the SAT specification, an ABRT
error translates to the ABORTED COMMAND sense key with NO ADDITIONAL SENSE
INFORMATION (0x00, 0x00).

Fail multi-sector taskfile commands in ata_scsi_pass_thru() with
ata_scsi_set_sense(dev, scmd, ABORTED_COMMAND, 0, 0) when
dev->multi_count == 0.

Fixes: 1dce589c38c3 ("libata passthru: support PIO multi commands")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260921032556.1160734-1-benquike@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c780a7f157389..8b9530c505315 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3474,6 +3474,11 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	if (is_multi_taskfile(tf)) {
 		unsigned int multi_count = 1 << (cdb[1] >> 5);
 
+		if (!dev->multi_count) {
+			ata_scsi_set_sense(dev, scmd, ABORTED_COMMAND, 0, 0);
+			return 1;
+		}
+
 		/* compare the passed through multi_count
 		 * with the cached multi_count of libata
 		 */
-- 
2.53.0



