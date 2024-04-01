Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A4D481C6;
	Mon,  1 Apr 2024 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989706; cv=none; b=msVk3Z1RSYdQIuvm6igHBZcP35I6K9qGWHqhvHmtHcwEebGiZ9MV8XD02wWzCYvosB1LzVuDTO7Yqiqq0d+4cBLMF/SJ9H8ggYi/S/gSfZ95vcK7wgPCu26VD9AFqiBSlt0ym/Fz2n9cgt9+qNV52cTPdXeh78aOr0mj8dD4atY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989706; c=relaxed/simple;
	bh=eQmbf1RMPKDY5zXnSJjfIVDpKA/kZvsTJhBReluHeHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPyh0uhfpfuaHmtBm3LOi/sqBjMMWXLfrkkG8fw5xGjElHhyu0MHCpsiq3k/tQ7x8xB9BJ7l2gQBpJlyt3ikNE/SAY3nIubb6tmgmnleXSb0NqQ0q3Yh87NsXp6GWE7Ldl3eVAEY3WJ5TSZLc5iBdNFMhdoO/Hm2pnul1RozwnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCbW4AwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCbW4AwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1807C433F1;
	Mon,  1 Apr 2024 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989706;
	bh=eQmbf1RMPKDY5zXnSJjfIVDpKA/kZvsTJhBReluHeHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCbW4AwXbWWz2lW6Fu6tFDaGEyPz5Eapn3lbhcqFjy4FjudgOOMgp7qh+xbFUYOhU
	 beCtepzYLWm8K1uGUIzOSqtGAkl7dpWcQOim8Ne6WantutLtItNFhf3sgUDio8Ok/i
	 GphQ6zXIXNIVhxeoN/34iA0pqIV3qOotw/n96nOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/396] vfio/platform: Disable virqfds on cleanup
Date: Mon,  1 Apr 2024 17:42:58 +0200
Message-ID: <20240401152551.763361081@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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



