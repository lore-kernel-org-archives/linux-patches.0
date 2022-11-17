Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA9817EC
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 04:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668657665; x=1700193665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VUNG8NIAa9pCK7zUL68UQaJAiq+0V2MYRuzo+MnCPyY=;
  b=EYNCM6Hs5Ibq8R6t/XhfRRTeOt+hEtgVqzDsaV9mzDyGmi+REa53VdCt
   0sHqeE1CyxqtjBb2a0dTqZsfDyD4uwssLYCAk94VvSyyrLxN8MsfRl99+
   /dTcngekyI8NOOWbXkZhDfbtQL2X6ug0y6F67OBRei+Bc4w/RV8Arbbp0
   gdkveuDducvFKpuzwzmUJKe/Rawfov+ctQM9ZJ6Sq2L/YvkIdD81LS3Fz
   L0uTvI0dMuuh9GmeLoRJTEGdRI74N52iQg0a002sqVw/QLtVzrt2bdulu
   Nz0yi1t3jUDHdapMcXCI5FbxSqI7S133PG+dFp+8jOVfaAWvP/O45lQEs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="399038905"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="399038905"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590462701"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590462701"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:58 -0800
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
Subject: [PATCH v3 10/16] platform/x86/intel/ifs: Add metadata support
Date: Wed, 16 Nov 2022 19:59:29 -0800
Message-Id: <20221117035935.4136738-11-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221117035935.4136738-1-jithu.joseph@intel.com>
References: <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221117035935.4136738-1-jithu.joseph@intel.com>
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

The location of metadata section within microcode header is as shown
below:

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

Upcoming changes will introduce the layout of IFS metadata
structure and will make use of metadata section.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index c914e4d359db..713f18ce00a1 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -43,6 +43,38 @@ static const char * const scan_authentication_status[] = {
 	[2] = "Chunk authentication error. The hash of chunk did not match expected value"
 };
 
+#define MC_HEADER_META_TYPE_END		(0)
+
+struct metadata_header {
+	unsigned int		type;
+	unsigned int		blk_size;
+};
+
+static struct metadata_header *find_meta_data(void *ucode, unsigned int meta_type)
+{
+	struct metadata_header *meta_header;
+	unsigned long data_size, total_meta;
+	unsigned long meta_size = 0;
+
+	data_size = get_datasize(ucode);
+	total_meta = ((struct microcode_intel *)ucode)->hdr.metasize;
+	if (!total_meta)
+		return NULL;
+
+	meta_header = (ucode + MC_HEADER_SIZE + data_size) - total_meta;
+
+	while (meta_header->type != MC_HEADER_META_TYPE_END &&
+	       meta_header->blk_size &&
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

