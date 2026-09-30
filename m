Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31FE51FCA6;
	Wed, 30 Sep 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790907; cv=none; b=lOU1le8pWRGAzkZ1VHG96XsnvjjGRw78R1RVy/cb4mQ0wC/S7qfVi0qIdu/u4ivdKN/kPASUgUvL1laSfjjZmzOlYUf+8UYHNCbVMBEDcpvsea+KfB8KL+irRBIR6tCdFdoFKcUVF0C93ZgOCvolkcXgtga1UclyQ9XrIBM2I7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790907; c=relaxed/simple;
	bh=7M3JbQfdqqqpwdky4RSEZUSri+JxaNfWfuzCuj3Nu2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5VmHisRyZFIGRy/EPH9YRi3Tq/c+jrm2f2XXl9qHoYe/RCbBasVwyZ7TRisjBmjC5xYNW8TfXoF4qKkNlBuQjceuQzaRaHD2FAQh+bCfGj9iX8cTs3xzIQTtPl2A2fkHoVV1vuXYzNo/LaUHi6umwSqco8JpWNjQ6Cd0UWUyhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmtQr55f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmtQr55f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084231F000FF;
	Wed, 30 Sep 2026 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790906;
	bh=KUWWg3VlkEXnRiL4okmekn4pBk0Pmf3x01j5IdUIBfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmtQr55fqK+tbVR4VT/05eD3GyjA8nJ3MGspqb0F0UJQbAVheMHoNTxKg62S0SOZY
	 mConYIHvKrj9LdfnYyXaTNswE0fEb4d6ZR+/3CGr/2JZI/9F5cnd30GDy85Nq0+iTl
	 HjsWMRt7TqkTfyb3Zm75oAh1adYJVEzB3tGd1oqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/752] ACPICA: validate byte_count in acpi_ps_get_next_package_length()
Date: Wed, 30 Sep 2026 17:19:09 +0200
Message-ID: <20260930152359.875702816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ikaros <void0red@gmail.com>

[ Upstream commit d49c6ee08365a8596f639da46eb7e71752b0cd42 ]

Validate package length reading in acpi_ps_get_next_package_length().

Link: https://github.com/acpica/acpica/commit/40e03f9941e2
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3616255.QJadu78ljV@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index a4e2349f43323..f348e644f8b03 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -48,6 +48,7 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	u32 package_length = 0;
 	u32 byte_count;
 	u8 byte_zero_mask = 0x3F;	/* Default [0:5] */
+	u32 remaining;
 
 	ACPI_FUNCTION_TRACE(ps_get_next_package_length);
 
@@ -55,7 +56,23 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	 * Byte 0 bits [6:7] contain the number of additional bytes
 	 * used to encode the package length, either 0,1,2, or 3
 	 */
+
+	/* Check if we have at least one byte to read */
+	remaining = (u32)ACPI_PTR_DIFF(parser_state->aml_end, aml);
+	if (remaining == 0) {
+		return_UINT32(0);
+	}
+
 	byte_count = (aml[0] >> 6);
+
+	/* Validate byte_count and ensure we have enough bytes to read */
+	if (byte_count >= remaining) {
+
+		/* Clamp to available bytes and advance to end */
+		parser_state->aml = parser_state->aml_end;
+		return_UINT32(0);
+	}
+
 	parser_state->aml += ((acpi_size)byte_count + 1);
 
 	/* Get bytes 3, 2, 1 as needed */
-- 
2.53.0



