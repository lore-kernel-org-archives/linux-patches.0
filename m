Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB3C197A8F;
	Thu,  6 Jun 2024 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683284; cv=none; b=lel5bMUdqhV+5OWr7C5J8g5xLGUOKrc0fnnln1q5MFhZOz8XPlvC/dO6+cuhWgf1hO9EQ72tL8u0Yg718CF8+wVZfVDZHnAuvBZI8S1BYqMbA10IFwMBadHB5AaRQv4BgbbIFCT9w6aDvtfqGKZGXT/TT35c/v1j3ZnIIFNbbm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683284; c=relaxed/simple;
	bh=ZA/tkY6vVjQ70nU5ngZQs5iMYMsMOApoMcFs7yfhn1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWRW8Y+xCKxxGFj7hZ5BrewU9S5ThGngQe83dk99QIeB/lCJaagOa1qMcRxQLAeq0n7KAVBWKCXc6HqVkZ7X5fFJHlZzu9mofT1WyQzt/EZDP2Z1oqr3P/tXI9wqRfkvAvomgCUQ/BjyL0GtFT3saygETIzhDBLy710aI5cqUic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tRXogX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tRXogX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9414C2BD10;
	Thu,  6 Jun 2024 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683283;
	bh=ZA/tkY6vVjQ70nU5ngZQs5iMYMsMOApoMcFs7yfhn1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tRXogX3TEHlx3mxsylLSSLNpcwsT9WpBIHLYMt0Z2N/v5DXArEpq0EoLEu7QumYQ
	 QK2O7JOBeubvOLAHcRIPfajUsLznahH/NmrHVuBs3TasjS9P5VcLgFDsPARQMCZJaF
	 XavbNt+6CbVwnadmS0Tomz/LgudBn7w65OmvBjgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/744] HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors
Date: Thu,  6 Jun 2024 15:58:17 +0200
Message-ID: <20240606131739.614417963@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



