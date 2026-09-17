Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC9D4E3231;
	Thu, 17 Sep 2026 16:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664032; cv=none; b=QIQeKo4+W1cdGKmFGmPlpAda2EPi7PdJ63W05CtrEfYSZRMnzJrWRjPuhVdJIsD5TkLDZDuMWOaLixXAgRt+73mz1ynlhcIj0lqyLni1wk9/Mi3sRSXNq3bDUMFyjRv6vwiZwOJ+X80usnkwUvzo+BKMuBWk3xjBlB/zT7Umoxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664032; c=relaxed/simple;
	bh=utskVc/6edrYa/B0Grj/ZxOcvuNqk90+hd/LeC6x4Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgyXSSEHrKBSbJzHJtyFAhLyr089/LTISrlXSQFUjh3pIf3grPvpIRmqZiveCv/ieR6eCjSxqDYkdawkYtEU14zhszkI6eWOlekeoJg945ocwHYsuqvm1wDKO3IbCFNQ7qGXJn2kAKS3KDXwhkbEcUUAZQsSbC+SGqyafpi/mB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQpYDR1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQpYDR1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E111F000FF;
	Thu, 17 Sep 2026 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664031;
	bh=0uXvPDzhUYjOOO9KtYOkhVk/jab2fUjhX5u4EdYV0WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQpYDR1PZRTX/R6KvzjBCiN2/zrzxEya1Sw8JLuoj3XHtPuTuc1L9GZ8d3EnZJEyK
	 83zOn1J+nns/FeFrIB2fzJ8UpNm6TNiS0a4j9bK8se0AL93cqQFOihHmb2lFlphSxq
	 iX2cvi4u/RbCweWmfQwtUHhGUN/a9xbNi2ingIQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0236/1250] ACPICA: Fix use-after-free in acpi_ds_terminate_control_method()
Date: Thu, 17 Sep 2026 16:00:31 +0100
Message-ID: <20260917151558.539986002@linuxfoundation.org>
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
index 45ec32e81903a..08bfe83030838 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -705,6 +705,8 @@ void
 acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
 				 struct acpi_walk_state *walk_state)
 {
+	u32 i;
+	struct acpi_namespace_node *ref_node;
 
 	ACPI_FUNCTION_TRACE_PTR(ds_terminate_control_method, walk_state);
 
@@ -715,6 +717,47 @@ acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
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



