Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E81B87F2;
	Tue, 12 Aug 2025 18:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022817; cv=none; b=EW3KZPSYyuCp9bdaNx2wxGxke4EpzJ9EfXDpSbvM4RL+F2dOwJdozklbr/sstZzlL9L1Ajn9fSZIkHzLhLP7UggX9mTu/2RQPLyE5B9wnGWXrsG0SkeRpqR9nUHSwDAxhvGFDvnzgQOST5PMkB7G8GtRBG9yJ0U95TNpwZC1Ycw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022817; c=relaxed/simple;
	bh=HCIrmASAnM4vNpr3k6T1Isich30iXqyS5EILZ9RhwQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quObs5XN2WxGTWt9/axfyaCY1WmBHo/MKLQ8MdoAIwlpYMKwc/VcHPkCvq83mq8rb63wgE63kAjY4aCaursKbZfnRgI+5t9r7T6v2K5nc2pqbsIN1qOQLbzyqC9Y/K48/9B3VylGdpSQ36RUc5Jun9X4xBRuCYmGgQA4oNYSKwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWRf7TtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWRf7TtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC36C4CEF6;
	Tue, 12 Aug 2025 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022817;
	bh=HCIrmASAnM4vNpr3k6T1Isich30iXqyS5EILZ9RhwQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWRf7TtSuU5pId2E4RVJWutS2TEuHEkudSq72pz2sr1aCqYh2XiAzqa7ecl3KcYh2
	 lCFMbNgjU9w+nJRp6LxyNHF9xlrQY/k7Tg45UyBShC6hoqd58BDIdWUOYTZb+9WxCA
	 5C876TUPaeZenz3H29KEZthJrv+U0iEZP2m7iZwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/369] vfio/pds: Fix missing detach_ioas op
Date: Tue, 12 Aug 2025 19:29:24 +0200
Message-ID: <20250812173024.806662348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit fe24d5bc635e103a517ec201c3cb571eeab8be2f ]

When CONFIG_IOMMUFD is enabled and a device is bound to the pds_vfio_pci
driver, the following WARN_ON() trace is seen and probe fails:

WARNING: CPU: 0 PID: 5040 at drivers/vfio/vfio_main.c:317 __vfio_register_dev+0x130/0x140 [vfio]
<...>
pds_vfio_pci 0000:08:00.1: probe with driver pds_vfio_pci failed with error -22

This is because the driver's vfio_device_ops.detach_ioas isn't set.

Fix this by using the generic vfio_iommufd_physical_detach_ioas
function.

Fixes: 38fe3975b4c2 ("vfio/pds: Initial support for pds VFIO driver")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20250702163744.69767-1-brett.creeley@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/vfio_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 76a80ae7087b..f6e0253a8a14 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -204,6 +204,7 @@ static const struct vfio_device_ops pds_vfio_ops = {
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void)
-- 
2.39.5



