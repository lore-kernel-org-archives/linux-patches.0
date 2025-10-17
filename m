Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18813328EC;
	Fri, 17 Oct 2025 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715369; cv=none; b=TZBj7kbutDZMFZd2Mt65yaihcKBSRJcFCmlXwx49L0kXbnxc6GDzAEqHmIp7aEM7VJaBF0TxaxT9BJC4fEUDNKfkAvx+awSv7hA4/laPG7dLOAK6z/WMSVFlxXvxmXoTS2sgqoPe0zytCG6ZgHw8klisSLk9RYKoCriOw7CQeJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715369; c=relaxed/simple;
	bh=UNUXHQq9GhukL+lhCqE2zrp5DZIlH2rlIZiC1s/KLw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=so53glvPVELnYIF12CEvyuY8v21Ekk6uE3ApcxB69UmAmarx2ZpCCXR3PyMPKzr7f3tch4AxuCsiQtd2BHJAe3hKkq4knH3rpvshDG8cUjSce6XnFOTYExoxEKk+vSxMwtXJtiGw4b1RSuIvlhDFobvg2J/jDJYNFh1MdSD2XtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umwNRz0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umwNRz0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9C2C4CEE7;
	Fri, 17 Oct 2025 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715369;
	bh=UNUXHQq9GhukL+lhCqE2zrp5DZIlH2rlIZiC1s/KLw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umwNRz0O26hb7DJ/sOapxiqo2tfnMf+q7lhgJU4jkLiYEX5I6op77TPpI265mzXW8
	 Q1zYrIwtontVKVKevoX3FhSU4WtsMdtZEWqeilndAiiOSf122wFEYleeXjkHK6Amn8
	 xCwPBHBta1UKG1/rHJEiWw3x5gt1ihQmwvipTOhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Joshua Santosh <joshua.santosh.ranjan@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.17 191/371] drm/xe/uapi: loosen used tracking restriction
Date: Fri, 17 Oct 2025 16:52:46 +0200
Message-ID: <20251017145208.837003819@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 2d1684a077d62fddfac074052c162ec6573a34e1 upstream.

Currently this is hidden behind perfmon_capable() since this is
technically an info leak, given that this is a system wide metric.
However the granularity reported here is always PAGE_SIZE aligned, which
matches what the core kernel is already willing to expose to userspace
if querying how many free RAM pages there are on the system, and that
doesn't need any special privileges. In addition other drm drivers seem
happy to expose this.

The motivation here if with oneAPI where they want to use the system
wide 'used' reporting here, so not the per-client fdinfo stats. This has
also come up with some perf overlay applications wanting this
information.

Fixes: 1105ac15d2a1 ("drm/xe/uapi: restrict system wide accounting")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Joshua Santosh <joshua.santosh.ranjan@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250919122052.420979-2-matthew.auld@intel.com
(cherry picked from commit 4d0b035fd6dae8ee48e9c928b10f14877e595356)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_query.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/xe/xe_query.c
+++ b/drivers/gpu/drm/xe/xe_query.c
@@ -274,8 +274,7 @@ static int query_mem_regions(struct xe_d
 	mem_regions->mem_regions[0].instance = 0;
 	mem_regions->mem_regions[0].min_page_size = PAGE_SIZE;
 	mem_regions->mem_regions[0].total_size = man->size << PAGE_SHIFT;
-	if (perfmon_capable())
-		mem_regions->mem_regions[0].used = ttm_resource_manager_usage(man);
+	mem_regions->mem_regions[0].used = ttm_resource_manager_usage(man);
 	mem_regions->num_mem_regions = 1;
 
 	for (i = XE_PL_VRAM0; i <= XE_PL_VRAM1; ++i) {
@@ -291,13 +290,11 @@ static int query_mem_regions(struct xe_d
 			mem_regions->mem_regions[mem_regions->num_mem_regions].total_size =
 				man->size;
 
-			if (perfmon_capable()) {
-				xe_ttm_vram_get_used(man,
-					&mem_regions->mem_regions
-					[mem_regions->num_mem_regions].used,
-					&mem_regions->mem_regions
-					[mem_regions->num_mem_regions].cpu_visible_used);
-			}
+			xe_ttm_vram_get_used(man,
+					     &mem_regions->mem_regions
+					     [mem_regions->num_mem_regions].used,
+					     &mem_regions->mem_regions
+					     [mem_regions->num_mem_regions].cpu_visible_used);
 
 			mem_regions->mem_regions[mem_regions->num_mem_regions].cpu_visible_size =
 				xe_ttm_vram_get_cpu_visible_size(man);


