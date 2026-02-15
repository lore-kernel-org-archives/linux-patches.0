Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704362FD7C3;
	Sun, 15 Feb 2026 17:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177294; cv=none; b=MZdzLpCvsOEW/OorqDfGhtuh+VGSodaNBH8SKbr2yBEb4PkKrtGoE0Ba/LbgSp3iKLFUvFmM7ZFobppEGVIwUTh0vM+jMdrveCEOW3nJXCvzMAWC1Oex3oisIIgF5fx9yWW9roTyvvkHS7uZSL+AkPQa0xDa5Afk+nmaT0ZFxvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177294; c=relaxed/simple;
	bh=LbQM1SY4h+dsVwn+X2vz/LGXYAHWPx+4nDtz+WVRXY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4kuAQCY3U9BI7denXF+pexXPrIDJagKT/fhdFVglX54zYxFlgvDzc0krRFdZBlvjaIdRuYQb446Uy1taXiimlS1QTbejwL2bWB6Xmmgc9SWWdB4lJI/eFxaiRlaeexu5Fhb5iD5FLDNJE8UOv03p87j0mQDLRnsqa9XFuN9DzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdK6NmcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdK6NmcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D7FC4CEF7;
	Sun, 15 Feb 2026 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177294;
	bh=LbQM1SY4h+dsVwn+X2vz/LGXYAHWPx+4nDtz+WVRXY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdK6NmcFacf//rpk+7mVBNLf9Uqw6vxsXU1TO8FE6CTNQvYRINSdI9AGMmCd4lVEx
	 veFIrQHD0RHWZ/N2p9mhKY/gARXQ+6GdUeVOsZNT7kKxd286kULU027R63mp9utP6p
	 2zyO8Ik66k6+NDYQRPZfPiylsL7d2boC5ZMXhYqBpfILEa0JQo1xYr4cVkaEI2OkbA
	 Wb8BXkWKcPdQu8Bj/SXXeQfXqo4Vy0oiaQnXZvDkR3+8xuZe/HwSCB5e6DnsEWTfS4
	 YYvBRnXlsfHkrDuZkHTz0LkO74O9NekcL1vlfXd8/ad5wVlhEjLPE5efOuBSalQuYp
	 qGgPvZHkaB6RQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	andersson@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-5.15] remoteproc: mediatek: Break lock dependency to `prepare_lock`
Date: Sun, 15 Feb 2026 12:41:18 -0500
Message-ID: <20260215174120.2390402-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215174120.2390402-1-sashal@kernel.org>
References: <20260215174120.2390402-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit d935187cfb27fc4168f78f3959aef4eafaae76bb ]

A potential circular locking dependency (ABBA deadlock) exists between
`ec_dev->lock` and the clock framework's `prepare_lock`.

The first order (A -> B) occurs when scp_ipi_send() is called while
`ec_dev->lock` is held (e.g., within cros_ec_cmd_xfer()):
1. cros_ec_cmd_xfer() acquires `ec_dev->lock` and calls scp_ipi_send().
2. scp_ipi_send() calls clk_prepare_enable(), which acquires
   `prepare_lock`.
See #0 in the following example calling trace.
(Lock Order: `ec_dev->lock` -> `prepare_lock`)

The reverse order (B -> A) is more complex and has been observed
(learned) by lockdep.  It involves the clock prepare operation
triggering power domain changes, which then propagates through sysfs
and power supply uevents, eventually calling back into the ChromeOS EC
driver and attempting to acquire `ec_dev->lock`:
1. Something calls clk_prepare(), which acquires `prepare_lock`.  It
   then triggers genpd operations like genpd_runtime_resume(), which
   takes `&genpd->mlock`.
2. Power domain changes can trigger regulator changes; regulator
   changes can then trigger device link changes; device link changes
   can then trigger sysfs changes.  Eventually, power_supply_uevent()
   is called.
3. This leads to calls like cros_usbpd_charger_get_prop(), which calls
   cros_ec_cmd_xfer_status(), which then attempts to acquire
   `ec_dev->lock`.
See #1 ~ #6 in the following example calling trace.
(Lock Order: `prepare_lock` -> `&genpd->mlock` -> ... -> `&ec_dev->lock`)

Move the clk_prepare()/clk_unprepare() operations for `scp->clk` to the
remoteproc prepare()/unprepare() callbacks.  This ensures `prepare_lock`
is only acquired in prepare()/unprepare() callbacks.  Since
`ec_dev->lock` is not involved in the callbacks, the dependency loop is
broken.

