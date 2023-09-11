Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FB811705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EDDC433C8;
	Mon, 11 Sep 2023 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443122;
	bh=YwdBhYb2m4OIwM/5baJP/b9ed35zEAAAGoUICQ4pog0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzlDR49losuKoOM1P5TUtznW+vry+LOWDhAxEoyweWE2zAUnpwQTEjWrUYDmDbtoJ
	 5EA7QeIMdSQcVfn9RHb6A/bj9/c3JOHGJNF4xJ+FqRAIBnItAkypwMr/QoMGEkHPA0
	 GTN/wUdjllmYb+ygsTyRxpEcDR4FqUad5ukMSeEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 265/737] pds_core: pass opcode to devcmd_wait
Date: Mon, 11 Sep 2023 15:42:04 +0200
Message-ID: <20230911134657.987207765@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 0ea064e74bc8f915aba3f2d0fb3418247a09b73d ]

Don't rely on the PCI memory for the devcmd opcode because we
read a 0xff value if the PCI bus is broken, which can cause us
to report a bogus dev_cmd opcode later.

Fixes: 523847df1b37 ("pds_core: add devcmd device interfaces")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230824161754.34264-6-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 524f422ee7ace..f77cd9f5a2fda 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -121,7 +121,7 @@ static const char *pdsc_devcmd_str(int opcode)
 	}
 }
 
-static int pdsc_devcmd_wait(struct pdsc *pdsc, int max_seconds)
+static int pdsc_devcmd_wait(struct pdsc *pdsc, u8 opcode, int max_seconds)
 {
 	struct device *dev = pdsc->dev;
 	unsigned long start_time;
@@ -131,9 +131,6 @@ static int pdsc_devcmd_wait(struct pdsc *pdsc, int max_seconds)
 	int done = 0;
 	int err = 0;
 	int status;
-	int opcode;
-
-	opcode = ioread8(&pdsc->cmd_regs->cmd.opcode);
 
 	start_time = jiffies;
 	max_wait = start_time + (max_seconds * HZ);
@@ -180,7 +177,7 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 
 	memcpy_toio(&pdsc->cmd_regs->cmd, cmd, sizeof(*cmd));
 	pdsc_devcmd_dbell(pdsc);
-	err = pdsc_devcmd_wait(pdsc, max_seconds);
+	err = pdsc_devcmd_wait(pdsc, cmd->opcode, max_seconds);
 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
 	if ((err == -ENXIO || err == -ETIMEDOUT) && pdsc->wq)
-- 
2.40.1



