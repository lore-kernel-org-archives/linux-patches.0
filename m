Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED8C3101BC;
	Wed,  3 Dec 2025 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776721; cv=none; b=iUzISfvEf7D7bmGTtiT3X1xx//fisGkX4boZk8/wsLgBhD6+LuMIE+igG/UROX7CZuFasDopicpBC+XR+GjGChWaBVdCT0DeHygstIvt9S3iPquiEde1ybiBhXMbdOXkbxUKKUS7RMz3ofJNEeHbqOs3U2KVY6vhVLGjkf+4ZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776721; c=relaxed/simple;
	bh=7fXpVIHAGAdrYqaqS8AoXvmj7pX71aRJrR4K0mAYIPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQ33Z4HgbNNUuOXavvdJHRKjNyNTkjU1MvzLwg8HppSy5usFlgGhLNJ/P8We2wONhMcm4fxUx3VLbpupjHMZyzpcr1B77kZPWGe2F35ILAUU1q0ZvVPLANn5Pwjck02arWpnryMjYC/adKaJQIJti2tRUoTGqfcV5+s+kEBpzhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jk7tYJqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jk7tYJqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D6EC4CEF5;
	Wed,  3 Dec 2025 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776721;
	bh=7fXpVIHAGAdrYqaqS8AoXvmj7pX71aRJrR4K0mAYIPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jk7tYJqeS8nSErlSH3p3bB7lHZ9W0AH/fsoaQquywd8xymm1jT6bMFBhedhwNyQPx
	 2qIoDRAiTxc4JvrNckuGWVDm+SC0fcgrI6THzgKXutuhUogRU/F9M0xRcQmCmPq0bt
	 WdeujbPPdP1IKlQe0+wzBT4YN3OdNcPYI7IZlXKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 267/300] MIPS: mm: Prevent a TLB shutdown on initial uniquification
Date: Wed,  3 Dec 2025 16:27:51 +0100
Message-ID: <20251203152410.525787673@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 9f048fa487409e364cf866c957cf0b0d782ca5a3 upstream.

Depending on the particular CPU implementation a TLB shutdown may occur
if multiple matching entries are detected upon the execution of a TLBP
or the TLBWI/TLBWR instructions.  Given that we don't know what entries
we have been handed we need to be very careful with the initial TLB
setup and avoid all these instructions.

Therefore read all the TLB entries one by one with the TLBR instruction,
bypassing the content addressing logic, and truncate any large pages in
place so as to avoid a case in the second step where an incoming entry
for a large page at a lower address overlaps with a replacement entry
chosen at another index.  Then preinitialize the TLB using addresses
outside our usual unique range and avoiding clashes with any entries
received, before making the usual call to local_flush_tlb_all().

This fixes (at least) R4x00 cores if TLBP hits multiple matching TLB
entries (SGI IP22 PROM for examples sets up all TLBs to the same virtual
address).

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 35ad7e181541 ("MIPS: mm: tlb-r4k: Uniquify TLB entries on init")
Cc: stable@vger.kernel.org
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com> # Boston I6400, M5150 sim
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/tlb-r4k.c |  102 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 64 insertions(+), 38 deletions(-)

--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/export.h>
+#include <linux/sort.h>
 
 #include <asm/cpu.h>
 #include <asm/cpu-type.h>
@@ -498,55 +499,79 @@ static int __init set_ntlb(char *str)
 
 __setup("ntlb=", set_ntlb);
 
