Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585607;
	b=Jx4zYuWWZLZQZ04w3nbRbCi1IGiWNDjLEduCicQFHX/D2FRbco289HrQFsILbXiKT2Uq
	 Vbvi+eIXvXJ5BL1H1wOfFMoINpEPygboaFFDLnj7qNsnh9w2OvqwicF8ABWjstXO2VDZB
	 cJtV8OyLpRbZ9hNZhe0MOyloRpg91v/XrHXr0rGSkxCf9MrkVejjUgz6VKNvqFNHemyhf
	 gNaPs+r4fZyG1t/gMaRU+6rUqsGQtQ332ZhcC5CXbsLZEtQzT4EUXMiCNGPEKo2iUo7k+
	 n7JvvEDrH8xJt78Eo6x+b3y4JpK9f1kT/L6CAWsvjvxDdyt0onTObs7+uUIEQpnSuSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jRUkABLH+WhGrfCNmQCVYUO1knKF1yGcKH7L3qdAKPw=;
	b=RiNi32sjUR/aV2WDRpm/FX/gTUx8r5hs3QKi3hjNF/7guLlZpxub2o9wFuZLvQ7R6gbf
	 UTZHtPWUL7G6sQM8s2rOqG/UdBSZGMWH49aqz3RQVPsQx68arkGdhM/QBISXWpP0bpVvR
	 z8EQg61jMTU1bYNG6hQlp6kbEE7U8XWuX5+Yf2ouPU6BN2EKMOJY7iWmRGdhiI0veExGa
	 sJ103P+dJQ5S3xhUwG1CDh5j4zKHE648gVmBAxDCri+z73HEApfP1Gl8Zbaq5ij66Xrct
	 aEsXsOd9440X1epMHz5zBhtzHiuIa9gkqnj79p+RIGI68rOg84z9MxsfXstx96EoUxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqD3Bj8O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D62606A33B;
	Fri, 13 Nov 2026 16:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqD3Bj8O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0281F000C4;
	Fri, 13 Nov 2026 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585606;
	bh=jRUkABLH+WhGrfCNmQCVYUO1knKF1yGcKH7L3qdAKPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqD3Bj8O+Nc4as3tRbuBVvsD2tnTPEQz7FVWiGwBc1cdZrdEyN7DC4tiumKJ71wBE
	 YCIG1wOXmMzrg2hH6AFFMVX4vWGDQo6GGOdNJrBNMffsMBnQDPKrJLwtpNB7BwICzT
	 en1zNjmETtwp52nEkfkIeDpSqsONRnx6CH5s5bMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 190/507] hwmon: (peci/dimmtemp) Fix devres leak and UAF on concurrent unbind
Date: Fri, 13 Nov 2026 10:48:14 -0500
Message-ID: <20261113153800.947552674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bd3e8715dfece..617a4cc0f65c7 100644
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
@@ -326,11 +325,13 @@ static int create_dimm_temp_info(struct peci_dimmtemp *priv)
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
 
@@ -398,10 +399,8 @@ static int peci_dimmtemp_probe(struct auxiliary_device *adev, const struct auxil
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
@@ -412,6 +411,13 @@ static int peci_dimmtemp_probe(struct auxiliary_device *adev, const struct auxil
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
@@ -665,6 +671,7 @@ MODULE_DEVICE_TABLE(auxiliary, peci_dimmtemp_ids);
 
 static struct auxiliary_driver peci_dimmtemp_driver = {
 	.probe		= peci_dimmtemp_probe,
+	.remove		= peci_dimmtemp_remove,
 	.id_table	= peci_dimmtemp_ids,
 };
 
-- 
2.53.0



