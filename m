Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C33E441D;
	Thu, 13 Jun 2024 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281915; cv=none; b=TEaVn67lIzE9KQ19Kzdp2GtXhlGseo/wtNNz+lhFgMV48sSBeM4XrHOeTSv12G26crM12FuhKINlR1Si/NfOWoQo/L9f7o2DyWvogMhdSkwb1eW7XnpERw5bMfgzlo4qe65dtc5nuFx+ssJAPRMVTePnb0y/gSOshCkLxiilpMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281915; c=relaxed/simple;
	bh=76T8RUHoJxU7JEN0rClctDDlNKqiSn7FuvvKCon6KXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHvj+5XJwd47J62TV/pfCPc+bKkIwuL6HW+y68ysfV5eNDIybLmHcPG6/Nsq5f6cLvPlTmZWEycyfCF9MGGqBrR8ygkjCJJYaWgOHG6JkrUc6Ng7T3vg8myyEiCVwKHAe1NINJOGCHHFMhazND7FyD5htVZF9HB4vWEEGMJ8YHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMWGT/2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMWGT/2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DC5C2BBFC;
	Thu, 13 Jun 2024 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281915;
	bh=76T8RUHoJxU7JEN0rClctDDlNKqiSn7FuvvKCon6KXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMWGT/2nC6qtc2UgM29lRGlluaZSxGoOjZ0VUhfHjDx9BpOiDbxcHnNs+DjzypRPa
	 bbKif4mPGKE0rZPOP0uqjnktilw4HiSUtdpcaAQARf0/3FsZ9CxIpMqH4tZMUgvBzk
	 2xycPt0zxq2TfzLT6PTqTVmup9TUoAHXZZZ1bDAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/402] HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors
Date: Thu, 13 Jun 2024 13:30:57 +0200
Message-ID: <20240613113306.037567493@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5916ef2933e27..bbc3ea34585d2 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -212,6 +212,11 @@ static int ish_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



