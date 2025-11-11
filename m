Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB12F2E403;
	Tue, 11 Nov 2025 01:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822872; cv=none; b=KHLuzQ29cJ8wJjA4rP0rFv91N6MW8zboXue7/bseMf/T2ZeXjwlXdG+Hxb12B7m1va5Nj0FIX7eZzP7FFhD5aJHGtF9ES9nidtm++zluYcRs4VPhy+vtzo5KFjWbG+StZYRowz/kwIJLdkHPTX8cdM9VqzrgwAHB8mKFSlcyjbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822872; c=relaxed/simple;
	bh=OLYu8DGg5GrRmupcsQl1iz1ljPSFktBr9MpOCJ0JLs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8slj1IjdLDpw1uoIwxXIYfO0BgbC+Oxq8JGm3l+Gt4YIKloOEAHU/oPifa3tOPxSNPZokYKiJH7N7jey7Od1FMHp0JjODH9yRXIiGfNDmVUBH+dIpRHOnBxCJFhMD5E2jkWZYvUWeaDizLlB08Z/6+BiInXCSIgnPXrh6idg0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMk/vtG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMk/vtG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C20C4CEFB;
	Tue, 11 Nov 2025 01:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822872;
	bh=OLYu8DGg5GrRmupcsQl1iz1ljPSFktBr9MpOCJ0JLs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMk/vtG1My7nsL4YmKuRVOCAOWu7hcGsE6UGyISBEgzMxnLqQLR5g8xZBRO41zsCd
	 PqZwbEYdVJMDUsJyKG1WvDwbvlqOqMykzLD6sWdO/8XQf56SdLB1zKKNxktMnynOtn
	 fwkSpUE5cqjZjAVN2LLg2JiLO8lsSQ4iDJjJgFak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 187/849] i3c: dw: Add shutdown support to dw_i3c_master driver
Date: Tue, 11 Nov 2025 09:35:57 +0900
Message-ID: <20251111004540.948013232@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Guntupalli <manikanta.guntupalli@amd.com>

[ Upstream commit 17e163f3d7a5449fe9065030048e28c4087b24ce ]

Add shutdown handler to the Synopsys DesignWare I3C master driver,
ensuring the device is gracefully disabled during system shutdown.

The shutdown handler cancels any pending hot-join work and disables
interrupts.

Signed-off-by: Manikanta Guntupalli <manikanta.guntupalli@amd.com>
Link: https://lore.kernel.org/r/20250730151207.4113708-1-manikanta.guntupalli@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 974122b2d20ee..9ceedf09c3b6a 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1737,6 +1737,28 @@ static const struct dev_pm_ops dw_i3c_pm_ops = {
 	SET_RUNTIME_PM_OPS(dw_i3c_master_runtime_suspend, dw_i3c_master_runtime_resume, NULL)
 };
 
+static void dw_i3c_shutdown(struct platform_device *pdev)
+{
+	struct dw_i3c_master *master = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(master->dev);
+	if (ret < 0) {
+		dev_err(master->dev,
+			"<%s> cannot resume i3c bus master, err: %d\n",
+			__func__, ret);
+		return;
+	}
+
+	cancel_work_sync(&master->hj_work);
+
+	/* Disable interrupts */
+	writel((u32)~INTR_ALL, master->regs + INTR_STATUS_EN);
+	writel((u32)~INTR_ALL, master->regs + INTR_SIGNAL_EN);
+
+	pm_runtime_put_autosuspend(master->dev);
+}
+
 static const struct of_device_id dw_i3c_master_of_match[] = {
 	{ .compatible = "snps,dw-i3c-master-1.00a", },
 	{},
@@ -1752,6 +1774,7 @@ MODULE_DEVICE_TABLE(acpi, amd_i3c_device_match);
 static struct platform_driver dw_i3c_driver = {
 	.probe = dw_i3c_probe,
 	.remove = dw_i3c_remove,
+	.shutdown = dw_i3c_shutdown,
 	.driver = {
 		.name = "dw-i3c-master",
 		.of_match_table = dw_i3c_master_of_match,
-- 
2.51.0



