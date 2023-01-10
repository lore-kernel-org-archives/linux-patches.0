Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461B16FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81669C433EF;
	Tue, 10 Jan 2023 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375144;
	bh=EIZqDPd9fNOCBCswgpx07PnRiZiEE9xZ/S9dqsC6PNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfXJMXeeZBuADVrYIvfdEugS24vzAXZMF4FIFBH0lB5TNWnWqelLH1plkw+fIYCjS
	 OLBeXYH+R81oQk8KGcWWRw/atZoyoHvfRutzbWy/VlTt6Fo4DzNdLX0TF4Xpla6Jj2
	 tMtoiq+MZUNyqHtD2MaBMiC/hXBoyPZEUgTQG0j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Antonov <alexander.antonov@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 5.15 065/290] perf/x86/intel/uncore: Disable I/O stacks to PMU mapping on ICX-D
Date: Tue, 10 Jan 2023 19:02:37 +0100
Message-Id: <20230110180033.876593847@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Antonov <alexander.antonov@linux.intel.com>

commit efe062705d149b20a15498cb999a9edbb8241e6f upstream.

Current implementation of I/O stacks to PMU mapping doesn't support ICX-D.
Detect ICX-D system to disable mapping.

Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221117122833.3103580-5-alexander.antonov@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore.h       |    1 +
 arch/x86/events/intel/uncore_snbep.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -2,6 +2,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <asm/apicdef.h>
+#include <asm/intel-family.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
 #include <linux/perf_event.h>
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5144,6 +5144,11 @@ static int icx_iio_get_topology(struct i
 
 static int icx_iio_set_mapping(struct intel_uncore_type *type)
 {
+	/* Detect ICX-D system. This case is not supported */
+	if (boot_cpu_data.x86_model == INTEL_FAM6_ICELAKE_D) {
+		pmu_clear_mapping_attr(type->attr_update, &icx_iio_mapping_group);
+		return -EPERM;
+	}
 	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
 }
 


