Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A1036C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302364; cv=none; b=uedpQqs41JuQ8AnmN1Vrf355l64hdpA8WrVLgQ/k9HUZpiPWoOusYEGSIBBZ6xCuQqGfQ0xrgIAKdkbuO4AIx90SIu7m8y9qjUx6tys4ilMDV+4lP0/4hrGA3VwMyWq+2yAZddu2o7ttQ1CiPyYF2SDt6vzsdQt6D7Gd1t3fXss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302364; c=relaxed/simple;
	bh=ROwxj+gmd7s4885hkdqNcbbj8uF84W1ko9+M41+PICU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qa3FjItWQhGKwEZi6cAzSZdB5qwL8y2A/0mvaCxvFWfzJ2XeHux5aTY2ZPhSRYVOn+1Pq6GYxRUuHvAFsJHNVrKVZPgZRHR69OkGvim38AI2yJHzEUkdE/tZ1wCZxY90hn+pROSJj+IcdeLje87sCchLi557BRUKgrhh6lujgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u8O+YOG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u8O+YOG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED0BC19425;
	Sat, 28 Feb 2026 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302364;
	bh=ROwxj+gmd7s4885hkdqNcbbj8uF84W1ko9+M41+PICU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8O+YOG3FTHlw1RuuPqt0Aq6wXKL2HZ033eUq1K3OP04zzeMMRnCRo8uwh6+H5IX4
	 oaeCcy+oKk6fhETQphR2iLJxBy27fv7Tx+7I0yPwqbljj1zEceNuIJeJ2rmU3UaHUa
	 FSI89apVxw4+ZvhOTeE95KOhxXBT2QHhgxMVf073V5RhEUyyqf7suJhONA3ze9/la2
	 DpG/q0TZv3Qotqwx+w9Hg8R8WixhCDL5fheWsrATI7+0CLLeQmYUqmloxerphaD3+O
	 JYIwIH8Ts7E2AEKPol7Bfs1XQU/EXsh0HruoqMdGSM7FtgmssSVZqpFZLNVurKJmuY
	 5ZvbKX3QIO+9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/232] PCI: Do not attempt to set ExtTag for VFs
Date: Sat, 28 Feb 2026 13:09:04 -0500
Message-ID: <20260228181127.1592657-91-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index c37ff0ee53f82..4a72a0163a862 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2097,7 +2097,8 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	u16 ctl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
+	/* PCI_EXP_DEVCTL_EXT_TAG is RsvdP in VFs */
+	if (!pci_is_pcie(dev) || dev->is_virtfn)
 		return 0;
 
 	ret = pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-- 
2.51.0

