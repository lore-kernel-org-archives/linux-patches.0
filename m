Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF3C1ABEB1;
	Mon, 14 Oct 2024 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918867; cv=none; b=OvmbJokHa79otI3sxjTwMsKtEWLDE3pP84tsYu/XqoxPfvUACwGosYOY1pJD1MU9DuyBECEQtGnSOOGsDNyrH7ttv+Ria60pXURXwpd0bkjlGNvMB72GRo/SGZYNcvlq7/YZrD9K5nqZEMsR8+5qqH3tDcKUhlk/prQiWtOEU+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918867; c=relaxed/simple;
	bh=d6Ri0FnK1WrGgrKW/k3ig2qs3VE06D73IQ6A43/yF1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvNGMqMNWrdFmynuDJzLiF2WTQklewSo7dXacxsjP1Ueu1fojeonIIJyo0no3Pro4pYEOvASDsiXANYWpYU8b0jGJZ6TfcOU+ZGkDlOTISBZeDqtfG9560K54zd6HENBJQeP361nzculXDVOeMAmfOsxrLmTRrJ7xij9Ee6vRwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2h7kP4LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2h7kP4LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D90FC4CEC7;
	Mon, 14 Oct 2024 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918866;
	bh=d6Ri0FnK1WrGgrKW/k3ig2qs3VE06D73IQ6A43/yF1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2h7kP4LPc50Yoi1urYd/5lj09K7qHP1kgLi74uOVEeGgWbrI4tkd2DGMNzgL1xGWn
	 TiQ0eIGWFZgTS+7Jn+rVWPaMQmJ8rakpchvO714c4eS1uClzZQgd39Skd8AhQgQ0XW
	 R2UNpgEL+kwvmkwZQI81IcuPIE09zV5hPfESdZmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 428/798] ACPICA: Fix memory leak if acpi_ps_get_next_field() fails
Date: Mon, 14 Oct 2024 16:16:22 +0200
Message-ID: <20241014141234.765493063@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit e6169a8ffee8a012badd8c703716e761ce851b15 ]

ACPICA commit 1280045754264841b119a5ede96cd005bc09b5a7

If acpi_ps_get_next_field() fails, the previously created field list
needs to be properly disposed before returning the status code.

Link: https://github.com/acpica/acpica/commit/12800457
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Rename local variable to avoid compiler confusion ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 919a7aebcc036..418d56203e27a 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -25,6 +25,8 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state);
 static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 						       *parser_state);
 
+static void acpi_ps_free_field_list(union acpi_parse_object *start);
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ps_get_next_package_length
@@ -683,6 +685,39 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 	return_PTR(field);
 }
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ps_free_field_list
+ *
+ * PARAMETERS:  start               - First Op in field list
+ *
+ * RETURN:      None.
+ *
+ * DESCRIPTION: Free all Op objects inside a field list.
+ *
+ ******************************************************************************/
+
+static void acpi_ps_free_field_list(union acpi_parse_object *start)
+{
+	union acpi_parse_object *cur = start;
+	union acpi_parse_object *next;
+	union acpi_parse_object *arg;
+
+	while (cur) {
+		next = cur->common.next;
+
+		/* AML_INT_CONNECTION_OP can have a single argument */
+
+		arg = acpi_ps_get_arg(cur, 0);
+		if (arg) {
+			acpi_ps_free_op(arg);
+		}
+
+		acpi_ps_free_op(cur);
+		cur = next;
+	}
+}
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ps_get_next_arg
@@ -751,6 +786,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 			while (parser_state->aml < parser_state->pkg_end) {
 				field = acpi_ps_get_next_field(parser_state);
 				if (!field) {
+					if (arg) {
+						acpi_ps_free_field_list(arg);
+					}
+
 					return_ACPI_STATUS(AE_NO_MEMORY);
 				}
 
-- 
2.43.0



