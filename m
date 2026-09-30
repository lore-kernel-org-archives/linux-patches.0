Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37234F93CC;
	Wed, 30 Sep 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782641; cv=none; b=ASr+Vd2v48zijZcmuYJPE9iYjXnB4PZE8kJ/QzJllM7Ea1XjHQNTDBPyLJvIR/kXYnrdy7S5dAtq507eUxT8oigVOxq4ZuKVR5Cg6WwsAzZit1/s6stCZHcp+hR0Nr6S0ZiyOBnnHbdAXmDbv5aBZ6yxE1qaSS5gTqDF7HskI+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782641; c=relaxed/simple;
	bh=1mTRJiBixJSSo0Alo2QmxEJfi6Gi6FPuURRXb77Dkp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKzjwc0HvOQAQrl47Lcf/wAiKZKMyBHLUgzyANurUxyyHwtFsrolhwQKBrxw2Blp5lgULv8us2up6ciVB3zBgL4PiQMLyCa0Kzg7h8nMxXSN59VDfdORLyfoag5//UNhe1J2mbbKzyU7cxvVJL48Z4Rz04anQvhRzjNszZ6YrA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BENt/8Ky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BENt/8Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1414A1F0089A;
	Wed, 30 Sep 2026 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782632;
	bh=rgFMiPzCAXvRb6css9DRH1C8ZHHkuEbgLh8LZi9waKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BENt/8KyrVf1cP+rgCFT0odREeQiLI5hCsnszelkn/d5MyFJ+Bq4jITca7976mzkk
	 GRT3pz5/kwZIL3jq1m9N7hM7wzA3zbGROsptq9Nc43JaSo452FuQLMFFuRTuSrrsLq
	 jy7Oe9+NPVDToYYI2KqyMd5suLFwOQaIW8qJ1KiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/595] ACPICA: Fix use-after-free in acpi_ds_terminate_control_method()
Date: Wed, 30 Sep 2026 17:19:23 +0200
Message-ID: <20260930152349.244862442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0f4770a48912d..f77c7f5ab770a 100644
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



