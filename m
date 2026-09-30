Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F443AE1A9;
	Wed, 30 Sep 2026 18:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794173; cv=none; b=BKa3Q+IU3+A18JWhtS4jaTRikumnJYWQo47rBC4KgEyVr1QsBEF6q39QzbDXx5G9sVY9P62mC+8nwf++ZFDMM38GNeovRLcDmaZ7xdUSZ1KVsA+eEeSb+rrxxnqETcGsrMlPfzBLlPs3gOtuW81+sfshxV8vanRWYocxDj/GcaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794173; c=relaxed/simple;
	bh=yw3YH70TPe+e83GuLuxmj+81z54/DvYK84nw3ZpLpQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaG3/pkXaLDR7C9d04czZdeJ+uZ41S+Jmxl0VrogKuoNkoNIjRP5XSn9O4DGu0leZsx2y75ASFqni2GYlmvgW5APVbhpiz0f5xK/bRDp63d2SyxKAOybdWOW/qrvFPUV53WFkIMb73uud3km2HEpeIzb9Vxp8XaNnNVji7C28j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHi9PdOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHi9PdOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74A81F0089A;
	Wed, 30 Sep 2026 18:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794171;
	bh=XEuhgMtX/QrAvBPDjo19S8KbfW44DzBN/NgbkZSRP/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHi9PdOOSx7RmHsSaBuTfnU2F8bI3JrECCQ5R8SlbeybJU6hMEaLtMdTODDEnL+pK
	 EAD9kd+K/90Eh74eGMS9aLzIDPhkzUNE2zrCUutrdWINnPp5Rrcm9Tf9okBMkQxiKu
	 UzaZD4MjwpQUXXS6oAOXWpUMVmwQgw8OAw+zGQNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0118/1193] ACPICA: Fix use-after-free in acpi_ds_terminate_control_method()
Date: Wed, 30 Sep 2026 17:13:22 +0200
Message-ID: <20260930152436.846910105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ikaros <void0red@gmail.com>

[ Upstream commit 945e87267cfd90937b3c637f87324cbb56998b72 ]

Fix use-after-free issue in acpi_ds_terminate_control_method() by
clearing references to method locals and arguments.

Link: https://github.com/acpica/acpica/commit/36f22a94cb1b
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/8730924.NyiUUSuA9g@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsmethod.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 6168597a96e6f..d0096425468cb 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -698,6 +698,8 @@ void
 acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
 				 struct acpi_walk_state *walk_state)
 {
+	u32 i;
+	struct acpi_namespace_node *ref_node;
 
 	ACPI_FUNCTION_TRACE_PTR(ds_terminate_control_method, walk_state);
 
@@ -708,6 +710,47 @@ acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
 	}
 
 	if (walk_state) {
+		/*
+		 * Check if the return value is a ref_of reference to a method local
+		 * or argument. If so, clear the reference to avoid use-after-free
+		 * when the walk state is deleted.
+		 */
+		if (walk_state->return_desc &&
+		    (walk_state->return_desc->common.type ==
+		     ACPI_TYPE_LOCAL_REFERENCE)
+		    && (walk_state->return_desc->reference.class ==
+			ACPI_REFCLASS_REFOF)) {
+			ref_node = walk_state->return_desc->reference.object;
+			if (ref_node) {
+
+				/* Check against method locals */
+				for (i = 0; i < ACPI_METHOD_NUM_LOCALS; i++) {
+					if (ref_node ==
+					    &walk_state->local_variables[i]) {
+						acpi_ut_remove_reference
+						    (walk_state->return_desc);
+						walk_state->return_desc = NULL;
+						break;
+					}
+				}
+
+				/* Check against method arguments if not already cleared */
+				if (walk_state->return_desc) {
+					for (i = 0; i < ACPI_METHOD_NUM_ARGS;
+					     i++) {
+						if (ref_node ==
+						    &walk_state->arguments[i]) {
+							acpi_ut_remove_reference
+							    (walk_state->
+							     return_desc);
+							walk_state->
+							    return_desc = NULL;
+							break;
+						}
+					}
+				}
+			}
+		}
 
 		/* Delete all arguments and locals */
 
-- 
2.53.0



