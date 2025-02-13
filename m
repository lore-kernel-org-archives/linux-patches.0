Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31576645;
	Thu, 13 Feb 2025 15:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459609; cv=none; b=sYv6ROx+g8Gj5PpvF4L65jWO9/SWsqLPxcEHlz1PD+M06T4uWd/RpaP2CFJcBDLLIqo5UOgiH7pPYUL3uWSij3qlPQMOXYGuL8J3+wi830LMHyLFwHRImi4wTvOyPGnEoMgA/Av6x2yvQS5CplnMT1wORwXI8bcNGqcHLwfW3vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459609; c=relaxed/simple;
	bh=BHu2OfgfBAqqlt3a2WRSOa+VV7BbmWeNZ9VpNvPMN28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv99z6ZzCGvN/U/eFSdf8Fi3jJBFAkFIsToSvJuGXFbZn4BP376AH2h1H+qLmYOTWRWoZR5VoOMdW2mJHgmttfkmYjrTLHgYtjculZRTsk02r4UPpdjGfqQA5eUKewSu/zQ3iTLAyfX2E457Enw5PIzc/6AFr6KaxZJ217kwZg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQZGB1jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQZGB1jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F00C4CED1;
	Thu, 13 Feb 2025 15:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459608;
	bh=BHu2OfgfBAqqlt3a2WRSOa+VV7BbmWeNZ9VpNvPMN28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQZGB1jlRrS5Qe/tRTqTtKlSSaUE2OijrWTYwNd8XSwiUgJhNjdye7YIaUrsrNge7
	 YOcyq8gX4hvQ5TTXjNLvGv/xQ3K8IH50HJMpJc6FkfaadiVd6Tz1EEZ1luzLfJ/jus
	 1OrwjlvfXdb8HAluq2fCmdewlAGtgAg/s8MUumqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.13 272/443] s390/pci: Fix SR-IOV for PFs initially in standby
Date: Thu, 13 Feb 2025 15:27:17 +0100
Message-ID: <20250213142451.105605373@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


