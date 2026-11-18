Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037629;
	b=h2FnjC/Tb5s3w1LFXdqc0aaQ5QP8xRDCPLRKGf0DA91lBCseztr5q8XYn5jR4B2DWYHF
	 mPyMXxFE6F3kcDm+L5EJSoElUrdzA6GB5RnmdW3e6OTuWqY6h+g28f80Kt/PM/YrZHKWA
	 P2lu43eBdFPNQAt9x52CHtlL1NbmT4s0P1F1+fALonMb06PTPRNJ9Djn2vEmKWbF0v4rh
	 dXqE1DiCzaymQrY7a9VBFfyD8GllWqpPyfu4zJ/ZVO19Rl+kpUC+vg5aafUSX5DCFY4UW
	 50RueN6NjpOe7gwAbsgUt/tnjUdYG62Q/5oOk/a1T6IEwgso5qz3wMvzm5uRl5BQgZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XrvkOsOEWI7T/oBdAKkbb90N4VYmox7mBRKvwh/8jLc=;
	b=3ytuUs01u6305nafEud3ORbg/7s+8SfUAcUrc/WDEBNuQl9J3lE/VQp6fXhpY/WO3Pq+
	 5NnXZHTLK3X51yHXciQ2LEiJwP8XDNucbKo3ejKMmdp64Z3cRFCz9+t1GgHd2hRscRJs+
	 QKLw3igMjLdlI2xtSkLBcPtd/kOJoObL8QVEKwvy3EaD+EAWo4GiZJXW066hpVDR1jAKp
	 4gdYlBnf44a3teBwiYkrCy7KXNkpE99blm+rtPFYPep2j+Dv2s8GZTBf+tFRU1Nrq0/ZZ
	 adOTYJUyl21zlvoBUj0GGB/V+Wg9ly0Po5M+dkNmzpqH/Q/x7N8OH44re/KWQblkSwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD7qejtz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F5A606A31C;
	Wed, 18 Nov 2026 21:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD7qejtz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523E91F000C4;
	Wed, 18 Nov 2026 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037628;
	bh=XrvkOsOEWI7T/oBdAKkbb90N4VYmox7mBRKvwh/8jLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yD7qejtzOIxZIFDG2OZZJmQASZH9UGkLxy1Af7dvBfPykNrKf0qfF0ra5qsbVs0lB
	 bmAKNMih1oDhzvhQRkpZh6edCvfvSHsl50WMMmijbKZRnFKDS3mxSzTRZQESla8yJ0
	 A0szmR7ZXFBEayqhMlIx+qR9j2zjWNg4BY16RINM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1462/3318] hwmon: (peci/dimmtemp) Fix devres leak and UAF on concurrent unbind
Date: Wed, 18 Nov 2026 15:34:44 +0100
Message-ID: <20261118150404.752008627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 01329fce39093..fcb77a147e4ee 100644
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



