Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF371262BE;
	Mon, 27 May 2024 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838150; cv=none; b=FHVQln6bDUDWlaIe3KMCj9bAOzpho61z4qHDXVrd4bCavzf6vqX4g519PgXwqa1DOo4256EOO/o6HUx/h6Vu6+kz+F2kWLwXZDaYtqhNahvk4B5Hw5CosBuBWjaePkY3bEekVuwZP4hqURvM2VWfVF285kvh6RF6DvnGgb9dXok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838150; c=relaxed/simple;
	bh=C1TzCSO4XRDQCimGvwBmnWMnyiAPp+uNHJOMeGGFXoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjtmkAn9+DzLX3bey17X7nOczi1N2iJvisTIv2t/+gtc8g9XiDzacVQkEHMGvBzfcrvb8MV2QAKdyCsuuCuaT9g1tTIJBtYQl3HkuewYz6/OZ9V7syTxt2pVRtvWYXpUweQ8jEUw9t+aSl1q/njas5619apQoMCytk7Pq6j/0oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUy3SMox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUy3SMox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F1FC2BBFC;
	Mon, 27 May 2024 19:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838149;
	bh=C1TzCSO4XRDQCimGvwBmnWMnyiAPp+uNHJOMeGGFXoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUy3SMoxdFzgFwVA6oVC5a5ZixpEJU4NKAmpA5qaux2kCFznX9hPMACzRzo6LbQ7z
	 mf9vIB/3SEUVmCZAaufVFNfKVWlGJIdLWnyAbnQGCZf0O4ssO5tjBA3Q4JkuvEOyIs
	 +RlA3FX2IjYhcK5peF+pmzm03/anhrtcX9WB5HHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 285/493] HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors
Date: Mon, 27 May 2024 20:54:47 +0200
Message-ID: <20240527185639.634173648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 65e7eeb2fa64e..ce5576ef3c861 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -172,6 +172,11 @@ static int ish_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



