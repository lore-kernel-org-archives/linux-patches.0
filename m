Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2FE24DFE4;
	Tue, 20 May 2025 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750250; cv=none; b=K/toROdMoKxwu2iAlxcHoofQi37RBM4JpWEYtUZRJO3pwxu4GuClaqGHj4OoCCz8EgSFmT1ZoI/VCi+OUR67ICmJiawtV6efJE2ijk4DN70lfgSizMPNCIXyyNinTYG0jL6Gyv9XPqKD/fgdgteeZXrTfIgyhRxLh6+w0cDOqq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750250; c=relaxed/simple;
	bh=lugozsFRkF1cf6zME4qySUpzthcL0yl/1sWRSmvtQU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRw5/cZakeO38/PUEk5JPfjOVISG9zVn94G8j2gkQv8l6mUU5+lAr8YH2E0Cox7Elpvr7W8HUJfQFGo7Y6mh5NGnjKPJ0dls8MLp1fIA8HiMJQKy+hfTUHVQNMhp254ctLzDlTn2TiQYw944yLBNzLxtsuSmp3xzzo7tKboPwSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6l+4JDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6l+4JDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7185C4CEEB;
	Tue, 20 May 2025 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750250;
	bh=lugozsFRkF1cf6zME4qySUpzthcL0yl/1sWRSmvtQU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6l+4JDCZ2uYGQKU+QiuFnzNeRoWsuz/kmMgz8C9xhWL11CsRX9bV5Vyg0LJYW7Ie
	 WrUywq+itMnjRvPJAVJn0s6ob8siEr1Wb2Jjx2EojOgAitSAVO3C1uuSVYnblO9NbE
	 T4Eqq2LV99wCxaewcgzJrD8s/KHmy0je7y3C+2g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 090/143] ACPI: PPTT: Fix processor subtable walk
Date: Tue, 20 May 2025 15:50:45 +0200
Message-ID: <20250520125813.596613522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jeremy Linton <jeremy.linton@arm.com>

commit adfab6b39202481bb43286fff94def4953793fdb upstream.

The original PPTT code had a bug where the processor subtable length
was not correctly validated when encountering a truncated
acpi_pptt_processor node.

Commit 7ab4f0e37a0f4 ("ACPI PPTT: Fix coding mistakes in a couple of
sizeof() calls") attempted to fix this by validating the size is as
large as the acpi_pptt_processor node structure. This introduced a
regression where the last processor node in the PPTT table is ignored
if it doesn't contain any private resources. That results errors like:

  ACPI PPTT: PPTT table found, but unable to locate core XX (XX)
  ACPI: SPE must be homogeneous

Furthermore, it fails in a common case where the node length isn't
equal to the acpi_pptt_processor structure size, leaving the original
bug in a modified form.

Correct the regression by adjusting the loop termination conditions as
suggested by the bug reporters. An additional check performed after
the subtable node type is detected, validates the acpi_pptt_processor
node is fully contained in the PPTT table. Repeating the check in
acpi_pptt_leaf_node() is largely redundant as the node is already
known to be fully contained in the table.

The case where a final truncated node's parent property is accepted,
but the node itself is rejected should not be considered a bug.

Fixes: 7ab4f0e37a0f4 ("ACPI PPTT: Fix coding mistakes in a couple of sizeof() calls")
Reported-by: Maximilian Heyne <mheyne@amazon.de>
Closes: https://lore.kernel.org/linux-acpi/20250506-draco-taped-15f475cd@mheyne-amazon/
Reported-by: Yicong Yang <yangyicong@hisilicon.com>
Closes: https://lore.kernel.org/linux-acpi/20250507035124.28071-1-yangyicong@huawei.com/
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Maximilian Heyne <mheyne@amazon.de>
Cc: All applicable <stable@vger.kernel.org> # 7ab4f0e37a0f4: ACPI PPTT: Fix coding mistakes ...
Link: https://patch.msgid.link/20250508023025.1301030-1-jeremy.linton@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/pptt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -231,16 +231,18 @@ static int acpi_pptt_leaf_node(struct ac
 			     sizeof(struct acpi_table_pptt));
 	proc_sz = sizeof(struct acpi_pptt_processor);
 
-	while ((unsigned long)entry + proc_sz < table_end) {
+	/* ignore subtable types that are smaller than a processor node */
+	while ((unsigned long)entry + proc_sz <= table_end) {
 		cpu_node = (struct acpi_pptt_processor *)entry;
+
 		if (entry->type == ACPI_PPTT_TYPE_PROCESSOR &&
 		    cpu_node->parent == node_entry)
 			return 0;
 		if (entry->length == 0)
 			return 0;
+
 		entry = ACPI_ADD_PTR(struct acpi_subtable_header, entry,
 				     entry->length);
-
 	}
 	return 1;
 }
@@ -273,15 +275,18 @@ static struct acpi_pptt_processor *acpi_
 	proc_sz = sizeof(struct acpi_pptt_processor);
 
 	/* find the processor structure associated with this cpuid */
-	while ((unsigned long)entry + proc_sz < table_end) {
+	while ((unsigned long)entry + proc_sz <= table_end) {
 		cpu_node = (struct acpi_pptt_processor *)entry;
 
 		if (entry->length == 0) {
 			pr_warn("Invalid zero length subtable\n");
 			break;
 		}
+		/* entry->length may not equal proc_sz, revalidate the processor structure length */
 		if (entry->type == ACPI_PPTT_TYPE_PROCESSOR &&
 		    acpi_cpu_id == cpu_node->acpi_processor_id &&
+		    (unsigned long)entry + entry->length <= table_end &&
+		    entry->length == proc_sz + cpu_node->number_of_priv_resources * sizeof(u32) &&
 		     acpi_pptt_leaf_node(table_hdr, cpu_node)) {
 			return (struct acpi_pptt_processor *)entry;
 		}


