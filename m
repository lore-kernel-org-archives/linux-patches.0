Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D648124E;
	Sat, 12 Sep 2026 18:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239600; cv=none; b=tr0NusWM1DTmIEnQfMRIPPk6p3yYLlLReabCR2sdLoFd0NP/x2nmSAIhODd7aghtkmoO+l86UlnakUpPtmUqPrRg0fthNi/9Ca/Jp7Eaqdvq/MPLKEeIibMwWPyuNKMjBtf1pk2CvHI/pFFLG/2WB9SV9LLGUY2YdX15vAsuhxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239600; c=relaxed/simple;
	bh=vSSsydwyTM61p40BP48k5o1afXRqvUxnsjOtk3pG7Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqNv29bUHzIJg9uyQyRR2gpvWJatfpvB6XxHU+SSW/59iHp510wBZ4rWZqbw4jwBOhdAY2RvttXoR4IrFUkQJqHq/uYFN1OYARahHlG4bwiDXlinpK8lUOLHbvRy7AkG7oiqqtzyEcH0Z3xBXi5KRpdqJQbk0USbep+tj8EZXRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhY8uTxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhY8uTxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BFC1F000FF;
	Sat, 12 Sep 2026 18:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239598;
	bh=tcndCAtQflbOr9o6UyC/VPfUvfTw7tqBnc56VKmoI+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhY8uTxlK0paiLCzHAtIZLMvhXfbSDrK5zIOcciZqFXM15h4l+4vaEVmEVjz0JVCL
	 +49aEz/DIutn4Z4ZRPwaCuwFsCZXspXcQfZiYDG9XUwsOSpCRWo1jBlnVvHLsgPW4s
	 Kftbk4Fp+CyCA8ziQTR7wJexVp6XtG9ockNzyaoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 697/935] PCI/sysfs: Add static PCI resource attribute macros
Date: Sat, 12 Sep 2026 09:02:07 +0200
Message-ID: <20260912065542.826416493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit b15ac7e008bf0039f981da21e983b2df130152ff ]

Add three macros for declaring static binary attributes for PCI resource
files:

  - pci_dev_resource_io_attr(), for I/O BAR resources (read/write)
  - pci_dev_resource_uc_attr(), for memory BAR resources (mmap uncached)
  - pci_dev_resource_wc_attr(), for write-combine resources (mmap WC)

Each macro only sets the callbacks its resource type needs.  The I/O macro
conditionally includes mmap support via __PCI_RESOURCE_IO_MMAP_ATTRS on
architectures where arch_can_pci_mmap_io() is true at compile time (such as
PowerPC, SPARC, and Xtensa).

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Link: https://patch.msgid.link/20260508043543.217179-7-kwilczynski@kernel.org
Stable-dep-of: bad94d3d18c6 ("PCI/sysfs: Return -EINVAL for unsupported I/O BAR mmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 396471572e579..33847e32fb429 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1181,6 +1181,47 @@ static ssize_t pci_write_resource_io(struct file *filp, struct kobject *kobj,
 	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
 }
 
+/*
+ * generic_file_llseek() consults f_mapping->host to determine
+ * the file size. As iomem_inode knows nothing about the
+ * attribute, it's not going to work, so override it as well.
+ */
+#if arch_can_pci_mmap_io()
+# define __PCI_RESOURCE_IO_MMAP_ATTRS		\
+	.f_mapping = iomem_get_mapping,		\
+	.llseek = pci_llseek_resource,		\
+	.mmap = pci_mmap_resource_uc,
+#else
+# define __PCI_RESOURCE_IO_MMAP_ATTRS
+#endif
+
+#define pci_dev_resource_io_attr(_bar)					\
+static const struct bin_attribute dev_resource##_bar##_io_attr = {	\
+	.attr = { .name = "resource" __stringify(_bar), .mode = 0600 },	\
+	.private = (void *)(unsigned long)(_bar),			\
+	.read = pci_read_resource_io,					\
+	.write = pci_write_resource_io,					\
+	__PCI_RESOURCE_IO_MMAP_ATTRS					\
+}
+
+#define pci_dev_resource_uc_attr(_bar)					\
+static const struct bin_attribute dev_resource##_bar##_uc_attr = {	\
+	.attr = { .name = "resource" __stringify(_bar), .mode = 0600 },	\
+	.private = (void *)(unsigned long)(_bar),			\
+	.f_mapping = iomem_get_mapping,					\
+	.llseek = pci_llseek_resource,					\
+	.mmap = pci_mmap_resource_uc,					\
+}
+
+#define pci_dev_resource_wc_attr(_bar)					      \
+static const struct bin_attribute dev_resource##_bar##_wc_attr = {	      \
+	.attr = { .name = "resource" __stringify(_bar) "_wc", .mode = 0600 }, \
+	.private = (void *)(unsigned long)(_bar),			      \
+	.f_mapping = iomem_get_mapping,					      \
+	.llseek = pci_llseek_resource,					      \
+	.mmap = pci_mmap_resource_wc,					      \
+}
+
 /**
  * pci_remove_resource_files - cleanup resource files
  * @pdev: dev to cleanup
-- 
2.53.0



