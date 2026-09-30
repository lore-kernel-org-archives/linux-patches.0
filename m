Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5B2381EB0;
	Wed, 30 Sep 2026 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783181; cv=none; b=giDBGfhEokJM8LHPA9dnwU2VAnzOiYoGfKX3tNnB77H0M4WtMx8X0nonCC3Vq84Tasz0Cd6o5pwWYsNeIBrfUT4j3dsV4V2S1ALVnvp2mQbdmej0zJV6PqKSJjzeydqlAR6f7EgaDvs128KG70VBeDzG1QHamdTxfje5oHI9nRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783181; c=relaxed/simple;
	bh=UWgA6E8kY8g7EF2l+QEJ931O0up4W7E8gYr/JAqwc/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAOlgpO4exm8mi1QJRUHthCZ0BQtfoIaPJ+mJxy/9QEeCazeKG9B6By/IIhUG+bDTeUHrfLCYN4pzzhEFGx/YrM9mve2hKlUKq5nmQjlhxc3eLKTMMdb8y+mpO8hdRkiis94vXPTnAhH2qf6lp/Nve1rQHvsAGIoDmMNSG3TtCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDkbh9mv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDkbh9mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65F11F000FF;
	Wed, 30 Sep 2026 15:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783177;
	bh=29FfXZqEVr3dVZTuU1h975cczYWI61JpUnItlGeqkEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDkbh9mv8A4TFShBkmGbZL88tyYyVlWZ+SoZwM2jWliKMveHvsmgl9WMYj3jYV1Xs
	 ipl7ot9TW9zQvv4g1UOn496mpdf7uPYfL3ogJZBh3Is9IOR8rmKXCyd5kS3ixDcICZ
	 NAwgO1Vv6HJXhcQipGVLDOwI3qPS0tIXIZvurdfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianting Tian <xianting.tian@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/595] virtio-console: call scheduler when we free unused buffs
Date: Wed, 30 Sep 2026 17:22:35 +0200
Message-ID: <20260930152353.344972852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 56b5e65efe0001fb5f95e412ee4167363debfc46 ]

For virtio-net we were getting CPU stall warnings, and fixed it by
calling the scheduler: see f8bb51043945 ("virtio_net: suppress cpu stall
when free_unused_bufs").

This driver is similar so theoretically the same logic applies.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Message-Id: <20230609131817.712867-3-xianting.tian@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 894f98e73983 ("virtio_console: do not free control-out buffers on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 712db89020f31..ed11f3104785a 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1943,6 +1943,7 @@ static void remove_vqs(struct ports_device *portdev)
 		flush_bufs(vq, true);
 		while ((buf = virtqueue_detach_unused_buf(vq)))
 			free_buf(buf, true);
+		cond_resched();
 	}
 	portdev->vdev->config->del_vqs(portdev->vdev);
 	kfree(portdev->in_vqs);
-- 
2.53.0



