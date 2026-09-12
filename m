Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F7E386C21;
	Sat, 12 Sep 2026 12:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215362; cv=none; b=au4C57KPSvaxdHyHQZG5DeYdjDgES5LCjHijOCTiqOK4e14nVFPfZkjnCrvBTGhWiokiAO3HoYNCRcXv2EAXfWeospsm1ZQKsHrU32rHRU2cCdBBB5WENYiJ2JGr5xwbZv+gx97ioDwFe1hqbm8rkDA9udiOs4G9BMceFV2ZnJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215362; c=relaxed/simple;
	bh=ESe3YFmYgtRzCqLA+pgOw9HpNNQ3D+1Z90oEGHmG/2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u32Jx0QWqwCczonpiomZScSzsLKS7oBLDvcmzQ3NsNxkq6A7F3SwmoNk/8mkeiSsax9lLvdjSSLwVi7WKE64i9xYsWKzIvLOBUjdNno5zdAWaVv96UkHAwTwPYKn6jGIC8suO1IS5y0aClp2aI82ADigjWT0MOnhfcFJv383IyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+DUrUfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+DUrUfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E156F1F000FF;
	Sat, 12 Sep 2026 12:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215360;
	bh=KlwmQhFfVyz2KFLvk/T9A1JbhcHtJUxSUT/vJVAYpMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+DUrUfPWO1evFai2WTtbC5xmTxuaZ2joMaq1TBu/zfg64uoHfnH5Nxnl94Rc55Or
	 B2KoqxVGrUuogxPwbyezUkHoI9KXx8xQ3+FQAg/joyJAcLBTZQE7+pHKZxryMWu+kY
	 yGXqz391nlcRfMkIaBaNlc3MHDwHi9yiEWAdt3/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0473/1376] ACPI: RISC-V: Fix riscv_acpi_add_prt_dep() loop handling
Date: Sat, 12 Sep 2026 08:48:19 +0200
Message-ID: <20260912065618.075589152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e97417ab94ce9..9c8185ca9f8c5 100644
--- a/drivers/acpi/riscv/irq.c
+++ b/drivers/acpi/riscv/irq.c
@@ -250,6 +250,20 @@ static int riscv_acpi_irq_get_dep(acpi_handle handle, unsigned int index, acpi_h
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
@@ -268,7 +282,7 @@ static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
 	}
 
 	entry = buffer.pointer;
-	while (entry && (entry->length > 0)) {
+	for (; acpi_prt_entry_valid(entry); entry = acpi_prt_next_entry(entry)) {
 		if (entry->source[0]) {
 			status = acpi_get_handle(handle, entry->source, &link_handle);
 			if (ACPI_FAILURE(status))
@@ -294,9 +308,6 @@ static u32 riscv_acpi_add_prt_dep(acpi_handle handle)
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



