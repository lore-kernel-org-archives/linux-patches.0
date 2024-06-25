Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64F314A0A8;
	Tue, 25 Jun 2024 09:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309268; cv=none; b=qscxcAAZrsRt9YGvqFEfV3ULR2AxtjjeC87IQ35qJhUfLGzforX8LA9XYZT3hce2HYl9IGGUnuuYMN8a5P2kPrDUHy74iKwZ+/P0dZjshgbMhj2o4BdRKxkA4FezyrsvvD2MMk9h3SKkwqkWPPHUWnpxHrsWrtaNBdH9LP6Vla0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309268; c=relaxed/simple;
	bh=vunAArS2xl3eULdu5eRLpmxfCyivdPt0CTcEH/s9IW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK6b8Of11xxk944/ARDtUTZ8HInucp6fkmUqDeo5jBhahMsgC08cQCPm1SLQugWvIKb2R3tn+XLOGVeF91rcuaUn2sKnE/ykePGJ32hjT8fC/EC9F2mJPRY6OVlCTOrQriOEmMnPg4W+L/+thUTFZj6eLmBARkvGfKAZWwrGWu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iV+uKiZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iV+uKiZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD82C32781;
	Tue, 25 Jun 2024 09:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309268;
	bh=vunAArS2xl3eULdu5eRLpmxfCyivdPt0CTcEH/s9IW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iV+uKiZ3gBSg/U8Nnz4dJ9uViTvopkZA1MFRosoqnEx/2JG/TMnGSnCDl7WqSVMtU
	 WMqUvqKCbhUqvcqB2NP3R6p8r3gMdgrvBme0j/77LnGqr7kNECcHrZhXsZCdPRkYq1
	 N5q47WCegIUdbxzkXj50sLeUgE0noUYce9S5HwiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanath S <Sanath.S@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/192] ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."
Date: Tue, 25 Jun 2024 11:33:13 +0200
Message-ID: <20240625085541.814170715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit a83e1385b780d41307433ddbc86e3c528db031f0 ]

Undo the modifications made in commit d410ee5109a1 ("ACPICA: avoid
"Info: mapping multiple BARs. Your kernel is fine.""). The initial
purpose of this commit was to stop memory mappings for operation
regions from overlapping page boundaries, as it can trigger warnings
if different page attributes are present.

However, it was found that when this situation arises, mapping
continues until the boundary's end, but there is still an attempt to
read/write the entire length of the map, leading to a NULL pointer
deference. For example, if a four-byte mapping request is made but
only one byte is mapped because it hits the current page boundary's
end, a four-byte read/write attempt is still made, resulting in a NULL
pointer deference.

Instead, map the entire length, as the ACPI specification does not
mandate that it must be within the same page boundary. It is
permissible for it to be mapped across different regions.

Link: https://github.com/acpica/acpica/pull/954
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218849
Fixes: d410ee5109a1 ("ACPICA: avoid "Info: mapping multiple BARs. Your kernel is fine."")
Co-developed-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exregion.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/acpica/exregion.c b/drivers/acpi/acpica/exregion.c
index 8907b8bf42672..c49b9f8de723d 100644
--- a/drivers/acpi/acpica/exregion.c
+++ b/drivers/acpi/acpica/exregion.c
@@ -44,7 +44,6 @@ acpi_ex_system_memory_space_handler(u32 function,
 	struct acpi_mem_mapping *mm = mem_info->cur_mm;
 	u32 length;
 	acpi_size map_length;
-	acpi_size page_boundary_map_length;
 #ifdef ACPI_MISALIGNMENT_NOT_SUPPORTED
 	u32 remainder;
 #endif
@@ -138,26 +137,8 @@ acpi_ex_system_memory_space_handler(u32 function,
 		map_length = (acpi_size)
 		    ((mem_info->address + mem_info->length) - address);
 
-		/*
-		 * If mapping the entire remaining portion of the region will cross
-		 * a page boundary, just map up to the page boundary, do not cross.
-		 * On some systems, crossing a page boundary while mapping regions
-		 * can cause warnings if the pages have different attributes
-		 * due to resource management.
-		 *
-		 * This has the added benefit of constraining a single mapping to
-		 * one page, which is similar to the original code that used a 4k
-		 * maximum window.
-		 */
-		page_boundary_map_length = (acpi_size)
-		    (ACPI_ROUND_UP(address, ACPI_DEFAULT_PAGE_SIZE) - address);
-		if (page_boundary_map_length == 0) {
-			page_boundary_map_length = ACPI_DEFAULT_PAGE_SIZE;
-		}
-
-		if (map_length > page_boundary_map_length) {
-			map_length = page_boundary_map_length;
-		}
+		if (map_length > ACPI_DEFAULT_PAGE_SIZE)
+			map_length = ACPI_DEFAULT_PAGE_SIZE;
 
 		/* Create a new mapping starting at the address given */
 
-- 
2.43.0



