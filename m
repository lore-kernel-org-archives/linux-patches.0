Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C60F1448EF;
	Thu, 11 Apr 2024 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829631; cv=none; b=pTSsZ0LL698AoUjJ2UJ4ARGXNEdXYUB8DRbiyxptSGnnef3zB4V4XvtPzRJxa6q7JZYPZXK8DgvqzCNBaib1m+qqKofH3hiq9qYLXr9naKGK2obh3eCZSbBjs1fczAaMb3M42orftcLO+HO1BsVrIq25cNpV91lqcfzM+JY3h+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829631; c=relaxed/simple;
	bh=ZPvhV4kyoJGDTb032j8gRr4CkdhqSSax5GZDFuxl9wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqhxB/KcvWpJOPVSeZVMVeBx3Pbm38qE3tRI18hhREhZtkuJOxZCUAtK3wirEuyoB8cdTxm6sA7sz3opBPCP1B/c+K4BpYgoy5wXdvCaNXJ79dLfwU8p86gg6AOLJuO3hnaK9ZzId+F5y/tFzxmkLaeRg364BBwOqFL70t6ovVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnfmPHY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnfmPHY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CB9C433C7;
	Thu, 11 Apr 2024 10:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829631;
	bh=ZPvhV4kyoJGDTb032j8gRr4CkdhqSSax5GZDFuxl9wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnfmPHY6dJ0HDH0FW4+Zwyu9o2rkgMfH0raxkfjm9XLaJUjqgdsYAMVFYC7YQ18JZ
	 FG5xxHLVdnKvC/L7w2AlMd1OjVoRHquDsFWsP56suKjgZ/2CiPl8ckFHgKGkm5z+Ub
	 skAZeCbMg2iuTnroZeTwBoJPSLbzImVljv9pf//g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/175] vfio/platform: Disable virqfds on cleanup
Date: Thu, 11 Apr 2024 11:54:36 +0200
Message-ID: <20240411095421.163980295@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 46d4750f43a8d..c53a9b4438733 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -329,8 +329,11 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
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



