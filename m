Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF53827FD44;
	Wed, 25 Feb 2026 01:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984041; cv=none; b=I3wT5RS6cU+UAMa3y4nemQC/QgLx1KNjUaeN9frwDgqXNfC3mdQ7iuV/ukqCGBOdfDVjzutbB5DAhQwrtpezWqOP41DyH2Ov39gaQgq2WL0frI/Fhyjz+Ke+MhKL7qIwknqGV77aKXj+7KqSEfQ4ZOR5bfp4lot91V+V6llZxew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984041; c=relaxed/simple;
	bh=7jPzZ1ysWsxFU/yFplb4wH4AljE+MTJOUMuMMwdH9ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=skAFNub1+qF86J2+vD4eeeQwplq2lWrUR5YUJdfna8vatrGUAvOd4W4hdaZOpBn0+JR9YVU005RVqG9vnsXRNPb5I6cDCruejhJPduYw+PdQ55gLVRDz3W4R+nG2i0SXh0zUev/Ja0x3MJ3ebUzdf5ECOxZoK4sbKBY5GrQ/i5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCFt0CkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCFt0CkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8613EC116D0;
	Wed, 25 Feb 2026 01:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984041;
	bh=7jPzZ1ysWsxFU/yFplb4wH4AljE+MTJOUMuMMwdH9ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCFt0CkUYt0Xy5XnqaZnx8LJ+J7PJp+GUqHi0IF9Bw+ht9Ss2ujfWyS2SfwuUDMaq
	 dvc4RnsdPoyaaOj/sSajKlFNqNuJD97q5pR8yKvaqoydg00eNp12AVkvELSVAhFYTC
	 qdXPAAWZ5iO4GHNh4faZpXaBBuoTTS6OS8UJXcuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 242/641] PCI: Do not attempt to set ExtTag for VFs
Date: Tue, 24 Feb 2026 17:19:28 -0800
Message-ID: <20260225012354.733759640@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 73711730a1128d91ebca1a6994ceeb18f36cb0cd ]

The bit for enabling extended tags is Reserved and Preserved (RsvdP) for
VFs, according to PCIe r7.0 section 7.5.3.4 table 7.21.  Hence, bail out
early from pci_configure_extended_tags() if the device is a VF.

Otherwise, we may see incorrect log messages such as:

  kernel: pci 0000:af:00.2: enabling Extended Tags

(af:00.2 is a VF)

Fixes: 60db3a4d8cc9 ("PCI: Enable PCIe Extended Tags if supported")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20251112095442.1913258-1-haakon.bugge@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9cd032dff31e5..8cf573fca3078 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2251,7 +2251,8 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	u16 ctl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
+	/* PCI_EXP_DEVCTL_EXT_TAG is RsvdP in VFs */
+	if (!pci_is_pcie(dev) || dev->is_virtfn)
 		return 0;
 
 	ret = pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-- 
2.51.0