This means the clock is always "prepared" when the SCP is running.  The
prolonged "prepared time" for the clock should be acceptable as SCP is
designed to be a very power efficient processor.  The power consumption
impact can be negligible.

A simplified calling trace reported by lockdep:
> -> #6 (&ec_dev->lock)
>        cros_ec_cmd_xfer
>        cros_ec_cmd_xfer_status
>        cros_usbpd_charger_get_port_status
>        cros_usbpd_charger_get_prop
>        power_supply_get_property
>        power_supply_show_property
>        power_supply_uevent
>        dev_uevent
>        uevent_show
>        dev_attr_show
>        sysfs_kf_seq_show
>        kernfs_seq_show
> -> #5 (kn->active#2)
>        kernfs_drain
>        __kernfs_remove
>        kernfs_remove_by_name_ns
>        sysfs_remove_file_ns
>        device_del
>        __device_link_del
>        device_links_driver_bound
> -> #4 (device_links_lock)
>        device_link_remove
>        _regulator_put
>        regulator_put
> -> #3 (regulator_list_mutex)
>        regulator_lock_dependent
>        regulator_disable
>        scpsys_power_off
>        _genpd_power_off
>        genpd_power_off
> -> #2 (&genpd->mlock/1)
>        genpd_add_subdomain
>        pm_genpd_add_subdomain
>        scpsys_add_subdomain
>        scpsys_probe
> -> #1 (&genpd->mlock)
>        genpd_runtime_resume
>        __rpm_callback
>        rpm_callback
>        rpm_resume
>        __pm_runtime_resume
>        clk_core_prepare
>        clk_prepare
> -> #0 (prepare_lock)
>        clk_prepare
>        scp_ipi_send
>        scp_send_ipi
>        mtk_rpmsg_send
>        rpmsg_send
>        cros_ec_pkt_xfer_rpmsg

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20260112110755.2435899-1-tzungbi@kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - the `prepare`/`unprepare` ops were added in 2020, well before any
current stable tree branch point. They exist in 5.10, 5.15, 6.1, and all
newer stable trees.

### 5. User Impact Assessment

This affects **MediaTek SCP on ChromeOS devices** (Chromebooks with
MediaTek SoCs). The deadlock scenario involves:
- ChromeOS EC communication via rpmsg (SCP IPI)
- Clock framework interactions
- Power domain/regulator/device link chains

This is a real-world deadlock that lockdep detected. ChromeOS devices
are widely deployed, and a deadlock in the EC communication path could
cause a complete system hang.

### 6. Risk Assessment

**Changes are mechanical and low-risk:**
- All `clk_prepare_enable()` → `clk_enable()` (7 call sites)
- All `clk_disable_unprepare()` → `clk_disable()` (7 call sites)
- New `scp_prepare()`/`scp_unprepare()` callbacks added to `scp_ops`
  (simple wrappers)

**The pattern is well-established** - `clk_prepare()` is meant to be
called in sleepable context, `clk_enable()` can be called from any
context including IRQ. Separating them is a standard clock framework
pattern.

**Total: 30 insertions, 13 deletions** across 2 files - small and
contained.

### 7. Dependency Check

The commit is self-contained:
- No subsequent commits in these files depend on it
- The `rproc_ops.prepare`/`.unprepare` callbacks exist since 2020
  (present in all stable trees: 5.10+)
- No other infrastructure changes needed

### Verification

- **git log master** confirmed commit d935187cfb27f is the exact commit
  being analyzed
- **git log --oneline d935187cfb27f..master** confirmed no subsequent
  commits modify the same files (no dependencies)
- **git log/show 33467ac3c8dc8** confirmed `prepare`/`unprepare` ops
  were added to `rproc_ops` in April 2020, present in stable trees 5.10+
- **Code review of remoteproc_internal.h** confirmed
  `rproc_prepare_device()`/`rproc_unprepare_device()` wrappers exist and
  are called in `rproc_fw_boot()` and `rproc_shutdown()` paths
- **Reviewed-by and Tested-by** from Chen-Yu Tsai (wenst@chromium.org)
  confirms the fix was tested on real hardware
- **Lockdep call trace** in commit message confirms this is a real
  detected lock ordering issue, not theoretical
- The commit is a standalone single patch (not part of a series) -
  confirmed by lore.kernel.org link format (single patch, not X/Y)

### Summary

