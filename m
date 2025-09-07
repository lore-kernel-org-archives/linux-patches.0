Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364C41DF246;
	Sun,  7 Sep 2025 20:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277316; cv=none; b=j37QnGYb5gvThbQhICoB0pEfU1sfHbbsqiJZA5u0KwkyuVUuQEUEQpD7nbGx7sVSATcH7Hu+Jjo3Si0Mz0iwOGSXqZDMEBp031tatGHuas5uIH2t0kfl896UbiIhE49cSKrYzd5AJgBsj1nSKmWFK+PT/tPfy75NMD9HHFBuv9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277316; c=relaxed/simple;
	bh=h9bcyqWyH1Zc4zeNhewdS0T18O1HrrCCwUVXxEo9FFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEUVo7k//DnZcwFyG7Y9zWfT9AuYnzyxmHc6rC94Q6mYolW7GIBziefbF2tWWAjDIAnJ+Hh3bbUhOeN2ZRfJhMH/Zj2l/lzB2BGrJLVzceRGMhuLc2bHKaM5NdYWDJVL+/uV21zshpKHiN65+or7wINMcuLiEMnktJk0eKuvmB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq88XfV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq88XfV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A85C4CEF0;
	Sun,  7 Sep 2025 20:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277316;
	bh=h9bcyqWyH1Zc4zeNhewdS0T18O1HrrCCwUVXxEo9FFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq88XfV/JETW5yiq4TM9W7jAjyz98Uw8q82bTQKpICcdBvtn1XJMH1G7LlQOyyKyL
	 LC3jWcGGelH/JGX4Wl31gQCj79xEX71mtB1+/RW8poWD4GVIRT7wjxjiCDZRLomMNE
	 iuzs6/5gQzNKr/emvWbxwXGwug8E2Zu0iFj6D5ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/175] platform/x86/intel: power-domains: Use topology_logical_package_id() for package ID
Date: Sun,  7 Sep 2025 21:59:08 +0200
Message-ID: <20250907195618.476100492@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arcari <darcari@redhat.com>

[ Upstream commit aa28991fd5dc4c01a40caab2bd9af8c5e06f9899 ]

Currently, tpmi_get_logical_id() calls topology_physical_package_id()
to set the pkg_id of the info structure. Since some VM hosts assign non
contiguous package IDs, topology_physical_package_id() can return a
larger value than topology_max_packages(). This will result in an
invalid reference into tpmi_power_domain_mask[] as that is allocatead
based on topology_max_packages() as the maximum package ID.

Fixes: 17ca2780458c ("platform/x86/intel: TPMI domain id and CPU mapping")
Signed-off-by: David Arcari <darcari@redhat.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20250829113859.1772827-1-darcari@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/tpmi_power_domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/tpmi_power_domains.c b/drivers/platform/x86/intel/tpmi_power_domains.c
index 12fb0943b5dc3..7e0b86535d02c 100644
--- a/drivers/platform/x86/intel/tpmi_power_domains.c
+++ b/drivers/platform/x86/intel/tpmi_power_domains.c
@@ -167,7 +167,7 @@ static int tpmi_get_logical_id(unsigned int cpu, struct tpmi_cpu_info *info)
 
 	info->punit_thread_id = FIELD_GET(LP_ID_MASK, data);
 	info->punit_core_id = FIELD_GET(MODULE_ID_MASK, data);
-	info->pkg_id = topology_physical_package_id(cpu);
+	info->pkg_id = topology_logical_package_id(cpu);
 	info->linux_cpu = cpu;
 
 	return 0;
-- 
2.51.0



