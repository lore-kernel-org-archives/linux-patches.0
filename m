Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423C26A352;
	Mon,  8 Apr 2024 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581809; cv=none; b=ggP0A8C22D3i4sKZLqLBSCCEAvFKCaVHAPUubvojQWbZ1JpwZ0FsUO6GQy4ZOv+64l9CZMDXB0q7RG+qO+2MxoNffPGgsM9kPOjC/CXZVKqD9uW5Rfuf5zHzxY3UqoqE2JMcx8HKC0w266loLdY6mZcjkx+VjwkHCvvdcAR1h4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581809; c=relaxed/simple;
	bh=KomyPUEH06kGexQb7mhmO/X2PJ5oPokvQ3DTTH1NZYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQovVEp8a7l2DOhLuaS6fBAKcqcJRjciGtjK+R9veYgDl+nsdpvXyyccy8bsXgRaImqE8OWptOOmqz6ObJ8O/KAPO/9Pj2Sxsw+zA+wchQYzKQ4pCftb/ypyKMV6VwlJml6vRaiTNQ2eMABQcwOfAyFUB0fkwuYlB1k3dmx7x3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXVmCI1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXVmCI1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56E8C433F1;
	Mon,  8 Apr 2024 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581809;
	bh=KomyPUEH06kGexQb7mhmO/X2PJ5oPokvQ3DTTH1NZYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXVmCI1d52MT2I61YmbyCHQTxSOtF/mEuGvo0C6EFXf9oPbXPV9/iqGJnr9f7ZdvV
	 +uAVcGCp2opA2spr3ghMBs/4PwVirQQq182kb/Of5ITeFLV01dnsLa2clIqyo9iBtb
	 Q1hySRh5Czyg91+0pw61w4cgCq9p9vF5TIyyi7yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/690] vfio/platform: Disable virqfds on cleanup
Date: Mon,  8 Apr 2024 14:49:10 +0200
Message-ID: <20240408125402.538656770@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit fcdc0d3d40bc26c105acf8467f7d9018970944ae ]

irqfds for mask and unmask that are not specifically disabled by the
user are leaked.  Remove any irqfds during cleanup

Cc: Eric Auger <eric.auger@redhat.com>
Cc:  <stable@vger.kernel.org>
Fixes: a7fa7c77cf15 ("vfio/platform: implement IRQ masking/unmasking via an eventfd")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-6-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/platform/vfio_platform_irq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index c5b09ec0a3c98..f2893f2fcaabd 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -321,8 +321,11 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
 {
 	int i;
 
-	for (i = 0; i < vdev->num_irqs; i++)
+	for (i = 0; i < vdev->num_irqs; i++) {
+		vfio_virqfd_disable(&vdev->irqs[i].mask);
+		vfio_virqfd_disable(&vdev->irqs[i].unmask);
 		vfio_set_trigger(vdev, i, -1, NULL);
+	}
 
 	vdev->num_irqs = 0;
 	kfree(vdev->irqs);
-- 
2.43.0



