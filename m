Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C8719B3D6;
	Wed,  3 Jul 2024 10:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004083; cv=none; b=IFhDYrxTeA28/X40NhSU5oaFRDJN3sqix/PH4RlvuFOh2YhCvvixgV51yQKJG4GP1+WfOxhfUwxdLhVP3JIIohy+mYLoDYWdaK5uyIKn2l08XiI3eAl5rAB0ZuLEax51jlDI7fIUf6105FOPWgnJ2jl1Ii0r00jjch/Mkcm/88w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004083; c=relaxed/simple;
	bh=6zqpn6I1wnq7JvO5nTqje77vW/d8TV0Wr2t4nn1BH98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDJ4Ms8a92YHvO7lCJlxdJh74ap4xKMtHXRShC6iUrOJ0eHyhoCTuEGQN7bMqcqPdWt1LkxvWiODuwoxsoNphxum3eTICtS/1sHGzwjuGi/d3O1ACeKtnKjFeEtnk2DwY9zn/bBkkMafwoKEC5em9h8hYWo67DVPMl1LEdh/eTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7z4NJN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7z4NJN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAF3C4AF0E;
	Wed,  3 Jul 2024 10:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004083;
	bh=6zqpn6I1wnq7JvO5nTqje77vW/d8TV0Wr2t4nn1BH98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7z4NJN04IqSQHQI2nLMedWpqnNrarPIqkD2lh2isYZ884IvNjsER0Xy9f8gBwlAr
	 YxgF9wVMWXbNqpY2He5t6Aht9WgLJxUGosUvYP8w4T5m2rU/Xn+7bL1KBa0ze8Sjvs
	 IR/BjUzxs9G/t7WRdnADkG289iKPI2qdf3QJIutg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanath S <Sanath.S@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/189] ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."
Date: Wed,  3 Jul 2024 12:39:37 +0200
Message-ID: <20240703102845.876677803@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c08521194b297..817e4c9445729 100644
--- a/drivers/acpi/acpica/exregion.c
+++ b/drivers/acpi/acpica/exregion.c
@@ -43,7 +43,6 @@ acpi_ex_system_memory_space_handler(u32 function,
 	struct acpi_mem_space_context *mem_info = region_context;
 	u32 length;
 	acpi_size map_length;
-	acpi_size page_boundary_map_length;
 #ifdef ACPI_MISALIGNMENT_NOT_SUPPORTED
 	u32 remainder;
 #endif
@@ -120,26 +119,8 @@ acpi_ex_system_memory_space_handler(u32 function,
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