This commit fixes a **lockdep-detected ABBA deadlock** in the MediaTek
SCP remoteproc driver. The deadlock involves the clock framework's
`prepare_lock` and the ChromeOS EC's `ec_dev->lock`. The fix is
mechanically simple (splitting `clk_prepare_enable` into separate
`clk_prepare` + `clk_enable` calls), uses existing remoteproc framework
infrastructure (`prepare`/`unprepare` callbacks available since 2020),
and has been reviewed and tested. The scope is limited to 2 files with
30 insertions/13 deletions. The risk of regression is very low as it
uses a well-established clock framework pattern, and the benefit is
preventing a real deadlock on ChromeOS devices with MediaTek SoCs.

**YES**

 drivers/remoteproc/mtk_scp.c     | 39 +++++++++++++++++++++++---------
 drivers/remoteproc/mtk_scp_ipi.c |  4 ++--
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index db8fd045468d9..98d00bd5200cc 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -283,7 +283,7 @@ static irqreturn_t scp_irq_handler(int irq, void *priv)
 	struct mtk_scp *scp = priv;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clocks\n");
 		return IRQ_NONE;
@@ -291,7 +291,7 @@ static irqreturn_t scp_irq_handler(int irq, void *priv)
 
 	scp->data->scp_irq_handler(scp);
 
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return IRQ_HANDLED;
 }
@@ -665,7 +665,7 @@ static int scp_load(struct rproc *rproc, const struct firmware *fw)
 	struct device *dev = scp->dev;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clocks\n");
 		return ret;
@@ -680,7 +680,7 @@ static int scp_load(struct rproc *rproc, const struct firmware *fw)
 
 	ret = scp_elf_load_segments(rproc, fw);
 leave:
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return ret;
 }
@@ -691,14 +691,14 @@ static int scp_parse_fw(struct rproc *rproc, const struct firmware *fw)
 	struct device *dev = scp->dev;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clocks\n");
 		return ret;
 	}
 
 	ret = scp_ipi_init(scp, fw);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 	return ret;
 }
 
@@ -709,7 +709,7 @@ static int scp_start(struct rproc *rproc)
 	struct scp_run *run = &scp->run;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clocks\n");
 		return ret;
@@ -734,14 +734,14 @@ static int scp_start(struct rproc *rproc)
 		goto stop;
 	}
 
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 	dev_info(dev, "SCP is ready. FW version %s\n", run->fw_ver);
 
 	return 0;
 
 stop:
 	scp->data->scp_reset_assert(scp);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 	return ret;
 }
 
@@ -909,7 +909,7 @@ static int scp_stop(struct rproc *rproc)
 	struct mtk_scp *scp = rproc->priv;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clocks\n");
 		return ret;
@@ -917,12 +917,29 @@ static int scp_stop(struct rproc *rproc)
 
 	scp->data->scp_reset_assert(scp);
 	scp->data->scp_stop(scp);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return 0;
 }
 
+static int scp_prepare(struct rproc *rproc)
+{
+	struct mtk_scp *scp = rproc->priv;
+
+	return clk_prepare(scp->clk);
+}
+
+static int scp_unprepare(struct rproc *rproc)
+{
+	struct mtk_scp *scp = rproc->priv;
+
+	clk_unprepare(scp->clk);
+	return 0;
+}
+
 static const struct rproc_ops scp_ops = {
+	.prepare	= scp_prepare,
+	.unprepare	= scp_unprepare,
 	.start		= scp_start,
 	.stop		= scp_stop,
 	.load		= scp_load,
diff --git a/drivers/remoteproc/mtk_scp_ipi.c b/drivers/remoteproc/mtk_scp_ipi.c
index c068227e251e7..7a37e273b3af8 100644
--- a/drivers/remoteproc/mtk_scp_ipi.c
+++ b/drivers/remoteproc/mtk_scp_ipi.c
@@ -171,7 +171,7 @@ int scp_ipi_send(struct mtk_scp *scp, u32 id, void *buf, unsigned int len,
 	    WARN_ON(len > scp_sizes->ipi_share_buffer_size) || WARN_ON(!buf))
 		return -EINVAL;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clock\n");
 		return ret;
@@ -211,7 +211,7 @@ int scp_ipi_send(struct mtk_scp *scp, u32 id, void *buf, unsigned int len,
 
 unlock_mutex:
 	mutex_unlock(&scp->send_lock);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return ret;
 }
-- 
2.51.0

