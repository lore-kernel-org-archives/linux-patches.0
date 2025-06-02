Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96FE22257E;
	Mon,  2 Jun 2025 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875403; cv=none; b=N2pEOsV2JAM3cqHJocqBBr8prftEC77gX/7htVgddSz7gvrMs7ieFG3Imh1Wd5VV9QBEuEWm1OqBthpBWC0GjL3RQsq5Jo+HxNJRtYI8lrQhePoNskk+JN9qKS1FJ3RJGCodp5uhSGJj3QQN70NbpqnxuitajCJUAkEI7mdu8vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875403; c=relaxed/simple;
	bh=nLK3/LsBYZyx7tic61g1ABHvjL7X4z1axn41rQ0nNmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4H3DEi+jqaGVMjNjq+1ZvOFY3bvs2DH1rkCpPwTZEIJ1VdosxnMkY6tWD/5Ow3z9IsQhL+kncC0HA9LWntnb13P3ekjiP+jiuzLY/9o7X2pSlpPncivxBZcXJuvlW2afJohV6kZZ3YVyOXo8lNWRPzIeWjisAcQ1PJlxkVrfUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7/So8GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7/So8GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70451C4CEEB;
	Mon,  2 Jun 2025 14:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875402;
	bh=nLK3/LsBYZyx7tic61g1ABHvjL7X4z1axn41rQ0nNmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7/So8GNCTMitUt+X379LMRJRGw7VmIWP8jYJpSElqsVc9dll05vNN4eC52ZZ31Fh
	 +LFDKPgQ2O0wkXp9bb8ec/j80juAplNSjef+jMYBZ+Jo48P1UZdU+gfHaRmIN7a9Jy
	 R6FpEq/aOor8kFwCZxcKiOioRnICCwvLz1X6a6Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 096/270] ACPI: PPTT: Fix processor subtable walk
Date: Mon,  2 Jun 2025 15:46:21 +0200
Message-ID: <20250602134311.099958704@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -219,16 +219,18 @@ static int acpi_pptt_leaf_node(struct ac
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
@@ -261,15 +263,18 @@ static struct acpi_pptt_processor *acpi_
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


