Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9365B1A5BA4;
	Tue, 11 Mar 2025 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707460; cv=none; b=b3iQX2B7qlmxQmR3shD6pKntC1+N+Iu8CPuLqO8rGNhXr8ozAlj6m9Fh4151qZlyu+apCCowSvmyBehwKVIGlFmA8M3XIp+BWKTeGRolyQAlUwyCkx/1Fvceqhy3UcXu74fTMAFHq75Ov4EG3m/mSkCM1bsxPXyqkijS9BIXiSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707460; c=relaxed/simple;
	bh=91q8NUoW4In5l/4m4vVDxHkGjk9tXrsHQD19s5nWJlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azflvlwPK/az7Q/ny/TJvslbALf1on7tt9jhWKRb+AoH3EhtBhHsEz2fmrBQf/89iNHzfXMn4SKYMnDU83QNJ10/Y+l/SE+c9yac883mQ4PcyKhCnmuQKaW4Zoq+u3QqMloh013XcGcw77ivw/IkBr007P4UVPim8WVDO6EPK70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+NP1oNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+NP1oNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1668FC4CEE9;
	Tue, 11 Mar 2025 15:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707460;
	bh=91q8NUoW4In5l/4m4vVDxHkGjk9tXrsHQD19s5nWJlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+NP1oNAxIxgRTDRkMQzcboEFY18pCDdMubbfAEnVRNwjrpVHtTR1az97a8egEX9Z
	 moouGdDMxMK3sjPxY6TXylwq0HcAyIrHywVZ7IxfXwx+mk0tkcTlJcmaL/pl7az4i8
	 1vHFRYtRgw02B5NofWw7c5BMlqnLLzd54lFFmbdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 397/462] x86/cpu: Properly parse CPUID leaf 0x2 TLB descriptor 0x63
Date: Tue, 11 Mar 2025 16:01:03 +0100
Message-ID: <20250311145814.018164624@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed S. Darwish <darwi@linutronix.de>

commit f6bdaab79ee4228a143ee1b4cb80416d6ffc0c63 upstream.

CPUID leaf 0x2's one-byte TLB descriptors report the number of entries
for specific TLB types, among other properties.

Typically, each emitted descriptor implies the same number of entries
for its respective TLB type(s).  An emitted 0x63 descriptor is an
exception: it implies 4 data TLB entries for 1GB pages and 32 data TLB
entries for 2MB or 4MB pages.

For the TLB descriptors parsing code, the entry count for 1GB pages is
encoded at the intel_tlb_table[] mapping, but the 2MB/4MB entry count is
totally ignored.

Update leaf 0x2's parsing logic 0x2 to account for 32 data TLB entries
for 2MB/4MB pages implied by the 0x63 descriptor.

Fixes: e0ba94f14f74 ("x86/tlb_info: get last level TLB entry number of CPU")
Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250304085152.51092-4-darwi@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel.c |   60 ++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 21 deletions(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -747,26 +747,37 @@ static unsigned int intel_size_cache(str
 }
 #endif
 
-#define TLB_INST_4K	0x01
-#define TLB_INST_4M	0x02
-#define TLB_INST_2M_4M	0x03
-
-#define TLB_INST_ALL	0x05
-#define TLB_INST_1G	0x06
-
-#define TLB_DATA_4K	0x11
-#define TLB_DATA_4M	0x12
-#define TLB_DATA_2M_4M	0x13
-#define TLB_DATA_4K_4M	0x14
-
-#define TLB_DATA_1G	0x16
-
-#define TLB_DATA0_4K	0x21
-#define TLB_DATA0_4M	0x22
-#define TLB_DATA0_2M_4M	0x23
-
-#define STLB_4K		0x41
-#define STLB_4K_2M	0x42
+#define TLB_INST_4K		0x01
+#define TLB_INST_4M		0x02
+#define TLB_INST_2M_4M		0x03
+
+#define TLB_INST_ALL		0x05
+#define TLB_INST_1G		0x06
+
+#define TLB_DATA_4K		0x11
+#define TLB_DATA_4M		0x12
+#define TLB_DATA_2M_4M		0x13
+#define TLB_DATA_4K_4M		0x14
+
+#define TLB_DATA_1G		0x16
+#define TLB_DATA_1G_2M_4M	0x17
+
+#define TLB_DATA0_4K		0x21
+#define TLB_DATA0_4M		0x22
+#define TLB_DATA0_2M_4M		0x23
+
+#define STLB_4K			0x41
+#define STLB_4K_2M		0x42
+
+/*
+ * All of leaf 0x2's one-byte TLB descriptors implies the same number of
+ * entries for their respective TLB types.  The 0x63 descriptor is an
+ * exception: it implies 4 dTLB entries for 1GB pages 32 dTLB entries
+ * for 2MB or 4MB pages.  Encode descriptor 0x63 dTLB entry count for
+ * 2MB/4MB pages here, as its count for dTLB 1GB pages is already at the
+ * intel_tlb_table[] mapping.
+ */
+#define TLB_0x63_2M_4M_ENTRIES	32
 
 static const struct _tlb_table intel_tlb_table[] = {
 	{ 0x01, TLB_INST_4K,		32,	" TLB_INST 4 KByte pages, 4-way set associative" },
@@ -788,7 +799,8 @@ static const struct _tlb_table intel_tlb
 	{ 0x5c, TLB_DATA_4K_4M,		128,	" TLB_DATA 4 KByte and 4 MByte pages" },
 	{ 0x5d, TLB_DATA_4K_4M,		256,	" TLB_DATA 4 KByte and 4 MByte pages" },
 	{ 0x61, TLB_INST_4K,		48,	" TLB_INST 4 KByte pages, full associative" },
-	{ 0x63, TLB_DATA_1G,		4,	" TLB_DATA 1 GByte pages, 4-way set associative" },
+	{ 0x63, TLB_DATA_1G_2M_4M,	4,	" TLB_DATA 1 GByte pages, 4-way set associative"
+						" (plus 32 entries TLB_DATA 2 MByte or 4 MByte pages, not encoded here)" },
 	{ 0x6b, TLB_DATA_4K,		256,	" TLB_DATA 4 KByte pages, 8-way associative" },
 	{ 0x6c, TLB_DATA_2M_4M,		128,	" TLB_DATA 2 MByte or 4 MByte pages, 8-way associative" },
 	{ 0x6d, TLB_DATA_1G,		16,	" TLB_DATA 1 GByte pages, fully associative" },
@@ -888,6 +900,12 @@ static void intel_tlb_lookup(const unsig
 		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
 			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
 		break;
+	case TLB_DATA_1G_2M_4M:
+		if (tlb_lld_2m[ENTRIES] < TLB_0x63_2M_4M_ENTRIES)
+			tlb_lld_2m[ENTRIES] = TLB_0x63_2M_4M_ENTRIES;
+		if (tlb_lld_4m[ENTRIES] < TLB_0x63_2M_4M_ENTRIES)
+			tlb_lld_4m[ENTRIES] = TLB_0x63_2M_4M_ENTRIES;
+		fallthrough;
 	case TLB_DATA_1G:
 		if (tlb_lld_1g[ENTRIES] < intel_tlb_table[k].entries)
 			tlb_lld_1g[ENTRIES] = intel_tlb_table[k].entries;


