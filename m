Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1CF171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C173AC43443;
	Mon,  8 May 2023 11:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545617;
	bh=ZGAacLBeVYZkq82ruS4X/tASMfAaJ2tPuVHY47k9p20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J040qidErVbXzdasNKrVbEH4BGSkM9cacUXGFq48elnxNkNfoLV6fEVbWt2zSen4q
	 qIzhbsOHbckFGXvJi535/vVO6+q0Bxs5vj33ho0Vt4Nedwe1CsTI7jSN+ku5yHaR5P
	 LsEfqILY5Rhx9BhT1RSaz2EKsF2Cj4MZioaISlKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Michael=20Niew=C3=B6hner?= <linux@mniewoehner.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/371] tpm, tpm_tis: Disable interrupts if tpm_tis_probe_irq() failed
Date: Mon,  8 May 2023 11:44:30 +0200
Message-Id: <20230508094814.855969707@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

[ Upstream commit 6d789ad726950e612a7f31044260337237c5b490 ]

Both functions tpm_tis_probe_irq_single() and tpm_tis_probe_irq() may setup
the interrupts and then return with an error. This case is indicated by a
missing TPM_CHIP_FLAG_IRQ flag in chip->flags.
Currently the interrupt setup is only undone if tpm_tis_probe_irq_single()
fails. Undo the setup also if tpm_tis_probe_irq() fails.

Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Tested-by: Michael Niewöhner <linux@mniewoehner.de>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Stable-dep-of: 955df4f87760 ("tpm, tpm_tis: Claim locality when interrupts are reenabled on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 274096fece3fa..99cbf6fb062ce 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1069,21 +1069,21 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 			goto out_err;
 		}
 
-		if (irq) {
+		if (irq)
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);
-			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-				dev_err(&chip->dev, FW_BUG
+		else
+			tpm_tis_probe_irq(chip, intmask);
+
+		if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
+			dev_err(&chip->dev, FW_BUG
 					"TPM interrupt not working, polling instead\n");
 
-				rc = request_locality(chip, 0);
-				if (rc < 0)
-					goto out_err;
-				disable_interrupts(chip);
-				release_locality(chip, 0);
-			}
-		} else {
-			tpm_tis_probe_irq(chip, intmask);
+			rc = request_locality(chip, 0);
+			if (rc < 0)
+				goto out_err;
+			disable_interrupts(chip);
+			release_locality(chip, 0);
 		}
 	}
 
-- 
2.39.2



