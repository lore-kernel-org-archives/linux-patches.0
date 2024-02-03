Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A17D134AE;
	Sat,  3 Feb 2024 04:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933731; cv=none; b=DAvLCwkQsqTeqVmU9ClPv6//sJ/Z1CoXuoF65UusBAUMy0W4YVi2udumcYNypVSU2hS9Iqw3ETWPi8DSfvpz5ZEQpr2k4Fax4bvUs/xOMJ0URQFGqBXyQeakvUGXt9xAdIbrFAXIGJdtpoilkEIGKBvRa3DmNmcFtbC/V4dZRW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933731; c=relaxed/simple;
	bh=txeTmLbMV4COHrgC5CyBdSdSeRC4Cm1xrD3VMkobU40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kt82owlpyitfe7J/EZ98v9jERyiw4xGzERwgOcWasfQ2V2yYjX5yJkg+4SaEPJIRhI7SkNF/uDhDG32r2FDlhQLydg28HVrUpfCjARnHs/jsiD/h+zIyizj1DJiB176aUU0L9A3Z4/mgXg7bBSQGTNRZd23KEv89p6SOJxG5rvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VckS7Zv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VckS7Zv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8F8C43399;
	Sat,  3 Feb 2024 04:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933730;
	bh=txeTmLbMV4COHrgC5CyBdSdSeRC4Cm1xrD3VMkobU40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VckS7Zv08g9uzxKAvrxRV217YiSrbWXnY4xFPo/MPR5flGeyyYxhloawWtUmC9+Yl
	 nXimPs9LpQiOhvl87SYzxM57doOPSnOppvc/wOulES1Bsk/IlY0DKDcsxK/pxcZCP8
	 9vhtJN9Ux+32a5Bh4Y3A+HBGeW4DUWPo9BqVAoSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 018/353] ACPI: tables: Correct and clean up the logic of acpi_parse_entries_array()
Date: Fri,  2 Feb 2024 20:02:16 -0800
Message-ID: <20240203035404.321468574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit 4b3805daaacb2168665c6222f261e68accb120dc ]

The original intention of acpi_parse_entries_array() is to return the
number of all matching entries on success. This number may be greater than
the value of the max_entries parameter. When this happens, the function
will output a warning message, indicating that `count - max_entries`
matching entries remain unprocessed and have been ignored.

However, commit 4ceacd02f5a1 ("ACPI / table: Always count matched and
successfully parsed entries") changed this logic to return the number of
entries successfully processed by the handler. In this case, when the
max_entries parameter is not zero, the number of entries successfully
processed can never be greater than the value of max_entries. In other
words, the expression `count > max_entries` will always evaluate to false.
This means that the logic in the final if statement will never be executed.

Commit 99b0efd7c886 ("ACPI / tables: do not report the number of entries
ignored by acpi_parse_entries()") mentioned this issue, but it tried to fix
it by removing part of the warning message. This is meaningless because the
pr_warn statement will never be executed in the first place.

Commit 8726d4f44150 ("ACPI / tables: fix acpi_parse_entries_array() so it
traverses all subtables") introduced an errs variable, which is intended to
make acpi_parse_entries_array() always traverse all of the subtables,
calling as many of the callbacks as possible. However, it seems that the
commit does not achieve this goal. For example, when a handler returns an
error, none of the handlers will be called again in the subsequent
iterations. This result appears to be no different from before the change.

This patch corrects and cleans up the logic of acpi_parse_entries_array(),
making it return the number of all matching entries, rather than the number
of entries successfully processed by handlers. Additionally, if an error
occurs when executing a handler, the function will return -EINVAL immediately.

This patch should not affect existing users of acpi_parse_entries_array().

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/fw_table.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/lib/fw_table.c b/lib/fw_table.c
index 294df54e33b6..c49a09ee3853 100644
--- a/lib/fw_table.c
+++ b/lib/fw_table.c
@@ -85,11 +85,6 @@ acpi_get_subtable_type(char *id)
 	return ACPI_SUBTABLE_COMMON;
 }
 
-static __init_or_acpilib bool has_handler(struct acpi_subtable_proc *proc)
-{
-	return proc->handler || proc->handler_arg;
-}
-
 static __init_or_acpilib int call_handler(struct acpi_subtable_proc *proc,
 					  union acpi_subtable_headers *hdr,
 					  unsigned long end)
@@ -133,7 +128,6 @@ acpi_parse_entries_array(char *id, unsigned long table_size,
 	unsigned long table_end, subtable_len, entry_len;
 	struct acpi_subtable_entry entry;
 	int count = 0;
-	int errs = 0;
 	int i;
 
 	table_end = (unsigned long)table_header + table_header->length;
@@ -145,25 +139,19 @@ acpi_parse_entries_array(char *id, unsigned long table_size,
 	    ((unsigned long)table_header + table_size);
 	subtable_len = acpi_get_subtable_header_length(&entry);
 
-	while (((unsigned long)entry.hdr) + subtable_len  < table_end) {
-		if (max_entries && count >= max_entries)
-			break;
-
+	while (((unsigned long)entry.hdr) + subtable_len < table_end) {
 		for (i = 0; i < proc_num; i++) {
 			if (acpi_get_entry_type(&entry) != proc[i].id)
 				continue;
-			if (!has_handler(&proc[i]) ||
-			    (!errs &&
-			     call_handler(&proc[i], entry.hdr, table_end))) {
-				errs++;
-				continue;
-			}
+
+			if (!max_entries || count < max_entries)
+				if (call_handler(&proc[i], entry.hdr, table_end))
+					return -EINVAL;
 
 			proc[i].count++;
+			count++;
 			break;
 		}
-		if (i != proc_num)
-			count++;
 
 		/*
 		 * If entry->length is 0, break from this loop to avoid
@@ -180,9 +168,9 @@ acpi_parse_entries_array(char *id, unsigned long table_size,
 	}
 
 	if (max_entries && count > max_entries) {
-		pr_warn("[%4.4s:0x%02x] found the maximum %i entries\n",
-			id, proc->id, count);
+		pr_warn("[%4.4s:0x%02x] ignored %i entries of %i found\n",
+			id, proc->id, count - max_entries, count);
 	}
 
-	return errs ? -EINVAL : count;
+	return count;
 }
-- 
2.43.0



