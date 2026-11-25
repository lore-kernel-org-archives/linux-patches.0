Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617977;
	b=yhjv+HTX6wxG5JQ5aLfMkhzrHGIqM+OLqSFud2zKCgFqggoQ2PLwRg6jDtjIWPqr9F5T
	 VpJqWciyXaaXFvd908K9YelJjEQS4+mVlu/ZjedqxkZ8MNHDNzW2OTx8ZeEcTIKIIhSgG
	 Wo/tzbU7iGnXQxABGH8OYcPEUu1YutBzBUzYVKv6P6SAyhgRItrhoehFQAD9s1lfMx57b
	 X0yiOd0IaWZw67buoyse4cINLmhzI6zq7Fbd5AodhU4wLkXkW3JWXTSFDA2dG+VN429Ne
	 5gCL9apQem/8QLd3KPEWsgocEKg4iIqYcAaSx9iJvLG1RjKSK5ewOTTgY3T4r/Q2vvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zvSHpjjfl8ITzkIkKLHi3u1SA/4izlGVRZAng28xctg=;
	b=QD3HGrgymW7HIUdh4ymkXHc127Hmz2Dm63gLKStYcXVTaB/KJ8W085zDIrGILFML9knc
	 nHdX8ednMj4DUullxMb55HbRNn1DuE4KLJYyJaZ1cjC9nb3BzoXqzybr3ehGEOMyb36J7
	 xqJHmOwLYAYAcO7HegqCIjURZN0rDhM3w5cBJcrp4iqLywes2tb8eadrJf5aW0WMwjlHg
	 YrEE/iO2wSDGD9djs4wDVA52sUJUXO4ey9M1TCvilScEZLDQmAbtvrm6VgFps8eDkfBQk
	 QU/TgA2Kw+Hzg3E+xs2vzWEhBt+zc5CA12hg44z/kfN9IRTYYSfpvz13qWyP1DNx2Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBQXq68Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87267606A31E;
	Wed, 25 Nov 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBQXq68Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3D91F000CA;
	Wed, 25 Nov 2026 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617976;
	bh=zvSHpjjfl8ITzkIkKLHi3u1SA/4izlGVRZAng28xctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBQXq68Y0HZrFGx8NK1n+CG1Wmj0E2SkFeK1iafCAoKOaZngR9jfig18gHbdvLTug
	 QkjasZmO4Xz4ikx0d0Pvjv4jfKPCGeQTEmCm9OotO3uKUlxpV4ys+8N4hjzNihfodb
	 AvFO4lA1/jzk+BVKeJBCgmGPuL5X88kEBodlpZMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0135/1005] ata: libata-eh: Retry non-NCQ commands when their sense data asks for it
Date: Wed, 25 Nov 2026 15:24:33 +0100
Message-ID: <20261125143824.901179275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c93c24b22d9ca..fd7ce2abfbcfd 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -4077,8 +4077,20 @@ void ata_eh_finish(struct ata_port *ap)
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



