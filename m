Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B90361DA6;
	Sat, 12 Sep 2026 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227015; cv=none; b=kowzxX9jsVadollHftZJXBFIetyDtRL2m3Z2cWgcybWlwOJUvziTwYXJO8mNDQB+erWNssy6z/Sz/lOwqB+a2jt4XNNMYCGjJMTfTbC411mWWHwcVoSqwh50/mnIacG82yc7q/L3EWxFKzxqk+twKbvyz60YD4omQjPQ9ERGDVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227015; c=relaxed/simple;
	bh=/TM/8EnSQotYazA7OXncEtCPpX0iKjaF52EQqC1cwKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYOqc1bhMB6GlDT+W9NDtFlpx+2Rn+0IVbY2cc10EV+tRKUXC6UglZU9NszTdS4JL6sNMiJx/wmPmy3PTpE1K93po8roRgKyqz7dh/bqmV/XUlGm9F2VG2LtIUv7f3OTY8+qcZSRO8GVlpK3GIVArzu9mo8TOKdzBgpWbwIwrzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLu3uCMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLu3uCMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031491F000FF;
	Sat, 12 Sep 2026 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227013;
	bh=yyWCE7SHJ37+00pwRkZecLGbgIR+gTQQDINpeBLFa4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLu3uCMGs3I299dX10H1KRpyxkKInY1hSmJ3QiIfw1Obn8VPz30sbDPy+hD3NT7d6
	 Xw44A9lQOE+mq2VJONGDHhH6BXMFDEyICAPXp48OTK46dW6VSpx24mcIogYaXs9u/5
	 iB94315hFN4O8GOEOeybjpW7p4L6/qJvUKf/ofmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Prasad <icarus@a0rg.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 0093/1191] ACPI: pfr_update: fix stack buffer overflow in query_capability()
Date: Sat, 12 Sep 2026 08:47:01 +0200
Message-ID: <20260912065550.268300705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Prasad <icarus@a0rg.com>

commit ced45be0073a8a31b30b4a7f68cd3a15734515de upstream.

query_capability() copies four ACPI buffer objects returned by the
firmware _DSM into fixed-size u8[16] fields in struct
pfru_update_cap_info using memcpy with the firmware-supplied length:

  memcpy(&cap_hdr->code_type,
         elements[CAP_CODE_TYPE_IDX].buffer.pointer,
         elements[CAP_CODE_TYPE_IDX].buffer.length);

The same pattern repeats for drv_type, platform_id, and oem_id.
If the firmware returns buffer.length > 16 for any of these fields,
memcpy writes past the destination array.

struct pfru_update_cap_info is stack-allocated in pfru_ioctl().

Confirmed with KASAN on 7.2-rc6: three stack-out-of-bounds reports
are generated when a DSM returns 64-byte buffers, with writes reaching
44 bytes past the end of cap_hdr's [64, 156) frame window into
adjacent stack redzones.

Introduce a helper pointer to out_obj->package.elements and use it
to validate each buffer length against its destination field size
before copying, returning -EINVAL if the firmware supplies an
oversized buffer.

