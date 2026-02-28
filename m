Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581D3347FC0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302363; cv=none; b=Bf3Jnjdj749MNdIrDdZVQcfxEv99t46gEtPv6H7PlebMpBSXWR+H2v6/PRLyalmNma+DbAamg0GQ+LSYrlYOGW48PmLaWV+1lxN+UrGPACbnNHQeKiRbhjnBlfIuF4ivZAVponYmhbP9j8zSkErPfKCubnpjMRNunKtX2T4UFDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302363; c=relaxed/simple;
	bh=HpXols9I3tjs1mEyhhBjth12PomgIUSyf5PAjXc/fU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkruID/lzsI7x+u2ngRcDTVBl7fxjjrhhAxUruGBK0ZIEwHpcwfpT1/y0M/0bt2p4J/vGra+PG59GLOuB32qaZrzPDtne0YV9AURoSAWzzN1ACmJVC8/Y0Re9jSas8w1Kt/ofNjZDE4ySG0tXoeFEKHTf47V6JamwzcxmdBVNnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUI5loHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUI5loHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A412DC116D0;
	Sat, 28 Feb 2026 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302363;
	bh=HpXols9I3tjs1mEyhhBjth12PomgIUSyf5PAjXc/fU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUI5loHUJji49Q3+t8WPBx+D3VC53XmCgVBMVVgkDuFpFFxBzvTvS9E1oHZCP8xbF
	 SEMxr4k7DJ/ape+bZDCcDWRZxtCp/hMfPdnp9LAs9h8cOc8kILexXm1w/B24xata68
	 bKNYPDrh7WR43XIKppCyjE/4xrs+sllOX2XFRBXKHKD/rv2Le4GXoLUC6g+igiDgmP
	 n1XE2Bt1XvsoCqPkkYvVLOfH4NmzqdBPcEIJ5K2VTAvtEsDyxKgV+r3A2xsY37MEkt
	 C/eFIINkX8uJssn1LBuyJPMeGwPDHXSxb7bCA4U9upgzNp5lT+49RlYJIpBNASNbQO
	 tvSX7C0eh0ikA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Brian Norris <briannorris@google.com>,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/232] PCI/PM: Avoid redundant delays on D3hot->D3cold
Date: Sat, 28 Feb 2026 13:09:03 -0500
Message-ID: <20260228181127.1592657-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@google.com>

[ Upstream commit 4d982084507d663df160546c4c48066a8887ed89 ]

When transitioning to D3cold, __pci_set_power_state() first transitions to
D3hot. If the device was already in D3hot, this adds excess work:

  (a) read/modify/write PMCSR; and
  (b) excess delay (pci_dev_d3_sleep()).

For (b), we already performed the necessary delay on the previous D3hot
entry; this was extra noticeable when evaluating runtime PM transition
latency.

Check whether we're already in the target state before continuing.

Note that __pci_set_power_state() already does this same check for other
state transitions, but D3cold is special because __pci_set_power_state()
converts it to D3hot for the purposes of PMCSR.

This seems to be an oversight in commit 0aacdc957401 ("PCI/PM: Clean up
pci_set_low_power_state()").

Fixes: 0aacdc957401 ("PCI/PM: Clean up pci_set_low_power_state()")
Signed-off-by: Brian Norris <briannorris@google.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
[bhelgaas: reverse test to match other "dev->current_state == state" cases]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251003154008.1.I7a21c240b30062c66471329567a96dceb6274358@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b4692c3f98d3b..bafa695bd7ec7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1397,6 +1397,9 @@ static int pci_set_low_power_state(struct pci_dev *dev, pci_power_t state, bool
 	   || (state == PCI_D2 && !dev->d2_support))
 		return -EIO;
 
+	if (dev->current_state == state)
+		return 0;
+
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 	if (PCI_POSSIBLE_ERROR(pmcsr)) {
 		pci_err(dev, "Unable to change power state from %s to %s, device inaccessible\n",
-- 
2.51.0

