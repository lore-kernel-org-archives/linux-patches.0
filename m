Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466904EE870;
	Tue, 13 Oct 2026 12:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894093; cv=none; b=qvnNiiFTOIlgRgbnXSSAbMFqQwxCoyug5zC72yW5dEoGBS3zWmF7pTLhvEHMJj5o3K5oaj4DHPZb9NHgkNPe3LJmw90pQn1kc6pRXpo4EK2QE8Lontvy20M9/zCrue6HBD2qH6Mv5VCTbdQc9i1OevFy3DO8ONCR4U/a5lGhiU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894093; c=relaxed/simple;
	bh=ga2HzA4dUVH0BEKzlQsd8cnn59H1w6gih53u9N+YCyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZCI1pV/7syLoE00Fz9nuA4RCMDrfVyzZWMlvYyp6Mp92JPVH9sSr6yJyWASLiJEuzWFmNHLG5OFNpZn+UMkyN7t2aCYhpPfCeDodQYehDirHmzdjEGJjCnXWfTSoTAPuIdqS4JVKsTqhZXtSX4n9VzV38aqU8z8Hl/UoPHGICs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyyYpb3Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyyYpb3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEE01F000FF;
	Tue, 13 Oct 2026 12:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894092;
	bh=VP0b8HoOJmft/BJToByvyzBS8qas4RfSEah/bwS6w1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyyYpb3Q3q+H/GOax1WzXCi4Gn14FCX6uRKY5ehLDhCY25vUaACaNUFSE+EqEZpOm
	 GXkdMTKjDIVnQ/Kf2s8K0v/sDsDQibl6iDSHkWOtHZJhZatu+uuvb8UwfBlUeG47Dj
	 YKcKy8ebqUWPxmu996DCvmEWg07mixLgECcsMrKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 445/621] PCI/sysfs: Add lockdown checks to legacy I/O and memory handlers
Date: Tue, 13 Oct 2026 13:37:20 +0200
Message-ID: <20261013112931.391622623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 76966343e0186..178ee8351f662 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -950,6 +950,11 @@ static ssize_t pci_write_legacy_io(struct file *filp, struct kobject *kobj,
 {
 	struct pci_bus *bus = to_pci_bus(kobj_to_dev(kobj));
 	u32 val;
+	int ret;
+
+	ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
+	if (ret)
+		return ret;
 
 	/* Only support 1, 2 or 4 byte accesses. */
 	switch (count) {
@@ -985,6 +990,11 @@ static int pci_mmap_legacy_mem(struct file *filp, struct kobject *kobj,
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
@@ -1005,6 +1015,11 @@ static int pci_mmap_legacy_io(struct file *filp, struct kobject *kobj,
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
-- 
2.53.0



