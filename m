Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F4247A57;
	Mon,  1 Apr 2024 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988302; cv=none; b=XrZMmPqmhdgpxhKdfE12fUf3x4hcO82R1WdQuq3LIHJ//iu4yyYxpHSNy0d6RxheoAhl91sRqFr1FXTmOh0vYr1kFX4783SzTIyT6Q05O41c22E/8Vbu/Uo/D8iCIojUtbxmi8jbgw9zZCPleCMSFKoVEda/nP4P+v5H0qeNGsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988302; c=relaxed/simple;
	bh=oxtVSWn6GtB83tkcF3jiCaitcY+CQymkF6iUMA51764=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlhBrEprA/42eHwjOlBxYPIuLTGeVHXhK3i3lXHZrD2H3Dm7YooDzl9VorAKZLBIiMewZPhQF+YBt8WQdyACwVmYKa4/vsl/0iBtDho+tzM+qUPs/OUkskl5T/aWOVRqL13truRoe0TbITHiVSnFFQ06ZwNlLTnf3uqQ5jDMNCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CS9Wdi1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CS9Wdi1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73315C433C7;
	Mon,  1 Apr 2024 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988302;
	bh=oxtVSWn6GtB83tkcF3jiCaitcY+CQymkF6iUMA51764=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CS9Wdi1ua01Z7RlaIIZiUFqMZ68I6ftJnTiYTs/LkkmX0LKUh3IT4ibWY63Iy5o/1
	 Uxa/qtcwa3VXr5PtB0Wes53VCDygGFVgfTEN1t+6+qDELignTXe/7jDFJIQnGewnwG
	 7Ypl9+ogudaEPNs4rABUUNyNzWEr6FcKii87hwfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 145/432] vfio/platform: Disable virqfds on cleanup
Date: Mon,  1 Apr 2024 17:42:12 +0200
Message-ID: <20240401152557.459034708@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 665197caed89e..d36c4cd0fbda3 100644
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



