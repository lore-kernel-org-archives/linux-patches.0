Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F5A824A3;
	Mon, 28 Oct 2024 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098430; cv=none; b=F/BEoyIACekO4zt6bQ84JSRgpDSR7kxSf+L5TRh+03x+Myz2lBNM90PTshUWc0QorBwE0LwXQqjbm5h3uVlCo/pqwgkgOirESxSIjUqNSjDuYnPB9tWRDopEkA+Y8iQ2y+z9pFi/t77jH2kQbyKvH/CBJb7vkIS/6WzxC57Rc9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098430; c=relaxed/simple;
	bh=w4G/RmUIhFItGymCaQZieBXipZjNsV9gSTtX5JeILnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvXc16svKbVDJTiTSex9Vy1ngcRqujmN3ToFNtZJum5cGcITvGwYdfWWBk2nZN0FBTrNWyiuBypfdVmMY9u9F0Tfz6KDVK2n1Opd1SVZSu8Wrt1D/O88J6NIU2bSL/iFsLXKD77h7CnDkSlICB6JYNlwdV96XV8vISS0sNUr9Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSZ3RLHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSZ3RLHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EA0C4CEC7;
	Mon, 28 Oct 2024 06:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098430;
	bh=w4G/RmUIhFItGymCaQZieBXipZjNsV9gSTtX5JeILnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSZ3RLHxF/lhCKJZRckGL3X/qf/Lcs1fAKJbbHdDtnpI2zwI+KsuO3res980kT4Qc
	 XcpDdHfv4jjXdhYuIGkCtYd2tU3TvigPD0dUWa67fmE15paieglKqN6Oi75dqubrdt
	 jbmOP+KZa0pK5y09ZpvkYsLTUS5zUbmrvIIO0dU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.11 224/261] x86/sev: Ensure that RMP table fixups are reserved
Date: Mon, 28 Oct 2024 07:26:06 +0100
Message-ID: <20241028062317.725775749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

commit 88a921aa3c6b006160d6a46a231b8b32227e8196 upstream.

The BIOS reserves RMP table memory via e820 reservations. This can still lead
to RMP page faults during kexec if the host tries to access memory within the
same 2MB region.

Commit

  400fea4b9651 ("x86/sev: Add callback to apply RMP table fixups for kexec"

adjusts the e820 reservations for the RMP table so that the entire 2MB range
at the start/end of the RMP table is marked reserved.

The e820 reservations are then passed to firmware via SNP_INIT where they get
marked HV-Fixed.

The RMP table fixups are done after the e820 ranges have been added to
memblock, allowing the fixup ranges to still be allocated and used by the
system.

The problem is that this memory range is now marked reserved in the e820
tables and during SNP initialization these reserved ranges are marked as
HV-Fixed.  This means that the pages cannot be used by an SNP guest, only by
the hypervisor.

However, the memory management subsystem does not make this distinction and
can allocate one of those pages to an SNP guest. This will ultimately result
in RMPUPDATE failures associated with the guest, causing it to fail to start
or terminate when accessing the HV-Fixed page.

The issue is captured below with memblock=debug:

  [    0.000000] SEV-SNP: *** DEBUG: snp_probe_rmptable_info:352 - rmp_base=0x280d4800000, rmp_end=0x28357efffff
  ...
  [    0.000000] BIOS-provided physical RAM map:
  ...
  [    0.000000] BIOS-e820: [mem 0x00000280d4800000-0x0000028357efffff] reserved
  [    0.000000] BIOS-e820: [mem 0x0000028357f00000-0x0000028357ffffff] usable
  ...
  ...
  [    0.183593] memblock add: [0x0000028357f00000-0x0000028357ffffff] e820__memblock_setup+0x74/0xb0
  ...
  [    0.203179] MEMBLOCK configuration:
  [    0.207057]  memory size = 0x0000027d0d194000 reserved size = 0x0000000009ed2c00
  [    0.215299]  memory.cnt  = 0xb
  ...
  [    0.311192]  memory[0x9]     [0x0000028357f00000-0x0000028357ffffff], 0x0000000000100000 bytes flags: 0x0
  ...
  ...
  [    0.419110] SEV-SNP: Reserving start/end of RMP table on a 2MB boundary [0x0000028357e00000]
  [    0.428514] e820: update [mem 0x28357e00000-0x28357ffffff] usable ==> reserved
  [    0.428517] e820: update [mem 0x28357e00000-0x28357ffffff] usable ==> reserved
  [    0.428520] e820: update [mem 0x28357e00000-0x28357ffffff] usable ==> reserved
  ...
  ...
  [    5.604051] MEMBLOCK configuration:
  [    5.607922]  memory size = 0x0000027d0d194000 reserved size = 0x0000000011faae02
  [    5.616163]  memory.cnt  = 0xe
  ...
  [    5.754525]  memory[0xc]     [0x0000028357f00000-0x0000028357ffffff], 0x0000000000100000 bytes on node 0 flags: 0x0
  ...
  ...
  [   10.080295] Early memory node ranges[   10.168065]
  ...
  node   0: [mem 0x0000028357f00000-0x0000028357ffffff]
  ...
  ...
  [ 8149.348948] SEV-SNP: RMPUPDATE failed for PFN 28357f7c, pg_level: 1, ret: 2

As shown above, the memblock allocations show 1MB after the end of the RMP as
available for allocation, which is what the RMP table fixups have reserved.
This memory range subsequently gets allocated as SNP guest memory, resulting
in an RMPUPDATE failure.

This can potentially be fixed by not reserving the memory range in the e820
table, but that causes kexec failures when using the KEXEC_FILE_LOAD syscall.

The solution is to use memblock_reserve() to mark the memory reserved for the
system, ensuring that it cannot be allocated to an SNP guest.

Since HV-Fixed memory is still readable/writable by the host, this only ends
up being a problem if the memory in this range requires a page state change,
which generally will only happen when allocating memory in this range to be
used for running SNP guests, which is now possible with the SNP hypervisor
support in kernel 6.11.

Backporter note:

Fixes tag points to a 6.9 change but as the last paragraph above explains,
this whole thing can happen after 6.11 received SNP HV support, therefore
backporting to 6.9 is not really necessary.

  [ bp: Massage commit message. ]

Fixes: 400fea4b9651 ("x86/sev: Add callback to apply RMP table fixups for kexec")
Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org> # 6.11, see Backporter note above.
Link: https://lore.kernel.org/r/20240815221630.131133-1-Ashish.Kalra@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/virt/svm/sev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -173,6 +173,8 @@ static void __init __snp_fixup_e820_tabl
 		e820__range_update(pa, PMD_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
 		e820__range_update_table(e820_table_kexec, pa, PMD_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
 		e820__range_update_table(e820_table_firmware, pa, PMD_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
+		if (!memblock_is_region_reserved(pa, PMD_SIZE))
+			memblock_reserve(pa, PMD_SIZE);
 	}
 }
 


