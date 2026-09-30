Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19D136A033;
	Wed, 30 Sep 2026 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784298; cv=none; b=Cg5gycDNdTy6e/LMBS5v0I5i8V5a0kPJbghvyHBO1sIbEUaZrEWnuL0hV5hupgVAMcwAZnROZZ7knZwPUtJvUw5DMzokUEccBBh49AQeZbGwe9zR5RYsf1P4onJPvJQqzu/MWFaXz3I2A8YZ9NgPSzFVWVSMf5cZRhv3VXS3BYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784298; c=relaxed/simple;
	bh=0rnRbeJAqBzN/SXYwHgfZo/kLcS+WheHxRLTslAGvoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNneaPH3GHHnx1qtPyleWRv5ZCGVJt9E7UniQyEFyuloi8CCCMPduxcD1UbAWB8663B5tbPWequIVp8ViXSytoLKPsclXf3EbBN/AsHXl9+1s4P47TP+alpqAd4ZOW3wKsmHmidFwHfk5+c9qL3tzynJ9DFSHeQdjAwvNE9c/Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ681Krr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ681Krr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3CC1F00893;
	Wed, 30 Sep 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784289;
	bh=qVBizi+17KcxY+TU2ON+koCtt7WJ1lvryHJH3q3TEbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQ681Krr457hx9hfgNmtnQUBVrSRWLutcAw6RtDwa2Yh1fgOP1svOuHO8zKA2bT5k
	 6AFi9LwoFOJkRWazo1t9ZX/QghdyxC9xpJqLIB9GVk9Mr5w/kJgIlCo610JVETw04I
	 SJCUeZYDHPksZBmdCj68+z0clPyKUACmXaa0dVEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/982] ACPICA: add boundary checks in acpi_ps_get_next_field()
Date: Wed, 30 Sep 2026 17:13:58 +0200
Message-ID: <20260930152419.001954146@linuxfoundation.org>
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
index 418d56203e27a..55af9b3fe8d40 100644
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



