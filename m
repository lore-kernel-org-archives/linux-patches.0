Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF61FBC92;
	Mon, 27 Oct 2025 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592785; cv=none; b=RFHY9pv5JJG8B63ScAvTXJ628ipIy5WnN5V0gksWf/h9TDO6w/Vdmwp3oVkMD7cgGz6Col3sJcXrWCtjVehXy4PDx/RIwLJz0MwdU28INCxbzY860wG5O5toxcTvoX3rN1Ma+TBdddGg9y8zs2TU90e3GhD3iirgxvuykadGHks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592785; c=relaxed/simple;
	bh=jia6LqX1YRf0dHxLyZpudoF0At1wiWp3heOnYKm46bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ht/dBlDUihU/WEX6jjv+nXwHCJDDx1kNPJpxmmTYqkhu5YOsBzpHe8sBKfUJijdgCpHD/Tfry/wsnY0UlufHxmv0EOG73vgbv9HYKoljgF/PjCo7WkBiWDCEYXoibD2ugARucMFJOF6MTF6qnWeSFuJQzz1tF1YVgfaeIp90Wrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABLJXn8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABLJXn8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D7FC4CEF1;
	Mon, 27 Oct 2025 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592784;
	bh=jia6LqX1YRf0dHxLyZpudoF0At1wiWp3heOnYKm46bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABLJXn8wMvuLkRYux3qYcRW8igci3m6KfpAi11oQO+e5dd0fqW6Jez7DiqRcxTDWE
	 90Y4On1/E3SQSveoBcDETeZsZo2NlbDXtWNlTeHk7rUdE2DvXYTvZ07aDlwppJ+GgY
	 PXC7XSLPjTCcP290+Jg/NIFISAKGWrF+A5gRqdPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/117] PCI: Test for bit underflow in pcie_set_readrq()
Date: Mon, 27 Oct 2025 19:35:37 +0100
Message-ID: <20251027183454.246397846@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 00e58ff924b3a684b076f9512fe2753be87b50e1 ]

In preparation for the future commit ("bitops: Add __attribute_const__ to generic
ffs()-family implementations"), which allows GCC's value range tracker
to see past ffs(), GCC 8 on ARM thinks that it might be possible that
"ffs(rq) - 8" used here:

	v = FIELD_PREP(PCI_EXP_DEVCTL_READRQ, ffs(rq) - 8);

could wrap below 0, leading to a very large value, which would be out of
range for the FIELD_PREP() usage:

drivers/pci/pci.c: In function 'pcie_set_readrq':
include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_471' declared with attribute error: FIELD_PREP: value too large for the field
...
drivers/pci/pci.c:5896:6: note: in expansion of macro 'FIELD_PREP'
  v = FIELD_PREP(PCI_EXP_DEVCTL_READRQ, ffs(rq) - 8);
      ^~~~~~~~~~

If the result of the ffs() is bounds checked before being used in
FIELD_PREP(), the value tracker seems happy again. :)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/linux-pci/CA+G9fYuysVr6qT8bjF6f08WLyCJRG7aXAeSd2F7=zTaHHd7L+Q@mail.gmail.com/
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250905052836.work.425-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3d1365f558d3a..0dd548e2b3676 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6048,6 +6048,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 {
 	u16 v;
 	int ret;
+	unsigned int firstbit;
 	struct pci_host_bridge *bridge = pci_find_host_bridge(dev->bus);
 
 	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
@@ -6065,7 +6066,10 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 			rq = mps;
 	}
 
-	v = FIELD_PREP(PCI_EXP_DEVCTL_READRQ, ffs(rq) - 8);
+	firstbit = ffs(rq);
+	if (firstbit < 8)
+		return -EINVAL;
+	v = FIELD_PREP(PCI_EXP_DEVCTL_READRQ, firstbit - 8);
 
 	if (bridge->no_inc_mrrs) {
 		int max_mrrs = pcie_get_readrq(dev);
-- 
2.51.0



