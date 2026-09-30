Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB913BBFDD;
	Wed, 30 Sep 2026 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794201; cv=none; b=WcPJGLpn7a5FiRgHory98kX52wDdXRVm17wEdkxdfOV1QLKEzLaI/a7dw8isviuj45I/d44uSaAJyB3aZ0Ae0kGfeXu/4Oyk2fUJ2mVainV8FTS0lzCNMyz4T8Od+PV5ejK+4fqzFDUxTPbE7m2Yyv9MSr32nd0Arh6lttx8gJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794201; c=relaxed/simple;
	bh=m3fqNlnT7HgpyBGH1dJVw4AcLK0OXaKRs9ozqY3ZCHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+I7K/tjxTIhq7vfqmgbeW7z4ZJDuSshHUActSwTRLmomA5wcfqlQd2jkNF1hqPSAjzgjSbC+aWD9dCoVfmJIcYI688lLf4HrZNueI3pae6dcdcGTUeSGillOQpYhKVNWdK7jElfK3qZIDh+tSz/SqhyudUewHMYhwBb47OmmmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOKRfcj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOKRfcj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457D31F000FF;
	Wed, 30 Sep 2026 18:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794199;
	bh=FpBGd7z5AiBBPXffHK7P1mdwmS3cmUMRYS51WWWYTm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOKRfcj5FfmfPGGeXz7DJJ9zMO/5kDHpgQN39fwVbkmJWG7dA1tggn952fSy3BN1c
	 HFzcAgvGJWpbDqzejjFf9N/ockRos9cknTBnaGGs2P6ZNn2upFOEjGUJ9EZ8wthlrU
	 Tli+/koOK79GV4cmitksz57SEASsxxXyIaOZJunQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0127/1193] ACPICA: Enhance OEM ID and Table ID validation in acpi_ex_load_table_op()
Date: Wed, 30 Sep 2026 17:13:31 +0200
Message-ID: <20260930152437.036364029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ikaros <void0red@gmail.com>

[ Upstream commit 485829e6999b7909f50761a1c708660304edc945 ]

Enhance OEM ID and Table ID validation in acpi_ex_load_table_op() to
prevent buffer overflows.

Link: https://github.com/acpica/acpica/commit/f85a43098d65
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2230782.OBFZWjSADL@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exconfig.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/exconfig.c b/drivers/acpi/acpica/exconfig.c
index 473115309860d..2cd1d3367a243 100644
--- a/drivers/acpi/acpica/exconfig.c
+++ b/drivers/acpi/acpica/exconfig.c
@@ -90,6 +90,8 @@ acpi_ex_load_table_op(struct acpi_walk_state *walk_state,
 	union acpi_operand_object *return_obj;
 	union acpi_operand_object *ddb_handle;
 	u32 table_index;
+	char oem_id[ACPI_OEM_ID_SIZE + 1];
+	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE + 1];
 
 	ACPI_FUNCTION_TRACE(ex_load_table_op);
 
@@ -102,12 +104,32 @@ acpi_ex_load_table_op(struct acpi_walk_state *walk_state,
 
 	*return_desc = return_obj;
 
+	/*
+	 * Validate OEM ID and OEM Table ID string lengths.
+	 * acpi_tb_find_table expects strings that can safely read
+	 * ACPI_OEM_ID_SIZE and ACPI_OEM_TABLE_ID_SIZE bytes.
+	 */
+	if ((operand[1]->string.length > ACPI_OEM_ID_SIZE) ||
+	    (operand[2]->string.length > ACPI_OEM_TABLE_ID_SIZE)) {
+		return_ACPI_STATUS(AE_AML_STRING_LIMIT);
+	}
+
+	/*
+	 * Copy OEM strings to local buffers with guaranteed null-termination.
+	 * This prevents heap-buffer-overflow when acpi_tb_find_table reads
+	 * ACPI_OEM_ID_SIZE/ACPI_OEM_TABLE_ID_SIZE bytes.
+	 */
+	memcpy(oem_id, operand[1]->string.pointer, operand[1]->string.length);
+	oem_id[operand[1]->string.length] = 0;
+	memcpy(oem_table_id, operand[2]->string.pointer,
+	       operand[2]->string.length);
+	oem_table_id[operand[2]->string.length] = 0;
+
 	/* Find the ACPI table in the RSDT/XSDT */
 
 	acpi_ex_exit_interpreter();
 	status = acpi_tb_find_table(operand[0]->string.pointer,
-				    operand[1]->string.pointer,
-				    operand[2]->string.pointer, &table_index);
+				    oem_id, oem_table_id, &table_index);
 	acpi_ex_enter_interpreter();
 	if (ACPI_FAILURE(status)) {
 		if (status != AE_NOT_FOUND) {
-- 
2.53.0



