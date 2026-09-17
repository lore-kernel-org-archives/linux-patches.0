Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CC74D9F6E;
	Thu, 17 Sep 2026 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667653; cv=none; b=dWo65UBn2m9itzmUVosZlg9n6zTmP5a4ug3tohJ70nYkTSUMWbbBv7MQ9MPwgs1w2do32uCW5KQX/0M3+WzJ3bRIedXB/XASkmOo7HWQUws0OocdhdAUIgT4XFl/hXfhNFTWAbKkg7J9PByY7PDMHM8jX5KIk6OSAdNh+ixW2rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667653; c=relaxed/simple;
	bh=3ZIPeS46YwH40sqXXxV90uUlDfLX4QvTn6oOE2ZdknQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2o+2I7pmcvd9GnFZPky28kXVECbWLXm49kHhG0MJ7vFXyFck3pzjP8m2lKuOG1KbjbRwom/B6lrdI3qu//u5tDqe4ocT/TuLZWJ255hAu5f0hKXzuZ4lHB2l9A3BD9P/5DGgXjb337Km3gtP3+VHIdrlQOhD/UQniwgBKt2ulc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJkQNzZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJkQNzZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784F31F000FF;
	Thu, 17 Sep 2026 17:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667652;
	bh=yoNPJSnX7jxOvWHfQMB7pTv9KKV0hHda6OmTO4niJsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJkQNzZgn3UMXTcJ+GpFszAV36iRi+VhFWRf3HrB34jdC7wSINdPgxo0ztj2/xh8t
	 68i5HlN3T29CybIJvRmJuyzkOM9NEICkdsKkTQPzrhkPSugsesO/FQ8SrZIl/XR6Dj
	 d7w6rbCh/B861PzwmAXoQuA9Cdx2BfNUvYvLPEdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0163/1102] ACPICA: add boundary checks in acpi_ps_get_next_field()
Date: Thu, 17 Sep 2026 16:01:46 +0100
Message-ID: <20260917151543.629620137@linuxfoundation.org>
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
index 28582adfc0aca..251f3eacb83d1 100644
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



