Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE59125B6
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A715C433EF;
	Mon,  8 May 2023 10:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543600;
	bh=UWL5keJvLh0Uk3EE3JzaaH1CmLH6lJ6rR9IJcJQW9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wB1hSPvVZqZOVekZqJTiWdJkr8af/5brXQufXoQvyH7PAb7wpnteTt3l7qW8VpTVN
	 zMPTyJC2z0WLkfZQ/2JCEG6ZhHVb64DChzXjqudMnrehYqIuUJCrDQujMG4o9co6Pe
	 XYMfPtqDWi24gNC1YuDHxraty+XRb9D6VVgQdGKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Michael=20Niew=C3=B6hner?= <linux@mniewoehner.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 141/694] tpm, tpm_tis: Claim locality before writing TPM_INT_ENABLE register
Date: Mon,  8 May 2023 11:39:36 +0200
Message-Id: <20230508094437.039034456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 282657a8bd7fddcf511b834f43705001668b33a7 ]

In disable_interrupts() the TPM_GLOBAL_INT_ENABLE bit is unset in the
TPM_INT_ENABLE register to shut the interrupts off. However modifying the
register is only possible with a held locality. So claim the locality
before disable_interrupts() is called.

Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Tested-by: Michael Niewöhner <linux@mniewoehner.de>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Stable-dep-of: 955df4f87760 ("tpm, tpm_tis: Claim locality when interrupts are reenabled on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 33d98f3e0f7a6..a2cbf9b6f4c92 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1094,7 +1094,11 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 				dev_err(&chip->dev, FW_BUG
 					"TPM interrupt not working, polling instead\n");
 
+				rc = request_locality(chip, 0);
+				if (rc < 0)
+					goto out_err;
 				disable_interrupts(chip);
+				release_locality(chip, 0);
 			}
 		} else {
 			tpm_tis_probe_irq(chip, intmask);
-- 
2.39.2



