Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3278910E0
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 21:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650403169; x=1681939169;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WhXECTf3/mPf+krPicUL/PhJxyTSG44MJLyCJeT0ht4=;
  b=bwWdW/HJM3/y63UYEEb4mSsvmYBYT40ez7ZToOx12HH1xcXOa7vUwrMP
   Zapah6lTyFC65Y+ps5mXTpMi/eTvTh+MT1MzJ0hQ9ToauQ6w/3hIDFxvu
   aLXYSQZsWDUzMpwouwBgJJKexkfIKkdzftwjZhxzI/Q+Z8Gpe05QF/E+6
   5tgbxgzJUOx9N/raGPBnloqKSXlv/R7qgEeb7pZr60lJHF939i7w7dyDL
   31qa9fD2P/MrwYdzOJFni9K3xB+uP1QM7Xs/GlR5vVnQNV4qfjNNYPFRh
   q2jr7D/k35PF+UpdXJ8AKqcKIA/clYwovpXmnLPBuIJB5WygTUdVkjZoj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="243807755"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="243807755"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 14:19:28 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="530778373"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 14:19:27 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Borislav Petkov <bp@alien8.de>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] ACPI, APEI, EINJ: Refuse to inject into the zero page
Date: Tue, 19 Apr 2022 14:19:21 -0700
Message-Id: <20220419211921.2230752-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some validation tests dynamically inject errors into memory used by
applications to check that the system can recover from a variety of
poison consumption sceenarios.

But sometimes the virtual address picked by these tests is mapped to
the zero page.

This causes additional unexpected machine checks as other processes that
map the zero page also consume the poison.

Disallow injection to the zero page.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
I picked -EADDRINUSE as a somewhat descriptive error code distinct
fromm -EINVAL used elsewhere in EINJ, but I'm not strongly attached
to it. Any other non -EINVAL value would be as good an indicator to
the validation tests that they shouldn't inject to this address.
---
 drivers/acpi/apei/einj.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 95cc2a9f3e05..d4326ec12d29 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -549,6 +549,9 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
 	     !arch_is_platform_page(base_addr)))
 		return -EINVAL;
 
+	if (is_zero_pfn(base_addr >> PAGE_SHIFT))
+		return -EADDRINUSE;
+
 inject:
 	mutex_lock(&einj_mutex);
 	rc = __einj_error_inject(type, flags, param1, param2, param3, param4);
-- 
2.35.1

