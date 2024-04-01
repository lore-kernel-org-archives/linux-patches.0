Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF047772;
	Mon,  1 Apr 2024 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986983; cv=none; b=KuvFoHV5BxDoKdPuaM6lZNOz4bnR+Rflh2rwhHgg5xCm9WU9hkal1ro6mKu0sqHMkFGgatsQ6BUFoluuzOaqUM2ydIHJ1/cLaDwr07qIfWNPSKK228IwTUy1+TG0WbIFfdeGR8+Kq0+PStQleyqqtwYraoLrGrymvqZjfv4NddE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986983; c=relaxed/simple;
	bh=YUjQOKEZcc1I424CxUN3BRPzSXlVIqnNDSuiwrvrbeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ8iAt3TUEACIbuKqDbgK4tC9xVHNNaJFH97q0t/5t5X1mhqTgW+2uCOqe4NDoH8Tgan7FYZB4oyy6hayGIBFiPVrHh6gDFSnBD0sLW9L7x6pU22DxqmTx0SFZ/XSYZC7/LkrcY1kW5bnESlRpUfF1PWc1It8JG+pC2xvcTwTnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMFJiXnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMFJiXnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32A3C433C7;
	Mon,  1 Apr 2024 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986983;
	bh=YUjQOKEZcc1I424CxUN3BRPzSXlVIqnNDSuiwrvrbeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMFJiXnR5VmTjQu5cSluFhGvIxwRiaxhlZojQySLJr6Q8fuW4hvRfj84rMCRIspYC
	 h8F3AvHAGZFgcYytKnWZ3Eg5SlO2/Lg199/sd46BJe2pVO/TiwDi72BPIydD6v8OIW
	 CLN6pPhFHyxthM2rWTnOD5TeNGA7U7QEZUZjztes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 148/399] vfio/platform: Disable virqfds on cleanup
Date: Mon,  1 Apr 2024 17:41:54 +0200
Message-ID: <20240401152553.607411446@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
index 61a1bfb68ac78..e5dcada9e86c4 100644
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



