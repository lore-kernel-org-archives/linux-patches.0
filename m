Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A614FD265;
	Thu, 17 Sep 2026 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667719; cv=none; b=cdUjq4MNKYm+nuwzV/4mK5xM2i3NfKxayQtQsLgkHMxPzMFV8QcImZS+/WCvmG+94QdCAPc3TQ/ZeNxkkykO3iMlebbLc1PHVgPAPc/zVd3FdCMW+0EwssjEHP05ODUMtB/CE6e+MB7Y6ArqegYYVAARZcqZcqerSH7HydgJa/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667719; c=relaxed/simple;
	bh=qVxLuu8vUymvwZPLLJ4i90EgnQj2p+Qd7EiVuBQnfWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiBmMST6swoQ3DIg5IKls71oPd3o5ujNsRRuOkMyvRUA0amsCu6HnjtmLQWMwIl/v1AWmBd0JlfrOmHAbc0eqgDv02RODng/IQRdPXLsu/HU8vtHORiGis+7fDTutlEH4pl3QfWiQWfQ9VxzF1YjP9HdH2BncW0Yq7xUgiDLreU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYxaakd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYxaakd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8996B1F000FF;
	Thu, 17 Sep 2026 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667718;
	bh=37bxbrZqW+jJptu8o8GWGqeDSI8ki/uY4wIBj5Zc/iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYxaakd4cZe4K00QrtNZcDBf3K8MsK57RGRBBUGqNT+HSGO1v29ia9xjbkrUsEDTD
	 P5esK5nzjh/QheBYRuiHtQW0Jn5FtKUQceXeoZfXuAi0q3C0HnJKmytY6tJ7sRIFgn
	 cX8GVxa1PNbVXBy4cMbgw41bGuSNBzQLk58eVJR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0169/1102] ACPICA: Add package limit checks in parser functions
Date: Thu, 17 Sep 2026 16:01:52 +0100
Message-ID: <20260917151543.783841150@linuxfoundation.org>
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

[ Upstream commit d27d48a528e437aed690f977e69a6fe73fe82ab5 ]

Add package limit checks in parser functions to prevent out-of-bounds
access.

Link: https://github.com/acpica/acpica/commit/b31b45af2122
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3212937.CbtlEUcBR6@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsxfname.c |  4 ++++
 drivers/acpi/acpica/psargs.c   |  4 ++++
 drivers/acpi/acpica/psloop.c   | 25 +++++++++++++++++++++++++
 drivers/acpi/acpica/psparse.c  |  8 ++++++++
 4 files changed, 41 insertions(+)

diff --git a/drivers/acpi/acpica/nsxfname.c b/drivers/acpi/acpica/nsxfname.c
index 5d5bcf1652985..835bf4810c29e 100644
--- a/drivers/acpi/acpica/nsxfname.c
+++ b/drivers/acpi/acpica/nsxfname.c
@@ -512,6 +512,10 @@ acpi_status acpi_install_method(u8 *buffer)
 
 	parser_state.aml += acpi_ps_get_opcode_size(opcode);
 	parser_state.pkg_end = acpi_ps_get_next_package_end(&parser_state);
+	if ((parser_state.pkg_end > parser_state.aml_end) ||
+	    (parser_state.pkg_end < parser_state.aml)) {
+		return (AE_AML_PACKAGE_LIMIT);
+	}
 	path = acpi_ps_get_next_namestring(&parser_state);
 
 	method_flags = *parser_state.aml++;
diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index a880959ebafce..19e7c8b4c9568 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -867,6 +867,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 
 		parser_state->pkg_end =
 		    acpi_ps_get_next_package_end(parser_state);
+		if ((parser_state->pkg_end > parser_state->aml_end)
+		    || (parser_state->pkg_end < parser_state->aml)) {
+			return_ACPI_STATUS(AE_AML_PACKAGE_LIMIT);
+		}
 		break;
 
 	case ARGP_FIELDLIST:
diff --git a/drivers/acpi/acpica/psloop.c b/drivers/acpi/acpica/psloop.c
index ceab76e3bcb82..a55ea47c92057 100644
--- a/drivers/acpi/acpica/psloop.c
+++ b/drivers/acpi/acpica/psloop.c
@@ -361,6 +361,13 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 					walk_state->parser_state.aml =
 					    acpi_ps_get_next_package_end
 					    (&walk_state->parser_state);
+					if ((walk_state->parser_state.aml >
+					     walk_state->parser_state.aml_end)
+					    || (walk_state->parser_state.aml <
+						walk_state->aml)) {
+						return_ACPI_STATUS
+						    (AE_AML_PACKAGE_LIMIT);
+					}
 					walk_state->aml =
 					    walk_state->parser_state.aml;
 				}
@@ -421,6 +428,14 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 					parser_state->aml =
 					    acpi_ps_get_next_package_end
 					    (parser_state);
+					if ((parser_state->aml >
+					     parser_state->aml_end)
+					    || (parser_state->aml <
+						walk_state->control_state->
+						control.aml_predicate_start)) {
+						return_ACPI_STATUS
+						    (AE_AML_PACKAGE_LIMIT);
+					}
 					walk_state->aml = parser_state->aml;
 
 					ACPI_ERROR((AE_INFO,
@@ -436,6 +451,16 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 						walk_state->parser_state.aml =
 						    acpi_ps_get_next_package_end
 						    (parser_state);
+						if ((walk_state->parser_state.
+						     aml >
+						     walk_state->parser_state.
+						     aml_end)
+						    || (walk_state->
+							parser_state.aml <
+							walk_state->aml)) {
+							return_ACPI_STATUS
+							    (AE_AML_PACKAGE_LIMIT);
+						}
 						walk_state->aml =
 						    parser_state->aml;
 					}
diff --git a/drivers/acpi/acpica/psparse.c b/drivers/acpi/acpica/psparse.c
index 10a072953d787..7ebebe1e27aff 100644
--- a/drivers/acpi/acpica/psparse.c
+++ b/drivers/acpi/acpica/psparse.c
@@ -300,6 +300,7 @@ acpi_ps_next_parse_state(struct acpi_walk_state *walk_state,
 {
 	struct acpi_parse_state *parser_state = &walk_state->parser_state;
 	acpi_status status = AE_CTRL_PENDING;
+	u8 *aml;
 
 	ACPI_FUNCTION_TRACE_PTR(ps_next_parse_state, op);
 
@@ -344,7 +345,14 @@ acpi_ps_next_parse_state(struct acpi_walk_state *walk_state,
 		 * Predicate of an IF was true, and we are at the matching ELSE.
 		 * Just close out this package
 		 */
+		aml = parser_state->aml;
+
 		parser_state->aml = acpi_ps_get_next_package_end(parser_state);
+		if ((parser_state->aml > parser_state->aml_end) ||
+		    (parser_state->aml < aml)) {
+			status = AE_AML_PACKAGE_LIMIT;
+			break;
+		}
 		status = AE_CTRL_PENDING;
 		break;
 
-- 
2.53.0



