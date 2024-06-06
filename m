Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F9919EEC6;
	Thu,  6 Jun 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683556; cv=none; b=BLz7GWqb5so59bz5Z+5k3YpyYste/Ch3EVtqy9gJLrrrJLTUBesVwW9QSXxZ3a67SGsbWmqkNx88eXKZzOYphRkjEX5jyOb604IygZVGtzOdpBeN52YvTfc0LxuSb1hUD1A463LOrEWO8vdZaNSj1gDKMA1NLV46SRlF5TQO0Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683556; c=relaxed/simple;
	bh=TNtNhQtNQJjP/dJwf6BHV0Wy3uY7Km/UFXa4aUB2haQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcP82C8O1aU/X4xG4sW6c5Wh5NUIVuf2z+s9z7pfCImfzvUWXLizKxXYVl/0jVWpnwZYNBWBw3j89zMF2NJHVvtRaRXzgah289Zm8ngHZ54ARlNw4rp8lQlGY1kHOTUxQzK9R1HW4q8iD6PVEu7PSCKENnc4j1eAtqbAKWNkeV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5tYco0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5tYco0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057CAC2BD10;
	Thu,  6 Jun 2024 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683556;
	bh=TNtNhQtNQJjP/dJwf6BHV0Wy3uY7Km/UFXa4aUB2haQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5tYco0Z1tt8mth5UnFt52W5JmjSlOXvpJdaZf90yo0Fwj+NEn9I1qy+vU6yjft6o
	 JESx302/An/adYrgSncWRlovgYSGlqxMSQDTZBp2yhnQmjhrYu/qNKQqqzg3mEUBFr
	 GAFymPWG4LpphuzWrrjHQBOl4AyU5y/hwzmJAKgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Satish Thatchanamurthy <Satish.Thatchanamurt@Dell.com>
Subject: [PATCH 6.6 498/744] PCI/EDR: Align EDR_PORT_DPC_ENABLE_DSM with PCI Firmware r3.3
Date: Thu,  6 Jun 2024 16:02:50 +0200
Message-ID: <20240606131748.414355337@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit f24ba846133d0edec785ac6430d4daf6e9c93a09 ]

The "Downstream Port Containment related Enhancements" ECN of Jan 28, 2019
(document 12888 below), defined the EDR_PORT_DPC_ENABLE_DSM function with
Revision ID 5 with Arg3 being an integer.  But when the ECN was integrated
into PCI Firmware r3.3, sec 4.6.12, it was defined as Revision ID 6 with
Arg3 being a package containing an integer.

The implementation in acpi_enable_dpc() supplies a package as Arg3 (arg4 in
the code), but it previously specified Revision ID 5.  Align this with PCI
Firmware r3.3 by using Revision ID 6.

If firmware implemented per the ECN, its Revision 5 function would receive
a package as Arg3 when it expects an integer, so acpi_enable_dpc() would
likely fail.  If such firmware exists and lacks a Revision 6 function that
expects a package, we may have to add support for Revision 5.

Link: https://lore.kernel.org/r/20240501022543.1626025-1-sathyanarayanan.kuppuswamy@linux.intel.com
Link: https://members.pcisig.com/wg/PCI-SIG/document/12888
Fixes: ac1c8e35a326 ("PCI/DPC: Add Error Disconnect Recover (EDR) support")
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
[bhelgaas: split into two patches, update commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Satish Thatchanamurthy <Satish.Thatchanamurt@Dell.com> # one platform
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/edr.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pcie/edr.c b/drivers/pci/pcie/edr.c
index 5f4914d313a17..fa085677c91de 100644
--- a/drivers/pci/pcie/edr.c
+++ b/drivers/pci/pcie/edr.c
@@ -32,10 +32,10 @@ static int acpi_enable_dpc(struct pci_dev *pdev)
 	int status = 0;
 
 	/*
-	 * Behavior when calling unsupported _DSM functions is undefined,
-	 * so check whether EDR_PORT_DPC_ENABLE_DSM is supported.
+	 * Per PCI Firmware r3.3, sec 4.6.12, EDR_PORT_DPC_ENABLE_DSM is
+	 * optional. Return success if it's not implemented.
 	 */
-	if (!acpi_check_dsm(adev->handle, &pci_acpi_dsm_guid, 5,
+	if (!acpi_check_dsm(adev->handle, &pci_acpi_dsm_guid, 6,
 			    1ULL << EDR_PORT_DPC_ENABLE_DSM))
 		return 0;
 
@@ -46,12 +46,7 @@ static int acpi_enable_dpc(struct pci_dev *pdev)
 	argv4.package.count = 1;
 	argv4.package.elements = &req;
 
-	/*
-	 * Per Downstream Port Containment Related Enhancements ECN to PCI
-	 * Firmware Specification r3.2, sec 4.6.12, EDR_PORT_DPC_ENABLE_DSM is
-	 * optional.  Return success if it's not implemented.
-	 */
-	obj = acpi_evaluate_dsm(adev->handle, &pci_acpi_dsm_guid, 5,
+	obj = acpi_evaluate_dsm(adev->handle, &pci_acpi_dsm_guid, 6,
 				EDR_PORT_DPC_ENABLE_DSM, &argv4);
 	if (!obj)
 		return 0;
-- 
2.43.0



