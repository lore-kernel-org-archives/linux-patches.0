Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17DF54765;
	Wed,  6 Nov 2024 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898973; cv=none; b=GbZM6VCuOKTCKaLuxsRg/vOdu1Mr2x1ml7rTo7FAkoZ3v63njVL8eUSVVKLpmpOMGWicNCB2bI1hN8wHhtKhSsFQoud+ml0jfG8dtU5ZJQzNUnmCvk2spageV4Wk/7NPAjG4zgCiDpRlNNev6+DoOkPWBQoiEJxexD0DxAbU7oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898973; c=relaxed/simple;
	bh=ujaT25a4otXjRdHX3AaqMNVEDmVDybbdQ3f0i0pMc6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIic7ZSc0LIAyPcTbsj+v1R6orQlJtIQBi91kFQAXQv8XcdBEYSRLI8ykyQx57SWmZxMd9ZMFTniBItD8xxOt8kd+j5z6CIUfMmsxfX0UqrA7jvi0Ecf3+Cah03AqWqRn0SyejQ3Dx69E/ydDKA8ICHDyCzl8Ld8xlUO7aHuEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtTSyxCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtTSyxCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDB1C4CECD;
	Wed,  6 Nov 2024 13:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898973;
	bh=ujaT25a4otXjRdHX3AaqMNVEDmVDybbdQ3f0i0pMc6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtTSyxCT5uNaIPYLI4GoyN/HJ78+LMBqehbVEvawesyfnymGF+8wzq91jEq6mU2wp
	 Qj/40ekfpv8lc/QDAqVssJki1ai4LI7y+Y/Q98pGlR2yfuOLQBtQggdEbFxHy8rYoO
	 2fcLryRTurGTImP+xk+NmZFhdNCZ83gNp/W1inJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.4 417/462] drm/amd: Guard against bad data for ATIF ACPI method
Date: Wed,  6 Nov 2024 13:05:10 +0100
Message-ID: <20241106120341.816214022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit bf58f03931fdcf7b3c45cb76ac13244477a60f44 upstream.

If a BIOS provides bad data in response to an ATIF method call
this causes a NULL pointer dereference in the caller.

```
? show_regs (arch/x86/kernel/dumpstack.c:478 (discriminator 1))
? __die (arch/x86/kernel/dumpstack.c:423 arch/x86/kernel/dumpstack.c:434)
? page_fault_oops (arch/x86/mm/fault.c:544 (discriminator 2) arch/x86/mm/fault.c:705 (discriminator 2))
? do_user_addr_fault (arch/x86/mm/fault.c:440 (discriminator 1) arch/x86/mm/fault.c:1232 (discriminator 1))
? acpi_ut_update_object_reference (drivers/acpi/acpica/utdelete.c:642)
? exc_page_fault (arch/x86/mm/fault.c:1542)
? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:623)
? amdgpu_atif_query_backlight_caps.constprop.0 (drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:387 (discriminator 2)) amdgpu
? amdgpu_atif_query_backlight_caps.constprop.0 (drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:386 (discriminator 1)) amdgpu
```

It has been encountered on at least one system, so guard for it.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c9b7c809b89f24e9372a4e7f02d64c950b07fdee)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -85,6 +85,7 @@ static union acpi_object *amdgpu_atif_ca
 					   struct acpi_buffer *params)
 {
 	acpi_status status;
+	union acpi_object *obj;
 	union acpi_object atif_arg_elements[2];
 	struct acpi_object_list atif_arg;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -107,16 +108,24 @@ static union acpi_object *amdgpu_atif_ca
 
 	status = acpi_evaluate_object(atif->handle, NULL, &atif_arg,
 				      &buffer);
+	obj = (union acpi_object *)buffer.pointer;
 
-	/* Fail only if calling the method fails and ATIF is supported */
+	/* Fail if calling the method fails and ATIF is supported */
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		DRM_DEBUG_DRIVER("failed to evaluate ATIF got %s\n",
 				 acpi_format_exception(status));
-		kfree(buffer.pointer);
+		kfree(obj);
 		return NULL;
 	}
 
-	return buffer.pointer;
+	if (obj->type != ACPI_TYPE_BUFFER) {
+		DRM_DEBUG_DRIVER("bad object returned from ATIF: %d\n",
+				 obj->type);
+		kfree(obj);
+		return NULL;
+	}
+
+	return obj;
 }
 
 /**


