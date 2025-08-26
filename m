Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC46E350851;
	Tue, 26 Aug 2025 13:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216175; cv=none; b=gcPHab21OUGa3yS2R8CO/6a3vtAmd0smTwI6GZFRpSskVZ1xfON1zOXRxnBatyMafWipJrqP57tiYu71pH76pTGFJcn4wHklTQ/ZZ9oh7PbWULmSJhg/AZEbNwXFEaFCCfc6DvmH28kfkzRTNWAgtWkAeCmhVAJzV2atWykbvrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216175; c=relaxed/simple;
	bh=mPh2YN8129UButDFr7HQe0Puho2ZDnarJPIQnCXfy+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVWankC/jSjSSt166oSNrsHzYEiryo5dEOqB1Glf+/2NhxvGTHpIO8NB87V4uYU4hwV5BKVmat2Ca7I7ZXQn/pQdH1lc58+nJc+beEEq/73kgF4NrSRbZiWXnamA0WWnXc1krKSLD7gMJKSqprZTCNCCY385GQRUExYZb/dRt1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvhD+xcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvhD+xcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2F4C4CEF1;
	Tue, 26 Aug 2025 13:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216173;
	bh=mPh2YN8129UButDFr7HQe0Puho2ZDnarJPIQnCXfy+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvhD+xcK7mAIFVdr0Kknr/OSu9SiBRuEqcsji+5QWoGhUkukQyyEHI3SZ8V+QSfiD
	 YPS/NFffPkWmD6i8nRaP5FTyuwNPjwZiLKL5TBCUQR2IiVCwpEgPN+yllat8Bjq7cH
	 R9ql5jWr4Bp3wWg1krqeU265cjTqwN9OTmAsSN4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Qiyu <qiyuzhu2@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/644] ACPI: PRM: Reduce unnecessary printing to avoid user confusion
Date: Tue, 26 Aug 2025 13:06:44 +0200
Message-ID: <20250826110954.141536303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Qiyu <qiyuzhu2@amd.com>

[ Upstream commit 3db5648c4d608b5483470efc1da9780b081242dd ]

Commit 088984c8d54c ("ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM
handler and context") introduced non-essential printing "Failed to find
VA for GUID: xxxx, PA: 0x0" which may confuse users to think that
something wrong is going on while it is not the case.

According to the PRM Spec Section 4.1.2 [1], both static data buffer
address and ACPI parameter buffer address may be NULL if they are not
needed, so there is no need to print out the "Failed to find VA ... "
in those cases.

Link: https://uefi.org/sites/default/files/resources/Platform%20Runtime%20Mechanism%20-%20with%20legal%20notice.pdf # [1]
Signed-off-by: Zhu Qiyu <qiyuzhu2@amd.com>
Link: https://patch.msgid.link/20250704014104.82524-1-qiyuzhu2@amd.com
[ rjw: Edits in new comments, subject and changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/prmt.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index 890c74c52beb..6290ed84c595 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -85,8 +85,6 @@ static u64 efi_pa_va_lookup(efi_guid_t *guid, u64 pa)
 		}
 	}
 
-	pr_warn("Failed to find VA for GUID: %pUL, PA: 0x%llx", guid, pa);
-
 	return 0;
 }
 
@@ -142,13 +140,37 @@ acpi_parse_prmt(union acpi_subtable_headers *header, const unsigned long end)
 		guid_copy(&th->guid, (guid_t *)handler_info->handler_guid);
 		th->handler_addr =
 			(void *)efi_pa_va_lookup(&th->guid, handler_info->handler_address);
+		/*
+		 * Print a warning message if handler_addr is zero which is not expected to
+		 * ever happen.
+		 */
+		if (unlikely(!th->handler_addr))
+			pr_warn("Failed to find VA of handler for GUID: %pUL, PA: 0x%llx",
+				&th->guid, handler_info->handler_address);
 
 		th->static_data_buffer_addr =
 			efi_pa_va_lookup(&th->guid, handler_info->static_data_buffer_address);
+		/*
+		 * According to the PRM specification, static_data_buffer_address can be zero,
+		 * so avoid printing a warning message in that case.  Otherwise, if the
+		 * return value of efi_pa_va_lookup() is zero, print the message.
+		 */
+		if (unlikely(!th->static_data_buffer_addr && handler_info->static_data_buffer_address))
+			pr_warn("Failed to find VA of static data buffer for GUID: %pUL, PA: 0x%llx",
+				&th->guid, handler_info->static_data_buffer_address);
 
 		th->acpi_param_buffer_addr =
 			efi_pa_va_lookup(&th->guid, handler_info->acpi_param_buffer_address);
 
+		/*
+		 * According to the PRM specification, acpi_param_buffer_address can be zero,
+		 * so avoid printing a warning message in that case.  Otherwise, if the
+		 * return value of efi_pa_va_lookup() is zero, print the message.
+		 */
+		if (unlikely(!th->acpi_param_buffer_addr && handler_info->acpi_param_buffer_address))
+			pr_warn("Failed to find VA of acpi param buffer for GUID: %pUL, PA: 0x%llx",
+				&th->guid, handler_info->acpi_param_buffer_address);
+
 	} while (++cur_handler < tm->handler_count && (handler_info = get_next_handler(handler_info)));
 
 	return 0;
-- 
2.39.5



