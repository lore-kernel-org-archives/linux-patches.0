Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE13712FB31;
	Wed, 19 Jun 2024 13:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802473; cv=none; b=C3u1x9e++AQoK9agEkLfCc8ZGJGSc1vFL+0qO13RWUFzAgYMzjbp64heLIVzcUdGHaUybEx54TyC52xmU6GbLztckR2DCQIJCAYv5U5QLxoxUR5wF9nlt8FFPfZE44kebOaR9IZ8+SU3VYQZaUuiYGO992QQeuHKUfeBevtcJIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802473; c=relaxed/simple;
	bh=3XiINLcZ8Htzgqav9fCunOWubog8Ca/eO82bwSl2Ep0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2TzIdXXJXaDes9zKFAjnd0uU5ug4AQb4tftJGMif3EBDGqG606vWoGNIWmp9+fzNmcDK74zRXsEjeqcUYZExER6kqjgkwVXgn36O6stHrrjFWtkRIfui3c+A6ND9FDIqmXs1DHSvgAx4KHXCfNGhyEtFIzokIntOWt7+qa2doo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5sSkXbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5sSkXbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547C4C2BBFC;
	Wed, 19 Jun 2024 13:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802473;
	bh=3XiINLcZ8Htzgqav9fCunOWubog8Ca/eO82bwSl2Ep0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5sSkXbYUO/S7OPVO3JB82wZ7LjKGIB9taYSuQGp46Oo3r2QIrZWhB+272D6C1QYE
	 k4zXk4VmwzZ1+Oa1DDblbDkUdf0vtsoPiN63HYRczzx9beqaKE4J0hB756eXyUl9g6
	 3UTQzH5eGE5YM22WlMUE6rjXTlrXuncyoVEhGGh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Apurva Nandan <a-nandan@ti.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 208/267] remoteproc: k3-r5: Wait for core0 power-up before powering up core1
Date: Wed, 19 Jun 2024 14:55:59 +0200
Message-ID: <20240619125614.312612379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Apurva Nandan <a-nandan@ti.com>

commit 61f6f68447aba08aeaa97593af3a7d85a114891f upstream.

PSC controller has a limitation that it can only power-up the second core
when the first core is in ON state. Power-state for core0 should be equal
to or higher than core1, else the kernel is seen hanging during rproc
loading.

Make the powering up of cores sequential, by waiting for the current core
to power-up before proceeding to the next core, with a timeout of 2sec.
Add a wait queue event in k3_r5_cluster_rproc_init call, that will wait
for the current core to be released from reset before proceeding with the
next core.

Fixes: 6dedbd1d5443 ("remoteproc: k3-r5: Add a remoteproc driver for R5F subsystem")
Signed-off-by: Apurva Nandan <a-nandan@ti.com>
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240430105307.1190615-2-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c |   33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -103,12 +103,14 @@ struct k3_r5_soc_data {
  * @dev: cached device pointer
  * @mode: Mode to configure the Cluster - Split or LockStep
  * @cores: list of R5 cores within the cluster
+ * @core_transition: wait queue to sync core state changes
  * @soc_data: SoC-specific feature data for a R5FSS
  */
 struct k3_r5_cluster {
 	struct device *dev;
 	enum cluster_mode mode;
 	struct list_head cores;
+	wait_queue_head_t core_transition;
 	const struct k3_r5_soc_data *soc_data;
 };
 
@@ -128,6 +130,7 @@ struct k3_r5_cluster {
  * @atcm_enable: flag to control ATCM enablement
  * @btcm_enable: flag to control BTCM enablement
  * @loczrama: flag to dictate which TCM is at device address 0x0
+ * @released_from_reset: flag to signal when core is out of reset
  */
 struct k3_r5_core {
 	struct list_head elem;
@@ -144,6 +147,7 @@ struct k3_r5_core {
 	u32 atcm_enable;
 	u32 btcm_enable;
 	u32 loczrama;
+	bool released_from_reset;
 };
 
 /**
@@ -460,6 +464,8 @@ static int k3_r5_rproc_prepare(struct rp
 			ret);
 		return ret;
 	}
+	core->released_from_reset = true;
+	wake_up_interruptible(&cluster->core_transition);
 
 	/*
 	 * Newer IP revisions like on J7200 SoCs support h/w auto-initialization
@@ -1140,6 +1146,12 @@ static int k3_r5_rproc_configure_mode(st
 		return ret;
 	}
 
+	/*
+	 * Skip the waiting mechanism for sequential power-on of cores if the
+	 * core has already been booted by another entity.
+	 */
+	core->released_from_reset = c_state;
+
 	ret = ti_sci_proc_get_status(core->tsp, &boot_vec, &cfg, &ctrl,
 				     &stat);
 	if (ret < 0) {
@@ -1280,6 +1292,26 @@ init_rmem:
 		    cluster->mode == CLUSTER_MODE_SINGLECPU ||
 		    cluster->mode == CLUSTER_MODE_SINGLECORE)
 			break;
+
+		/*
+		 * R5 cores require to be powered on sequentially, core0
+		 * should be in higher power state than core1 in a cluster
+		 * So, wait for current core to power up before proceeding
+		 * to next core and put timeout of 2sec for each core.
+		 *
+		 * This waiting mechanism is necessary because
+		 * rproc_auto_boot_callback() for core1 can be called before
+		 * core0 due to thread execution order.
+		 */
+		ret = wait_event_interruptible_timeout(cluster->core_transition,
+						       core->released_from_reset,
+						       msecs_to_jiffies(2000));
+		if (ret <= 0) {
+			dev_err(dev,
+				"Timed out waiting for %s core to power up!\n",
+				rproc->name);
+			return ret;
+		}
 	}
 
 	return 0;
@@ -1709,6 +1741,7 @@ static int k3_r5_probe(struct platform_d
 	cluster->dev = dev;
 	cluster->soc_data = data;
 	INIT_LIST_HEAD(&cluster->cores);
+	init_waitqueue_head(&cluster->core_transition);
 
 	ret = of_property_read_u32(np, "ti,cluster-mode", &cluster->mode);
 	if (ret < 0 && ret != -EINVAL) {


