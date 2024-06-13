Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25A2142E84;
	Thu, 13 Jun 2024 12:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280992; cv=none; b=YJ82VgJcJ7WZS0iyt5xiM3Rz+z2/kU/X5XZn/1mdCV6T0DjBQccprswgcMjXrMDlCbWcpAFQvwNosMZPqnpvb5GDw4VUqKAg/EwWIK6vcJAlDdEFw5XJ1jYZ7xf4FNScyL/Us8uXRt0o4uugNQKRjOc9CIW4OlJw7aspZicOthA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280992; c=relaxed/simple;
	bh=YTVCG8yhiIcjsrN9gDaGA4Axzx00+snL0rvcZzd99dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fri7GlwbW9jfwPz0FB1dnuSYcYrGmpq5ZOfEMtlzWghhSYWFX4nU2xdcAsbMXZtyK6599Dm2DmT25vmnJ6ZHy+y4543C9ISaBNgPOwc8KJPhxauUD5aegunBLFDvemSZGXSI+zTiqIEXAa8EUqvyrXU6i9jOjcerxPLvXl09MRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzSmcPXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzSmcPXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EB5C2BBFC;
	Thu, 13 Jun 2024 12:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280991;
	bh=YTVCG8yhiIcjsrN9gDaGA4Axzx00+snL0rvcZzd99dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzSmcPXNRl9PJKplu8LKjZWdvaGRiRe9j9mbRUBHLVDACgzgNywZuoHhUjWwL2u7P
	 WidjKn6ja32f+L+qfq2xwqUzsKgFO8fdXnwqh9ZFFZ+LzixloLw2j32egXZ1rc/WvO
	 59VQRnxr+RF69cEbCONAbehj/X3LJb60MX6H4YBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/317] HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors
Date: Thu, 13 Jun 2024 13:31:30 +0200
Message-ID: <20240613113250.333322368@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 6baa4524027fd64d7ca524e1717c88c91a354b93 ]

Add a check for the return value of pci_alloc_irq_vectors() and return
error if it fails.

[jkosina@suse.com: reworded changelog based on Srinivas' suggestion]
Fixes: 74fbc7d371d9 ("HID: intel-ish-hid: add MSI interrupt support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index c6d48a8648b70..4a16ede402ff5 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -164,6 +164,11 @@ static int ish_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* request and enable interrupt */
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0) {
+		dev_err(dev, "ISH: Failed to allocate IRQ vectors\n");
+		return ret;
+	}
+
 	if (!pdev->msi_enabled && !pdev->msix_enabled)
 		irq_flag = IRQF_SHARED;
 
-- 
2.43.0



