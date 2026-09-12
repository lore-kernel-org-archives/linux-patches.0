Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2B13F54B6;
	Sat, 12 Sep 2026 08:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201941; cv=none; b=XA4KE6fAhch10eoiX/y+ppKmftlMRfE+TtqULBzE4mzWWO30NFusrECwg2AMp/CJ9BK/Xe0jN72SPXGkQ70V5fUSlqWW5El3nEqk6WncANIncbUC6xp1Ngg1xpHYS8Ca9uTR0lXZTR9egJnifGPThZlLJCCfaate2fxHJUJ1JSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201941; c=relaxed/simple;
	bh=LbqA0jHAatNGQYRV3WX8JzJkqweVmhTGMOeOwjqsVvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJyKmhyicK+RlK35r7jJ80wMVrVCaeKRhI6qq99LdySLeRAb4ijRP17ATUJVv2w18OqIDarw9+f2E3HAnElV7STp+4QKPiWe0z9M79ejfoLmJFvwWzPg/9GqWL72qyux/gu9tQbKGMonC5yf67LxvAjiP4Mf8zyXGPP4lwiZm/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBwHuXhT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBwHuXhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BBB1F000FF;
	Sat, 12 Sep 2026 08:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201936;
	bh=x8B+SMvAv8q60Mw2nCbbK6EUevqKWzrNivSXIkti51k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBwHuXhT0/9vQUeq5cV6aC/nqH8RAoZJ4htJH43KWjSJVDqXJjtiBRJu3aEIuk2eV
	 d7dOnVhr3Dm8mdd0IoWtmmO8KZdkEB8T43trHDI1/pGV7iYe3YJMPv1pnzUKffVO2N
	 SgeCWqc/b944/jUPbFXrUEh5i0Y5lBx1pti0tLk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1056/1815] PCI/sysfs: Return -EINVAL for unsupported I/O BAR mmap
Date: Sat, 12 Sep 2026 08:46:46 +0200
Message-ID: <20260912065713.807428253@linuxfoundation.org>
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

[ Upstream commit bad94d3d18c600cfe2c24c17b1825db4b8795e3e ]

Currently, mmap() of a resourceN file for an I/O BAR fails with -ENODEV on
architectures where arch_can_pci_mmap_io() is 0, such as x86, because the
attribute has no mmap callback there and the error comes from the generic
kernfs dispatch.

This is a side effect of commit e854d8b2a82e ("PCI: Add
arch_can_pci_mmap_io() on architectures which can mmap() I/O space"),
which removed the mmap callback from the I/O resource attribute on
these architectures.  Previously the request reached the architecture
mmap code and failed with -EINVAL, and the same commit deliberately
kept -EINVAL for the identical operation on the procfs interface, so
the two PCI userspace interfaces have disagreed ever since.

Add a pci_mmap_resource_io_unsupported() callback that
returns -EINVAL and use it as the mmap handler of the I/O resource
attribute when arch_can_pci_mmap_io() is 0, so the failure is
produced deliberately by PCI code, consistent with the procfs
interface and with the behaviour before e854d8b2a82e.

Architectures where arch_can_pci_mmap_io() is non-zero keep the real
pci_mmap_resource_uc() handler and are unaffected.  The mmap() fails
either way.  Only the reported error changes from -ENODEV to -EINVAL.

Fixes: e854d8b2a82e ("PCI: Add arch_can_pci_mmap_io() on architectures which can mmap() I/O space")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260720204624.1503794-1-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 1be627913a9be..eab14be6fcf19 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1274,7 +1274,16 @@ static loff_t pci_llseek_resource(struct file *filep,
 	.llseek = pci_llseek_resource,		\
 	.mmap = pci_mmap_resource_uc,
 #else
-# define __PCI_RESOURCE_IO_MMAP_ATTRS
+static int pci_mmap_resource_io_unsupported(struct file *filp,
+					    struct kobject *kobj,
+					    const struct bin_attribute *attr,
+					    struct vm_area_struct *vma)
+{
+	return -EINVAL;
+}
+
+# define __PCI_RESOURCE_IO_MMAP_ATTRS	\
+	.mmap = pci_mmap_resource_io_unsupported,
 #endif
 
 #define pci_dev_resource_io_attr(_bar)					\
-- 
2.53.0



