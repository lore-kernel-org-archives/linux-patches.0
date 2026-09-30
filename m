Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A395E4DA9D4;
	Wed, 30 Sep 2026 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784314; cv=none; b=B+NRpcKQDo6R7gB8U5kBtV5vr8jnMx04xILDt9igVSurEPZ0w5+k36QNB7hwcZ/eVLN7e4glNysV+FfC2PtUVcx5ZF2GpOiMKBj51+08kL9hHyBL9yxxq+8WLBbSSEieM9qIzjmA1qVtAiS8nEm0PPz4uvVcuYfj+qIoUOktQlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784314; c=relaxed/simple;
	bh=df4XsYSzLZQa4IbbfJ29k1ed7QhBj8ko+hx0HMeSNKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRS4znNwu1HpRTNhnyWqbiHQXO90bKCQ16pWpmtxcSaT+TlkTeGLGJeE1L4f3HX6H//GOebyJOl2PZwRl9UwDxzkycpAcE6Jjm5O6piS3qHWTJldkhpmUJX6/vL9WsYnGPAPfnxrCHieUDcI5GQ3j+Fu6RYHcElaj738cjs+vkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UC3a1Nbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UC3a1Nbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E666C1F000FF;
	Wed, 30 Sep 2026 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784309;
	bh=knp042//phIwc3Mf5QaFW7s2vJ/r2eSrF7v2IvqWj8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UC3a1NbsPA5JeXBx2kJWF3rwPdAyzH9FEzX6JTkf7VrNYO1m8g1tHeM+DmkGdXAg8
	 zt3UoBhMH9BQ7ChEgf3/sMlrBo/VEJiHBrOGYdePJbD+lI5QXgghXN3b7TK4ZGaoLk
	 is7X0SN4AqJiqhy/oVwAQXqtZJDTAGFEu+KCcagw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/982] ACPICA: Add package limit checks in parser functions
Date: Wed, 30 Sep 2026 17:14:04 +0200
Message-ID: <20260930152419.129875699@linuxfoundation.org>
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
index b2cfdfef31947..8079364e2440e 100644
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
index 1a52bc08db4ce..35166be684880 100644
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
index e851c7fe31906..60c55743d399e 100644
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
index ba93f359760a9..a4eb254c62ea5 100644
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



