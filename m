Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD77F168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FB1C4339B;
	Mon,  8 May 2023 10:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541732;
	bh=n3QEz4aGFCKSi/bjyE9BdveUnSgb/cpcPmtwao7juVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IA5CwU5Bwh49DtXDoFbd+HUtMVUX4VLEKbLdOwaKbLkrBNktctZEdgUBwhLUniMjA
	 96hl/QUD12pO9qjpKXzrPYZVrUeH9DFFQUlPeShSt+5LAEqgo7GVvnlm/VR2xvGfk2
	 OuRXBsOzR77+euAfisdqC68XiLfO3llKd1Ca02ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muralidhara M K <muralimk@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 175/663] x86/MCE/AMD: Use an u64 for bank_map
Date: Mon,  8 May 2023 11:40:01 +0200
Message-Id: <20230508094434.140081099@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Muralidhara M K <muralimk@amd.com>

[ Upstream commit 4c1cdec319b9aadb65737c3eb1f5cb74bd6aa156 ]

Thee maximum number of MCA banks is 64 (MAX_NR_BANKS), see

  a0bc32b3cacf ("x86/mce: Increase maximum number of banks to 64").

However, the bank_map which contains a bitfield of which banks to
initialize is of type unsigned int and that overflows when those bit
numbers are >= 32, leading to UBSAN complaining correctly:

  UBSAN: shift-out-of-bounds in arch/x86/kernel/cpu/mce/amd.c:1365:38
  shift exponent 32 is too large for 32-bit type 'int'

Change the bank_map to a u64 and use the proper BIT_ULL() macro when
modifying bits in there.

  [ bp: Rewrite commit message. ]

Fixes: a0bc32b3cacf ("x86/mce: Increase maximum number of banks to 64")
Signed-off-by: Muralidhara M K <muralimk@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230127151601.1068324-1-muralimk@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/amd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 10fb5b5c9efa4..5518272061bfb 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -235,10 +235,10 @@ static DEFINE_PER_CPU(struct threshold_bank **, threshold_banks);
  * A list of the banks enabled on each logical CPU. Controls which respective
  * descriptors to initialize later in mce_threshold_create_device().
  */
-static DEFINE_PER_CPU(unsigned int, bank_map);
+static DEFINE_PER_CPU(u64, bank_map);
 
 /* Map of banks that have more than MCA_MISC0 available. */
-static DEFINE_PER_CPU(u32, smca_misc_banks_map);
+static DEFINE_PER_CPU(u64, smca_misc_banks_map);
 
 static void amd_threshold_interrupt(void);
 static void amd_deferred_error_interrupt(void);
@@ -267,7 +267,7 @@ static void smca_set_misc_banks_map(unsigned int bank, unsigned int cpu)
 		return;
 
 	if (low & MASK_BLKPTR_LO)
-		per_cpu(smca_misc_banks_map, cpu) |= BIT(bank);
+		per_cpu(smca_misc_banks_map, cpu) |= BIT_ULL(bank);
 
 }
 
@@ -528,7 +528,7 @@ static u32 smca_get_block_address(unsigned int bank, unsigned int block,
 	if (!block)
 		return MSR_AMD64_SMCA_MCx_MISC(bank);
 
-	if (!(per_cpu(smca_misc_banks_map, cpu) & BIT(bank)))
+	if (!(per_cpu(smca_misc_banks_map, cpu) & BIT_ULL(bank)))
 		return 0;
 
 	return MSR_AMD64_SMCA_MCx_MISCy(bank, block - 1);
@@ -572,7 +572,7 @@ prepare_threshold_block(unsigned int bank, unsigned int block, u32 addr,
 	int new;
 
 	if (!block)
-		per_cpu(bank_map, cpu) |= (1 << bank);
+		per_cpu(bank_map, cpu) |= BIT_ULL(bank);
 
 	memset(&b, 0, sizeof(b));
 	b.cpu			= cpu;
@@ -884,7 +884,7 @@ static void amd_threshold_interrupt(void)
 		return;
 
 	for (bank = 0; bank < this_cpu_read(mce_num_banks); ++bank) {
-		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
+		if (!(per_cpu(bank_map, cpu) & BIT_ULL(bank)))
 			continue;
 
 		first_block = bp[bank]->blocks;
@@ -1362,7 +1362,7 @@ int mce_threshold_create_device(unsigned int cpu)
 		return -ENOMEM;
 
 	for (bank = 0; bank < numbanks; ++bank) {
-		if (!(this_cpu_read(bank_map) & (1 << bank)))
+		if (!(this_cpu_read(bank_map) & BIT_ULL(bank)))
 			continue;
 		err = threshold_create_bank(bp, cpu, bank);
 		if (err) {
-- 
2.39.2