Fixes: 0db89fa243e5 ("ACPI: Introduce Platform Firmware Runtime Update device driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Anirudh Prasad <icarus@a0rg.com>
Link: https://patch.msgid.link/1a001e1fee9.637da6dc3533246.238498880682901704@a0rg.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/pfr_update.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -120,7 +120,7 @@ static int query_capability(struct pfru_
 			    struct pfru_device *pfru_dev)
 {
 	acpi_handle handle = ACPI_HANDLE(pfru_dev->parent_dev);
-	union acpi_object *out_obj;
+	union acpi_object *out_obj, *elem;
 	int ret = -EINVAL;
 
 	out_obj = acpi_evaluate_dsm_typed(handle, &pfru_guid,
@@ -144,36 +144,39 @@ static int query_capability(struct pfru_
 	    out_obj->package.elements[CAP_OEM_INFO_IDX].type != ACPI_TYPE_BUFFER)
 		goto free_acpi_buffer;
 
-	cap_hdr->status = out_obj->package.elements[CAP_STATUS_IDX].integer.value;
+	elem = out_obj->package.elements;
+
+	cap_hdr->status = elem[CAP_STATUS_IDX].integer.value;
 	if (cap_hdr->status != DSM_SUCCEED) {
 		ret = -EBUSY;
 		dev_dbg(pfru_dev->parent_dev, "Error Status:%d\n", cap_hdr->status);
 		goto free_acpi_buffer;
 	}
 
-	cap_hdr->update_cap = out_obj->package.elements[CAP_UPDATE_IDX].integer.value;
+	if (elem[CAP_CODE_TYPE_IDX].buffer.length > sizeof(cap_hdr->code_type) ||
+	    elem[CAP_DRV_TYPE_IDX].buffer.length > sizeof(cap_hdr->drv_type) ||
+	    elem[CAP_PLAT_ID_IDX].buffer.length > sizeof(cap_hdr->platform_id) ||
+	    elem[CAP_OEM_ID_IDX].buffer.length > sizeof(cap_hdr->oem_id))
+		goto free_acpi_buffer;
+
+	cap_hdr->update_cap = elem[CAP_UPDATE_IDX].integer.value;
 	memcpy(&cap_hdr->code_type,
-	       out_obj->package.elements[CAP_CODE_TYPE_IDX].buffer.pointer,
-	       out_obj->package.elements[CAP_CODE_TYPE_IDX].buffer.length);
-	cap_hdr->fw_version =
-		out_obj->package.elements[CAP_FW_VER_IDX].integer.value;
-	cap_hdr->code_rt_version =
-		out_obj->package.elements[CAP_CODE_RT_VER_IDX].integer.value;
+	       elem[CAP_CODE_TYPE_IDX].buffer.pointer,
+	       elem[CAP_CODE_TYPE_IDX].buffer.length);
+	cap_hdr->fw_version = elem[CAP_FW_VER_IDX].integer.value;
+	cap_hdr->code_rt_version = elem[CAP_CODE_RT_VER_IDX].integer.value;
 	memcpy(&cap_hdr->drv_type,
-	       out_obj->package.elements[CAP_DRV_TYPE_IDX].buffer.pointer,
-	       out_obj->package.elements[CAP_DRV_TYPE_IDX].buffer.length);
-	cap_hdr->drv_rt_version =
-		out_obj->package.elements[CAP_DRV_RT_VER_IDX].integer.value;
-	cap_hdr->drv_svn =
-		out_obj->package.elements[CAP_DRV_SVN_IDX].integer.value;
+	       elem[CAP_DRV_TYPE_IDX].buffer.pointer,
+	       elem[CAP_DRV_TYPE_IDX].buffer.length);
+	cap_hdr->drv_rt_version = elem[CAP_DRV_RT_VER_IDX].integer.value;
+	cap_hdr->drv_svn = elem[CAP_DRV_SVN_IDX].integer.value;
 	memcpy(&cap_hdr->platform_id,
-	       out_obj->package.elements[CAP_PLAT_ID_IDX].buffer.pointer,
-	       out_obj->package.elements[CAP_PLAT_ID_IDX].buffer.length);
+	       elem[CAP_PLAT_ID_IDX].buffer.pointer,
+	       elem[CAP_PLAT_ID_IDX].buffer.length);
 	memcpy(&cap_hdr->oem_id,
-	       out_obj->package.elements[CAP_OEM_ID_IDX].buffer.pointer,
-	       out_obj->package.elements[CAP_OEM_ID_IDX].buffer.length);
-	cap_hdr->oem_info_len =
-		out_obj->package.elements[CAP_OEM_INFO_IDX].buffer.length;
+	       elem[CAP_OEM_ID_IDX].buffer.pointer,
+	       elem[CAP_OEM_ID_IDX].buffer.length);
+	cap_hdr->oem_info_len = elem[CAP_OEM_INFO_IDX].buffer.length;
 
 	ret = 0;
 


