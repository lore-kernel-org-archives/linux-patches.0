Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2073B0ADE;
	Thu, 16 Jul 2026 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211670; cv=none; b=Bo3LkmqiUHCQGCb5Ngb5x7hsJnXkXyGhL+6dfHPAfSS+qHMX3B6C7zBnzbA1IOr9ksfl5OIPMa+8HeI0kXuKeAqSMIeHgMWLUO1lNjevLKnG9aANg++NoiI1UXWggSVEH58qpGDpPCFCUsch3t9e4pdR4/Zh+0I/sWJ9IyGRDo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211670; c=relaxed/simple;
	bh=zwVL/1AHjrOwhte6SxnIajCy0dSVM02o0IEw6n7Ew7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2WndtU9xdOVURwie8ZPvg/ahDOQInD1K4GrXPyEyE6sLewaIKI2fd0do3DBKO5yqRu3ukAsrh8JMK6fYTuUdnGO/iON1SxohCe7soRfVOH2zUf31WU/LWCt+tui8g+TbWV9wvEqJ3r6rSxN5CNczyV1ryd6cYQ/CeeRDfTQDJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShuX0mmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShuX0mmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EC61F000E9;
	Thu, 16 Jul 2026 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211669;
	bh=mUI6h6lUBf87JpxLzwG2adgefXw6BdzTzirX/KYt8Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShuX0mmXLTacAIR7di6fmPUevgi+oJ9brJbIZ+8NBGITPDxELi18b6uEZvQQ8gH04
	 jzJ41zdc7/PwyYLsTAmzM9sRFFnT8piKHXuAOyuMIehxKBq2O9uPIv++Xfigl2iewD
	 gHWG4rL0f7H5KkePsvx/kkmylX7IgWzvdaa2CdK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jarred White <jarredwhite@linux.microsoft.com>,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 034/349] ACPI: CPPC: Suppress UBSAN warning caused by field misuse
Date: Thu, 16 Jul 2026 15:29:28 +0200
Message-ID: <20260716133034.073858585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Linton <jeremy.linton@arm.com>

commit 1b1acf2dada0cc3931bb2cb9ff8832edfbee46a1 upstream.

The definition of reg->access_width changes depending on the
reg->space_id type.  Type ACPI_ADR_SPACE_PLATFORM_COMM uses
access_width to indicate the PCC region, which can result in a UBSAN
if the value is greater than 4.

For example:

 UBSAN: shift-out-of-bounds in drivers/acpi/cppc_acpi.c:1090:9
 shift exponent 32 is too large for 32-bit type 'int'
 CPU: 61 UID: 0 PID: 1220 Comm: (udev-worker) Not tainted 7.0.10-201.fc44.aarch64 #1 PREEMPT(lazy)
 Hardware name: To be filled by O.E.M.
 Call trace:
  ...(trimming)
  ubsan_epilogue+0x10/0x48
  __ubsan_handle_shift_out_of_bounds+0xdc/0x1e0
  cpc_write+0x4d0/0x670
  cppc_set_perf+0x18c/0x490
  cppc_cpufreq_cpu_init+0x1c8/0x380 [cppc_cpufreq]
  ... (trimming)

Lets fix this by validating the region type, as well as whether
access_width has a value. Then since we are returning bit_width
directly for ACPI_ADR_SPACE_PLATFORM_COMM, drop the code correcting
the size.

Fixes: 2f4a4d63a193 ("ACPI: CPPC: Use access_width over bit_width for system memory accesses")
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Jarred White <jarredwhite@linux.microsoft.com>
Reviewed-by: Jarred White <jarredwhite@linux.microsoft.com>
Reviewed-by: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260601235808.1113137-1-jeremy.linton@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -172,8 +172,13 @@ show_cppc_data(cppc_get_perf_caps, cppc_
 show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, reference_perf);
 show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, wraparound_time);
 
-/* Check for valid access_width, otherwise, fallback to using bit_width */
-#define GET_BIT_WIDTH(reg) ((reg)->access_width ? (8 << ((reg)->access_width - 1)) : (reg)->bit_width)
+/*
+ * PCC reuses the access_width field as the subspace id, so only decode access
+ * size for non-PCC registers. Otherwise, use the bit_width.
+ */
+#define GET_BIT_WIDTH(reg) (((reg)->access_width &&				\
+			     (reg)->space_id != ACPI_ADR_SPACE_PLATFORM_COMM) ? \
+			    (8 << ((reg)->access_width - 1)) : (reg)->bit_width)
 
 /* Shift and apply the mask for CPC reads/writes */
 #define MASK_VAL_READ(reg, val) (((val) >> (reg)->bit_offset) &				\
@@ -1031,7 +1036,6 @@ static int cpc_read(int cpu, struct cpc_
 		 * by the bit width field; the access size is used to indicate
 		 * the PCC subspace id.
 		 */
-		size = reg->bit_width;
 		vaddr = GET_PCC_VADDR(reg->address, pcc_ss_id);
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
@@ -1103,7 +1107,6 @@ static int cpc_write(int cpu, struct cpc
 		 * by the bit width field; the access size is used to indicate
 		 * the PCC subspace id.
 		 */
-		size = reg->bit_width;
 		vaddr = GET_PCC_VADDR(reg->address, pcc_ss_id);
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)


