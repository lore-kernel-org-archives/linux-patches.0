Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E41A3167;
	Wed, 17 Sep 2025 12:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113879; cv=none; b=p6+mYlSsbyxHvraLDXyDgFe9hc/3n6IJUQz7TOnm5pgdzH209hLOBYoUZUj1DgiJZoFXVJz1TGNpvjb4dQLBYZzYEGKY2UVRpM4rOMR3uXhmoUiXCFZDad4hryqeBeIZ6+E1ZWfimnydsoOeLnq6lI9kY4N8NbRuY2VFZETp0Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113879; c=relaxed/simple;
	bh=I5gC/ui3MCJcKTWQiCovPlXYLYugq2Z/sI2iu404YJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c02rBSLcUgUAv8c18Zo6jDp8bvJqs3NZ1CW0Z5r4nrneBJgM/F76NltUzSFOByBCh41YrfNSeBqCLbT7/ynmLTT4zWDNFhd2Shq3F7LVdNfdlLjv8ymxsGtn6a0yCo6X1KkCfpkmjgdlHlONpiDrAq7w+NPoIn5oklVXQ8XVgbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFospepG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFospepG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363A3C4CEF0;
	Wed, 17 Sep 2025 12:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113879;
	bh=I5gC/ui3MCJcKTWQiCovPlXYLYugq2Z/sI2iu404YJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFospepGpina+C1R3EdUDA4vYFM5AUZgGK8kddLLAVzKJ/Izc6CqJnuVInWbJi/D/
	 /JuOn+x8K0Iq09vwSh4gEKItX7wTTssv6pBAHy3hqEMHsXPmn2/lG3AHG5neHzUWUR
	 4OW3J2CIrxmCfq8F1x+J82MQoV0IfDXBUdMevFkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/101] dmaengine: idxd: Fix refcount underflow on module unload
Date: Wed, 17 Sep 2025 14:35:05 +0200
Message-ID: <20250917123338.817246725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yi Sun <yi.sun@intel.com>

[ Upstream commit b7cb9a034305d52222433fad10c3de10204f29e7 ]

A recent refactor introduced a misplaced put_device() call, resulting in a
reference count underflow during module unload.

There is no need to add additional put_device() calls for idxd groups,
engines, or workqueues. Although the commit claims: "Note, this also
fixes the missing put_device() for idxd groups, engines, and wqs."

It appears no such omission actually existed. The required cleanup is
already handled by the call chain:
idxd_unregister_devices() -> device_unregister() -> put_device()

Extend idxd_cleanup() to handle the remaining necessary cleanup and
remove idxd_cleanup_internals(), which duplicates deallocation logic
for idxd, engines, groups, and workqueues. Memory management is also
properly handled through the Linux device model.

Fixes: a409e919ca32 ("dmaengine: idxd: Refactor remove call with idxd_cleanup() helper")
Signed-off-by: Yi Sun <yi.sun@intel.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Link: https://lore.kernel.org/r/20250729150313.1934101-3-yi.sun@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 3a78973882211..163a276d2670e 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -904,7 +904,10 @@ static void idxd_remove(struct pci_dev *pdev)
 	device_unregister(idxd_confdev(idxd));
 	idxd_shutdown(pdev);
 	idxd_device_remove_debugfs(idxd);
-	idxd_cleanup(idxd);
+	perfmon_pmu_remove(idxd);
+	idxd_cleanup_interrupts(idxd);
+	if (device_pasid_enabled(idxd))
+		idxd_disable_system_pasid(idxd);
 	pci_iounmap(pdev, idxd->reg_base);
 	put_device(idxd_confdev(idxd));
 	pci_disable_device(pdev);
-- 
2.51.0



