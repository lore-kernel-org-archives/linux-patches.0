Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8D628E3
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01822C433D2;
	Thu, 12 Jan 2023 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533806;
	bh=CflFW6C0H8V0pmwSh+WVf5fe1NQuHWhUGwX19oH5Vf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4gbt+Jk9CM0oJIDQKTr+yvp7x1VERJDWghKc109wcmz6hcbMNqsSSoQyzDV7k2Um
	 NSFAuIpct3rU+QS5PShU83EBNnoa3JRy+oNR68V9yVmc373G5X34/SufuY3j0QK5IE
	 9W5pFNGIlRYyVi3x5pGgHcAYx2yJAeEu0v+OOJLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 596/783] tpm: acpi: Call acpi_put_table() to fix memory leak
Date: Thu, 12 Jan 2023 14:55:12 +0100
Message-Id: <20230112135551.915872201@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hanjun Guo <guohanjun@huawei.com>

commit 8740a12ca2e2959531ad253bac99ada338b33d80 upstream.

The start and length of the event log area are obtained from
TPM2 or TCPA table, so we call acpi_get_table() to get the
ACPI information, but the acpi_get_table() should be coupled with
acpi_put_table() to release the ACPI memory, add the acpi_put_table()
properly to fix the memory leak.

While we are at it, remove the redundant empty line at the
end of the tpm_read_log_acpi().

Fixes: 0bfb23746052 ("tpm: Move eventlog files to a subdirectory")
Fixes: 85467f63a05c ("tpm: Add support for event log pointer found in TPM2 ACPI table")
Cc: stable@vger.kernel.org
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/acpi.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -90,16 +90,21 @@ int tpm_read_log_acpi(struct tpm_chip *c
 			return -ENODEV;
 
 		if (tbl->header.length <
-				sizeof(*tbl) + sizeof(struct acpi_tpm2_phy))
+				sizeof(*tbl) + sizeof(struct acpi_tpm2_phy)) {
+			acpi_put_table((struct acpi_table_header *)tbl);
 			return -ENODEV;
+		}
 
 		tpm2_phy = (void *)tbl + sizeof(*tbl);
 		len = tpm2_phy->log_area_minimum_length;
 
 		start = tpm2_phy->log_area_start_address;
-		if (!start || !len)
+		if (!start || !len) {
+			acpi_put_table((struct acpi_table_header *)tbl);
 			return -ENODEV;
+		}
 
+		acpi_put_table((struct acpi_table_header *)tbl);
 		format = EFI_TCG2_EVENT_LOG_FORMAT_TCG_2;
 	} else {
 		/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
@@ -120,8 +125,10 @@ int tpm_read_log_acpi(struct tpm_chip *c
 			break;
 		}
 
+		acpi_put_table((struct acpi_table_header *)buff);
 		format = EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
 	}
+
 	if (!len) {
 		dev_warn(&chip->dev, "%s: TCPA log area empty\n", __func__);
 		return -EIO;
@@ -156,5 +163,4 @@ err:
 	kfree(log->bios_event_log);
 	log->bios_event_log = NULL;
 	return ret;
-
 }


