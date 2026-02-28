Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477833A2AEF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302704; cv=none; b=FFB6QJNrJ0GGpBraFCGy2WLrBbvqNwTRdYjvwO9MSqtJCtWtwlKkjD8MmyxJhR0cjVpSsoKR0zz2iSmopC/uUc2W11qL5JLhbaox2ttCqD5l9uYRKD2DNbaEmQgQgWo5HORevS0khZcLqwcCBCfvr/8FLhrMZZYIlcxh5qZ9e2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302704; c=relaxed/simple;
	bh=lA5ZwtJ2AIqcMJQcwR/zWrMLVq/RN40IO6kqj5gCBxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WltRW2192+aKNb3MJD+FCfqybGz2HNsFU41dBwYpbEeYKnaOUZr5Mi9gxzr3VgQc+C1EXeHDwSvI4lpklywwqzqSC7sNSJfAda5ldbuDDXGNPTpJ54BvyLDdrJTIc0r4o00I0AYIi0KVH938ppPGLSi/6cySJGqESjqOnnbyn58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0aTjEww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0aTjEww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CEBC19424;
	Sat, 28 Feb 2026 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302704;
	bh=lA5ZwtJ2AIqcMJQcwR/zWrMLVq/RN40IO6kqj5gCBxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0aTjEwwkoR6RXv0tPd0AVjTUy+sEatWvLsmljDIpIyralfZbFQWENjjNwEvIppEu
	 K/qSgq9krIdJ0TaIu6dnaM0fJfXqnnNvV4s7sR02BKp4nMMpa++CtylU/wKXbnPhyI
	 hDsonYHXH6xEDGV0krMLZS1Y2vUxiHIfPl6cm1r0lbwqQq0NGx6HghGc5cC9xteG0s
	 ZQ9+TCMc+/RqLmWsCU3zog63gC/lljjAyc6JSPhY5d2991lx98M7ARQ4J19xXayQMr
	 Fpo+6D6YvRlySEjQVGeZL2S4EDaxGmWtqas7hCbxMfM1jgFmLeNmDuoMnOfAqbDtqx
	 6KNSnmdWokWYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/147] PCI: Do not attempt to set ExtTag for VFs
Date: Sat, 28 Feb 2026 13:16:09 -0500
Message-ID: <20260228181736.1605592-61-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 0b1ef4f2c90dd..50a7fd09b068e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2069,7 +2069,8 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	u16 ctl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
+	/* PCI_EXP_DEVCTL_EXT_TAG is RsvdP in VFs */
+	if (!pci_is_pcie(dev) || dev->is_virtfn)
 		return 0;
 
 	ret = pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-- 
2.51.0

