Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EC92222D8;
	Thu, 13 Feb 2025 14:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457900; cv=none; b=L9FHzIyDmr7Bi54mlUUF71YfLrcRSEdHhyTscqyzE0M3OyNXNQnLPCWLSEpv4rN7kmLY30XafYceRoVMo/LcrYO1Q784a+v2sK0R2NgYaaGkxkiCm055oDi32cw+BQk58713A3kPRm/koOcjpXlAfVq7W1+U6FRUjlZo2t+9AAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457900; c=relaxed/simple;
	bh=oUMEO4OJkqK54dLwgjzZuGysRCgVBExmYwShOlE0A+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGmDBXTll/54WNZDT8Ncs0zHfmQ7YYvjNUuVXB/qFo7qXPG8KV6uSpfIDchAmt9s95n1yRhfp1XUsQgUHydMFex6LTKP1sqvAE57C8IiYOCHLQDtctPHjjFtV69ZIXesG4uQZSGiEjW3FG9sjPMIkcmcLUMSf2eEYpvKegocQco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8laIHx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8laIHx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BB0C4CED1;
	Thu, 13 Feb 2025 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457899;
	bh=oUMEO4OJkqK54dLwgjzZuGysRCgVBExmYwShOlE0A+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8laIHx9JvWzc9mTlVRMh8QTRvrYvw8ycLJCV/AYako8jxlG3dvkoqxmT1RKIkwpM
	 XAhPcUlU/wh4HFYuUxXX6jraRCBAHWVbDE1YBnbXn4YRQvt5XZoPdJuedNwZFoCp/j
	 CmPpppkagm7coNfbyPjxPAqG3zn0npdoLJzrQm7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 246/422] s390/pci: Fix SR-IOV for PFs initially in standby
Date: Thu, 13 Feb 2025 15:26:35 +0100
Message-ID: <20250213142446.031148329@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit dc287e4c9149ab54a5003b4d4da007818b5fda3d upstream.

Since commit 25f39d3dcb48 ("s390/pci: Ignore RID for isolated VFs") PFs
which are not initially configured but in standby are considered
isolated. That is they create only a single function PCI domain. Due to
the PCI domains being created on discovery, this means that even if they
are configured later on, sibling PFs and their child VFs will not be
added to their PCI domain breaking SR-IOV expectations.

The reason the referenced commit ignored standby PFs for the creation of
multi-function PCI subhierarchies, was to work around a PCI domain
renumbering scenario on reboot. The renumbering would occur after
removing a previously in standby PF, whose domain number is used for its
configured sibling PFs and their child VFs, but which itself remained in
standby. When this is followed by a reboot, the sibling PF is used
instead to determine the PCI domain number of it and its child VFs.

In principle it is not possible to know which standby PFs will be
configured later and which may be removed. The PCI domain and root bus
are pre-requisites for hotplug slots so the decision of which functions
belong to which domain can not be postponed. With the renumbering
occurring only in rare circumstances and being generally benign, accept
it as an oddity and fix SR-IOV for initially standby PFs simply by
allowing them to create PCI domains.

Cc: stable@vger.kernel.org
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Fixes: 25f39d3dcb48 ("s390/pci: Ignore RID for isolated VFs")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_bus.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -171,7 +171,6 @@ void zpci_bus_scan_busses(void)
 static bool zpci_bus_is_multifunction_root(struct zpci_dev *zdev)
 {
 	return !s390_pci_no_rid && zdev->rid_available &&
-		zpci_is_device_configured(zdev) &&
 		!zdev->vfn;
 }
 


