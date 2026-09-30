Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A423D3F926D;
	Wed, 30 Sep 2026 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784329; cv=none; b=jIeS5+HVUey+xpV8KoWaez2Qm++i3SYjOUWPwaEAREeUyDXpKU1nVedZYc1YagNgZNtlhHDaWCNRgGCS/WhXO+mw9YbfwyazVxP5FPTQSCZqao1WaV4N+3QPN7Vai63MYy4fIv5aRZrE8JnmE/1s2r/1+N3zQKQO0IPA+HqkKJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784329; c=relaxed/simple;
	bh=MKV9vVpLGlIdIJnuTfo4Ood+XA5r+R5TzJOBaRgjGuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVdM4el8d+SVBMoz797CNoV1pWDQAW2BPsZMMS5H43P9Bie/8u44wifNWT2/ohUt2rAIL6+3/ecFdHC5ZWZZuSFA1or/qCKEDCCnUbRnfaZnF6j/D3BJvOKqF8Il9C9b6ktOZI/6b1LO6tspdljH/R94wDCsMVKW51z0VqoB4vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLbllpkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLbllpkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281A91F00893;
	Wed, 30 Sep 2026 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784323;
	bh=ROWjcqdkWOVJ0355n7VMqFHSjl3JvH1UW4wheWaIMhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLbllpkZiSQMmYGE/2jAdNJG302O7QmqoUU/AUWrdCnNDpi8yOQX16YS7pxSIM1fq
	 FFwSWKI1Mh+s47C5nt2EdopLw6LKa4T+OgVhH3S31wrT/2B/p3J8FuXeBneLlH7mnF
	 WO/p2qFrMP6EVbjNWul25dl6cx2vzjstrLoOr3GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/982] ACPICA: add boundary checks in two places
Date: Wed, 30 Sep 2026 17:14:09 +0200
Message-ID: <20260930152419.242747348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit bdc35754012906dbf094be104b103ca3adfef6f7 ]

Add boundary checks in acpi_ps_get_next_namestring() and
acpi_ps_peek_opcode() to prevent out-of-bounds access.

Link: https://github.com/acpica/acpica/commit/cfdc96896d8d
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5180044.0VBMTVartN@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c  | 18 +++++++++++++++++-
 drivers/acpi/acpica/psparse.c |  6 ++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 35166be684880..1d206670a9786 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -148,10 +148,16 @@ char *acpi_ps_get_next_namestring(struct acpi_parse_state *parser_state)
 
 	/* Point past any namestring prefix characters (backslash or carat) */
 
-	while (ACPI_IS_ROOT_PREFIX(*end) || ACPI_IS_PARENT_PREFIX(*end)) {
+	while (end < parser_state->aml_end &&
+	       (ACPI_IS_ROOT_PREFIX(*end) || ACPI_IS_PARENT_PREFIX(*end))) {
 		end++;
 	}
 
+	if (end >= parser_state->aml_end) {
+		parser_state->aml = parser_state->aml_end;
+		return_PTR(NULL);
+	}
+
 	/* Decode the path prefix character */
 
 	switch (*end) {
@@ -176,6 +182,11 @@ char *acpi_ps_get_next_namestring(struct acpi_parse_state *parser_state)
 
 		/* Multiple name segments, 4 chars each, count in next byte */
 
+		if ((end + 1) >= parser_state->aml_end) {
+			parser_state->aml = parser_state->aml_end;
+			return_PTR(NULL);
+		}
+
 		end += 2 + (*(end + 1) * ACPI_NAMESEG_SIZE);
 		break;
 
@@ -187,6 +198,11 @@ char *acpi_ps_get_next_namestring(struct acpi_parse_state *parser_state)
 		break;
 	}
 
+	if (end > parser_state->aml_end) {
+		parser_state->aml = parser_state->aml_end;
+		return_PTR(NULL);
+	}
+
 	parser_state->aml = end;
 	return_PTR((char *)start);
 }
diff --git a/drivers/acpi/acpica/psparse.c b/drivers/acpi/acpica/psparse.c
index a4eb254c62ea5..fc5a18cf0c610 100644
--- a/drivers/acpi/acpica/psparse.c
+++ b/drivers/acpi/acpica/psparse.c
@@ -70,6 +70,9 @@ u16 acpi_ps_peek_opcode(struct acpi_parse_state * parser_state)
 	u16 opcode;
 
 	aml = parser_state->aml;
+	if (aml >= parser_state->aml_end) {
+		return (0xFFFF);
+	}
 	opcode = (u16) ACPI_GET8(aml);
 
 	if (opcode == AML_EXTENDED_PREFIX) {
@@ -77,6 +80,9 @@ u16 acpi_ps_peek_opcode(struct acpi_parse_state * parser_state)
 		/* Extended opcode, get the second opcode byte */
 
 		aml++;
+		if (aml >= parser_state->aml_end) {
+			return (0xFFFF);
+		}
 		opcode = (u16) ((opcode << 8) | ACPI_GET8(aml));
 	}
 
-- 
2.53.0



