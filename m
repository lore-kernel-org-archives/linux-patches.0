Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78DA12C499;
	Tue, 30 Apr 2024 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474650; cv=none; b=jV1SluqOlHQye4a02ossnEBBG+OgCmjmGOk0ugROn6y/TL2DInQlArNOwOYWZYiGjRSAQB9C5XDPSvc1lllX7TFLc8HhFipaitGJDi0Wdf51Y/qz4spO+eT5UUQFXZRaK5cXao3l8fhawPZDgfhY6ITI7Ew0UzIa3lL+VYWzRzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474650; c=relaxed/simple;
	bh=/NPikGZAQlmbGd9c8vuVlKXxGnbAqRl5P6cJy/9tAVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/0hrZz2YmYcg8Z1NMh3DOUxHa+RqyRWQMOitiXDRhdtrSRTWagbc/KMjReEQyS5xRq42vxo/fXQPOytCGPTygbl20DPuaLNChg/n5pM26bIXpf1BIYwLrqgb1sPD0KnKM6H7/LbefY6BMWc7Vy4sBTkia+NH2a5AmdPjtYpxEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGWAoYU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGWAoYU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C46BC2BBFC;
	Tue, 30 Apr 2024 10:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474650;
	bh=/NPikGZAQlmbGd9c8vuVlKXxGnbAqRl5P6cJy/9tAVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGWAoYU4xrdzPc2cusvIMGoJBCT/FOWbaj8HoNwroQpjPCXqtIY3abZQLwS0v2Ead
	 ggtQrc+NCBWsmOGkrxsT5j9rVSyI+7dRANYegxxp5TzvRY1qogLy8+ZKMbCO8uNPC+
	 7bR7LwxdIiHekMz+WeEtEwUb4PhSJwRtdyFJij/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vanshidhar Konda <vanshikonda@os.amperecomputing.com>,
	Jarred White <jarredwhite@linux.microsoft.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.8 184/228] ACPI: CPPC: Fix access width used for PCC registers
Date: Tue, 30 Apr 2024 12:39:22 +0200
Message-ID: <20240430103109.113154348@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vanshidhar Konda <vanshikonda@os.amperecomputing.com>

commit f489c948028b69cea235d9c0de1cc10eeb26a172 upstream.

commit 2f4a4d63a193 ("ACPI: CPPC: Use access_width over bit_width for system
memory accesses") modified cpc_read()/cpc_write() to use access_width to
read CPC registers.

However, for PCC registers the access width field in the ACPI register
macro specifies the PCC subspace ID.  For non-zero PCC subspace ID it is
incorrectly treated as access width. This causes errors when reading
from PCC registers in the CPPC driver.

For PCC registers, base the size of read/write on the bit width field.
The debug message in cpc_read()/cpc_write() is updated to print relevant
information for the address space type used to read the register.

Fixes: 2f4a4d63a193 ("ACPI: CPPC: Use access_width over bit_width for system memory accesses")
Signed-off-by: Vanshidhar Konda <vanshikonda@os.amperecomputing.com>
Tested-by: Jarred White <jarredwhite@linux.microsoft.com>
Reviewed-by: Jarred White <jarredwhite@linux.microsoft.com>
Reviewed-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: 5.15+ <stable@vger.kernel.org> # 5.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |   53 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 16 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1002,14 +1002,14 @@ static int cpc_read(int cpu, struct cpc_
 	}
 
 	*val = 0;
+	size = GET_BIT_WIDTH(reg);
 
 	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
-		u32 width = GET_BIT_WIDTH(reg);
 		u32 val_u32;
 		acpi_status status;
 
 		status = acpi_os_read_port((acpi_io_address)reg->address,
-					   &val_u32, width);
+					   &val_u32, size);
 		if (ACPI_FAILURE(status)) {
 			pr_debug("Error: Failed to read SystemIO port %llx\n",
 				 reg->address);
@@ -1018,17 +1018,22 @@ static int cpc_read(int cpu, struct cpc_
 
 		*val = val_u32;
 		return 0;
-	} else if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM && pcc_ss_id >= 0)
+	} else if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM && pcc_ss_id >= 0) {
+		/*
+		 * For registers in PCC space, the register size is determined
+		 * by the bit width field; the access size is used to indicate
+		 * the PCC subspace id.
+		 */
+		size = reg->bit_width;
 		vaddr = GET_PCC_VADDR(reg->address, pcc_ss_id);
+	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		vaddr = reg_res->sys_mem_vaddr;
 	else if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
 		return cpc_read_ffh(cpu, reg, val);
 	else
 		return acpi_os_read_memory((acpi_physical_address)reg->address,
-				val, reg->bit_width);
-
-	size = GET_BIT_WIDTH(reg);
+				val, size);
 
 	switch (size) {
 	case 8:
@@ -1044,8 +1049,13 @@ static int cpc_read(int cpu, struct cpc_
 		*val = readq_relaxed(vaddr);
 		break;
 	default:
-		pr_debug("Error: Cannot read %u bit width from PCC for ss: %d\n",
-			 reg->bit_width, pcc_ss_id);
+		if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
+			pr_debug("Error: Cannot read %u bit width from system memory: 0x%llx\n",
+				size, reg->address);
+		} else if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM) {
+			pr_debug("Error: Cannot read %u bit width from PCC for ss: %d\n",
+				size, pcc_ss_id);
+		}
 		return -EFAULT;
 	}
 
@@ -1063,12 +1073,13 @@ static int cpc_write(int cpu, struct cpc
 	int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
 	struct cpc_reg *reg = &reg_res->cpc_entry.reg;
 
+	size = GET_BIT_WIDTH(reg);
+
 	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
-		u32 width = GET_BIT_WIDTH(reg);
 		acpi_status status;
 
 		status = acpi_os_write_port((acpi_io_address)reg->address,
-					    (u32)val, width);
+					    (u32)val, size);
 		if (ACPI_FAILURE(status)) {
 			pr_debug("Error: Failed to write SystemIO port %llx\n",
 				 reg->address);
@@ -1076,17 +1087,22 @@ static int cpc_write(int cpu, struct cpc
 		}
 
 		return 0;
-	} else if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM && pcc_ss_id >= 0)
+	} else if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM && pcc_ss_id >= 0) {
+		/*
+		 * For registers in PCC space, the register size is determined
+		 * by the bit width field; the access size is used to indicate
+		 * the PCC subspace id.
+		 */
+		size = reg->bit_width;
 		vaddr = GET_PCC_VADDR(reg->address, pcc_ss_id);
+	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		vaddr = reg_res->sys_mem_vaddr;
 	else if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
 		return cpc_write_ffh(cpu, reg, val);
 	else
 		return acpi_os_write_memory((acpi_physical_address)reg->address,
-				val, reg->bit_width);
-
-	size = GET_BIT_WIDTH(reg);
+				val, size);
 
 	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		val = MASK_VAL(reg, val);
@@ -1105,8 +1121,13 @@ static int cpc_write(int cpu, struct cpc
 		writeq_relaxed(val, vaddr);
 		break;
 	default:
-		pr_debug("Error: Cannot write %u bit width to PCC for ss: %d\n",
-			 reg->bit_width, pcc_ss_id);
+		if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
+			pr_debug("Error: Cannot write %u bit width to system memory: 0x%llx\n",
+				size, reg->address);
+		} else if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM) {
+			pr_debug("Error: Cannot write %u bit width to PCC for ss: %d\n",
+				size, pcc_ss_id);
+		}
 		ret_val = -EFAULT;
 		break;
 	}


