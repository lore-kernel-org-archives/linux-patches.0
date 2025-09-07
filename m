Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A414315A;
	Sun,  7 Sep 2025 20:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277887; cv=none; b=ItxPMMDaMT56Oi6kBTFCfZ91JdoBPxRTEMWHoTxuCQZN1agT6BaM4F9XJyhyBVHByKR++FAe8wiZQyrcCJ/GNTzZp8iWCZSOkYob7r7DD5oOTtAeus7mw1TIE1ml6YBbFKIp4auM1oXu99pP+CvDG4vOHjAqNMRKBmxlXuODVN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277887; c=relaxed/simple;
	bh=mP5J+ZOlTV5SGEbGYtB1K86DEm7Ov/e0EQUy+WzL+RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vc5yEzqcxnpWtqn+yNaaQ98sPpZ2+OB7AGNAwF55x1bNeml5BzL/SY2Uinu8rgNUWHPsw14+cF2eMmkXbZEqE/3d3TtKr8nzUUANa+1JoKpxwTjoLiG1GcIh9jW9CSehGH5RT3QSPXmeFj9tU/p59y46HiyEuicT9YWe/dCGvS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwJm5e7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwJm5e7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CEAC4CEF0;
	Sun,  7 Sep 2025 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277886;
	bh=mP5J+ZOlTV5SGEbGYtB1K86DEm7Ov/e0EQUy+WzL+RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwJm5e7Dv0Rys4Jqc5PgF8VcmFCPX/4rWJcxj68fgw2IIdpWT2rAG8n3k7/5zempp
	 C0iFT+HgKzVnr1pOjb+RYZ5nd5LVyYNZ3GypIjgHs5JKSAkSirGjE3iw1kbUqlG01W
	 3mzhMX3WaymAkzmiAie4W1BN69bxl4Bwy+XPHo2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 153/183] platform/x86/intel: power-domains: Use topology_logical_package_id() for package ID
Date: Sun,  7 Sep 2025 21:59:40 +0200
Message-ID: <20250907195619.452682225@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 9d8247bb9cfa5..8641353b2e061 100644
--- a/drivers/platform/x86/intel/tpmi_power_domains.c
+++ b/drivers/platform/x86/intel/tpmi_power_domains.c
@@ -178,7 +178,7 @@ static int tpmi_get_logical_id(unsigned int cpu, struct tpmi_cpu_info *info)
 
 	info->punit_thread_id = FIELD_GET(LP_ID_MASK, data);
 	info->punit_core_id = FIELD_GET(MODULE_ID_MASK, data);
-	info->pkg_id = topology_physical_package_id(cpu);
+	info->pkg_id = topology_logical_package_id(cpu);
 	info->linux_cpu = cpu;
 
 	return 0;
-- 
2.51.0



