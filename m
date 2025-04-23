Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED3A283680;
	Wed, 23 Apr 2025 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420558; cv=none; b=QdC23Pl3j9gaojQMYldqMjdUYPwMrTzik7n5QGmvIdblZYuvAU7rnubveYSRd/26EFYeb3UFdruorDPFlne3OA63vFpgMq011r6DGh7vCGvc4EN5/e6DstNGkeGaqT3ic1TrMigWK/EA4TNz/Y4R/gjGmDPao91pRGP5x2YK9o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420558; c=relaxed/simple;
	bh=vsKuVqoFtPV3UkUFXo5KcFkAk/77hD9rOqj/nPXI5Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlDi5rzOYy54I3jqCfc9WbxvpE3RkU3mD+GA1jfnUHEFU3jS8CNkch0Ek5wYMfPBgyi/btMk1NxUKhuIPE8cAsuUAz+mn93bNwgOi6CrQ6TXsI66Kvp1+SHjZIaG9gqwsUMDfU8S8P+Z/rQ1qzmUZEiof8TJSWAxTKqDx9nIVis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajLXaEY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajLXaEY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6CDC4CEE2;
	Wed, 23 Apr 2025 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420558;
	bh=vsKuVqoFtPV3UkUFXo5KcFkAk/77hD9rOqj/nPXI5Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajLXaEY9rTiCytxAKXBN5GfonPhTsEd0DiwOcOjUJ3I546X4SsEt0CzsRyxrem304
	 EADBdn5K85XgEyM3NRfpmQWg7lLkro6/+/Bxpj5mc3jq0lmmVqgSml//CtiZ7FD4u5
	 b7iMigSGlmFMxVuNIQTkqkyTyG4XGROyPY6vXbDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 141/223] RAS/AMD/ATL: Include row[13] bit in row retirement
Date: Wed, 23 Apr 2025 16:43:33 +0200
Message-ID: <20250423142622.931974816@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 6c44e5354d4d16d9d891a419ca3f57abfe18ce7a upstream.

Based on feedback from hardware folks, row[13] is part of the variable
bits within a physical row (along with all column bits).

Only half the physical addresses affected by a row are calculated if
this bit is not included.

Add the row[13] bit to the row retirement flow.

Fixes: 3b566b30b414 ("RAS/AMD/ATL: Add MI300 row retirement support")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250401-fix-fmpm-extra-records-v1-1-840bcf7a8ac5@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ras/amd/atl/umc.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/ras/amd/atl/umc.c
+++ b/drivers/ras/amd/atl/umc.c
@@ -320,7 +320,7 @@ static unsigned long convert_dram_to_nor
  * See amd_atl::convert_dram_to_norm_addr_mi300() for MI300 address formats.
  */
 #define MI300_NUM_COL		BIT(HWEIGHT(MI300_UMC_MCA_COL))
-static void retire_row_mi300(struct atl_err *a_err)
+static void _retire_row_mi300(struct atl_err *a_err)
 {
 	unsigned long addr;
 	struct page *p;
@@ -351,6 +351,23 @@ static void retire_row_mi300(struct atl_
 	}
 }
 
+/*
+ * In addition to the column bits, the row[13] bit should also be included when
+ * calculating addresses affected by a physical row.
+ *
+ * Instead of running through another loop over a single bit, just run through
+ * the column bits twice and flip the row[13] bit in-between.
+ *
+ * See MI300_UMC_MCA_ROW for the row bits in MCA_ADDR_UMC value.
+ */
+#define MI300_UMC_MCA_ROW13	BIT(23)
+static void retire_row_mi300(struct atl_err *a_err)
+{
+	_retire_row_mi300(a_err);
+	a_err->addr ^= MI300_UMC_MCA_ROW13;
+	_retire_row_mi300(a_err);
+}
+
 void amd_retire_dram_row(struct atl_err *a_err)
 {
 	if (df_cfg.rev == DF4p5 && df_cfg.flags.heterogeneous)


