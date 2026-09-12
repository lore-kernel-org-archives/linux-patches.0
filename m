Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB9736A36A;
	Sat, 12 Sep 2026 09:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206877; cv=none; b=KhicB/qPtddZb9kTnSk3fdJttjiaHcKl0sH9vPt59YSXYGYSkLeytEu0LLpHO59u8nJgNZTMJLPQFluofFDSy7klac0u+sbiee+iotAdiemisxFiDjJdHizRcud+CMUPmxGryYtW6Y+s2qZ/Hw/J+9oxSLQ8erFERY0Ke1nr6Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206877; c=relaxed/simple;
	bh=91zO/IrzBYVt1CYpwjeCfRBRryQ7jpWQwLWQvheqZac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWI1Gc0QcMl4FxASVISxilXbmsUqVVmv+UjdJZQYShS/w9yNV4GMhtYBf3K3ms6NEOfM8Krc6cFADRzaGbsFlp5SBZtDy6VoV566TphJRYgi1soE2Q0SA4Cw9D+sgvwnblSF9EqClHtamW5ZDN7nfvkNUG7gTh/us+xGhPWWRt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OixrAjcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OixrAjcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0D31F000FF;
	Sat, 12 Sep 2026 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206876;
	bh=fYckJ7jvFjgRXb49r+KL/7Akd7HdWhMqKc/JSlSF7x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OixrAjcfn+bku8MPqMli0reYWAWQkl8Nu9Sdr90KjBKdXSRsAKpEi96Q/bh0rXvS6
	 OQUY2FXA+GS0z0oEh89OJhu9yTt4ICGn5MbQyzKCNMaRqmUC4ryzzY2aPLbjYotu8g
	 k1J/fdyOvAFGJ897VZHvj3v/k+2p+w6pcrT+L8+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0297/1518] ACPI: RISC-V: Fix riscv_acpi_add_prt_dep() loop handling
Date: Sat, 12 Sep 2026 08:41:06 +0200
Message-ID: <20260912065630.198936840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 3a56321d0aceee2a0bd80d23366401c131ff8350 ]

The loop in riscv_acpi_add_prt_dep() includes error conditions that are
handled in a dubious - if not outright wrong - way, by continuining the
loop (which skips and misses the entry pointer update to point to the next
entry).

Rewrite the loop as a for loop (that handles the continuation correctly)
and wrap the condition and update statements using helper functions to make
it cleaner.

Fixes: 1b173cc4bfcd ("ACPI: RISC-V: Implement function to add implicit dependencies")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Tested-by: Sunil V L <sunilvl@oss.qualcomm.com>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
Link: https://patch.msgid.link/20260709-gic-v5-acpi-iwb-probe-deferral-v4-4-48dae790f871@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/riscv/irq.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/riscv/irq.c b/drivers/acpi/riscv/irq.c
index 46af9085dbce7..f41ab67040374 100644
--- a/drivers/acpi/riscv/irq.c
+++ b/drivers/acpi/riscv/irq.c
@@ -319,6 +319,20 @@ static int riscv_acpi_irq_get_dep(acpi_handle handle, unsigned int index, acpi_h
 	return ctx.rc;
 }
 
+static bool acpi_prt_entry_valid(void *prt_entry)
+{
+	struct acpi_pci_routing_table *entry = prt_entry;
+
+	return entry && entry->length > 0;
+}
+
+static void *acpi_prt_next_entry(void *prt_entry)
+{
+	struct acpi_pci_routing_table *entry = prt_entry;
+
+	return prt_entry + entry->length;
+}
+
 static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -337,7 +351,7 @@ static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
 	}
 
 	entry = buffer.pointer;
-	while (entry && (entry->length > 0)) {
+	for (; acpi_prt_entry_valid(entry); entry = acpi_prt_next_entry(entry)) {
 		if (entry->source[0]) {
 			status = acpi_get_handle(handle, entry->source, &link_handle);
 			if (ACPI_FAILURE(status))
@@ -363,9 +377,6 @@ static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
 			dep_devices.handles[0] = gsi_handle;
 			count += acpi_scan_add_dep(handle, &dep_devices);
 		}
-
-		entry = (struct acpi_pci_routing_table *)
-			((unsigned long)entry + entry->length);
 	}
 
 	kfree(buffer.pointer);
-- 
2.53.0



