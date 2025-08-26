Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B70734DCF1;
	Tue, 26 Aug 2025 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217562; cv=none; b=cUleFPL9cYgqmPvQCHubqdagi5YHOz/5/Va/zkTGUOTAhQqExZCmmPpSn/HslCK3Z8DZc8CdwK+KKLxzezFRi5Xs0qtrPjju1RIVmvuj9I49+A0NrA0n6Y8kb42JTwlZDINdO8IdigzzS7CUMP9OHvsITAIENk8kJ+0TJdXhZYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217562; c=relaxed/simple;
	bh=kGcpItgG24Z6ByXQTb5XT0wtXJrB43Io78woCXu3fzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcRl0lMEOf6N/Yu8RkjMK1Pm3uyjweolzAei+wF9FRxwz9OnNenMRWpLd0z2rPXyLCxVpiWqAX7n/BHE/x/gk2NJkVaFQhlZCg8+HWZKlabvM4/d3tV1RCQP7HXKPTJUSJbt7XNIxDRi1e3izpr1fDie9UVZPR7CX/ypr0eLqTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1ni+sQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1ni+sQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9DBC4CEF1;
	Tue, 26 Aug 2025 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217562;
	bh=kGcpItgG24Z6ByXQTb5XT0wtXJrB43Io78woCXu3fzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1ni+sQz86DbJs91cP8LKQFI3By1VrdOS/7dxVP0kMgEMxMt+vvNAx/AElH+lCGa5
	 r3r15Lw/P3znBWzPTTWFhrgjAiXJzmiMsgWTgGjeRQMwzgSSBt8TH4t/kCoeUeWzKR
	 hSMUoewbI9qr5TynOWHSi1kNikTirsf+7OpQYNTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 189/523] MIPS: mm: tlb-r4k: Uniquify TLB entries on init
Date: Tue, 26 Aug 2025 13:06:39 +0200
Message-ID: <20250826110929.112486856@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 35ad7e181541aa5757f9f316768d3e64403ec843 upstream.

Hardware or bootloader will initialize TLB entries to any value, which
may collide with kernel's UNIQUE_ENTRYHI value. On MIPS microAptiv/M5150
family of cores this will trigger machine check exception and cause boot
failure. On M5150 simulation this could happen 7 times out of 1000 boots.

Replace local_flush_tlb_all() with r4k_tlb_uniquify() which probes each
TLB ENTRIHI unique value for collisions before it's written, and in case
of collision try a different ASID.

Cc: stable@kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/tlb-r4k.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -498,6 +498,60 @@ static int __init set_ntlb(char *str)
 
 __setup("ntlb=", set_ntlb);
 
+/* Initialise all TLB entries with unique values */
+static void r4k_tlb_uniquify(void)
+{
+	int entry = num_wired_entries();
+
+	htw_stop();
+	write_c0_entrylo0(0);
+	write_c0_entrylo1(0);
+
+	while (entry < current_cpu_data.tlbsize) {
+		unsigned long asid_mask = cpu_asid_mask(&current_cpu_data);
+		unsigned long asid = 0;
+		int idx;
+
+		/* Skip wired MMID to make ginvt_mmid work */
+		if (cpu_has_mmid)
+			asid = MMID_KERNEL_WIRED + 1;
+
+		/* Check for match before using UNIQUE_ENTRYHI */
+		do {
+			if (cpu_has_mmid) {
+				write_c0_memorymapid(asid);
+				write_c0_entryhi(UNIQUE_ENTRYHI(entry));
+			} else {
+				write_c0_entryhi(UNIQUE_ENTRYHI(entry) | asid);
+			}
+			mtc0_tlbw_hazard();
+			tlb_probe();
+			tlb_probe_hazard();
+			idx = read_c0_index();
+			/* No match or match is on current entry */
+			if (idx < 0 || idx == entry)
+				break;
+			/*
+			 * If we hit a match, we need to try again with
+			 * a different ASID.
+			 */
+			asid++;
+		} while (asid < asid_mask);
+
+		if (idx >= 0 && idx != entry)
+			panic("Unable to uniquify TLB entry %d", idx);
+
+		write_c0_index(entry);
+		mtc0_tlbw_hazard();
+		tlb_write_indexed();
+		entry++;
+	}
+
+	tlbw_use_hazard();
+	htw_start();
+	flush_micro_tlb();
+}
+
 /*
  * Configure TLB (for init or after a CPU has been powered off).
  */
@@ -537,7 +591,7 @@ static void r4k_tlb_configure(void)
 	temp_tlb_entry = current_cpu_data.tlbsize - 1;
 
 	/* From this point on the ARC firmware is dead.	 */
-	local_flush_tlb_all();
+	r4k_tlb_uniquify();
 
 	/* Did I tell you that ARC SUCKS?  */
 }


