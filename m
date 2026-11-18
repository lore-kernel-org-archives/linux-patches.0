Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040301;
	b=lGSSCc2wafTvj32HM9mt2noeNvp+GfK6e+rP7XpTybHFvcvZ6D/Cjx6z+TDZtBN7vny+
	 iBksCQq3RKMO7oeLqJBcp0Egl0xkECzc1d811JXaQfNvpjeytcyzUeaWMedT26rStMme4
	 cM6xKes1vkyUnBu7OpyUhWgqslAM0DKLRZWkq35TyuWwhulWGHoMSmDC1PTLReg/n1w+2
	 093cnUsb3abm8qdSeXZB7xlZ81WnbEDXL/oG9Ht8YIli97ue/CcWB3AD+lrQL8U+5BPGe
	 SrdU0yMYoBkvap2jnhUOYabaTKYXL80qXaW0YPlJcBxJi5UTc6KuokczrJe39627IUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=99FjlCXmlMv/MKM0V0t8OompgJ1cgTuQoytoIMBFau4=;
	b=Fr6A3znkCYKDkPA8kirst5+6T3NXqQ01uwgKrWdr/a2K0IGcOAeS4WS6PRjQ7o94iYsg
	 zbEO8YvUyzww9jqW8WxXJ+zK+rlPxhvPDgIfgXJuGzC3rgqqxuOFQ7g8/aq+ekY87blFN
	 BWelAKW4UzkLOtmrioTjHpAHQOt/a+33mVE3nE12LG+YibJjByDgA/9vyFl8ZBryZZYyt
	 yn9kzOX/vmIZkKUTxbe/XZ5sIbU7zgtSHXRxF12sEN5k8tVXNECXGaFe5QWOtMJZbx+l+
	 34Rli06WaxQdqtuqlTjSy4fll7l4R15+oDoQA77MrEPPB+duBK8r3yghMTJLZGEMw+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSCrt0XS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F8D606A320;
	Wed, 18 Nov 2026 22:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSCrt0XS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E972D1F000C4;
	Wed, 18 Nov 2026 22:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040301;
	bh=99FjlCXmlMv/MKM0V0t8OompgJ1cgTuQoytoIMBFau4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSCrt0XSXirovFgpe80PaSsSQPrkGP8LizmcOHtLKEHqFATVBE20gHX/hbKzPJ8NM
	 s6w3E2tq5yUfkMMtpFIoHgOfYo1KRcVZA2S2yLT0it4BFtR8JJnfo0Mfyelr7s1Kzc
	 l+lxdC7ah8PtAm9WoLazkbZxsHGbtdrPfjDOKspI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2368/3318] ACPICA: Fix memory leak in acpi_ds_create_field()
Date: Wed, 18 Nov 2026 15:49:50 +0100
Message-ID: <20261118150432.608411299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 532401ecdab0c..9009f4a3022e0 100644
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



