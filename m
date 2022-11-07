Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4D815C90
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861690; x=1699397690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mk+Vz7rzmu4MdLLvCybyRG1sgfbqtsuXJMMpfrS3JGA=;
  b=TevDA/lCyShBlwtpFzjHrSQ12PHP4rIPg4E3FHu7KpUfRJV2vA1o5hpk
   vldHg1KvCapl4jWh3EPUzDexL/kr/Pc+gE2mnC3CQ+fUQamioWqVZ9gGD
   98Mi1+jlKSbSL4rmWgT3VV+2xvNeuMiHrPIgg7bzZZIrpwlfdRSXsZX+/
   qkBUQ3DcEh3SpXPS471HQ63Td90/4hc83RFcJqSkD5uH9AYW1/lH2S4/D
   jpggX31w9WvZspiV0+82SjnNdnIT1ma7h710rnneDr+cmWjhtkcC3DmA7
   V6yrUqm8d8Dj0kJlVfb5n7cHfuLiy+5jpMZ0MtRbXRBAD09BRy4DAmKb6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697414"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697414"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012982"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012982"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:47 -0800
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
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v2 08/14] platform/x86/intel/ifs: Add metadata support
Date: Mon,  7 Nov 2022 14:53:17 -0800
Message-Id: <20221107225323.2733518-9-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107225323.2733518-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ashok Raj <ashok.raj@intel.com>

One of the existing reserved fields in microcode header has been
allocated to indicate the size for metadata structures.

The metadata section within microcode header is as shown below:

    Microcode Format
   +----------------------+  Base
   |Header Version        |
   +----------------------+
   |Update revision       |
   +----------------------+
   |Date DDMMYYYY         |
   +----------------------+
   |Sig                   |
   +----------------------+
   |Checksum              |
   +----------------------+
   |Loader Version        |
   +----------------------+
   |Processor Flags       |
   +----------------------+
   |Data Size             |
   +----------------------+
   |Total Size            |
   +----------------------+
   |Meta Size             |
   +----------------------+
   |Reserved              |
   +----------------------+
   |Reserved              |
   +----------------------+  Base+48
   |                      |
   |                      |
   |                      |
   |                      |
   |    Microcode         |
   |                      |
   |     Data             |
   |                      |
   |                      |
   +----------------------+  Base+48+data_size-
   |                      |     meta_size
   |   Meta Data          |
   |   structure(s)       |
   |                      |
   +----------------------+  Base+48+data_size
   |   Extended Signature |
   |        Table         |
   |                      |
   |                      |
   |                      |
   |                      |
   |                      |
   +----------------------+  Base+total_size

Add an accessor function which will return a pointer to the
start of a specific meta_type being queried.

In subsequent patches, IFS test image file (which reuse microcode header
format) will make use of metadata section.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 89ce265887ea..60ba5a057f91 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -44,6 +44,38 @@ static const char * const scan_authentication_status[] = {
 	[2] = "Chunk authentication error. The hash of chunk did not match expected value"
 };
 
+#define META_TYPE_END		(0)
+
+struct metadata_header {
+	unsigned int		type;
+	unsigned int		blk_size;
+};
+
+static struct metadata_header *ifs_find_meta_data(void *ucode, unsigned int meta_type)
+{
+	struct metadata_header *meta_header;
+	unsigned long data_size, total_meta;
+	unsigned long meta_size = 0;
+
+	data_size = get_datasize(ucode);
+	total_meta = ((struct microcode_intel *)ucode)->hdr.metasize;
+
+	if (!total_meta)
+		return NULL;
+
+	meta_header = (ucode + MC_HEADER_SIZE + data_size) - total_meta;
+
+	while ((meta_header->type != META_TYPE_END) && meta_header->blk_size &&
+	       meta_size < total_meta) {
+		meta_size += meta_header->blk_size;
+		if (meta_header->type == meta_type)
+			return meta_header;
+
+		meta_header = (void *)meta_header + meta_header->blk_size;
+	}
+	return NULL;
+}
+
 /*
  * To copy scan hashes and authenticate test chunks, the initiating cpu must point
  * to the EDX:EAX to the test image in linear address.
-- 
2.25.1

