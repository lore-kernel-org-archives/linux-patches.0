Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D761A8412;
	Thu,  3 Jul 2025 15:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555709; cv=none; b=gPLmqDlIhD3OO1DW3YiGeMCUghPNetp3GdV0XyE/nQZmcM9f3a3MmIkn54z1UBayysRYN8tlk3BWN6KS2lXlAI5/IeiLXVjWjPUcNtzjpD8asfFXAY4FNMdXQf2qE3hUlgIxi3KcS36zg5uL26opRyuxcFuW3rMODqD9bzl+p08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555709; c=relaxed/simple;
	bh=+Q73dMwF6X6+G8mwUKOhIS1ZJcf62H9UqVoT6ubVym0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NC28Qbv/fetR9nbUkK0FYEZgLDPSNFBajIaykdbrCqUuv/PgrEv2sHpJ6+ubBhiSaDAYFimc8T+70Ia9HFix29ptwSMe8dcHL1Qb4vfOvVwoLHYXW46U/iYBiERJ/x/OKLjHugAPaEhC/1EYjxdilGFRdw2l+Bi6Gm7rya9d7rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1FVgFIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1FVgFIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FF6C4CEE3;
	Thu,  3 Jul 2025 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555709;
	bh=+Q73dMwF6X6+G8mwUKOhIS1ZJcf62H9UqVoT6ubVym0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1FVgFIGq0+eToAEXSg7QRbuLIt/cjIrvhOvdr4bifC9zIBPet/q5FAccUn/x7KeV
	 nhdawuqYArfWSjrXijSZD5slR73HAFlKK4HGQpSBREobNrE396257ddjN5xZAM96OT
	 8u9Pe8y9YjFiM13XdrWNOrNUL0ErDvQ1TP11ZN0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=BDilvinas=20=C5=BDaltiena?= <zilvinas@natrix.lt>,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: [PATCH 6.6 095/139] EDAC/amd64: Fix size calculation for Non-Power-of-Two DIMMs
Date: Thu,  3 Jul 2025 16:42:38 +0200
Message-ID: <20250703143944.873553899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avadhut Naik <avadhut.naik@amd.com>

commit a3f3040657417aeadb9622c629d4a0c2693a0f93 upstream.

Each Chip-Select (CS) of a Unified Memory Controller (UMC) on AMD Zen-based
SOCs has an Address Mask and a Secondary Address Mask register associated with
it. The amd64_edac module logs DIMM sizes on a per-UMC per-CS granularity
during init using these two registers.

Currently, the module primarily considers only the Address Mask register for
computing DIMM sizes. The Secondary Address Mask register is only considered
for odd CS. Additionally, if it has been considered, the Address Mask register
is ignored altogether for that CS. For power-of-two DIMMs i.e. DIMMs whose
total capacity is a power of two (32GB, 64GB, etc), this is not an issue
since only the Address Mask register is used.

For non-power-of-two DIMMs i.e., DIMMs whose total capacity is not a power of
two (48GB, 96GB, etc), however, the Secondary Address Mask register is used
in conjunction with the Address Mask register. However, since the module only
considers either of the two registers for a CS, the size computed by the
module is incorrect. The Secondary Address Mask register is not considered for
even CS, and the Address Mask register is not considered for odd CS.

Introduce a new helper function so that both Address Mask and Secondary
Address Mask registers are considered, when valid, for computing DIMM sizes.
Furthermore, also rename some variables for greater clarity.

