Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FF6400990;
	Thu, 16 Jul 2026 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210404; cv=none; b=YtoRxMJ922VyBmSOxp48StEC4T7viMrO1zNKBqyNDyvufnUnTeg2e8K3r8/JiHse/TmWisgdeyeuAIuxcTD6iy9FPwWJFwRdCcfddstPwwgBV0HBcUzLcTOcJhjjWCwMc1Nz68JuRN2jTTSOqaLPpTAkT61zxaff3H6ZutoV1Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210404; c=relaxed/simple;
	bh=GIuFrLIf+O5v9OzFdX+xVIF3FYZAoPo4ofBF8d12D/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbqaNH5OlnYmZtHOJamV9xAoB/uRpy5aA12vqV9oYuCXkuq3ygVUT5nxWKlqdOjNVKjVfFP5wUx5JKNNeYgEX0am9/PN1gaVuWF6kk/BUbhOXD9NdS3KVx1eLBocx7LZEEN33FEhCDZUAJo14opx3ontCMkqY3vUAzB0dGKYYWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdaD2jB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdaD2jB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45A91F000E9;
	Thu, 16 Jul 2026 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210403;
	bh=5O6Z4ahs4ktb+SlE8WsbLLvc3s9M9KrlOuu5uOnsRy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdaD2jB9rRjfESURVaPOvdvMHWmN6Hv4ZsWPbNosfE/ij2Jfwq3GIhp6NdFrmAJLB
	 neIM3920BfsgyQzD9TrLvBUxsRLSuFrU0pQvTujXf0+0iud3GEc1pt7TQCFqZzxh+3
	 QMT3gH5cxLKtU1mY3iYbzIOE/wXBmguCtr7DtcGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jarred White <jarredwhite@linux.microsoft.com>,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 033/480] ACPI: CPPC: Suppress UBSAN warning caused by field misuse
Date: Thu, 16 Jul 2026 15:26:20 +0200
Message-ID: <20260716133045.415478906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -185,8 +185,13 @@ show_cppc_data(cppc_get_perf_caps, cppc_
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
@@ -1036,7 +1041,6 @@ static int cpc_read(int cpu, struct cpc_
 		 * by the bit width field; the access size is used to indicate
 		 * the PCC subspace id.
 		 */
-		size = reg->bit_width;
 		vaddr = GET_PCC_VADDR(reg->address, pcc_ss_id);
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
@@ -1109,7 +1113,6 @@ static int cpc_write(int cpu, struct cpc
 		 * by the bit width field; the access size is used to indicate
 		 * the PCC subspace id.
 		 */
-		size = reg->bit_width;
 		vaddr = GET_PCC_VADDR(reg->address, pcc_ss_id);
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)


