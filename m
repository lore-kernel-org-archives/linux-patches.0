Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693B35024F
	for <patches@lists.linux.dev>; Thu,  7 Dec 2023 19:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ikr6FZPh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701978988; x=1733514988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t5VxIPCjhEqavPh7wbXuE5TbTXLyEI0R+msiZrynqtw=;
  b=Ikr6FZPhlj4jHsZXxNaHOF41/E8SiQBzlKTqQSgKcMzfpeAEGfEeS/JU
   wPQgAgUo2tq97l/ErECsPbzgbtS/LLkfKQ0UFeageRjK0GnpNwg67dwgT
   xRk6D5XqFzXebJNC6xodltjwZpUHltTktvOiFdEZKmFmyOShpo9elc83l
   BSE0kv3lQAOAzoujYAQD++AqItQ2rUJlINZkFH7FGWqqZIdJofyK+3ITe
   b/fMsgxIw+iA2aaORdDDCBd6V7apehVdg+VE6LpnSj3ZJH1/7C4ypV4A7
   n5M0Jqpb+lS5YL4asf7C4AR1+LgKIV68goaMFS3rM3/zeFFc+o4Cy1A94
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="15848960"
X-IronPort-AV: E=Sophos;i="6.04,258,1695711600"; 
   d="scan'208";a="15848960"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 11:56:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="889858593"
X-IronPort-AV: E=Sophos;i="6.04,258,1695711600"; 
   d="scan'208";a="889858593"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 11:56:23 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v6 2/3] x86/resctrl: Use total bandwidth for mba_MBps option when local isn't present
Date: Thu,  7 Dec 2023 11:56:12 -0800
Message-ID: <20231207195613.153980-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231207195613.153980-1-tony.luck@intel.com>
References: <20231201214737.104444-1-tony.luck@intel.com>
 <20231207195613.153980-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Intel systems the memory bandwidth monitoring events are
independently enumerated. It is possible for a system to support
total memory bandwidth monitoring, but not support local bandwidth
monitoring. On such a system a user could not enable mba_sc mode.
Users will see this highly unhelpful error message from mount:

 # mount -t resctrl -o mba_MBps resctrl /sys/fs/resctrl
 mount: /sys/fs/resctrl: wrong fs type, bad option, bad superblock on
 resctrl, missing codepage or helper program, or other error.
 dmesg(1) may have more information after failed mount system call.

dmesg(1) does not provide any additional information.

Modify the existing "mba_MBps" mount option to switch to total bandwidth
monitoring if local monitoring is not available.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5f64a0b2597c..7410513db45a 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2725,6 +2725,8 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			return -EINVAL;
 		if (is_mbm_local_enabled())
 			ctx->enable_mba_mbps_local = true;
+		else if (is_mbm_total_enabled())
+			ctx->enable_mba_mbps_total = true;
 		else
 			return -EINVAL;
 		return 0;
-- 
2.41.0

