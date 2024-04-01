Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F41C0DE7;
	Mon,  1 Apr 2024 17:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990914; cv=none; b=YpMvoDzcD2go05MdFt/Ha/AzT03Pi6zPC/cwJTZRH1dOIVw8IU4KJAmToYsoS9pZi1tznR578awOBgoDKf7K8h3HxqkWp1nvOUiBiasUx2YfhrwzN5yveV+2F/YMexK/BS094Ly0e8s2LRdWSUVgyQK7H2q4wQPJnG8A19jPkzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990914; c=relaxed/simple;
	bh=+FW9FZEAk9tq0QZBFeJCZUuaaZWOg38z6PIZnKjnuBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwb/uL64/KL496bZdAAfw8uwqniRht3rnW11LW8qOHlrh0oLeU+8+Yn27/1ukVntRVUplmLzu67MQCWGQv4eSjzKfkWv5ZS8tJrRs7HYy5SRY1QJyzBgL4CqWxztAWKCk7vWII3vq4tPISCVmf+zVTzMS0aLCzyxCNHShzg8P9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDi5Yt/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDi5Yt/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA77C433F1;
	Mon,  1 Apr 2024 17:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990914;
	bh=+FW9FZEAk9tq0QZBFeJCZUuaaZWOg38z6PIZnKjnuBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDi5Yt/O+EZQ/XrNyD9vlGa/CKC6Ec3OG6MlGzWdlEB089zFDcQgfAabCe6KsOOG4
	 uQmCtDUR0K3v6aaazYdtPNGGA1Yu/QhGBwmvDvOgXNdYUGsMIko40hnUMIk8DPnIL3
	 6bz4Aew4Ghfr94GeU9p0Pu3GebpK8+lrCcVfGymE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/272] vfio/platform: Disable virqfds on cleanup
Date: Mon,  1 Apr 2024 17:44:55 +0200
Message-ID: <20240401152533.916784205@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



