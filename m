Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD33386452
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577763; cv=none; b=lWaxHf9S5mdi5Qcv4Hu5fm6TAyA6VQ0aLY6y+pv61jcumQsbvphBGBuSCZyBlxCsCFEueQz9/7sc5gf6qVTpD7elSodx0AZJrX6aQWGPJPoeLSt8LWWSiXD4A1rmENWOp+a0MpLbs577LpeHkIdKcUYvY/SzHKeij/Q9te6UkX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577763; c=relaxed/simple;
	bh=UmtJaEEjPND1GwglwNpwhcFwJ4D2HpzVcTyZRXsHAY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjIT+iG8WH0RJ99Y1gDYDHAM4OT5D0LiX1FZdEXNrIkBNJF5UNVqBc6C9Rq0y4eooy13mMt79tZan17hb0jC7ZqgsqX06HAJmoH7p7eAVhhKjxhTbeFmUyeC4y076EwvBEFSHhvCjxq7paHXPFdVvQi2cUtuut3sPtZB3BQDNms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e8btk1dX; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e8btk1dX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577756; x=1807113756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UmtJaEEjPND1GwglwNpwhcFwJ4D2HpzVcTyZRXsHAY0=;
  b=e8btk1dXH3+0y8TnUcON7OHve2i47YbuC4rv54LjXtCt59e3ecBel/9P
   WfChZU4xdMriM/EelPu42XFzYLPPyeaiL+v6k5zydlF/yXCaO95GB8uLY
   R0aX2pVnjvSDOkeQhsO9F1vgg/x+apWhJSk2kZUpX4aYdWXX9Ub44wtt/
   9HwZmn1EXI+SGdcFbdbE0u74I0ONcH4ZV2wKnff4A+N7mlxH1WkVsoU0/
   S5A/oypwPWvI3A8YEm+S+6ov9rKagCdbzomyBSGFIGB8knhwfH3DjBZTf
   Y8k5NQ+jN2lyFQpLl/fV5TTkBoxk69JBKzso6pRWUo2mFXTKg7kWA8DTV
   g==;
X-CSE-ConnectionGUID: MFVL4RsuSnOo06w+1/QKow==
X-CSE-MsgGUID: nJFYq9N0TpiCgwR03r43jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432713"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432713"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: t3q8wxuPRWqfMdBNYIPfZQ==
X-CSE-MsgGUID: i809PUXPQJK3CnY31pg2GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119050"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 07/13] fs/resctrl: Use accurate type for rdt_resource::rid
Date: Tue,  7 Apr 2026 09:02:04 -0700
Message-ID: <da613d2fd19093dd8a2b9b9cb49b3337c2f853fd.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every resctrl resource has a unique ID described by enum resctrl_res_level.
enum resctrl_res_level is used in all resource ID initializations and all
resource ID comparisons. All functions consuming the resource ID expects an
enum resctrl_res_level. Of the four structures that contain a resource ID
(struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
 rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.

Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
it obvious what values are valid, match the type everywhere this member is
used, and obtain benefits from tools that can flag any enum misuse.

Move define of RDT_NUM_RESOURCES outside the enum to enable tools to catch
when a switch() on the resource ID does not handle all the resources and
thus help flag which switch statements need an update when a new resource
is added.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v1:
- Use RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG as last entry in enum.(Ben)

Changes since v2:
- Add Ben's RB tag.
---
 include/linux/resctrl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0b28049378c8..99a4774735c7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -54,11 +54,11 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_PERF_PKG,
-
-	/* Must be the last */
-	RDT_NUM_RESOURCES,
+	RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG
 };
 
+#define RDT_NUM_RESOURCES (RDT_RESOURCE_LAST + 1)
+
 /**
  * enum resctrl_conf_type - The type of configuration.
  * @CDP_NONE:	No prioritisation, both code and data are controlled or monitored.
@@ -320,7 +320,7 @@ struct resctrl_mon {
  * @cdp_capable:	Is the CDP feature available on this resource
  */
 struct rdt_resource {
-	int			rid;
+	enum resctrl_res_level	rid;
 	bool			alloc_capable;
 	bool			mon_capable;
 	enum resctrl_scope	ctrl_scope;
-- 
2.50.1

