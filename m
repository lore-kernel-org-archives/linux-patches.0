Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590167;
	b=XJK1GD4ynR4FL9ETtiNHI9mALpVvBzYq40+68/yV6ZL/1P6gImcYNoC8UpAGxzEXkzZx
	 /I/dmIudKnZTaNiuaNLIOscuNmKn9oRrSuwRaoQK4eBRmOPLMsVMSOdRbtzvszisVDgUB
	 pGk2vj7T7g5Ji7Xn+rNvxsN3QCJ+6HjE+2UX5sZTiMKS6Nd2JjOEncEOB6xDp4QAnp7Fh
	 TmDWWfkPUWE0O14qagTtED4l0TOyxEmCaW+gVj82tz10JoSmVLv/4Fpw8BJo56TMgCgPk
	 z4PnBf6WWmMTYMoEA3cfvK6jJEbjVkXKKgE8k89pEubCPlUCZpYMBYVjkKEQOA8ofkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHYgjqYfvfiv3Qla87hGd/DmaCT8IKZdarq1R11GJrc=;
	b=4ZHQm6ma4dnp5uBetJ2KMIaBAt41/m4nf1eZ7BWm3HU2A1ybQIX5SjTk0E+dt4cHPEIj
	 3MPz4jx6jfgB7DDcWyrKEfMCya+N0WoqNn2wyIzYjq0pvYtvMJVzJjrhCZNAtfoSa3uPh
	 7NI4UI16wFDCmMG6LtdTVhgBOpTpYiFye6eWybV/ILLPQ+27s0AUbZhjSxCmfVQ0gdJsL
	 9ZgWIFsEUg80b9VA2VzI1ZrzcOD9y9i+RJAO59EhIST1cMe+wrug0gIJItFZuQlY9pvSi
	 C8UWQ0zpA5oOg0cWsz9U4wzdgb4nu8GoW9UlEysIYGw+nrsVGa81+UGLzP989NByrSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WMXTDTZU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF9F606D4AE;
	Fri, 13 Nov 2026 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WMXTDTZU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CFF1F000C4;
	Fri, 13 Nov 2026 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590167;
	bh=BHYgjqYfvfiv3Qla87hGd/DmaCT8IKZdarq1R11GJrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMXTDTZUfsXOUDz5/WJXKeF9YlzuVuuGt3si3PRKvooT/ExFkzkpEr63SALjdFaz9
	 tk4pxi86kcMwGgojxGR/LNwscVC7IqCGIm2tgT0CH9MKsHLFhomIda2Bb+GDx5Mqdd
	 B4GPpu1nMnVZz8NZ4yjOZNQHpT4Vz8wvo623DO3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Noam D. Eliyahu" <noam.d.eliyahu@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/686] tg3: Invert restart quirk logic to restrict SNP power-down bypass
Date: Fri, 13 Nov 2026 10:45:10 -0500
Message-ID: <20261113153827.002302150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Noam D. Eliyahu <noam.d.eliyahu@gmail.com>

[ Upstream commit d7314b51341c037973ce022f12c6009fd07b021e ]

Commit 9fc3bc764334 ("tg3: power down device only on SYSTEM_POWER_OFF")
bypassed `tg3_power_down()` on system restarts to prevent reboot hangs and
NMIs on servers where NICs were initialized via SNP (such as Dell PowerEdge
R650 and R750).

However, skipping the power-down flow globally causes the ACPI _PTS method
to trigger fatal PCIe AER events and hangs on other models. Commit
e0efe83ed325 ("tg3: Disable tg3 PCIe AER on system reboot") attempted to
mitigate this by adding an AER-disable DMI quirk table. Maintaining a
growing list of models for a secondary symptom misses the root cause,
leaving systems like the PowerEdge T440 (sharing the BCM5720 NIC) exposed.

Fix this by inverting the quirk logic:
1. Restrict SNP power-down avoidance strictly to
   `tg3_restart_snp_quirk_table` for the specific systems requiring it
   (Dell PowerEdge R650 and R750).
2. Restore standard power-down behavior for all other systems, eliminating
   the separate AER-disable quirk table.

For systems affected by the original SNP restart issue, their shutdown flow
remains completely untouched.

Link: https://lore.kernel.org/netdev/20251221175050.14089-1-noam.d.eliyahu@gmail.com/T/#u
Fixes: 9fc3bc764334 ("tg3: power down device only on SYSTEM_POWER_OFF")
Fixes: e0efe83ed325 ("tg3: Disable tg3 PCIe AER on system reboot")
Cc: stable@vger.kernel.org
Signed-off-by: Noam D. Eliyahu <noam.d.eliyahu@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20261026220955.473247-1-noam.d.eliyahu@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 42 ++++++++---------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 50eb40de7b220..897bb86bedb13 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18201,41 +18201,17 @@ static int tg3_resume(struct device *device)
 
 static SIMPLE_DEV_PM_OPS(tg3_pm_ops, tg3_suspend, tg3_resume);
 
-/* Systems where ACPI _PTS (Prepare To Sleep) S5 will result in a fatal
- * PCIe AER event on the tg3 device if the tg3 device is not, or cannot
- * be, powered down.
+/* Systems where powering down a tg3 device on restarts triggers
+ * NMIs and fatal hangs during reboot if the network adapters were
+ * initialized under SNP.
  */
-static const struct dmi_system_id tg3_restart_aer_quirk_table[] = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R440"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R540"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R640"),
-		},
-	},
+static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R650"),
 		},
 	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R740"),
-		},
-	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
@@ -18259,14 +18235,18 @@ static void tg3_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		dev_close(dev);
 
-	if (system_state == SYSTEM_POWER_OFF)
+	if (!dmi_first_match(tg3_restart_snp_quirk_table) ||
+	    system_state == SYSTEM_POWER_OFF) {
 		tg3_power_down(tp);
-	else if (system_state == SYSTEM_RESTART &&
-		 dmi_first_match(tg3_restart_aer_quirk_table) &&
+	} else if (system_state == SYSTEM_RESTART &&
 		 pdev->current_state != PCI_D3cold &&
 		 pdev->current_state != PCI_UNKNOWN) {
 		/* Disable PCIe AER on the tg3 to avoid a fatal
 		 * error during this system restart.
+		 * Needed since on restarts for systems in
+		 * tg3_restart_snp_quirk_table skipping on powering down the
+		 * tg3 device causes a fatal AER error during ACPI _PTS
+		 * (Prepare To Sleep).
 		 */
 		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL,
 					   PCI_EXP_DEVCTL_CERE |
-- 
2.53.0



