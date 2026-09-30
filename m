Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0780F5218A0;
	Wed, 30 Sep 2026 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790939; cv=none; b=qF5SWYbI2HCKMunFpbh39FVtUDmPRwd4/RSut60jVdK/RvlTcccwwldFHMgB3JjhOWeHd8znRaguTkynxkZjNMgE79+QLMVfF4Ml5KERxeASltvP0Uz/KU0ups4vi/yH+qzWDs+/fYZax68mQIFQ5/0nwRbV6xmcMvO4pJbXgdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790939; c=relaxed/simple;
	bh=jyl7QXbxK/xQcUogn2+5J7V8BBMhfDZTZ1b/PmFokPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxaoo37/N5amRai0VrBF5VoURyh/Gxo2ylAcxekISBnqJT3abwiUG2kh4f3BOVx1pRGD+c1+LGAYM504ZxSiPGm/vXPfMh6OEj+hmrRTQNlaiJgQV1DJICa02h6tbOGomsjyN4VJft5EAZirH2JP3FBnZ0Md+IUKM1gZYsnbykI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq2pi4Fg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq2pi4Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8891F000FF;
	Wed, 30 Sep 2026 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790937;
	bh=EIP6w63x3QWG9CbGJN1qm7a+CcW+kfIUa/tgI46eYpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iq2pi4FgXC3SarYXeE4WSUjhxntvVCTHqt0o3BIxnxaBUSPcef0zbMebzh4KZYFw4
	 m6S0b6Zh2WTNI/uEiQTNFoSUQwQZu7xU0yiXnmuMQ93bD6h823C+va75F65vfEq0k3
	 m4BcKrce0pxlIE8yr6veSkB/NcRmnlVEPbVOtUn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/752] ACPICA: Improve argument parsing in acpi_ps_get_next_simple_arg()
Date: Wed, 30 Sep 2026 17:19:12 +0200
Message-ID: <20260930152359.941100478@linuxfoundation.org>
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

[ Upstream commit 27d27e75ecb752a0b4da848c440bb3a88396ecba ]

Improve argument parsing in acpi_ps_get_next_simple_arg() to handle
remaining AML data safely.

Link: https://github.com/acpica/acpica/commit/ecbb8bcfe301
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2008043.taCxCBeP46@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 78 +++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index f348e644f8b03..8e65c114473e3 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -384,6 +384,8 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 	u32 length;
 	u16 opcode;
 	u8 *aml = parser_state->aml;
+	u32 remaining = (u32)ACPI_PTR_DIFF(parser_state->aml_end, aml);
+	u64 partial_value;
 
 	ACPI_FUNCTION_TRACE_U32(ps_get_next_simple_arg, arg_type);
 
@@ -393,8 +395,13 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 1 byte from the AML stream */
 
 		opcode = AML_BYTE_OP;
-		arg->common.value.integer = (u64) *aml;
-		length = 1;
+		if (remaining >= 1) {
+			arg->common.value.integer = (u64)*aml;
+			length = 1;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+		}
 		break;
 
 	case ARGP_WORDDATA:
@@ -402,8 +409,19 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 2 bytes from the AML stream */
 
 		opcode = AML_WORD_OP;
-		ACPI_MOVE_16_TO_64(&arg->common.value.integer, aml);
-		length = 2;
+		if (remaining >= 2) {
+			ACPI_MOVE_16_TO_64(&arg->common.value.integer, aml);
+			length = 2;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+			if (remaining > 0) {
+				partial_value = 0;
+				memcpy(&partial_value, aml, remaining);
+				arg->common.value.integer = partial_value;
+				length = remaining;
+			}
+		}
 		break;
 
 	case ARGP_DWORDDATA:
@@ -411,8 +429,19 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 4 bytes from the AML stream */
 
 		opcode = AML_DWORD_OP;
-		ACPI_MOVE_32_TO_64(&arg->common.value.integer, aml);
-		length = 4;
+		if (remaining >= 4) {
+			ACPI_MOVE_32_TO_64(&arg->common.value.integer, aml);
+			length = 4;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+			if (remaining > 0) {
+				partial_value = 0;
+				memcpy(&partial_value, aml, remaining);
+				arg->common.value.integer = partial_value;
+				length = remaining;
+			}
+		}
 		break;
 
 	case ARGP_QWORDDATA:
@@ -420,8 +449,19 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Get 8 bytes from the AML stream */
 
 		opcode = AML_QWORD_OP;
-		ACPI_MOVE_64_TO_64(&arg->common.value.integer, aml);
-		length = 8;
+		if (remaining >= 8) {
+			ACPI_MOVE_64_TO_64(&arg->common.value.integer, aml);
+			length = 8;
+		} else {
+			arg->common.value.integer = 0;
+			length = 0;
+			if (remaining > 0) {
+				partial_value = 0;
+				memcpy(&partial_value, aml, remaining);
+				arg->common.value.integer = partial_value;
+				length = remaining;
+			}
+		}
 		break;
 
 	case ARGP_CHARLIST:
@@ -434,10 +474,28 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 		/* Find the null terminator */
 
 		length = 0;
-		while (aml[length]) {
+		while ((length < remaining) && aml[length]) {
+			length++;
+		}
+		if (length < remaining) {
+
+			/* Account for the terminating null */
 			length++;
+		} else {
+			/*
+			 * No terminator found - add null at buffer boundary
+			 * and report a warning
+			 */
+			ACPI_WARNING((AE_INFO,
+				      "Invalid AML string: no null terminator, truncating at offset %u",
+				      (u32)(aml - parser_state->aml)));
+
+			/* Add null terminator at the boundary */
+			if (remaining > 0) {
+				aml[remaining - 1] = 0;
+				length = remaining;
+			}
 		}
-		length++;
 		break;
 
 	case ARGP_NAME:
-- 
2.53.0



