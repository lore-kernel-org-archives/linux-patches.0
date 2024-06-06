Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF685197A8F;
	Thu,  6 Jun 2024 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683278; cv=none; b=VzAePgAxS7LJreObbYibNt/BFDaJ3XYyQktpEGbbOyDxACOM3JOHj5++ePPj/RovZtLa6nqzH722iypdRdKOccUcUoPiLv3dPnVcZldXPvCdvZSD8PmUk00VjxaFlzamylHkLqXNFAxajydm2jm5JpVMAMypTOTt/QH/lsBPmQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683278; c=relaxed/simple;
	bh=1Zuje2bv6RLoqafkPF0+iOnpbV9Mcg/GrRwK/RIVGSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq51z3hPG0N7GGHFAf5Maq6vgOnSGWbxci5qtdVxgc6RXCOnAI+xGRuaV45vI9G2DXESqGP216xV5fYDjitDYd/cdsDsmHAMNaoeD2VD98MiUFh6kL2Mucehj1WVNp2pEV2q1OluZp4IZLMuoSqQ12JdjR0Y6v7/gJie1jcWLo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQmQYjdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQmQYjdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9848BC32781;
	Thu,  6 Jun 2024 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683278;
	bh=1Zuje2bv6RLoqafkPF0+iOnpbV9Mcg/GrRwK/RIVGSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQmQYjdmjyOd8IQc9vtniPdjRf1xRAbbvK0sLAkc2Prvmzq0n+M/ymPVc3ls2uKvW
	 kXZXVA58k1KrrgHGM/JjYNQhdlbKpvTVZgOIhG4GGdDyZhNh3r/Z6IOncInSExbELb
	 0BOH92AZbc7Mu5JNWn45EOKkoUJQyobU+3SORdTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/473] HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors
Date: Thu,  6 Jun 2024 16:01:25 +0200
Message-ID: <20240606131705.117408051@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 710fda5f19e1c..916d427163ca2 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -216,6 +216,11 @@ static int ish_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



