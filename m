Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199C71DF995;
	Wed,  6 Nov 2024 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899153; cv=none; b=SDh/XGAjHCnhT49oB/RZU0EaFj4GF9tqjegmveVH7fmlov7awqcgO/+lZHJBxqTODB+I77CFhe8EZ9K8FDRWRFrGPYnBSaK0FFXi+cKz2/poMQTLDoqM7yREsASNEaaqf9dk/6RwLaqrOMaZ31DEl+gJMI4B+SiittUXr2BQx1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899153; c=relaxed/simple;
	bh=3Ov14wS5figs14UXA7h2xH4+tNmaMw742sf12EA+53I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DttaI/fi23t2XO4vVZ73tGQY3lM264W3gMRNfuwgjuZMqe3ay6gDKpfnN7Vl35M4llDNFb4aOK/TejCwNFxverzowoPiLPTZOH/IlRT1pO61gC6bjA1pJmZGjlXlSLMYfgs9NKFUDYZ046UEBfkAT2ZSwDe/JCFae1wwNdpY9G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7VOLH/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7VOLH/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850BFC4CECD;
	Wed,  6 Nov 2024 13:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899152;
	bh=3Ov14wS5figs14UXA7h2xH4+tNmaMw742sf12EA+53I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7VOLH/6DqthLkzIq02+u/LSRHT2Uk1sW+NRjB+CxT7DTz9KuvbpZIEPzErwC/Qyc
	 jfFeZZXwwFqvRkKiU1E4inmdN0hZkLnroeQffQL+k797JDTqg2b/vmux75cig145f8
	 y2GG9kZs79xUJX4RYKOfdSVOPMs7AuQafhEYh7mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koba Ko <kobak@nvidia.com>,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/73] ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context
Date: Wed,  6 Nov 2024 13:05:09 +0100
Message-ID: <20241106120300.124390716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koba Ko <kobak@nvidia.com>

[ Upstream commit 088984c8d54c0053fc4ae606981291d741c5924b ]

PRMT needs to find the correct type of block to translate the PA-VA
mapping for EFI runtime services.

The issue arises because the PRMT is finding a block of type
EFI_CONVENTIONAL_MEMORY, which is not appropriate for runtime services
as described in Section 2.2.2 (Runtime Services) of the UEFI
Specification [1]. Since the PRM handler is a type of runtime service,
this causes an exception when the PRM handler is called.

    [Firmware Bug]: Unable to handle paging request in EFI runtime service
    WARNING: CPU: 22 PID: 4330 at drivers/firmware/efi/runtime-wrappers.c:341
        __efi_queue_work+0x11c/0x170
    Call trace:

Let PRMT find a block with EFI_MEMORY_RUNTIME for PRM handler and PRM
context.

If no suitable block is found, a warning message will be printed, but
the procedure continues to manage the next PRM handler.

However, if the PRM handler is actually called without proper allocation,
it would result in a failure during error handling.

By using the correct memory types for runtime services, ensure that the
PRM handler and the context are properly mapped in the virtual address
space during runtime, preventing the paging request error.

The issue is really that only memory that has been remapped for runtime
by the firmware can be used by the PRM handler, and so the region needs
to have the EFI_MEMORY_RUNTIME attribute.

Link: https://uefi.org/sites/default/files/resources/UEFI_Spec_2_10_Aug29.pdf # [1]
Fixes: cefc7ca46235 ("ACPI: PRM: implement OperationRegion handler for the PlatformRtMechanism subtype")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Koba Ko <kobak@nvidia.com>
Reviewed-by: Matthew R. Ochs <mochs@nvidia.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20241012205010.4165798-1-kobak@nvidia.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/prmt.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index 6da424f1f133f..63ead3f1d2947 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -72,17 +72,21 @@ struct prm_module_info {
 	struct prm_handler_info handlers[];
 };
 
-static u64 efi_pa_va_lookup(u64 pa)
+static u64 efi_pa_va_lookup(efi_guid_t *guid, u64 pa)
 {
 	efi_memory_desc_t *md;
 	u64 pa_offset = pa & ~PAGE_MASK;
 	u64 page = pa & PAGE_MASK;
 
 	for_each_efi_memory_desc(md) {
-		if (md->phys_addr < pa && pa < md->phys_addr + PAGE_SIZE * md->num_pages)
+		if ((md->attribute & EFI_MEMORY_RUNTIME) &&
+		    (md->phys_addr < pa && pa < md->phys_addr + PAGE_SIZE * md->num_pages)) {
 			return pa_offset + md->virt_addr + page - md->phys_addr;
+		}
 	}
 
+	pr_warn("Failed to find VA for GUID: %pUL, PA: 0x%llx", guid, pa);
+
 	return 0;
 }
 
@@ -136,9 +140,15 @@ acpi_parse_prmt(union acpi_subtable_headers *header, const unsigned long end)
 		th = &tm->handlers[cur_handler];
 
 		guid_copy(&th->guid, (guid_t *)handler_info->handler_guid);
-		th->handler_addr = (void *)efi_pa_va_lookup(handler_info->handler_address);
-		th->static_data_buffer_addr = efi_pa_va_lookup(handler_info->static_data_buffer_address);
-		th->acpi_param_buffer_addr = efi_pa_va_lookup(handler_info->acpi_param_buffer_address);
+		th->handler_addr =
+			(void *)efi_pa_va_lookup(&th->guid, handler_info->handler_address);
+
+		th->static_data_buffer_addr =
+			efi_pa_va_lookup(&th->guid, handler_info->static_data_buffer_address);
+
+		th->acpi_param_buffer_addr =
+			efi_pa_va_lookup(&th->guid, handler_info->acpi_param_buffer_address);
+
 	} while (++cur_handler < tm->handler_count && (handler_info = get_next_handler(handler_info)));
 
 	return 0;
@@ -232,6 +242,13 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
 		if (!handler || !module)
 			goto invalid_guid;
 
+		if (!handler->handler_addr ||
+		    !handler->static_data_buffer_addr ||
+		    !handler->acpi_param_buffer_addr) {
+			buffer->prm_status = PRM_HANDLER_ERROR;
+			return AE_OK;
+		}
+
 		ACPI_COPY_NAMESEG(context.signature, "PRMC");
 		context.revision = 0x0;
 		context.reserved = 0x0;
-- 
2.43.0



