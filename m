Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF16482E4;
	Mon,  1 Apr 2024 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991037; cv=none; b=cUvmOR02heH5lRN1OVZLl4OLUhnszNxVkLc5UYSYt+nt4Kmtf5/Xg9PtwAyshsTRIaHhRDuDbqjweZLay3paeF0mtCPPsbmQArgMkh5nLPf5l3DYY459rOt97WGAO+g3mcdTzpLBvAgRP1231+FHeU0fxMO05cGW8O1S5Dc2I9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991037; c=relaxed/simple;
	bh=fJ7JgUoLnHBb/rri0IeL5dvX91GqL5w5gABE13Wol64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4BMowkYbihpDzy469Ln7tm3wnBbkc4bavreFAIbDVAe2OF1ne4PcagSQP3DBeZFTqdrm2qIBa15M3ZuTAjFxxxqoTP+at7cQduGJkQTmS6pu3/AyIhZOO4xcqKz761dVJ1natXpD8TXI9sINidvnFzk4OdyFfBjUi+iTgwpT1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f76e7OCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f76e7OCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBD2C43394;
	Mon,  1 Apr 2024 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991036;
	bh=fJ7JgUoLnHBb/rri0IeL5dvX91GqL5w5gABE13Wol64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f76e7OCZGdv+pAOeduR1dSgGUFSoPI3cUPEAIJR20ZCfXbNYSjlmJclLIez298n/8
	 KvvOX/IdGwxkhnsYs2LfKscUt7Aq+B5wglsBY1epLbm6VzktUSU9qYtQC4xOOY63r3
	 An6TKoQ2Zy9IqZRNLpsdOyjTnTLJsfa7ZeCO95J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Rybakov <danilrybakov249@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 143/272] platform/x86: p2sb: On Goldmont only cache P2SB and SPI devfn BAR
Date: Mon,  1 Apr 2024 17:45:33 +0200
Message-ID: <20240401152535.150457171@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit aec7d25b497ce4a8d044e9496de0aa433f7f8f06 upstream.

On Goldmont p2sb_bar() only ever gets called for 2 devices, the actual P2SB
devfn 13,0 and the SPI controller which is part of the P2SB, devfn 13,2.

But the current p2sb code tries to cache BAR0 info for all of
devfn 13,0 to 13,7 . This involves calling pci_scan_single_device()
for device 13 functions 0-7 and the hw does not seem to like
pci_scan_single_device() getting called for some of the other hidden
devices. E.g. on an ASUS VivoBook D540NV-GQ065T this leads to continuous
ACPI errors leading to high CPU usage.

Fix this by only caching BAR0 info and thus only calling
pci_scan_single_device() for the P2SB and the SPI controller.

Fixes: 5913320eb0b3 ("platform/x86: p2sb: Allow p2sb_bar() calls during PCI device probe")
Reported-by: Danil Rybakov <danilrybakov249@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218531
Tested-by: Danil Rybakov <danilrybakov249@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240304134356.305375-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/p2sb.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -20,9 +20,11 @@
 #define P2SBC_HIDE		BIT(8)
 
 #define P2SB_DEVFN_DEFAULT	PCI_DEVFN(31, 1)
+#define P2SB_DEVFN_GOLDMONT	PCI_DEVFN(13, 0)
+#define SPI_DEVFN_GOLDMONT	PCI_DEVFN(13, 2)
 
 static const struct x86_cpu_id p2sb_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	PCI_DEVFN(13, 0)),
+	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, P2SB_DEVFN_GOLDMONT),
 	{}
 };
 
@@ -98,21 +100,12 @@ static void p2sb_scan_and_cache_devfn(st
 
 static int p2sb_scan_and_cache(struct pci_bus *bus, unsigned int devfn)
 {
-	unsigned int slot, fn;
+	/* Scan the P2SB device and cache its BAR0 */
+	p2sb_scan_and_cache_devfn(bus, devfn);
 
-	if (PCI_FUNC(devfn) == 0) {
-		/*
-		 * When function number of the P2SB device is zero, scan it and
-		 * other function numbers, and if devices are available, cache
-		 * their BAR0s.
-		 */
-		slot = PCI_SLOT(devfn);
-		for (fn = 0; fn < NR_P2SB_RES_CACHE; fn++)
-			p2sb_scan_and_cache_devfn(bus, PCI_DEVFN(slot, fn));
-	} else {
-		/* Scan the P2SB device and cache its BAR0 */
-		p2sb_scan_and_cache_devfn(bus, devfn);
-	}
+	/* On Goldmont p2sb_bar() also gets called for the SPI controller */
+	if (devfn == P2SB_DEVFN_GOLDMONT)
+		p2sb_scan_and_cache_devfn(bus, SPI_DEVFN_GOLDMONT);
 
 	if (!p2sb_valid_resource(&p2sb_resources[PCI_FUNC(devfn)].res))
 		return -ENOENT;


