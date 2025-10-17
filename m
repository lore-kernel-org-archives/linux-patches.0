Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D379242935;
	Fri, 17 Oct 2025 15:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714362; cv=none; b=OLs6HMOI4BUsQANjoMiEMPzureCfN6wDOlAxr1Au/RF3MIvevBmBnSi/ljIv+uAo+YTdFG3gtrd0yS8WwX3NWhOwXuWOF65KSCrs41p4cDWvgg3apuM9SrUB64GKZDBQgd8mK+qTmb0QN5nQFbZgrcsDj0lnTV5BPj5oAnO4/no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714362; c=relaxed/simple;
	bh=Mh1ypalunFhOv8CUTbpWSJ2Oh5p+T0W/Zq/N1V4vgqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=asJxrWAICBecExQ4oIT/h0aHIGBrOf7fGs+UDBzbPYmgZ4Ee2z/cLSHI2D0NMln1yeuf/zRL72FqtkxBymf7OF7nIV+je1gDoEtdbsPVfkZcuEP5JouGtAoSESuFF6t6PVipaKpQ1s5+5z2RHva6KzOmp3N5t+4Ef6cScWBTqUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bumDgTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bumDgTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3066DC113D0;
	Fri, 17 Oct 2025 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714361;
	bh=Mh1ypalunFhOv8CUTbpWSJ2Oh5p+T0W/Zq/N1V4vgqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bumDgTpouIe8AaPJv0K0JBtro3FnjTEw9N/r/+c57yUAXFMqI0BXyBf0BaawUiXk
	 DEUpCt3LGIf8elA3yzbHloEgznzkpkjxxMioHWpkMwRuN16vTiR78ygR/NiGadE/Tn
	 tm5wr2cjXVqECQXeGj+DPyQAF+mWJRL2gFjgN12M=
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
Subject: [PATCH 6.12 118/277] drm/xe/uapi: loosen used tracking restriction
Date: Fri, 17 Oct 2025 16:52:05 +0200
Message-ID: <20251017145151.433531892@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -277,8 +277,7 @@ static int query_mem_regions(struct xe_d
 	mem_regions->mem_regions[0].instance = 0;
 	mem_regions->mem_regions[0].min_page_size = PAGE_SIZE;
 	mem_regions->mem_regions[0].total_size = man->size << PAGE_SHIFT;
-	if (perfmon_capable())
-		mem_regions->mem_regions[0].used = ttm_resource_manager_usage(man);
+	mem_regions->mem_regions[0].used = ttm_resource_manager_usage(man);
 	mem_regions->num_mem_regions = 1;
 
 	for (i = XE_PL_VRAM0; i <= XE_PL_VRAM1; ++i) {
@@ -294,13 +293,11 @@ static int query_mem_regions(struct xe_d
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


