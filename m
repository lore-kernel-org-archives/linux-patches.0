Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02E7346E46;
	Fri, 21 Nov 2025 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732293; cv=none; b=uyTUXvvIZsLRiW/gdDGWZrC0GheYdMIoSrZ/gKLhkxgULkJU27SCj2GuIUKRGkbRX3/wOz9Jiy/SrYy8eCzYTk7G7gLcLnB6kCRKvbQfMdQK0uBOrcK2nTjbf9XqVLjgT1JrTefs0AjtaDHRmCW7de9n6BG/weLEoBiSRIHYHNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732293; c=relaxed/simple;
	bh=bKFon2rkYVDRUFUdK8reoffH0reJAF7oMuGa+BVzcac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgUoW4yDscP2aAF8MK5VAyvjt6rJ+XmtKM2m/YK9H0NRU1EfyyYm9JaV7tsZJ6p+HtMIsX1jh/ghbDVKvrCOqXmDnmfgizjlMj9oPr/S1DM4NyPhfwpfrD1VMjrCkp2/5Od3vsXAGZh0pO2IOTNT/vuopLroCH8fZmHuiHCN68U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCH/gAgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCH/gAgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A4BC4CEF1;
	Fri, 21 Nov 2025 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732292;
	bh=bKFon2rkYVDRUFUdK8reoffH0reJAF7oMuGa+BVzcac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCH/gAgGG+lGE6z2OcW78Jap2a6CDTISWngvI0sxn8mIjcUZAFlksEHwmM8i/78hH
	 jrkUhpXVKtCpHR4BuFc5NX4gE0jsKZPEYh0o5f/YXYFrexTuQyOf6HJhp5nwcpqdyB
	 KtLJ2kE+GEonSiCvSXc9HrlMLBmclxcmbIpPUurk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shang song (Lenovo)" <shangsong2@foxmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/529] ACPI: PRM: Skip handlers with NULL handler_address or NULL VA
Date: Fri, 21 Nov 2025 14:06:10 +0100
Message-ID: <20251121130233.552247173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Shang song (Lenovo) <shangsong2@foxmail.com>

[ Upstream commit 311942ce763e21dacef7e53996d5a1e19b8adab1 ]

If handler_address or mapped VA is NULL, the related buffer address and
VA can be ignored, so make acpi_parse_prmt() skip the current handler
in those cases.

Signed-off-by: Shang song (Lenovo) <shangsong2@foxmail.com>
Link: https://patch.msgid.link/20250826030229.834901-1-shangsong2@foxmail.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/prmt.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index eb8f2a1ce1388..6efaeda01d166 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -150,15 +150,28 @@ acpi_parse_prmt(union acpi_subtable_headers *header, const unsigned long end)
 		th = &tm->handlers[cur_handler];
 
 		guid_copy(&th->guid, (guid_t *)handler_info->handler_guid);
+
+		/*
+		 * Print an error message if handler_address is NULL, the parse of VA also
+		 * can be skipped.
+		 */
+		if (unlikely(!handler_info->handler_address)) {
+			pr_info("Skipping handler with NULL address for GUID: %pUL",
+					(guid_t *)handler_info->handler_guid);
+			continue;
+		}
+
 		th->handler_addr =
 			(void *)efi_pa_va_lookup(&th->guid, handler_info->handler_address);
 		/*
-		 * Print a warning message if handler_addr is zero which is not expected to
-		 * ever happen.
+		 * Print a warning message and skip the parse of VA if handler_addr is zero
+		 * which is not expected to ever happen.
 		 */
-		if (unlikely(!th->handler_addr))
+		if (unlikely(!th->handler_addr)) {
 			pr_warn("Failed to find VA of handler for GUID: %pUL, PA: 0x%llx",
 				&th->guid, handler_info->handler_address);
+			continue;
+		}
 
 		th->static_data_buffer_addr =
 			efi_pa_va_lookup(&th->guid, handler_info->static_data_buffer_address);
-- 
2.51.0



