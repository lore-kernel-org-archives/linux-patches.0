Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1135A3081B3;
	Mon, 13 Oct 2025 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367420; cv=none; b=DCtTHC7Bdqwz1N+1SDmkqqm3aCZbbNGAVJV0Wcn6J9E8RtUhslX3Xpz8RLuf4HxtteXj9BQ5dWovFuF1Rv525qFoM9dDuJsU81e9J1jYNN3iVv/GPanNS6shJ/V/HQm8yCpmweAlfaXINDt/MVVuKg3y+R1BnHJ2tJzkAi+70jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367420; c=relaxed/simple;
	bh=q5CQu7NsdPDYOvHTTswwRtl6ABcGEqY/XR6/218t5O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU2JeE96cFYkDTMtb/IaxXMhmkUuT3Af7axY0x2Tsw8xqBHj/w+rJB/wsl3au1zZ3MMCuN1eo1htjxwv7oDxToTmEXLCaxtNrSrojLwTY42e5D5VUoSLXgqAReDFem/jicXrUNzzKo5+Vts2AEQ8PmEVZfTsPicpIK9U3u7nHh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqrpL0jL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqrpL0jL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C67BC4CEE7;
	Mon, 13 Oct 2025 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367419;
	bh=q5CQu7NsdPDYOvHTTswwRtl6ABcGEqY/XR6/218t5O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqrpL0jL8yxPyr6WMjQgv+zH3aErOfkpTlKX+XFCGOZS4Wd9Ppz6+ClPs4vzR7RvH
	 dzX8+oOUyqyTipIos14Hdy0o5FxdGoRkhnpznp4pD822V/CyZYX02lLY5Q7AoNg+za
	 C59h/R66qdKXq7T0G5ggqFDVqhb03oWDOj5tAyNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 195/196] cacheinfo: Fix LLC is not exported through sysfs
Date: Mon, 13 Oct 2025 16:46:08 +0200
Message-ID: <20251013144321.744322113@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

commit 5c2712387d4850e0b64121d5fd3e6c4e84ea3266 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


