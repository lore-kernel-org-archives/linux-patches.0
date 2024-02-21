Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0317A7E58D;
	Wed, 21 Feb 2024 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522521; cv=none; b=dlaId7SxsW8MuHf/YHcI8TD8+tcM/Okg5h3a3UsIgFk7gSDksLqTJUinLoJIzWpLUED9cg0x1BIazyDQO9M19eAYWWwl9aI3u+l2TxaBS3nvBuOAAoT1+2PTZ4cdD0U7bLmkyIXu+JNdygBQfT7QNSQdVcSfltLTnMxTuabpAn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522521; c=relaxed/simple;
	bh=Okm6G4FeiVJ3JJD8r0EwFg1LKsRY6AbYIptzgybZyOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USnmANdrD2o8C+/cpdp9srAiBRIZHNfCh5gKxJeb1ky5X3EjB6bShfftDgQVz9CySKH7MO1put1Mj0JngABqm/AjrT7OIUdXy4C+9pr5EuuYk8VGA4Bk+5Qy3SJBV+qmkiF26IbYoC+GuC7kBL0/VELfu0Tkr36mSOnylhinRMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7ii1EIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7ii1EIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF04C433F1;
	Wed, 21 Feb 2024 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522520;
	bh=Okm6G4FeiVJ3JJD8r0EwFg1LKsRY6AbYIptzgybZyOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7ii1EIN5I25dEJ1GZe2DgqpnmDkEa2QOcAJ8EYtBIkTgoBax7Ey54c4doSU2sCB6
	 w2bLhy3qcug9ZsJQ22+0Ed8Q1vyi5RlJOCr5pFrrHJ48ZZuHHcj3Sb33EXISKXgwMU
	 Hi3+gV4+6ZyOWmqi9kI2IfeaFFo3XJsR4YCBnmWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/476] ionic: pass opcode to devcmd_wait
Date: Wed, 21 Feb 2024 14:03:57 +0100
Message-ID: <20240221130014.759297604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b778d8264bca..f81b00c7e106 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -268,6 +268,7 @@ void ionic_dev_cmd_comp(struct ionic_dev *idev, union ionic_dev_cmd_comp *comp)
 
 void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd)
 {
+	idev->opcode = cmd->cmd.opcode;
 	memcpy_toio(&idev->dev_cmd_regs->cmd, cmd, sizeof(*cmd));
 	iowrite32(0, &idev->dev_cmd_regs->done);
 	iowrite32(1, &idev->dev_cmd_regs->doorbell);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 38f38fe8f21d..1ab86eee8b5a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -144,6 +144,7 @@ struct ionic_dev {
 	bool fw_hb_ready;
 	bool fw_status_ready;
 	u8 fw_generation;
+	u8 opcode;
 
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 538c024afed5..7942a7f0f7b3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -350,7 +350,7 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
-	opcode = readb(&idev->dev_cmd_regs->cmd.cmd.opcode);
+	opcode = idev->opcode;
 	start_time = jiffies;
 	do {
 		done = ionic_dev_cmd_done(idev);
-- 
2.43.0



