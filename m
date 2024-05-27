Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408B015ECFF;
	Mon, 27 May 2024 19:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836865; cv=none; b=LxrT0b9akF5SUZ/U0wNzQgkmJY5lZZ7pHd5htwhcxMRPxVz2uYmK17F9gc7YzQulff/jc7LRl3T1rzA6kPn08Y7mIFsg1B0v5hKFo8jL9tTlCa4cvKmFO1yKMfPWUiclzMAivC1+uZSB8oCzgIkg9RSe2deYHDS15qnMkRQj/RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836865; c=relaxed/simple;
	bh=G/JzLtCoHXnjY6DSVLRAFMF31eGCn6/+2H3ITxC51xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW6Yw8fIwxqEb1Pr4ydhB7J5cp8BYv7HF2uciMov3h6owCLrIeOxGuvYYIwCBw6ixhcaOsDalE8+T1cQh2FmyLlpkBSOEEJbQpVRE4QGa/F22NiTQdOAb6eAn+k/ohb64fid7L7AITPIVXTJfoC613ombo3XbEeAC/TgdHG4esM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZDDzaLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZDDzaLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5D2C32781;
	Mon, 27 May 2024 19:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836865;
	bh=G/JzLtCoHXnjY6DSVLRAFMF31eGCn6/+2H3ITxC51xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZDDzaLhbZpVcNwd2VwoNI1L3s+lYUTJuS1/6g+OyOfcjplU8QRALQo6lhwqBW/o7
	 AuAl5uV8ZAKPSEvn59kuc7xZfW7pykNjhW1YAV1+dm8tc4OCBq6sOH8L6EHzgOpZb5
	 NotA2kJcKXTviTemewCkQ2mWaerLxSnIFscG+omo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 217/427] HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors
Date: Mon, 27 May 2024 20:54:24 +0200
Message-ID: <20240527185622.783751988@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 56bd4f02f3191..4b8232360cc46 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -173,6 +173,11 @@ static int ish_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



