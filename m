Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99938431A56;
	Wed, 30 Sep 2026 19:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797024; cv=none; b=kuR1iBdAYvbmHPs7GlAYFmCgt7nMygX1lFkrWMtrTPv9etLFU3ZEKRGJZMjpTvpSopZ53Rgb2g9RGQ6ODJJ6JnXYJZvAJvJEcIYGffScf5g+cuvLaOJEUSoJvxQnwYU5FU0NPALluiasXteYu/kq2NGiYo+IrMzjor/c7ftT4lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797024; c=relaxed/simple;
	bh=Jndn6xYGg0KWBXDKPSKCgJyp/JGXPEr5RhDXYSr57Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDacWUQB3j0WnalTlAy52l9ikIBu6yF3EHLDWGSVu5x2bBNmTrloFGCouRsVB7pxKNGsPx4pHEGMqdm0ZZzTrqwqRPlhvIStnyVHC4vYQDTNxUo2NDhqgY2ne6VrOX5htIHWhNAwhYvlRqq1FimfB4mMDRDnhO830WMlxNMr9JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tClLLqM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tClLLqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8001F000FF;
	Wed, 30 Sep 2026 19:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797023;
	bh=MRoApst9b28+xvwG1LmQMbNEpyIcHx51Ed7LD+Z/Vp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tClLLqMOdLs3mLo9HozhiJibSHxktAuyIC9zV4M8JU3mV9ATOptu1Pc4AZMxXEwz
	 FdRWqTc0L9joCyDq1AkrXiToJo3hV2LTHDUEtgkjPiniVbubyd8hOJ1MFuxJmlOZXK
	 Ot0xXcwzYT2nTqvS+IOSf41QsqUmw+QAM2UHbtqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angel J <iamanaws@httpd.dev>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 1120/1193] PCI: of_property: Omit bus properties without a subordinate bus
Date: Wed, 30 Sep 2026 17:30:04 +0200
Message-ID: <20260930152459.116388900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Angel J <iamanaws@httpd.dev>

commit 8805840aad73df7146778be243a196d48b4f6430 upstream.

A bridge (a device with a Type 1 header) may not have a secondary bus
allocated (pdev->subordinate), e.g., if there are no available bus numbers
or the bridge secondary/subordinate bus numbers are not writable.

The dynamic OF helpers of_pci_prop_bus_range() and of_pci_prop_intr_map()
dereference pdev->subordinate without checking it.  When
CONFIG_PCI_DYNAMIC_OF_NODES is enabled, this can cause a NULL pointer
dereference and early boot hang.

Generate 'bus-range' and 'interrupt-map' properties only when a subordinate
bus exists.  Keep the node and its remaining properties for bridges without
one.

The problem was latent since 407d1a51921e ("PCI: Create device tree node
for bridge"), but wasn't reachable until 1f340724419e ("PCI: of: Create
device tree PCI host bridge node"), which appeared in v6.15.  Before
1f340724419e, of_pci_make_dev_node() returned early because the parent OF
node was missing.

Fixes: 407d1a51921e ("PCI: Create device tree node for bridge")
Signed-off-by: Angel J <iamanaws@httpd.dev>
[bhelgaas: move pdev->subordinate test to callees, commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v6.6+
Link: https://patch.msgid.link/20260918195540.GA1187209@bhelgaas
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/of_property.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/pci/of_property.c
+++ b/drivers/pci/of_property.c
@@ -91,9 +91,13 @@ static int of_pci_prop_bus_range(struct
 				 struct of_changeset *ocs,
 				 struct device_node *np)
 {
-	u32 bus_range[] = { pdev->subordinate->busn_res.start,
-			    pdev->subordinate->busn_res.end };
+	u32 bus_range[2];
 
+	if (!pdev->subordinate)
+		return 0;
+
+	bus_range[0] = pdev->subordinate->busn_res.start;
+	bus_range[1] = pdev->subordinate->busn_res.end;
 	return of_changeset_add_prop_u32_array(ocs, np, "bus-range", bus_range,
 					       ARRAY_SIZE(bus_range));
 }
@@ -196,6 +200,9 @@ static int of_pci_prop_intr_map(struct p
 	int ret;
 	u8 pin;
 
+	if (!pdev->subordinate)
+		return 0;
+
 	pnode = pci_device_to_OF_node(pdev->bus->self);
 	if (!pnode)
 		pnode = pci_bus_to_OF_node(pdev->bus);


