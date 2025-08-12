Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306152E4248;
	Tue, 12 Aug 2025 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023186; cv=none; b=CakkKeFS/746aLrVLulm5qYGeiSttLg8ouZbsYWYVLw+7fsOGrXkbcuuhl2sA4T5adVHYwk4RKrvWqUHB24PrJHVTV5clU9DcM6sCSmq/jn8ABn9LqZdJdEaQ3qQNZUBulJ/auD2Mi1rD128jz1zCVM9Mzx3N9HinrLDWNmj+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023186; c=relaxed/simple;
	bh=ORqbNgUob5MQDscsY75IALIRQRJglIfz0tz+2G3PBNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awpM9cBsKcQZpYuhdUqoage85CG4y4MXztIXDsQXwhrQcsvhrc0JnOxqEt0juh8HZd6JQnVZxBc+9nX6XeB+AWDb9m8xDW+D7As7jMnHSBNSQDUtQRP3U5c4Sua2dYVIxzheWzO+D/Eoa4OLA7OhTTG4c+YdWicovO6eo+VnHM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPEQCPXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPEQCPXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8053C4CEF0;
	Tue, 12 Aug 2025 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023186;
	bh=ORqbNgUob5MQDscsY75IALIRQRJglIfz0tz+2G3PBNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPEQCPXWNv7XRyb+5n9/v3LEbx1WesUkae9sApox4pAAw0XYLoKVnGkONTO1tfuYB
	 cRER2vFZ+pVM9X/nFBbeJG+dzXANVA11Omm9fOy7uy37YQm/7iALv6GHPrDKujhsAA
	 bkPGS2zEtoLDlQcfLKNs5wjMyxGsHwV4lgIwUjZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 361/369] MIPS: mm: tlb-r4k: Uniquify TLB entries on init
Date: Tue, 12 Aug 2025 19:30:58 +0200
Message-ID: <20250812173030.266802651@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -508,6 +508,60 @@ static int __init set_ntlb(char *str)
 
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
@@ -547,7 +601,7 @@ static void r4k_tlb_configure(void)
 	temp_tlb_entry = current_cpu_data.tlbsize - 1;
 
 	/* From this point on the ARC firmware is dead.	 */
-	local_flush_tlb_all();
+	r4k_tlb_uniquify();
 
 	/* Did I tell you that ARC SUCKS?  */
 }


