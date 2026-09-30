Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7856F4FE2E6;
	Wed, 30 Sep 2026 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790876; cv=none; b=ayiZZZbTJWZpG7bg6dwGS6LHiIhKeBCjBl2C5rU1yRGnkwAWbqlmjQ5ldrzcQiktvaOve/r/kIQLFzYN+QmG3y3m/dASCSKSV7/XKNnwL6ljgxPTDoByhb+4+sUNTj+FqMtpoqKwg/ohcig336L+sso1VB4tN4c8EmBMEHB7l9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790876; c=relaxed/simple;
	bh=lfdt9W9ksvbAEWmJrYvbb3YC4Edlqo8VILhOQRS66Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm9zPrbKhe60JhxAnj7+4ainZ3H+GMJtni5dyMCyahPrnhkPGjDKMA0ijPxwhw2EufL3sQ6NYDF2oelO7qlxqrr/st5AvqCdt0EhlT9yGsT/5R0GScyLJJixhi0qh+e4Kd8wqx5beaY41XVgndVKkIsFHaTeECymx6XGpSCZ7Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvEPou0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvEPou0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36691F000FF;
	Wed, 30 Sep 2026 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790875;
	bh=yO9359Y0WLUSIneOY4cE+raWq95kZKPVwYA+Zxc+1zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvEPou0asbdqgC4JwZn8Y2OOmZq7OJGhr7Fw4Bpw7dRtQ+HpIH2Bl0x0e9G/MI4xT
	 G9j7IkShyNRuMz99vv5FRziMq667Uk6mTE2nMvOOd/Xr9107dWP6JQX3/SKuzVHaq2
	 S9XXKy2dGPZIWHjipLwJpqGNvKmIZ5oRKy9yaTTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/752] ACPICA: add boundary checks in acpi_ps_get_next_field()
Date: Wed, 30 Sep 2026 17:19:08 +0200
Message-ID: <20260930152359.853704857@linuxfoundation.org>
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

[ Upstream commit e15aa60de0256d63df2331bf5a4bc4dd287504cd ]

Add boundary checks in acpi_ps_get_next_field() to prevent out-of-bounds
access.

Link: https://github.com/acpica/acpica/commit/c39183ea84bc
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/24388159.6Emhk5qWAg@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 29239a569bfd7..a4e2349f43323 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -474,6 +474,10 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 	ASL_CV_CAPTURE_COMMENTS_ONLY(parser_state);
 	aml = parser_state->aml;
 
+	if (aml >= parser_state->aml_end) {
+		return_PTR(NULL);
+	}
+
 	/* Determine field type */
 
 	switch (ACPI_GET8(parser_state->aml)) {
@@ -522,6 +526,11 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 
 		/* Get the 4-character name */
 
+		if ((parser_state->aml + ACPI_NAMESEG_SIZE) >
+		    parser_state->aml_end) {
+			acpi_ps_free_op(field);
+			return_PTR(NULL);
+		}
 		ACPI_MOVE_32_TO_32(&name, parser_state->aml);
 		acpi_ps_set_name(field, name);
 		parser_state->aml += ACPI_NAMESEG_SIZE;
@@ -567,6 +576,10 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 
 		/* Get the two bytes (Type/Attribute) */
 
+		if ((parser_state->aml + 2) > parser_state->aml_end) {
+			acpi_ps_free_op(field);
+			return_PTR(NULL);
+		}
 		access_type = ACPI_GET8(parser_state->aml);
 		parser_state->aml++;
 		access_attribute = ACPI_GET8(parser_state->aml);
@@ -578,6 +591,10 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 		/* This opcode has a third byte, access_length */
 
 		if (opcode == AML_INT_EXTACCESSFIELD_OP) {
+			if (parser_state->aml >= parser_state->aml_end) {
+				acpi_ps_free_op(field);
+				return_PTR(NULL);
+			}
 			access_length = ACPI_GET8(parser_state->aml);
 			parser_state->aml++;
 
-- 
2.53.0



