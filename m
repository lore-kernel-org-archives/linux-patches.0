Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621145;
	b=ccopQCUGah1TyMro2QcMLjZBbZvKx/d0kQoP7ZbuQGqZowvtmVHASqQNmUgNkQKTlhEL
	 YuCkyn1ouXG8IlM+8PEedWo+vfAVr9o6XN+cqF3XAU2EJyCL/mUaG1qutt+D/H999Hfc9
	 vXNbc3HoeH4YQkO6zDw6nEfdKqnPx+FvPhMbqhlq/31HEFthQ6HSbcY1Po8CbfFLdsHQe
	 YVB74r9oiuLNtUtOaL2r8iB0kKfaaVP74VO4NMbhAej8SIXaLMakUH4J74LnJwAU5YQuo
	 bV+iuuXUV2f/uP8lW3yDa/4BfqL8yhejQw3rAyFLM1mGRJe25hlpQCq9Ig+DifXvC9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8qCVJhlsY6SLR/Ooi0EyuwCVY0GOp2+JfrUWm2U7Gr0=;
	b=voUfcs8FZHLMpq0QDaM0FfBwZ1buGWw2SSxYpytDg1odP2+rN/j+ag1Axm3MOKdLb8SA
	 Dc06HVHS6dQ6U6iKI0BLcBNzt4O1Y74SpGusNzgy9y0Y1QHZLTv9xPep3k4SC+XAjNevq
	 BOk9H3xu2yOp72YwGrqVk64aSKxP5kYXoam1SA39GU0EaFNeHlWkR32FPImev1wrPYwC8
	 GvEInrQN+3+RiOaFrsJ/jTyRQcTwj1sOr1TorCAcjzHhxybWb1a+a4Y2DBbEkFMGr8Ge3
	 wAEcPvU6O4uTz0Z9czp8aBSqqL4+xjjPfB2rQjQ+ujatP9cuFxKztD6OfV+s4YN1trQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BhjxrFi2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9058E606A332;
	Wed, 25 Nov 2026 15:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BhjxrFi2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29841F000C0;
	Wed, 25 Nov 2026 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621145;
	bh=8qCVJhlsY6SLR/Ooi0EyuwCVY0GOp2+JfrUWm2U7Gr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhjxrFi2dko1jZNahgwhZDW0raXzoKSfk5apcyh84YSg3vCTObuo7XKbsu/yucc/n
	 fiHPk1Bv4vGrHfreJqD8vrRG7Y2QZ9eBkOKDjowhv831kI1QhwSx5TAJdp19TALV/R
	 T2fMNw8AUzx2qTGoPfLKQVgc5K9Io8e5faoZ7vUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/990] ata: libata-eh: Retry non-NCQ commands when their sense data asks for it
Date: Wed, 25 Nov 2026 15:25:03 +0100
Message-ID: <20261125143825.269343632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 9d35b4f8d3929..1e5946c0a7434 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -4061,8 +4061,20 @@ void ata_eh_finish(struct ata_port *ap)
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



