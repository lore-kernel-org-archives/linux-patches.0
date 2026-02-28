Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC62338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301773; cv=none; b=hD40Bu20kPTvUvvdWkw7ScK7x+aHoFRZMQfCkL2/y2QnJlNZHF4TBOizGWG6iqia4IRAu5wCCOWW9NRJgPAHhfYmQ3GZm056etzkBsmqaxLBn5Mj69WIYl5o7n6GLHygZM+onU0NrWqtqc1XdHtw0tAu+Q+6VmX212ez3+0tX8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301773; c=relaxed/simple;
	bh=IaMzEcs1LfPgGCn0lK9QZeKnB4cWNyge70Onp7fBmuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICVtk/o7vjzSCx3BK6wuVyVcdziGNLckc0MySDM+R6elqoB1C6NyYThxCop6JIvnkb1wrQrWq/U4lcIJtMqC+3BeRDV/MeQRR5FW/+f94ireC17EvnpmVSwk4t5yQuPim3ymV/GMIan15QpivPxjTPJutaybwaCpeEh+Ds5Hotg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zu9OnlqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zu9OnlqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4117C116D0;
	Sat, 28 Feb 2026 18:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301773;
	bh=IaMzEcs1LfPgGCn0lK9QZeKnB4cWNyge70Onp7fBmuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zu9OnlqJ9PbnMfVgg4rFFalvcRTFRenat0sUcz8VtxZBcCuRc8laDqiqhNR4GDPpO
	 5xRJU23auHTgy2hJ3+t2xVug4tCmycru9jlEhMG5rDsbkj2jAmxkZf5DwavaOd7+/L
	 817X6xMxQbXDb8xiDUU7xVYScI69D7lQUkm8Apfuu6TVzwca6Mj64P1d/llt7ciwpo
	 FfDRHMzMDdSZo/1jTeSHjh5yM8UztAx9fskWDqLX2TQAXO5kG8bVsFN18En3HfI3YE
	 gVU8dalDOj+TnEa9mKaQAggmY9fkDZuqZIFFJoYUc8FDuTbxK748uN9W2KZp+kwnTx
	 OGXySTvideavg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/385] PCI: Do not attempt to set ExtTag for VFs
Date: Sat, 28 Feb 2026 12:56:43 -0500
Message-ID: <20260228180011.1568201-181-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index b358b93a02753..7010f74f1336a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2175,7 +2175,8 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	u16 ctl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
+	/* PCI_EXP_DEVCTL_EXT_TAG is RsvdP in VFs */
+	if (!pci_is_pcie(dev) || dev->is_virtfn)
 		return 0;
 
 	ret = pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-- 
2.51.0

