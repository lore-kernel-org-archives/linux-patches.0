Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5CC1DB127;
	Tue,  8 Jul 2025 16:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993451; cv=none; b=S/4nxPMeGLDW3XwCQtsXJIzxH1Ml8/8MyypKIIyMs1/LQx0bEmwu9Ksy2vgDPnXEkQA5HuSIlIWUzeSKt6no5bKwRFFJCeSutVaI/l63Ykt2GciFDoeKoMaPfJfAo+s6KXYbHQLS29/EwhPHsDfaUQtNmL+dJqno494dsy57xas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993451; c=relaxed/simple;
	bh=JKUUt/O60q7+K1xfVL0kRYEl3MtqURamu1qL1c/jdUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KtpRbyt9Z9s6Gvzh89DjcEEezIPf8lUq58vUVgGrekGDpeiE/G3g861pX/mzn8Iba9o63V6I6dn4M5gezhUnM/Icgl794XDHPZqiblbXEJ/rB2RS6PLJt1dAJIVC3mfac8yinDafZ2Ta9mn9CBkGgKMou6NW2MldjV7cZUIPsqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjKJ/7MJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjKJ/7MJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C43C4CEED;
	Tue,  8 Jul 2025 16:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993451;
	bh=JKUUt/O60q7+K1xfVL0kRYEl3MtqURamu1qL1c/jdUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjKJ/7MJT8A93McOrOafMK+7y99bi/MsYPIeXC8FDjsMAPgGJde5CkPkYyewAht2j
	 v9qGGq6s6/yjxeVhxzy1SNSJLU0fX9kEbYTPu+LsMz27fj+jvLVWZGa8EEU+44JUhs
	 yIrNU/Ka5VQo0LFBiKq3a4BOtKreqHPH4g1kCuqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 079/178] nvme-pci: refresh visible attrs after being checked
Date: Tue,  8 Jul 2025 18:21:56 +0200
Message-ID: <20250708162238.744181293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <eugen.hristev@collabora.com>

[ Upstream commit 14005c96d6649b27fa52d0cd0f492eb3b5586c07 ]

The sysfs attributes are registered early, but the driver does not know
whether they are needed or not at that moment.

For the CMB attributes, commit e917a849c3fc ("nvme-pci: refresh visible
attrs for cmb attributes") solved this problem by
calling nvme_update_attrs after mapping the CMB.  However the issue
persists for the HMB attributes. To solve the problem, moved the call to
nvme_update_attrs after nvme_setup_host_mem, which sets up the HMB.

Fixes: e917a849c3fc ("nvme-pci: refresh visible attrs for cmb attributes")
Fixes: 86adbf0cdb9e ("nvme: simplify transport specific device attribute handling")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f1dd804151b1c..776c867fb64d5 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2031,8 +2031,6 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if ((dev->cmbsz & (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS)) ==
 			(NVME_CMBSZ_WDS | NVME_CMBSZ_RDS))
 		pci_p2pmem_publish(pdev, true);
-
-	nvme_update_attrs(dev);
 }
 
 static int nvme_set_host_mem(struct nvme_dev *dev, u32 bits)
@@ -2969,6 +2967,8 @@ static void nvme_reset_work(struct work_struct *work)
 	if (result < 0)
 		goto out;
 
+	nvme_update_attrs(dev);
+
 	result = nvme_setup_io_queues(dev);
 	if (result)
 		goto out;
@@ -3305,6 +3305,8 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (result < 0)
 		goto out_disable;
 
+	nvme_update_attrs(dev);
+
 	result = nvme_setup_io_queues(dev);
 	if (result)
 		goto out_disable;
-- 
2.39.5



