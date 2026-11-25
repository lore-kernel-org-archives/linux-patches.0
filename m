Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624218;
	b=Fs0nBGh+DBhhBe2+kyTPZ0LJgYcoegG4c/I/ryOSSqCXsKu86Z9PmopDTsUsG30SrVC/
	 aaNufXi7mSu+Tacilnc1hAxl0cnFIVHi6ZK+5OZtsE8XJkwjitRjmFrviKRResfelk9qV
	 pmCe71b6g6kc6v7jrWVO7frHx6k2i9QMG+Ae6H3fgITyTElS3Z+4Hw9+jDChvhitcDrQp
	 6nlY8F0uj/bTd84jLj/vsFzEvhd7QphX7erdkAXGSNJp/pvs6V2IwCXlH5Pxoa8lyL9Xy
	 fxuDF4OykCLOwtQpu1rJPRX4vuTJyN3Ng1sK4s1qysOh7aTga0/d7UuWCtP1uOBiahA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r9zmapBdACNhxK/9Thhkm1tgtBZinz3EjU8+5OBNwro=;
	b=g1NyUuv7/Dppr+RWEVa4r8T0y+ObHfBoxoXM1D6wp3ygB0mv9d7P4myVZ/P8LyaoP5/6
	 CgUgaZDZU2s48QV9hHh0p9aLrvKAJmzaTB+Bfe9h9Wh9vZdzClLqUFoxtXHZh6YvHn3cY
	 hIE08HF3wKMoUlzZ4hB0+rXNrE1YLOmCj6cDrhCd7tnEN9LrtAhpuuOfS/a8HKywx95gU
	 RHZYNZFSvWMckakMajqujtV+cyrICofO5kF9qaGSLW3cAsJVx5IOUm50aIu4U7Wg+MfHg
	 U14/qXunFFEHhcwwZBHxnweAomjDXS3kmdHFSYmSfL2STtwuBPX4EH7q3XongltPg6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vd+jC5tr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523D4606A338;
	Wed, 25 Nov 2026 16:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vd+jC5tr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7841F000C4;
	Wed, 25 Nov 2026 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624218;
	bh=r9zmapBdACNhxK/9Thhkm1tgtBZinz3EjU8+5OBNwro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vd+jC5trrdGI/9TI+406HGjW+MTzYc/IQwCTjcgTAiR2EalH0/fcRblDXswODzbak
	 gSh8UswnUQnNshM0h+tJABryw79F1psVx1Y1MMuKiZKes9euoSVAMoSBHxkoS7BNvF
	 blgdBBwu8zwukJDikOG353EqS51TVe7n7nfBoYyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/816] ata: libata-eh: Retry non-NCQ commands when their sense data asks for it
Date: Wed, 25 Nov 2026 15:27:48 +0100
Message-ID: <20261125143851.988450310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 597be4104c4045d73979c05307fa5fc778d1dbde ]

When a failed command has valid sense data, ata_eh_analyze_tf() asks
scsi_check_sense() whether the command should be retried, and sets
ATA_QCFLAG_RETRY if it should. ata_eh_link_autopsy() then clears
AC_ERR_DEV and AC_ERR_OTHER from qc->err_mask, relying on that decision.

For an NCQ command, qc->err_mask still has AC_ERR_NCQ, so
ata_eh_finish() honors ATA_QCFLAG_RETRY. For a non-NCQ command, whose
sense data comes from REQUEST SENSE DATA EXT, qc->err_mask is now zero,
and ata_eh_finish() completes the command with scmd->retries set to
scmd->allowed, without looking at ATA_QCFLAG_RETRY. Such a command is
thus never retried, even when its sense data asks for a retry, e.g. a
transient error reported as ABORTED COMMAND.

Make ata_eh_finish() honor ATA_QCFLAG_RETRY for commands with valid
sense data. ata_eh_qc_retry() cannot be used for this: as qc->err_mask
is zero, it increments scmd->allowed, so every retry would allow one
more, and a persistent error would be retried forever. Instead,
complete the command without touching scmd->allowed or scmd->retries,
so that the SCSI midlayer retries it at most scmd->allowed times, like
any other failed command.

Fixes: 3852e3738266 ("libata: evaluate SCSI sense code")
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20261030090047.407906-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b78aa5371c14c..e56735f189535 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -4014,8 +4014,20 @@ void ata_eh_finish(struct ata_port *ap)
 				ata_eh_qc_complete(qc);
 			}
 		} else {
-			if (qc->flags & ATA_QCFLAG_SENSE_VALID ||
-			    qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) {
+			if (qc->flags & ATA_QCFLAG_SENSE_VALID &&
+			    qc->flags & ATA_QCFLAG_RETRY) {
+				/*
+				 * The sense data asks for a retry, see
+				 * ata_eh_analyze_tf(). ata_eh_link_autopsy()
+				 * cleared qc->err_mask, so ata_eh_qc_retry()
+				 * would increment scmd->allowed. Leave
+				 * scmd->allowed alone, so that upper layer
+				 * only retries the command if it has not
+				 * already been retried too many times.
+				 */
+				__ata_eh_qc_complete(qc);
+			} else if (qc->flags & ATA_QCFLAG_SENSE_VALID ||
+				   qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) {
 				ata_eh_qc_complete(qc);
 			} else {
 				/* feed zero TF to sense generation */
-- 
2.53.0



