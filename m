Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2653F4831;
	Sat, 12 Sep 2026 08:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201942; cv=none; b=POpQ+TaiOjxBiQ2x/1S+OBRb1Eh6M1i/vdviR9EowWDZX8zHAM5SI8frWmtsARihXPrx0b6WgaQO8th2zJxaFi0Qx3viyP68qPHqED5VfvCUPoThAlhA0DT8T8CNXLldmKH4UAIYqDCRXRZV1tQ2+IR72raeJ4nPeByfM3ci9jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201942; c=relaxed/simple;
	bh=O7PDlOwApLxrpPTqekNmTQY1FHA7iQn94/0nEHNKktw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GRjw8pQtIGogDSBLX9plRcNLBg7k+ulKWi4+iQjKZJOiZMUZlUcma9zV7u9V/OjdAR8SagaFr3kTKVewmW5nuBZ59lRXsTNLeIH9wi0GxnQ7514DEC3X1PbovIFZiBUKZ25uvmxm/fBxlHL3zptH2HZYc6BiaZDRNsEeNMvaZ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpyIV4kv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpyIV4kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5F71F00893;
	Sat, 12 Sep 2026 08:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201941;
	bh=EX4Nw4FRPJm/766UVwS1WftGw2//juavuffcnV97y4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OpyIV4kvfQ+w3wZ0dD+ZQaKPjuSnxbGS+tif60SLTio8lbz2LleO2NZHjyXm3RCI9
	 eBIuWUx1TmiDZIuAHGrTTGjXSuJg3Gwn8Ow4CIKrOcfiL2+J2A5XY5ykZDJ0xuAp4M
	 gOslWJHKnQqrrm9pvuXVE5pTFKCPKMfvXgZGDYCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1057/1815] PCI/sysfs: Add lockdown checks to legacy I/O and memory handlers
Date: Sat, 12 Sep 2026 08:46:47 +0200
Message-ID: <20260912065713.831238241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 747b9bbbbdfdee51aee2456388f9b94b5086de4d ]

Currently, the legacy I/O and memory sysfs handlers do not check
security_locked_down(LOCKDOWN_PCI_ACCESS), leaving the legacy_io and
legacy_mem files unprotected when the kernel is locked down.

Commit eb627e17727e ("PCI: Lock down BAR access when the kernel is locked
down") added the check to pci_write_config(), pci_mmap_resource(), and
pci_write_resource_io() to prevent userspace from programming DMA-capable
hardware that could be used to modify kernel code, but did not cover the
legacy handlers.

As a result, root can still write arbitrary I/O ports and map the legacy
I/O and memory spaces while the kernel is locked down, which is the same
capability the lockdown is meant to remove.

Add the same check to pci_write_legacy_io(), pci_mmap_legacy_mem(), and
pci_mmap_legacy_io().

These generic handlers cover both architectures that define HAVE_PCI_LEGACY
(such as Alpha and PowerPC).

Fixes: eb627e17727e ("PCI: Lock down BAR access when the kernel is locked down")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: add Link]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260720211541.1509744-1-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index eab14be6fcf19..6b016792e0ad8 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -967,6 +967,11 @@ static int pci_mmap_legacy_mem(struct file *filp, struct kobject *kobj,
 			       struct vm_area_struct *vma)
 {
 	struct pci_bus *bus = to_pci_bus(kobj_to_dev(kobj));
+	int ret;
+
+	ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
+	if (ret)
+		return ret;
 
 	return pci_mmap_legacy_page_range(bus, vma, pci_mmap_mem);
 }
@@ -987,6 +992,11 @@ static int pci_mmap_legacy_io(struct file *filp, struct kobject *kobj,
 			      struct vm_area_struct *vma)
 {
 	struct pci_bus *bus = to_pci_bus(kobj_to_dev(kobj));
+	int ret;
+
+	ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
+	if (ret)
+		return ret;
 
 	return pci_mmap_legacy_page_range(bus, vma, pci_mmap_io);
 }
@@ -1003,6 +1013,11 @@ static inline umode_t __pci_legacy_is_visible(struct kobject *kobj,
 					      bool sparse)
 {
 	struct pci_bus *bus = to_pci_bus(kobj_to_dev(kobj));
+	int ret;
+
+	ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
+	if (ret)
+		return ret;
 
 	if (pci_legacy_has_sparse(bus, type) != sparse)
 		return 0;
-- 
2.53.0



