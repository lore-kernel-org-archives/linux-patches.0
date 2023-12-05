Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CAD6AA0;
	Tue,  5 Dec 2023 03:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKyY271g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67401C433C8;
	Tue,  5 Dec 2023 03:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746501;
	bh=iokkyjSm8NDwgV2Bz2qkp+JHe1M82rGROAb52VG9t3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKyY271g8JUj+k5+9sqkChxnDivDWLRQdDvvlBCdzRqk3KxPSn/zBnGw8cTu05Vy5
	 54wUw6WTDFkuE28cJMAzTmRQAFKtjBVYFH1AvDAqqnO/uqnTV/zYg/IS2ih0dg778z
	 QcYgDo33a//5YpWw0AqRUOOlAArQ47j9pSwzh1FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 046/134] powercap: DTPM: Fix unneeded conversions to micro-Watts
Date: Tue,  5 Dec 2023 12:15:18 +0900
Message-ID: <20231205031538.481504835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Lukasz Luba <lukasz.luba@arm.com>

commit b817f1488fca548fe50e2654d84a1956a16a1a8a upstream.

The power values coming from the Energy Model are already in uW.

The PowerCap and DTPM frameworks operate on uW, so all places should
just use the values from the EM.

Fix the code by removing all of the conversion to uW still present in it.

Fixes: ae6ccaa65038 (PM: EM: convert power field to micro-Watts precision and align drivers)
Cc: 5.19+ <stable@vger.kernel.org> # v5.19+
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/dtpm_cpu.c     |    6 +-----
 drivers/powercap/dtpm_devfreq.c |   11 +++--------
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -24,7 +24,6 @@
 #include <linux/of.h>
 #include <linux/pm_qos.h>
 #include <linux/slab.h>
-#include <linux/units.h>
 
 struct dtpm_cpu {
 	struct dtpm dtpm;
@@ -104,8 +103,7 @@ static u64 get_pd_power_uw(struct dtpm *
 		if (pd->table[i].frequency < freq)
 			continue;
 
-		return scale_pd_power_uw(pd_mask, pd->table[i].power *
-					 MICROWATT_PER_MILLIWATT);
+		return scale_pd_power_uw(pd_mask, pd->table[i].power);
 	}
 
 	return 0;
@@ -122,11 +120,9 @@ static int update_pd_power_uw(struct dtp
 	nr_cpus = cpumask_weight(&cpus);
 
 	dtpm->power_min = em->table[0].power;
-	dtpm->power_min *= MICROWATT_PER_MILLIWATT;
 	dtpm->power_min *= nr_cpus;
 
 	dtpm->power_max = em->table[em->nr_perf_states - 1].power;
-	dtpm->power_max *= MICROWATT_PER_MILLIWATT;
 	dtpm->power_max *= nr_cpus;
 
 	return 0;
--- a/drivers/powercap/dtpm_devfreq.c
+++ b/drivers/powercap/dtpm_devfreq.c
@@ -39,10 +39,8 @@ static int update_pd_power_uw(struct dtp
 	struct em_perf_domain *pd = em_pd_get(dev);
 
 	dtpm->power_min = pd->table[0].power;
-	dtpm->power_min *= MICROWATT_PER_MILLIWATT;
 
 	dtpm->power_max = pd->table[pd->nr_perf_states - 1].power;
-	dtpm->power_max *= MICROWATT_PER_MILLIWATT;
 
 	return 0;
 }
@@ -54,13 +52,10 @@ static u64 set_pd_power_limit(struct dtp
 	struct device *dev = devfreq->dev.parent;
 	struct em_perf_domain *pd = em_pd_get(dev);
 	unsigned long freq;
-	u64 power;
 	int i;
 
 	for (i = 0; i < pd->nr_perf_states; i++) {
-
-		power = pd->table[i].power * MICROWATT_PER_MILLIWATT;
-		if (power > power_limit)
+		if (pd->table[i].power > power_limit)
 			break;
 	}
 
@@ -68,7 +63,7 @@ static u64 set_pd_power_limit(struct dtp
 
 	dev_pm_qos_update_request(&dtpm_devfreq->qos_req, freq);
 
-	power_limit = pd->table[i - 1].power * MICROWATT_PER_MILLIWATT;
+	power_limit = pd->table[i - 1].power;
 
 	return power_limit;
 }
@@ -110,7 +105,7 @@ static u64 get_pd_power_uw(struct dtpm *
 		if (pd->table[i].frequency < freq)
 			continue;
 
-		power = pd->table[i].power * MICROWATT_PER_MILLIWATT;
+		power = pd->table[i].power;
 		power *= status.busy_time;
 		power >>= 10;
 


