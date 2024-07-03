Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA65173328;
	Wed,  3 Jul 2024 11:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004693; cv=none; b=YoiffnMrtPWWHz9wnD+gEt06O413PIjaKVawGAg6GZKCTb1OmKaWLCfP3InKYhc5yFBnClbAu8sgmByX1gcAiDJ9lR9AYR9Ct4Ba9ziL2SPppob/NNwTAfMfRo2oe6v8lKOFkFkxSRlfTP9LO7gXNOrY3Py3ljpXx2ep3qKCeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004693; c=relaxed/simple;
	bh=S0OUneQuKI8vBqi7mTFrwsR15fU4+3GoL86YHBNQT+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6ZbrLVIk9g2zkQtozb5xHn4CitolLlsR96gQWSJmj7qyaU5OwOJSvbXO1qAHjHpvT11JedInJYu/TeB+2P7LtmIok5E4U1TOHqDXOdwzckfZDTw1K1Vy1gz56t+8AzFY6v7RB9S5ZAlgdZUYftn6mi8zpFAtyMY9yssPAVCB9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8qHZoag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8qHZoag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52639C2BD10;
	Wed,  3 Jul 2024 11:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004693;
	bh=S0OUneQuKI8vBqi7mTFrwsR15fU4+3GoL86YHBNQT+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8qHZoagAdaDhLXdrdFlygH7e3cxL8/0pZhatGcYa9vffnaBuyzSNcQpe4xHwkJdr
	 ZGd0BaMNt9L726xk1/N1t3aBk0lJ0++SpUD8MThR/o4NtQFcmp8tGL8JYGAnL2nAS1
	 xob2+d6usMAPNT3BqED44687pz9Up835znjoByCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 086/290] remoteproc: k3-r5: Do not allow core1 to power up before core0 via sysfs
Date: Wed,  3 Jul 2024 12:37:47 +0200
Message-ID: <20240703102907.442478413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beleswar Padhi <b-padhi@ti.com>

commit 3c8a9066d584f5010b6f4ba03bf6b19d28973d52 upstream.

PSC controller has a limitation that it can only power-up the second
core when the first core is in ON state. Power-state for core0 should be
equal to or higher than core1.

Therefore, prevent core1 from powering up before core0 during the start
process from sysfs. Similarly, prevent core0 from shutting down before
core1 has been shut down from sysfs.

Fixes: 6dedbd1d5443 ("remoteproc: k3-r5: Add a remoteproc driver for R5F subsystem")
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240430105307.1190615-3-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -429,7 +429,7 @@ static int k3_r5_rproc_start(struct rpro
 	struct k3_r5_cluster *cluster = kproc->cluster;
 	struct mbox_client *client = &kproc->client;
 	struct device *dev = kproc->dev;
-	struct k3_r5_core *core;
+	struct k3_r5_core *core0, *core;
 	u32 boot_addr;
 	int ret;
 
@@ -478,6 +478,15 @@ static int k3_r5_rproc_start(struct rpro
 				goto unroll_core_run;
 		}
 	} else {
+		/* do not allow core 1 to start before core 0 */
+		core0 = list_first_entry(&cluster->cores, struct k3_r5_core,
+					 elem);
+		if (core != core0 && core0->rproc->state == RPROC_OFFLINE) {
+			dev_err(dev, "%s: can not start core 1 before core 0\n",
+				__func__);
+			return -EPERM;
+		}
+
 		ret = k3_r5_core_run(core);
 		if (ret)
 			goto put_mbox;
@@ -518,7 +527,8 @@ static int k3_r5_rproc_stop(struct rproc
 {
 	struct k3_r5_rproc *kproc = rproc->priv;
 	struct k3_r5_cluster *cluster = kproc->cluster;
-	struct k3_r5_core *core = kproc->core;
+	struct device *dev = kproc->dev;
+	struct k3_r5_core *core1, *core = kproc->core;
 	int ret;
 
 	/* halt all applicable cores */
@@ -531,6 +541,15 @@ static int k3_r5_rproc_stop(struct rproc
 			}
 		}
 	} else {
+		/* do not allow core 0 to stop before core 1 */
+		core1 = list_last_entry(&cluster->cores, struct k3_r5_core,
+					elem);
+		if (core != core1 && core1->rproc->state != RPROC_OFFLINE) {
+			dev_err(dev, "%s: can not stop core 0 before core 1\n",
+				__func__);
+			return -EPERM;
+		}
+
 		ret = k3_r5_core_halt(core);
 		if (ret)
 			goto out;


