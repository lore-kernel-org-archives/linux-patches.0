Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF0C35B158;
	Wed,  3 Dec 2025 16:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778932; cv=none; b=Zx++8yG9728fPqASuWapBI7kBiOOBShiwO49/Ds9xKI9JJfbEVeoH1+r6CinI04vHpde+A71A8yIudUEDfYRSTA3o3JkR1tAZffT9QlZH1QOBxUKNtKMXPRjvtTQw1G/UgiztKOkPr1+XihteN+e+omnmlPYpuMtK8PfEP/E4is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778932; c=relaxed/simple;
	bh=stfqXkuUNlUNO43/bAQrUAC7hveCilOQdMVA4hyd7oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgvL/NJiiKCLPHlEEeFDpupy9gE/iv39PLERCH7gB3TiXapF8w1dfKNo9bI8JPDXYDT0M0KE62C3tjkILkt1EYsTqS5wK2/A9nGSdgy+obWUz6j45Y1QtmMneMEV7MiU/tFt0mutrMwZ98DLzwXS188Wi0yVgAolUtjWQ+/iAJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gdoe1vqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gdoe1vqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52962C4CEF5;
	Wed,  3 Dec 2025 16:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778932;
	bh=stfqXkuUNlUNO43/bAQrUAC7hveCilOQdMVA4hyd7oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gdoe1vqvlrypMQKhlVAM+jBLPOsSRuB7yjEJBRUmLcy/J/SAkI1YFZtJ0EQpol+P8
	 5/loZaS8iuxBruL7SN+CaPYnMiBFWZAz/4bAkR07HPJMIshP7Iksuboi9YVNjqQOMF
	 lKHts9ndj52cNBD2lk0JFROiRJlBVJ+X8GBzn9lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 072/568] cacheinfo: Fix LLC is not exported through sysfs
Date: Wed,  3 Dec 2025 16:21:14 +0100
Message-ID: <20251203152443.347472535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 5c2712387d4850e0b64121d5fd3e6c4e84ea3266 ]

After entering 6.3-rc1 the LLC cacheinfo is not exported on our ACPI
based arm64 server. This is because the LLC cacheinfo is partly reset
when secondary CPUs boot up. On arm64 the primary cpu will allocate
and setup cacheinfo:
init_cpu_topology()
  for_each_possible_cpu()
    fetch_cache_info() // Allocate cacheinfo and init levels
detect_cache_attributes()
  cache_shared_cpu_map_setup()
    if (!last_level_cache_is_valid()) // not valid, setup LLC
      cache_setup_properties() // setup LLC

On secondary CPU boot up:
detect_cache_attributes()
  populate_cache_leaves()
    get_cache_type() // Get cache type from clidr_el1,
                     // for LLC type=CACHE_TYPE_NOCACHE
  cache_shared_cpu_map_setup()
    if (!last_level_cache_is_valid()) // Valid and won't go to this branch,
                                      // leave LLC's type=CACHE_TYPE_NOCACHE

The last_level_cache_is_valid() use cacheinfo->{attributes, fw_token} to
test it's valid or not, but populate_cache_leaves() will only reset
LLC's type, so we won't try to re-setup LLC's type and leave it
CACHE_TYPE_NOCACHE and won't export it through sysfs.

This patch tries to fix this by not re-populating the cache leaves if
the LLC is valid.

Fixes: 5944ce092b97 ("arch_topology: Build cacheinfo from primary CPU")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20230328114915.33340-1-yangyicong@huawei.com
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -490,12 +490,18 @@ int detect_cache_attributes(unsigned int
 
 populate_leaves:
 	/*
-	 * populate_cache_leaves() may completely setup the cache leaves and
-	 * shared_cpu_map or it may leave it partially setup.
+	 * If LLC is valid the cache leaves were already populated so just go to
+	 * update the cpu map.
 	 */
-	ret = populate_cache_leaves(cpu);
-	if (ret)
-		goto free_ci;
+	if (!last_level_cache_is_valid(cpu)) {
+		/*
+		 * populate_cache_leaves() may completely setup the cache leaves and
+		 * shared_cpu_map or it may leave it partially setup.
+		 */
+		ret = populate_cache_leaves(cpu);
+		if (ret)
+			goto free_ci;
+	}
 
 	/*
 	 * For systems using DT for cache hierarchy, fw_token


