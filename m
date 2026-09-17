Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D534E9C36;
	Thu, 17 Sep 2026 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664056; cv=none; b=t5ELCcfYjeagfGcs4zpIUpdNOHYLw/m3d+KoDiRxJ3p+H/kYn1G6H2vT9KXtylgZJYzOzZe+Qgvgl+CRKoM+oIG4aOMkO0SU8F4ZRS02brONGOkw8Sy3zDqhUcRkL3qjlecaB5VyHO9iQGKQ8ihejoM8frzB0pzFyJcFMzsFaJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664056; c=relaxed/simple;
	bh=gEilLrmRitm83j4Uzbjg2drRXfPdtSHvU7y4LIaYKlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZubQ5snsXQ/JDgWSHGKPzX7bcucaZE+jylVqEJAb0tpw5Hl0MDpa2NOFXGSlHVimhhaFBO0ONoSpU0+Q1IQrsS9roP98h7ppUVdh9Rv8U5oxuSnXCbR7Zp1I76FSR3Jyel3xyizB0+LClmKXgEPxpVdBBV2obn4uUlRad/FVpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1H/+qc7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1H/+qc7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE5D1F000FF;
	Thu, 17 Sep 2026 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664055;
	bh=Lj0pWclodmdo1QUTdefePqLIQTE1xyoo92T0QQIaVYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1H/+qc7v8FAsDzb10YxeuV6cq3k/12kR6T1poZUFTpemeBZlrESMJ3qoDVspopsJW
	 oHDSCPFu45LOkAn0cMap2uz+TldK0Jxw9Yz4GIDHFgfNnbN2LeYYd/hEYu5zM9cLU3
	 qMa4s2YSSwquV1DnV8Lg8HH7dqxyClE+VpxY07uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0243/1250] ACPICA: Add package limit checks in parser functions
Date: Thu, 17 Sep 2026 16:00:38 +0100
Message-ID: <20260917151558.731250833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1db831545ec8c..821fb4930e9d8 100644
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
index 064652d11d9aa..34d887e2211ac 100644
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
index 35111ff2526b1..7c3caf0ccab62 100644
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
index 55a416e56fd83..b4f21a8988795 100644
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



