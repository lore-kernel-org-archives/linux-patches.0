Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B962509F18;
	Wed, 30 Sep 2026 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785257; cv=none; b=QiPtIMEomt5Cz5Mmhf4kIcqWc1T8vzBXaAfJyCkue0ptHIl3gzevinq6onbTiDXMBPWzR/Dvbew8Bg6KEoDMPMSQXstqlMeIqBQtGr1qlypDRwMbYCeJ8LDQwh9uzM2WXqmq/0FpPkkPzwNAc6Q+TvyM30SV813NvN0FEeTFsAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785257; c=relaxed/simple;
	bh=YJWYKqNpCEvzNQfhGExZJIlYFdRQjN5N7SCfbuzgxnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJbw8JhnRrBCv++y4prwUKL0tjEGhaizVefOzsBVYpFIvsa1GOeXcFtNQinWl6uaPtGvplwmkS+em6RL13HkenXsQ7u2975F5UhK0kR1O8cVp18ECAQwDZwAH9Oa1ALr31abBlBnQazIYtkGPuCjYTQTUlowWR0W4oU2BKeuuBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRMy1n26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRMy1n26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475A81F00898;
	Wed, 30 Sep 2026 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785245;
	bh=3effoMf8uFJ4n8qu3VG7Qtf0FrNBkOPDInim8omvaoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRMy1n26f/ydGFoqIOuQKD7Gv6zmbPwY1wIP2vcIJx1n1dliMEm/3tncv0E3Rgjqu
	 D7WYw20sXPlwXo30F40dyXoNQQ6RQJYWrzYdK6gz+LNi0JHkwsUVItipBtJRKYw5s0
	 9zo99I1ZGbuFk1AiriyxqmESJJobZYUcUoTp+cdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianting Tian <xianting.tian@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/982] virtio-console: call scheduler when we free unused buffs
Date: Wed, 30 Sep 2026 17:19:35 +0200
Message-ID: <20260930152426.223452690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a4786f8108e35..fd3c83ccecc46 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1941,6 +1941,7 @@ static void remove_vqs(struct ports_device *portdev)
 		flush_bufs(vq, true);
 		while ((buf = virtqueue_detach_unused_buf(vq)))
 			free_buf(buf, true);
+		cond_resched();
 	}
 	portdev->vdev->config->del_vqs(portdev->vdev);
 	kfree(portdev->in_vqs);
-- 
2.53.0



