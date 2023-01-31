Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA581AD30
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 23:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675208699; x=1706744699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=by5qRdZTxe0QTHHwMBIcWAw1uHYiJKW6XwzKCf+gNJo=;
  b=fN7Y4b9vxmwEMfm9bya1JbyIBCiSlFMvzCfklr7j27ufZItsGbuTKK3G
   TkCeoohmRMBIIaM1u0+bqc8/LpF1ttLzQOk7As7eMMiYY8RIpotYoPdDs
   r0ImJf+MnLBzwoNKsU7gk8nhc5tC0CzDIxlv8AD6jeIkZLIefjLidIgx/
   ERRRsooUPAf6QsP9vOcwDAfng34dLG42qum6MYaUTOZwfQ+1eBzqfETFp
   VtORKVGdgZx75cBL2xQvKsVINqjLPxW0yfTG7NiTXwrLt8sBC2YtXvBaI
   oMxsU3wYarkII4bMloQrdBqqQuNOPPwtj9acAnX3lAOP1g3ps7l0Vj+uY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="390360439"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="390360439"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 15:44:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="773192036"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="773192036"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 15:44:55 -0800
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
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH 5/5] platform/x86/intel/ifs: Trace support for array test
Date: Tue, 31 Jan 2023 15:43:02 -0800
Message-Id: <20230131234302.3997223-6-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230131234302.3997223-1-jithu.joseph@intel.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable tracing support in array test flow.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 include/trace/events/intel_ifs.h         | 27 ++++++++++++++++++++++++
 drivers/platform/x86/intel/ifs/runtest.c |  1 +
 2 files changed, 28 insertions(+)

diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/intel_ifs.h
index d7353024016c..db43df4139a2 100644
--- a/include/trace/events/intel_ifs.h
+++ b/include/trace/events/intel_ifs.h
@@ -35,6 +35,33 @@ TRACE_EVENT(ifs_status,
 		__entry->status)
 );
 
+TRACE_EVENT(ifs_array,
+
+	TP_PROTO(int cpu, union ifs_array activate, union ifs_array status),
+
+	TP_ARGS(cpu, activate, status),
+
+	TP_STRUCT__entry(
+		__field(	u64,	status	)
+		__field(	int,	cpu	)
+		__field(	u32,	arrays	)
+		__field(	u16,	bank	)
+	),
+
+	TP_fast_assign(
+		__entry->cpu	= cpu;
+		__entry->arrays	= activate.array_bitmask;
+		__entry->bank	= activate.array_bank;
+		__entry->status	= status.data;
+	),
+
+	TP_printk("cpu: %d, array_list: %.8x, array_bank: %.4x, status: %.16llx",
+		__entry->cpu,
+		__entry->arrays,
+		__entry->bank,
+		__entry->status)
+);
+
 #endif /* _TRACE_IFS_H */
 
 /* This part must be outside protection */
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index ec0ceb6b5890..4fd80d91ea29 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -301,6 +301,7 @@ static void ifs_array_test_core(int cpu, struct device *dev)
 		stop_core_cpuslocked(cpu, do_array_test, msrvals);
 		status.data = msrvals[1];
 
+		trace_ifs_array(cpu, activate, status);
 		if (status.ctrl_result)
 			break;
 
-- 
2.25.1