-/* Initialise all TLB entries with unique values */
+
+/* Comparison function for EntryHi VPN fields.  */
+static int r4k_vpn_cmp(const void *a, const void *b)
+{
+	long v = *(unsigned long *)a - *(unsigned long *)b;
+	int s = sizeof(long) > sizeof(int) ? sizeof(long) * 8 - 1: 0;
+	return s ? (v != 0) | v >> s : v;
+}
+
+/*
+ * Initialise all TLB entries with unique values that do not clash with
+ * what we have been handed over and what we'll be using ourselves.
+ */
 static void r4k_tlb_uniquify(void)
 {
-	int entry = num_wired_entries();
+	unsigned long tlb_vpns[1 << MIPS_CONF1_TLBS_SIZE];
+	int tlbsize = current_cpu_data.tlbsize;
+	int start = num_wired_entries();
+	unsigned long vpn_mask;
+	int cnt, ent, idx, i;
+
+	vpn_mask = GENMASK(cpu_vmbits - 1, 13);
+	vpn_mask |= IS_ENABLED(CONFIG_64BIT) ? 3ULL << 62 : 1 << 31;
 
 	htw_stop();
-	write_c0_entrylo0(0);
-	write_c0_entrylo1(0);
 
-	while (entry < current_cpu_data.tlbsize) {
-		unsigned long asid_mask = cpu_asid_mask(&current_cpu_data);
-		unsigned long asid = 0;
-		int idx;
+	for (i = start, cnt = 0; i < tlbsize; i++, cnt++) {
+		unsigned long vpn;
 
-		/* Skip wired MMID to make ginvt_mmid work */
-		if (cpu_has_mmid)
-			asid = MMID_KERNEL_WIRED + 1;
+		write_c0_index(i);
+		mtc0_tlbr_hazard();
+		tlb_read();
+		tlb_read_hazard();
+		vpn = read_c0_entryhi();
+		vpn &= vpn_mask & PAGE_MASK;
+		tlb_vpns[cnt] = vpn;
 
-		/* Check for match before using UNIQUE_ENTRYHI */
-		do {
-			if (cpu_has_mmid) {
-				write_c0_memorymapid(asid);
-				write_c0_entryhi(UNIQUE_ENTRYHI(entry));
-			} else {
-				write_c0_entryhi(UNIQUE_ENTRYHI(entry) | asid);
-			}
-			mtc0_tlbw_hazard();
-			tlb_probe();
-			tlb_probe_hazard();
-			idx = read_c0_index();
-			/* No match or match is on current entry */
-			if (idx < 0 || idx == entry)
-				break;
-			/*
-			 * If we hit a match, we need to try again with
-			 * a different ASID.
-			 */
-			asid++;
-		} while (asid < asid_mask);
-
-		if (idx >= 0 && idx != entry)
-			panic("Unable to uniquify TLB entry %d", idx);
-
-		write_c0_index(entry);
+		/* Prevent any large pages from overlapping regular ones.  */
+		write_c0_pagemask(read_c0_pagemask() & PM_DEFAULT_MASK);
 		mtc0_tlbw_hazard();
 		tlb_write_indexed();
-		entry++;
+		tlbw_use_hazard();
 	}
 
+	sort(tlb_vpns, cnt, sizeof(tlb_vpns[0]), r4k_vpn_cmp, NULL);
+
+	write_c0_pagemask(PM_DEFAULT_MASK);
+	write_c0_entrylo0(0);
+	write_c0_entrylo1(0);
+
+	idx = 0;
+	ent = tlbsize;
+	for (i = start; i < tlbsize; i++)
+		while (1) {
+			unsigned long entryhi, vpn;
+
+			entryhi = UNIQUE_ENTRYHI(ent);
+			vpn = entryhi & vpn_mask & PAGE_MASK;
+
+			if (idx >= cnt || vpn < tlb_vpns[idx]) {
+				write_c0_entryhi(entryhi);
+				write_c0_index(i);
+				mtc0_tlbw_hazard();
+				tlb_write_indexed();
+				ent++;
+				break;
+			} else if (vpn == tlb_vpns[idx]) {
+				ent++;
+			} else {
+				idx++;
+			}
+		}
+
 	tlbw_use_hazard();
 	htw_start();
 	flush_micro_tlb();
@@ -592,6 +617,7 @@ static void r4k_tlb_configure(void)
 
 	/* From this point on the ARC firmware is dead.	 */
 	r4k_tlb_uniquify();
+	local_flush_tlb_all();
 
 	/* Did I tell you that ARC SUCKS?  */
 }


