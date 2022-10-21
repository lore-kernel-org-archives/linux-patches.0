Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687797B
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384554; x=1697920554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jYLjCtMe0oKlNW4X9hQ8u/gqYqo3txjMxVWcMyx5Mts=;
  b=m0+iBCmf3G12v8hUT0V5kQW4BRL3kFzifNcdH4xOdFcO9UEb7av8ZzXI
   mdr75j9WTSjHv+cr8PaNUzbePobGtDno0maqNW1bcFf0NtslvK51qM9Cc
   g+PggoQsTZsKnNY1F0UMfTvwafK/gNReCpUHrgM5QI2/IqD4sqt/PQcqd
   e6moFREwdEObT2RzbHUCs7vpuaMPI+LZzCO0QvPbWUaCzqm27SAoZcuDl
   VYgF87qOfd8/v46StkWEjzr7nb14CTM1qzV4/ykv2WFm7m51/rS9NOscA
   HIO4oJfNXQ0Tl5soGf0mrFkoI0CPMxiALUtbmoHDL2T9nwRcWB5R2zlYO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675903"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675903"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:35 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701014"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701014"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:34 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: [PATCH 06/14] x86/microcode/intel: Use appropriate type in microcode_sanity_check()
Date: Fri, 21 Oct 2022 13:34:05 -0700
Message-Id: <20221021203413.1220137-7-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021203413.1220137-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The data type of print_err parameter used by microcode_sanity_check()
is int. In prepration for exporting this function, to be used by
the IFS driver, Convert it to a more appropriate bool type for readability.

No functional change intended.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/kernel/cpu/microcode/intel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index f0cc60d92dfc..5473b094baee 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -164,7 +164,7 @@ static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigne
 		intel_ucode_patch = p->data;
 }
 
-static int microcode_sanity_check(void *mc, int print_err)
+static int microcode_sanity_check(void *mc, bool print_err)
 {
 	unsigned long total_size, data_size, ext_table_size;
 	struct microcode_header_intel *mc_header = mc;
@@ -282,7 +282,7 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 		mc_size = get_totalsize(mc_header);
 		if (!mc_size ||
 		    mc_size > size ||
-		    microcode_sanity_check(data, 0) < 0)
+		    microcode_sanity_check(data, false) < 0)
 			break;
 
 		size -= mc_size;
@@ -821,7 +821,7 @@ static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
 		memcpy(mc, &mc_header, sizeof(mc_header));
 		data = mc + sizeof(mc_header);
 		if (!copy_from_iter_full(data, data_size, iter) ||
-		    microcode_sanity_check(mc, 1) < 0) {
+		    microcode_sanity_check(mc, true) < 0) {
 			break;
 		}
 
-- 
2.25.1

