Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D10359A8A
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477192; cv=none; b=nTgrdqmK4MC5lP6tQl5EvcoDeGrHJzFC5sfqR6XAoY0rmGXNmfV49oiK5Dcvpuh4hvXnju+AmlIGdCrSUfGBOMG1ZVwWG7pIFnlm7YOQj1a5B7aRX83PXNvqKzMwiJFjTGsxQ43PmoctdtuU2vU0NQM32DlT8NtJ1jLG0MJMue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477192; c=relaxed/simple;
	bh=nwyQzMGADx/PfQKCWg0k2WacxbE7C0hQBCBBvvQeJ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zy4G83cbwnJDtqJ6/998moe9XMj+xNCD08Ho0Y219kxubY1b/ojNnRMfAtg+AWVPN51F8DL38VevIyGcgmqG3SDjLEuzwXUYRX+ORTc3Q4IlMQ2GvUp8nzLf4viEMfbo82dD+u6JX7NcVvdjXcjnIdPuJ/SLMfwjlWXXL9dOREQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SalyVaCt; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SalyVaCt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477191; x=1804013191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nwyQzMGADx/PfQKCWg0k2WacxbE7C0hQBCBBvvQeJ94=;
  b=SalyVaCtGu0R+dQ+qTPgQ0jS++GesPcOybQXD4sETuZWJK35SmZjSnMv
   mpP8eLuKsxomCdiQoBIkUwiqaXrexVCBo2oD1kJyR4z3hoblpjTnfkbDI
   zRihJGUxxHHNvU6+2Awmr65nY5kCUXKeA/iZ9n/O2k+hyNmmrJmOMkBpe
   FyPFkQTYKS0YUHwqeknviqzPXxXxg8PaKmqJ7NSXMLT9qlPCJ6yb1xgQs
   BKigOSTWCCthEArKXp8NM3gnvVVRmgu0NgkF4T7vl2INvzNxVMw8029xo
   ArtOC7+Betvf2ed/BEqEWOAxzYz3moKo5KoRp+CvNx24b1UvvOoGOosL+
   g==;
X-CSE-ConnectionGUID: sOopaWwRQRySOuTeP1eusQ==
X-CSE-MsgGUID: SoHrYCdIRtO0XZN9YtnzWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135468"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135468"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: FItd45U6T5GnrJ2dKM4YIw==
X-CSE-MsgGUID: uVw9xmdBRKKfw9k9oeKV/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604089"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
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
Subject: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
Date: Mon,  2 Mar 2026 10:46:11 -0800
Message-ID: <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
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
---
 include/linux/resctrl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..48e95f273fb3 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -54,11 +54,11 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_PERF_PKG,
-
-	/* Must be the last */
-	RDT_NUM_RESOURCES,
+	/* Additions to enum need to update RDT_NUM_RESOURCES. */
 };
 
+#define RDT_NUM_RESOURCES (RDT_RESOURCE_PERF_PKG + 1)
+
 /**
  * enum resctrl_conf_type - The type of configuration.
  * @CDP_NONE:	No prioritisation, both code and data are controlled or monitored.
@@ -319,7 +319,7 @@ struct resctrl_mon {
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

