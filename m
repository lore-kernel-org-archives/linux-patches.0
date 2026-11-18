Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055379;
	b=Yx7BikWk6M2z+VWF1e2UVZDYdlcI3uYAUvOjEIB4LKmAcG7NzLtBGe3N66MbaDXVdqNE
	 u3iHuZPDgJm8ay9gi07wr2s20DRBtaJLbsiEQfOtnwkDQs254VHnUn/5V4j3VQ6IY0SPL
	 xoB4QtWW2T3S8GGY21HmIBUfVW3dN/JVWK/c6tielI8mTNbfVV1ivsxbamiOgKEB0YXak
	 OvDgYB2u0x9PBWphdRe03ieb79ERUejqZCs5h17qEpdgHIQl7Q+/9jt/P4yKWPBrlKpc4
	 2qXOcMj66Q6+Q/8VAy1h0V3v9Rcn5x8FexIe1B9ociWUie3MCiexsCJ/2qayCOMV2FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l0kZrZodXrAic3Kl+6xRUA5G7wo/Dfcj+oGsyB5RkA4=;
	b=2W0heDJwrqFUs4xJD+JLN6jQEpBaeP6+UEuWRXST5LOEIyWHClUar9/Grfx8esQpssAI
	 TkAArz/6GTFoP4G4TgNQQJzuO43wXJGI2SUW5SaLIL1ZBeSr7hdobRGWPFuunQoRNUmrB
	 nkPoPbOkYqRBs+nu5guwQZMARlwSKef4osRkFU2zjWeiaTWfmysKejkqFfSn5aVjWdxMs
	 56dVdxXCZoH5DIuRF1Lrqp0fuInZf7OdnXh7eEwbI5dURmc7XNHN+vHVW26Ze4bhEPqDQ
	 m84xWOKrv7BvUGfVYb0c2jfam6+vf7pDj2CL4o8pTZD+3jhpLmOAkoTsihsRf/pGPyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3XP8ZV3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE6560A260E;
	Thu, 19 Nov 2026 02:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3XP8ZV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080721F000C8;
	Thu, 19 Nov 2026 02:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055379;
	bh=l0kZrZodXrAic3Kl+6xRUA5G7wo/Dfcj+oGsyB5RkA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3XP8ZV32uH7RcKJ8mf0euq9KcQ3D0JzNoIU4uYZMy1yl4e+lLFjmZRCQub9W/uWy
	 GhUNzTTDNdUqSCrbyyxMe6dJR2cBsE+cCL1Mwte4gBx33Uxd5NBJaNswuvPI2aiRUt
	 Busoio3C6bwlee8UARdn3sDGLUKFgPJ2429NCDEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1611/2214] ACPICA: Fix memory leak in acpi_ds_create_field()
Date: Wed, 18 Nov 2026 15:54:47 +0100
Message-ID: <20261118150116.376749695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit dbb3d99ee95c32711950850ddd33eb22a6042eb2 ]

acpi_ds_create_field() allocates internal_pcc_buffer for operation
regions in the PCC address space.

The function runs once per field, so a second field on the
same region overwrites the pointer and orphans the previous buffer.

The matching ACPI_FREE() in acpi_ut_delete_internal_obj() only ever sees
the last one.

An arm64 platform whose SSDT declares regions with multiple fields each
leaks two buffers at boot, as detected by kmemleak:

  unreferenced object 0xffff000051e65400 (size 192):
    comm "swapper/0", pid 1, jiffies 4294668436
    backtrace (crc 0):
      __kmalloc_noprof
      acpi_ds_create_field
      acpi_ds_load2_end_op
      acpi_ds_exec_end_op
      acpi_ps_parse_loop
      acpi_ps_parse_aml
      acpi_ns_load_table
      acpi_load_tables
      acpi_init

Do not allocate a region if it was previously allocated before,
preserving the current design, but, not leaking memory.

Fixes: aa6ec56b574d ("ACPICA: ACPI 6.3: add PCC operation region support for AML interpreter")
Link: https://github.com/open-acpica/acpica/commit/c71849d476bb5f97ca1867849e893368e12a69e6
Signed-off-by: Breno Leitao <leitao@debian.org>
[ rjw: Subject tweak, fixed the Fixes: tag ]
Link: https://patch.msgid.link/20260925-acpica-pcc-field-leak-v2-1-e37008e715af@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsfield.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/dsfield.c b/drivers/acpi/acpica/dsfield.c
index a168177679691..d53368871e537 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -522,7 +522,8 @@ acpi_ds_create_field(union acpi_parse_object *op,
 	}
 
 	if (info.region_node->object->region.space_id ==
-	    ACPI_ADR_SPACE_PLATFORM_COMM) {
+	    ACPI_ADR_SPACE_PLATFORM_COMM &&
+	    !region_node->object->field.internal_pcc_buffer) {
 		region_node->object->field.internal_pcc_buffer =
 		    ACPI_ALLOCATE_ZEROED(info.region_node->object->region.
 					 length);
-- 
2.53.0



