Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591106;
	b=BdNXrqHJtTQaVmqu/zgjncIeUW0zaLnK1b+yTZl6ptHAtMS1A6VpuMkb/UZrQs+JLUlz
	 PC0jFO6JDdevSWjdGrEd0b4QFuTv2FgOk1wAS5o6eunSztIju10MMuNuCPv3g1aMR5a+Z
	 k1udyihmWKdFGDi40M3P/geqSeai1gEtjkMAgIYx/+P8Bv2UeKT+4S50ZkR2AHpSBl2zY
	 OCTSNcUXsqGSCg7/PXcBeezcL/PgxklTrNAXBXysaH1HwxBbgyHJx0s03sJCwvcPGfoGg
	 1pe2oHl1j4SZF4iYqvlViF1T3W/N19XMSPwM7TQ51wFXu/A2IC2c3QCTuoYdDrGP/gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxWgQDht9lAEJdgjwI9aIdLcdK2b6CkynyzZ/jFmVDQ=;
	b=DMsqL6TKDrKeq/fec6UZa69am5LblA8Ruvfm9u8N9l7LhAQ1279XIXpRLtTyn3b3eFQc
	 staccVLwX32Z6F1X6ISCiBReZARQpKFKnmd6JXaROos/Vo5oNlk+c5NQboKalOlKvJm4A
	 4NgHb5wYknmPwTa2qbVmOuBONS0d67wAm7cdkNO6V8apQvBxNgYmhjuhoil+xwJwgugYe
	 DP7TEvMBHFlDbt+DRCPLeZ12jeTY1XKoYahLX1aAS3UtChRDaIW2LXjXVb6aVMvSCh7qV
	 aFPMNGZu5lgEctrdgwDoz7bWhFRY1uJTHkcvUN5XNSzCEaaV4ytsfS+ECfNl5El24KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WclUvGO6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D806074B12;
	Fri, 13 Nov 2026 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WclUvGO6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38CC1F000C4;
	Fri, 13 Nov 2026 17:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591106;
	bh=ZxWgQDht9lAEJdgjwI9aIdLcdK2b6CkynyzZ/jFmVDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WclUvGO6SoHPBAjj1tSikElTOZQipNwvcGvFK86hJLLnt73dOpZTO7a4Tfyk16m9w
	 +J0DVTg77rEJp0BIU/QC6SFXraI44aUF9uU+m3dO10iYbSGeP0J75zZ8PmTNFgtHf0
	 hfCwzlBN0tjewaooQy8370PCy2+7Lo/NQcAD2NgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/670] hwmon: (peci/dimmtemp) Fix devres leak and UAF on concurrent unbind
Date: Fri, 13 Nov 2026 10:47:03 -0500
Message-ID: <20261113153820.615044545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 61bc4514b8e99e9733c04de028885f6fc906d628 ]

When a peci_dimmtemp device is unbound concurrently with its delayed
initialization work (detect_work), newly allocated devm resources and
the hwmon device are leaked, leading to a use-after-free when reading
the lingering hwmon sysfs attributes.

In peci_dimmtemp_probe(), detect_work is registered for cancellation via
devm_delayed_work_autocancel(). During driver detach, devres_release_all()
first moves all existing entries from dev->devres_head onto a local todo
list before invoking their release callbacks in reverse order. If
create_dimm_temp_info_delayed() is already running when
devm_delayed_work_drop() calls cancel_delayed_work_sync(),
create_dimm_temp_info() can allocate dimmtemp_label strings via
devm_kzalloc()/devm_kasprintf() and register the hwmon device via
devm_hwmon_device_register_with_info(), appending new devres entries to
the now-empty dev->devres_head. Once the work finishes,
devres_release_all() frees priv and priv->name from the local todo list
without re-evaluating dev->devres_head, leaving the late devres
allocations and registered hwmon device behind with a dangling priv
pointer.

Cancel detect_work synchronously in a driver .remove() callback instead
of relying on devm_delayed_work_autocancel() so that the work is fully
drained before devres_release_all() detaches dev->devres_head, allowing
any devm resources registered by the delayed work to be released in
proper reverse order. Also only schedule detect_work when
check_populated_dimms() returns -EAGAIN so that probe failure paths do
not leave delayed work pending.

Fixes: 73bc1b885dae ("hwmon: peci: Add dimmtemp driver")
Cc: stable@vger.kernel.org
Cc: Iwona Winiarska <iwona.winiarska@intel.com>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/peci/dimmtemp.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/peci/dimmtemp.c b/drivers/hwmon/peci/dimmtemp.c
index b7b09780c7b0a..671ea8d3b8ad4 100644
--- a/drivers/hwmon/peci/dimmtemp.c
+++ b/drivers/hwmon/peci/dimmtemp.c
@@ -4,7 +4,6 @@
 #include <linux/auxiliary_bus.h>
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
-#include <linux/devm-helpers.h>
 #include <linux/hwmon.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
@@ -331,11 +330,13 @@ static int create_dimm_temp_info(struct peci_dimmtemp *priv)
 	if (ret == -ENODEV) {
 		dev_dbg(priv->dev, "No DIMMs found\n");
 		return 0;
-	} else if (ret) {
+	}
+	if (ret == -EAGAIN) {
 		schedule_delayed_work(&priv->detect_work, DIMM_MASK_CHECK_DELAY_JIFFIES);
 		dev_dbg(priv->dev, "Deferred populating DIMM temp info\n");
-		return ret;
 	}
+	if (ret)
+		return ret;
 
 	channels = priv->gen_info->chan_rank_max * priv->gen_info->dimm_idx_max;
 
@@ -405,10 +406,8 @@ static int peci_dimmtemp_probe(struct auxiliary_device *adev, const struct auxil
 			 "Unexpected PECI revision %#x, some features may be unavailable\n",
 			 peci_dev->info.peci_revision);
 
-	ret = devm_delayed_work_autocancel(priv->dev, &priv->detect_work,
-					   create_dimm_temp_info_delayed);
-	if (ret)
-		return ret;
+	auxiliary_set_drvdata(adev, priv);
+	INIT_DELAYED_WORK(&priv->detect_work, create_dimm_temp_info_delayed);
 
 	ret = create_dimm_temp_info(priv);
 	if (ret && ret != -EAGAIN) {
@@ -419,6 +418,13 @@ static int peci_dimmtemp_probe(struct auxiliary_device *adev, const struct auxil
 	return 0;
 }
 
+static void peci_dimmtemp_remove(struct auxiliary_device *adev)
+{
+	struct peci_dimmtemp *priv = auxiliary_get_drvdata(adev);
+
+	cancel_delayed_work_sync(&priv->detect_work);
+}
+
 static int
 read_thresholds_hsx(struct peci_dimmtemp *priv, int dimm_order, int chan_rank, u32 *data)
 {
@@ -655,6 +661,7 @@ MODULE_DEVICE_TABLE(auxiliary, peci_dimmtemp_ids);
 
 static struct auxiliary_driver peci_dimmtemp_driver = {
 	.probe		= peci_dimmtemp_probe,
+	.remove		= peci_dimmtemp_remove,
 	.id_table	= peci_dimmtemp_ids,
 };
 
-- 
2.53.0



