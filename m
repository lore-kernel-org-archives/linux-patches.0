Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84A737170
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/NpCfbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836E2C433C8;
	Wed, 15 Nov 2023 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076450;
	bh=kUgbqqpaqgEi4z0TpvVOL2V3+P4TCIDkSdLfUrLjuoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/NpCfbjMxnFNhtO4JMDMgkjey4VqVfGdxYgDKgGLoA/1OhE7rnJGdYby6ONEV7Dw
	 QlSxB3UDfrdsekZcHZGgjlgxLMPTh0Ag4whzxzfK/sr4L9etWbsQhX8BHX0JaL/Xve
	 g00SnbW7r34+kmVvzOh8U3NATzmyKyJZOKv8Z0Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 296/550] firmware: tegra: Add suspend hook and reset BPMP IPC early on resume
Date: Wed, 15 Nov 2023 14:14:40 -0500
Message-ID: <20231115191621.328710937@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit ea608a01d4ee66f8b51070e623f9adb8684c0dd4 ]

Add suspend hook and a 'suspended' field in the 'struct tegra_bpmp'
to mark if BPMP is suspended. Also, add a 'flags' field in the
'struct tegra_bpmp_message' whose 'TEGRA_BPMP_MESSAGE_RESET' bit can be
set from the Tegra MC driver to signal that the reset of BPMP IPC
channels is required before sending MRQ to the BPMP FW. Together both
the fields allow us to handle any requests that might be sent too soon
as they can cause hang during system resume.

One case where we see BPMP requests being sent before the BPMP driver
has resumed is the memory bandwidth requests which are triggered by
onlining the CPUs during system resume. The CPUs are onlined before the
BPMP has resumed and we need to reset the BPMP IPC channels to handle
these requests.

The additional check for 'flags' is done to avoid any un-intended BPMP
IPC reset if the tegra_bpmp_transfer*() API gets called during suspend
sequence after the BPMP driver is suspended.

Fixes: f41e1442ac5b ("cpufreq: tegra194: add OPP support and set bandwidth")
Co-developed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/bpmp.c | 30 ++++++++++++++++++++++++++++++
 include/soc/tegra/bpmp.h      |  6 ++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/firmware/tegra/bpmp.c b/drivers/firmware/tegra/bpmp.c
index 17bd3590aaa24..5ce202c26e8d3 100644
--- a/drivers/firmware/tegra/bpmp.c
+++ b/drivers/firmware/tegra/bpmp.c
@@ -314,6 +314,8 @@ static ssize_t tegra_bpmp_channel_write(struct tegra_bpmp_channel *channel,
 	return __tegra_bpmp_channel_write(channel, mrq, flags, data, size);
 }
 
+static int __maybe_unused tegra_bpmp_resume(struct device *dev);
+
 int tegra_bpmp_transfer_atomic(struct tegra_bpmp *bpmp,
 			       struct tegra_bpmp_message *msg)
 {
@@ -326,6 +328,14 @@ int tegra_bpmp_transfer_atomic(struct tegra_bpmp *bpmp,
 	if (!tegra_bpmp_message_valid(msg))
 		return -EINVAL;
 
+	if (bpmp->suspended) {
+		/* Reset BPMP IPC channels during resume based on flags passed */
+		if (msg->flags & TEGRA_BPMP_MESSAGE_RESET)
+			tegra_bpmp_resume(bpmp->dev);
+		else
+			return -EAGAIN;
+	}
+
 	channel = bpmp->tx_channel;
 
 	spin_lock(&bpmp->atomic_tx_lock);
@@ -365,6 +375,14 @@ int tegra_bpmp_transfer(struct tegra_bpmp *bpmp,
 	if (!tegra_bpmp_message_valid(msg))
 		return -EINVAL;
 
+	if (bpmp->suspended) {
+		/* Reset BPMP IPC channels during resume based on flags passed */
+		if (msg->flags & TEGRA_BPMP_MESSAGE_RESET)
+			tegra_bpmp_resume(bpmp->dev);
+		else
+			return -EAGAIN;
+	}
+
 	channel = tegra_bpmp_write_threaded(bpmp, msg->mrq, msg->tx.data,
 					    msg->tx.size);
 	if (IS_ERR(channel))
@@ -797,10 +815,21 @@ static int tegra_bpmp_probe(struct platform_device *pdev)
 	return err;
 }
 
+static int __maybe_unused tegra_bpmp_suspend(struct device *dev)
+{
+	struct tegra_bpmp *bpmp = dev_get_drvdata(dev);
+
+	bpmp->suspended = true;
+
+	return 0;
+}
+
 static int __maybe_unused tegra_bpmp_resume(struct device *dev)
 {
 	struct tegra_bpmp *bpmp = dev_get_drvdata(dev);
 
+	bpmp->suspended = false;
+
 	if (bpmp->soc->ops->resume)
 		return bpmp->soc->ops->resume(bpmp);
 	else
@@ -808,6 +837,7 @@ static int __maybe_unused tegra_bpmp_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops tegra_bpmp_pm_ops = {
+	.suspend_noirq = tegra_bpmp_suspend,
 	.resume_noirq = tegra_bpmp_resume,
 };
 
diff --git a/include/soc/tegra/bpmp.h b/include/soc/tegra/bpmp.h
index 5842e38bb2880..f5e4ac5b8cce8 100644
--- a/include/soc/tegra/bpmp.h
+++ b/include/soc/tegra/bpmp.h
@@ -102,8 +102,12 @@ struct tegra_bpmp {
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs_mirror;
 #endif
+
+	bool suspended;
 };
 
+#define TEGRA_BPMP_MESSAGE_RESET BIT(0)
+
 struct tegra_bpmp_message {
 	unsigned int mrq;
 
@@ -117,6 +121,8 @@ struct tegra_bpmp_message {
 		size_t size;
 		int ret;
 	} rx;
+
+	unsigned long flags;
 };
 
 #if IS_ENABLED(CONFIG_TEGRA_BPMP)
-- 
2.42.0



