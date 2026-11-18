Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048622;
	b=D7FN/IHCGFehfdsWWsY5exdlQLuS9CnpOkVzTpCkZrH+f9tijwyJTNiDEZQxqDZ7Xtbs
	 n5TtI1BQbITxrXYCb0NEIZ+8DHGtoOp56DAORnz8ykhZIdKAFJArBQrYervAQP6PyBgI6
	 9S9B1BAyQLy/lmrdV5grjOq4xN5VN1UqVJSb0uV5vw2owVwlZwQOCzvt1BALMxwo3wrlU
	 /fas02z75lzobulfHtzJcUVCuUqiSuqE6lrVWYzL1JDB76+H33XccJLcRQjtqlbSH8NBx
	 DssgkQHclHGk5WJuG78h3/bKrtnwJBo0oVFPwA5KJCAs+uELE4VJDtEKXMEVnC2+0Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=apKBW4SHlZ/jWkRYgPs2WOdFucCLzWfEOLWQVGOflbQ=;
	b=mnc+kO/EcVsV6gIXzbJD6LVHlrhP13S+bOh+G4QdGa9AHz3wj1YOfi211b/Nid8JxYU0
	 e7bnANV8I2D4HeUqCTUxKDwUlu17zBzAP5eCr+ssN0hKec7kdFNngDfcxaNw6Pa8K9XSG
	 Ukf/8xVMFUCF9mAIIlU7J+7akJNpaOrcctJH0yCPzsxqQU+E/0dvvZkk5ZFKFIJlm9SPn
	 WViAeROhPkN4A7IlwspSxnPzvdSG9xyQDIb0aXG7iYcWEtF9X664mKvROvSYlJyKNr1TE
	 FyKIZxWZDmrYHbbmbYexw+LWEkWaU+Tw81ETqjs6CjHtvIrjpVx3PC95tGMTNg+0jxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPGtcPhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9F606A325;
	Thu, 19 Nov 2026 00:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPGtcPhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7911E1F000C4;
	Thu, 19 Nov 2026 00:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048622;
	bh=apKBW4SHlZ/jWkRYgPs2WOdFucCLzWfEOLWQVGOflbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPGtcPhh8ucsPZDqTDyFiAL2VtdJzHbo4PsUm4MCrLB1Uj2RSjofwXUaCxCEPQQ9s
	 QErGdITNkOsYaA1WCDrPmTv7IBAON13evrO02JOL4SKGAuEjQP1QZ4pWwR9G3Jdurc
	 XU1ILazDVtjpCMXz7uQjgJb/Sg4UEIiI2vCJJ+0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2060/2857] ACPICA: Fix memory leak in acpi_ds_create_field()
Date: Wed, 18 Nov 2026 15:51:34 +0100
Message-ID: <20261118150315.587224954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index de175f1b4bebe..cf81b72993899 100644
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



