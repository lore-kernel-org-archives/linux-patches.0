Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221E33AAF49;
	Thu, 17 Sep 2026 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667797; cv=none; b=B/7RHrr2JBmP4C64iRCRpPcI1YFddu3t+mDjxZkfNgJjC/Sv64fLem6NGjrFm32X04DrACOyouJRjli7W0Lh0sAMyyCTes30czg0gbuIiSl46V6cG8PyeQmEgKduSKvs+vpg/Z8NaPl+1BsCD103kTkeGu9TH1Qx4sUbiYyxqXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667797; c=relaxed/simple;
	bh=KCXYu4GuXgA8UQkksqS9YM8zHRva6Urc6tC62V4Eiho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtwCRC7LIExj/mz4Buix1SWNVEKKz33IvaSWAqvi+jl/0g/CrtkjbuK3AooJ2msaAyXtoQAyqULFwx+KGQQRJD0BuiHmzq+kLrDTHzoBXfKc4p4p3TR2bC2Hr+A2+sYBC0/0zqbPkV7Y4vySskBXBXch8HklWpmLggQ/vW1VjFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ys5M7NLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ys5M7NLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B981F000FF;
	Thu, 17 Sep 2026 17:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667796;
	bh=G5k5VwvhSGmbchVTNuVc8Mi7zLsw2PRW7HbaBbv3R60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ys5M7NLEkPO48CN3Kb0IAJpLfj64F5Ix1/1rCB87DmY40PZv/ZKLTCEnCgEG5DLti
	 pZv5kzN7CNBgbjff1YxXhSli1JV3Assn6T0qjDvz/sBLs4ZVRe4Q0jawI/924/m9GT
	 LV3xjbFPczMNidmtU5w/P7uAZ4oM03IIcmEqdl00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0174/1102] ACPICA: add boundary checks in two places
Date: Thu, 17 Sep 2026 16:01:57 +0100
Message-ID: <20260917151543.915970037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 19e7c8b4c9568..29ebc2fa02b60 100644
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
index 7ebebe1e27aff..13e1ed2ff879d 100644
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



