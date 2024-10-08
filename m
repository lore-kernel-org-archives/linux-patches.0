Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABC1165F08;
	Tue,  8 Oct 2024 12:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389783; cv=none; b=KvVZyVdhO7StW/IHp1/71sB0TaJHYDe5Kw5o2W6S71EQs67El349tQ6cJ/TOXg5XEXqNOfhKXrkKuYrkSmsc/bSPrNN9go+Y0VF7spkpn0Tv8w/Qn1Xz98SyrIEa4jCgrasgcD36UJcRnLSTDWEuOljOOQAXF95Ha9D0F7zIQb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389783; c=relaxed/simple;
	bh=j5tEMMIfCJM/18TuCg+27evV9DOO/bq4TRclMOKw9ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVADen6P3WZb7efAyTde14zVrxnJcZIHOueQ7Xo3PlnAt+WNrxjivMmCeltxvRu667GPL6gJYaqfaErjQVXorK33nz+8IeITbTcyQnW9QDz0eiqw444qxkMNkpRm5UbX5lmbcSIeXohFNonubDf4dBTp7pXKRBj/g/cEOWBo3f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaYOWzlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaYOWzlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B01C4CECD;
	Tue,  8 Oct 2024 12:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389782;
	bh=j5tEMMIfCJM/18TuCg+27evV9DOO/bq4TRclMOKw9ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaYOWzlgP3XxSa3rHZ0Q5kyG5alEO4Q//UoLO7uurO6HO0MwkTPPXw+53b2MAXXb4
	 04U8v8gR7LB+Vg8Qzm5BpSIL8q3CpOsqsudLNhz8zOaAMU2ezUAMdxEBm9ODt8NIY2
	 zxzCbrPF7BObeHFbuE717NyDXX+v3qkF/gMJAVzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 087/482] ACPICA: Fix memory leak if acpi_ps_get_next_field() fails
Date: Tue,  8 Oct 2024 14:02:30 +0200
Message-ID: <20241008115651.729465938@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7debfd5ce0d86..28582adfc0aca 100644
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