Fixes: 81f5090db843 ("EDAC/amd64: Support asymmetric dual-rank DIMMs")
Closes: https://lore.kernel.org/dbec22b6-00f2-498b-b70d-ab6f8a5ec87e@natrix.lt
Reported-by: Žilvinas Žaltiena <zilvinas@natrix.lt>
Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Tested-by: Žilvinas Žaltiena <zilvinas@natrix.lt>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250529205013.403450-1-avadhut.naik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/amd64_edac.c |   57 +++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 21 deletions(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1475,7 +1475,9 @@ static int umc_get_cs_mode(int dimm, u8
 	if (csrow_enabled(2 * dimm + 1, ctrl, pvt))
 		cs_mode |= CS_ODD_PRIMARY;
 
-	/* Asymmetric dual-rank DIMM support. */
+	if (csrow_sec_enabled(2 * dimm, ctrl, pvt))
+		cs_mode |= CS_EVEN_SECONDARY;
+
 	if (csrow_sec_enabled(2 * dimm + 1, ctrl, pvt))
 		cs_mode |= CS_ODD_SECONDARY;
 
@@ -1496,12 +1498,13 @@ static int umc_get_cs_mode(int dimm, u8
 	return cs_mode;
 }
 
-static int __addr_mask_to_cs_size(u32 addr_mask_orig, unsigned int cs_mode,
-				  int csrow_nr, int dimm)
+static int calculate_cs_size(u32 mask, unsigned int cs_mode)
 {
-	u32 msb, weight, num_zero_bits;
-	u32 addr_mask_deinterleaved;
-	int size = 0;
+	int msb, weight, num_zero_bits;
+	u32 deinterleaved_mask;
+
+	if (!mask)
+		return 0;
 
 	/*
 	 * The number of zero bits in the mask is equal to the number of bits
@@ -1514,19 +1517,30 @@ static int __addr_mask_to_cs_size(u32 ad
 	 * without swapping with the most significant bit. This can be handled
 	 * by keeping the MSB where it is and ignoring the single zero bit.
 	 */
-	msb = fls(addr_mask_orig) - 1;
-	weight = hweight_long(addr_mask_orig);
+	msb = fls(mask) - 1;
+	weight = hweight_long(mask);
 	num_zero_bits = msb - weight - !!(cs_mode & CS_3R_INTERLEAVE);
 
 	/* Take the number of zero bits off from the top of the mask. */
-	addr_mask_deinterleaved = GENMASK_ULL(msb - num_zero_bits, 1);
+	deinterleaved_mask = GENMASK(msb - num_zero_bits, 1);
+	edac_dbg(1, "  Deinterleaved AddrMask: 0x%x\n", deinterleaved_mask);
+
+	return (deinterleaved_mask >> 2) + 1;
+}
+
+static int __addr_mask_to_cs_size(u32 addr_mask, u32 addr_mask_sec,
+				  unsigned int cs_mode, int csrow_nr, int dimm)
+{
+	int size;
 
 	edac_dbg(1, "CS%d DIMM%d AddrMasks:\n", csrow_nr, dimm);
-	edac_dbg(1, "  Original AddrMask: 0x%x\n", addr_mask_orig);
-	edac_dbg(1, "  Deinterleaved AddrMask: 0x%x\n", addr_mask_deinterleaved);
+	edac_dbg(1, "  Primary AddrMask: 0x%x\n", addr_mask);
 
 	/* Register [31:1] = Address [39:9]. Size is in kBs here. */
-	size = (addr_mask_deinterleaved >> 2) + 1;
+	size = calculate_cs_size(addr_mask, cs_mode);
+
+	edac_dbg(1, "  Secondary AddrMask: 0x%x\n", addr_mask_sec);
+	size += calculate_cs_size(addr_mask_sec, cs_mode);
 
 	/* Return size in MBs. */
 	return size >> 10;
@@ -1535,8 +1549,8 @@ static int __addr_mask_to_cs_size(u32 ad
 static int umc_addr_mask_to_cs_size(struct amd64_pvt *pvt, u8 umc,
 				    unsigned int cs_mode, int csrow_nr)
 {
+	u32 addr_mask = 0, addr_mask_sec = 0;
 	int cs_mask_nr = csrow_nr;
-	u32 addr_mask_orig;
 	int dimm, size = 0;
 
 	/* No Chip Selects are enabled. */
@@ -1574,13 +1588,13 @@ static int umc_addr_mask_to_cs_size(stru
 	if (!pvt->flags.zn_regs_v2)
 		cs_mask_nr >>= 1;
 
-	/* Asymmetric dual-rank DIMM support. */
-	if ((csrow_nr & 1) && (cs_mode & CS_ODD_SECONDARY))
-		addr_mask_orig = pvt->csels[umc].csmasks_sec[cs_mask_nr];
-	else
-		addr_mask_orig = pvt->csels[umc].csmasks[cs_mask_nr];
+	if (cs_mode & (CS_EVEN_PRIMARY | CS_ODD_PRIMARY))
+		addr_mask = pvt->csels[umc].csmasks[cs_mask_nr];
+
+	if (cs_mode & (CS_EVEN_SECONDARY | CS_ODD_SECONDARY))
+		addr_mask_sec = pvt->csels[umc].csmasks_sec[cs_mask_nr];
 
-	return __addr_mask_to_cs_size(addr_mask_orig, cs_mode, csrow_nr, dimm);
+	return __addr_mask_to_cs_size(addr_mask, addr_mask_sec, cs_mode, csrow_nr, dimm);
 }
 
 static void umc_debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
@@ -3773,9 +3787,10 @@ static void gpu_get_err_info(struct mce
 static int gpu_addr_mask_to_cs_size(struct amd64_pvt *pvt, u8 umc,
 				    unsigned int cs_mode, int csrow_nr)
 {
-	u32 addr_mask_orig = pvt->csels[umc].csmasks[csrow_nr];
+	u32 addr_mask		= pvt->csels[umc].csmasks[csrow_nr];
+	u32 addr_mask_sec	= pvt->csels[umc].csmasks_sec[csrow_nr];
 
-	return __addr_mask_to_cs_size(addr_mask_orig, cs_mode, csrow_nr, csrow_nr >> 1);
+	return __addr_mask_to_cs_size(addr_mask, addr_mask_sec, cs_mode, csrow_nr, csrow_nr >> 1);
 }
 
 static void gpu_debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)


