Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E564101E2;
	Sat,  3 Feb 2024 04:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933386; cv=none; b=tttdym/HIZzJyjD13eC+uRRIo9Vb13UgAf0DUhcMQjsddwtoyhT5UEW8fTmVWJM8lzmFSxas4mnfm6qP96aUtbA2pcduEdxtrVnd7oN+lZkkzoEiICcln6j40y7J9RPOdg5Z39qfdbg3eF51M3+cGe4rK4uADw1W95f/rdEx6No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933386; c=relaxed/simple;
	bh=u8m17Oluy24qbcsfBgBjo0ZDoIT8JtB9Q7tdDVUiaaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0zA0+F8it1XVUQPFfaE32ENpRNKQG1iluAJ2Zq3BDHVXB3lgQTE9UEUjWIj2FDPmB2qEPxP1MjVhTlbUxOFAnLl1ZWkYU0wU3KR2WZxRslHzmita9q397kyFJDCzoLrvP4ABrV/yXVNj2o9cwKooJ71pKdeX117xvQ9fjpHt7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/H5P/tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/H5P/tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA711C433F1;
	Sat,  3 Feb 2024 04:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933386;
	bh=u8m17Oluy24qbcsfBgBjo0ZDoIT8JtB9Q7tdDVUiaaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/H5P/tfEvbkt3aQOJ6l240N+Oz2tXxqyljLo/4BGeHq/lmNpSRL2R3aSN+LUAFhB
	 zhjwOzcD61WA6Dasayy7i3ej50PgzgiUitbdhVOum+TnRY5D0Dh3pe7bBgsaRhj7hm
	 Vxh8Wz82l6YNixZZ4ovxnniTURV5/fJ760EkCnfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/219] ionic: pass opcode to devcmd_wait
Date: Fri,  2 Feb 2024 20:04:07 -0800
Message-ID: <20240203035327.455389261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 24f110240c03c6b5368f1203bac72883d511e606 ]

Don't rely on the PCI memory for the devcmd opcode because we
read a 0xff value if the PCI bus is broken, which can cause us
to report a bogus dev_cmd opcode later.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c  | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.h  | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 344a3924627d..7adfcd7c2f3a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -293,6 +293,7 @@ void ionic_dev_cmd_comp(struct ionic_dev *idev, union ionic_dev_cmd_comp *comp)
 
 void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd)
 {
+	idev->opcode = cmd->cmd.opcode;
 	memcpy_toio(&idev->dev_cmd_regs->cmd, cmd, sizeof(*cmd));
 	iowrite32(0, &idev->dev_cmd_regs->done);
 	iowrite32(1, &idev->dev_cmd_regs->doorbell);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 13dfcf9f75da..c10da629ef6e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -150,6 +150,7 @@ struct ionic_dev {
 	bool fw_hb_ready;
 	bool fw_status_ready;
 	u8 fw_generation;
+	u8 opcode;
 
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 79272f5f380c..9ecbbe7a02ec 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -465,7 +465,7 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
-	opcode = readb(&idev->dev_cmd_regs->cmd.cmd.opcode);
+	opcode = idev->opcode;
 	start_time = jiffies;
 	for (fw_up = ionic_is_fw_running(idev);
 	     !done && fw_up && time_before(jiffies, max_wait);
-- 
2.43.0



