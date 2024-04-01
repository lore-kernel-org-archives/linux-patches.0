Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE04383BA;
	Mon,  1 Apr 2024 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987168; cv=none; b=ItLPf9PnVw2eJdQqlpKRnldBR2bdfiSGa6MDlBl03YSXHzRYMAUIhcHjB1R6pfRffrawbb9Mv7ABZyQUH5yGROgN8hzwWi0h86Ps/T5hK4Iyi5PSRBVvwjdMuIggA23R6LXgzsMQHsOq4oBHGIDLbD3wS5NPbxDJ7lwvDO9SET4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987168; c=relaxed/simple;
	bh=6bZuzsEiRDf64uhIU1u+U7cgn2S2AZIWoZOuBiDUYwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqjbwqeNyYz8jlDweKS5FQLXqbUFrvygRA1i7hDOF/SGuiXVqkF2XfVdYvAwoZDcXZ8Gwi6zJ704o/rCmScfwnr3f2SPOtCiuRfERV5Azb19dyCV6owFtuefRF35zuxvhDVQZh3RhfbMIhNEewPo/wQ2UB6uvYu5Znm4E7+ns0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJtIPR/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJtIPR/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE77C433F1;
	Mon,  1 Apr 2024 15:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987168;
	bh=6bZuzsEiRDf64uhIU1u+U7cgn2S2AZIWoZOuBiDUYwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJtIPR/g1ML1qz5xKCXebYm3+33qx381++5ZvYZvrthKoW0fgS2JeHy6h5MGIXkPi
	 ySe6rYWiopGK9JavkCW7YV9hh2g8Rl8DR/qoZNlDbtSL1FVAZ7YfNPU5P/y+hSey/k
	 JDgSNBRd7WnnWni6PTqZCFcGmBXVMQSei1a7Qlz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 197/399] virtio: reenable config if freezing device failed
Date: Mon,  1 Apr 2024 17:42:43 +0200
Message-ID: <20240401152555.062123358@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 310227f42882c52356b523e2f4e11690eebcd2ab ]

Currently, we don't reenable the config if freezing the device failed.

For example, virtio-mem currently doesn't support suspend+resume, and
trying to freeze the device will always fail. Afterwards, the device
will no longer respond to resize requests, because it won't get notified
about config changes.

Let's fix this by re-enabling the config if freezing fails.

Fixes: 22b7050a024d ("virtio: defer config changed notifications")
Cc: <stable@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Message-Id: <20240213135425.795001-1-david@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index f4080692b3513..f513ee21b1c18 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -510,8 +510,10 @@ int virtio_device_freeze(struct virtio_device *dev)
 
 	if (drv && drv->freeze) {
 		ret = drv->freeze(dev);
-		if (ret)
+		if (ret) {
+			virtio_config_enable(dev);
 			return ret;
+		}
 	}
 
 	if (dev->config->destroy_avq)
-- 
2.43.0



