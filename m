Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA9E13DDC0;
	Wed, 19 Jun 2024 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804027; cv=none; b=R0YwshIOGOkog4f5AAochtu/sfBViEtWHC6XyZlyjMRIQzuMI70k5+nAw6KQ4eP5XcurwyStYXPY1yMsb0+3J6bleAtfukupaF+X7emOkYR1XH6VAvW/CHgN2qVTvR7m2uUuap1p0vXEu+Szz7pcfo5NvRnMfJCG+iy7L5xLUfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804027; c=relaxed/simple;
	bh=JWgFXXd3ZCOIaRpB/zR3fU+DUuvgIFzfUXHUrZNUY5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ+U2VOx9hh8abB+GJcL0Ulb/zsib94S3RzmJkqvm/u1cPs/5yIdtRwQiQgZTq7WaQ82DeiLX9ReqUwxLkDPjoXwAXgtnMEkyhBn2bRKp2cRZbotYcfWlmXwBtXU4ivMVQGEZ+RTi8RlYjC0lZn2RYjf36ofjMLld5SJpsywaQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js3ncoDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js3ncoDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06893C2BBFC;
	Wed, 19 Jun 2024 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804027;
	bh=JWgFXXd3ZCOIaRpB/zR3fU+DUuvgIFzfUXHUrZNUY5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=js3ncoDFAiMFs1t2AEQDEwnLVBT8rt9JI1GX16R3YwX5Wvvaj/1KWoLjU2UzgwaAG
	 NXkBzHjzS/ro/1UvnUS1kGBrTLQXkFGVuhGpYpXA3IABIU8YMZSVA/ue2aEiIwe6eX
	 /75fJnfjau06p8EPXyhM2LLQiD/cZuVRfnfJA/3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 185/217] remoteproc: k3-r5: Do not allow core1 to power up before core0 via sysfs
Date: Wed, 19 Jun 2024 14:57:08 +0200
Message-ID: <20240619125603.824340072@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
@@ -543,7 +543,7 @@ static int k3_r5_rproc_start(struct rpro
 	struct k3_r5_rproc *kproc = rproc->priv;
 	struct k3_r5_cluster *cluster = kproc->cluster;
 	struct device *dev = kproc->dev;
-	struct k3_r5_core *core;
+	struct k3_r5_core *core0, *core;
 	u32 boot_addr;
 	int ret;
 
@@ -569,6 +569,15 @@ static int k3_r5_rproc_start(struct rpro
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
@@ -614,7 +623,8 @@ static int k3_r5_rproc_stop(struct rproc
 {
 	struct k3_r5_rproc *kproc = rproc->priv;
 	struct k3_r5_cluster *cluster = kproc->cluster;
-	struct k3_r5_core *core = kproc->core;
+	struct device *dev = kproc->dev;
+	struct k3_r5_core *core1, *core = kproc->core;
 	int ret;
 
 	/* halt all applicable cores */
@@ -627,6 +637,15 @@ static int k3_r5_rproc_stop(struct rproc
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


