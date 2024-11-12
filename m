Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628D420E31D;
	Tue, 12 Nov 2024 10:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407291; cv=none; b=sMRgd+DJaN6vyhI4frZ7OdINnlNCUxd5q5ZuHPjvuP+N9xif6/uGdp3CGetWLYza1iHocsEGReSSHqZHsO5BHBgrAoklejonqSH+fVZ/I+Q5XMas63hPEu9ZqVrhTM03sVKklYPY3asxj2A4jM4dA0lWtG2+v7VeWp6DBiPZB4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407291; c=relaxed/simple;
	bh=aYJtXjncOrRkWtwB4tkpl8jgR/LtvadlQurqc4A3MCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7DbgcStV5/qWqc8YhDE/HLIH014RKLILWQVaW9yjHNVAf1xJpR59Zcsv8YvUEl9wC//y4v1bik4jnl822n5J7NoZEJOhlZP97OGbOydL6qNWi9V9czN2vZ1O5+jxs+2A1Mv6F0JM2Ha4oSuo51Kt/UMRKORdru/iKsMpBPEz8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjxLKw9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjxLKw9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FEEC4CED6;
	Tue, 12 Nov 2024 10:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407291;
	bh=aYJtXjncOrRkWtwB4tkpl8jgR/LtvadlQurqc4A3MCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjxLKw9vmXOmZ4O2yiZuB8n0h9kenv9zyAWVpgE1MQYtGpWu0SIqiMBgTrMEhVqJT
	 aj80B3XckDD8C8PfSWOQ/ySyop/iiP0IHcN1lLDAsUJv778ciEGfPx/4uaVfJ1k+Yi
	 zrXurEc0cz4fP/3o+f2x4UxGH++sDPp30BRyhws8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Joe Damato <jdamato@fastly.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/98] virtio_net: Add hash_key_length check
Date: Tue, 12 Nov 2024 11:20:46 +0100
Message-ID: <20241112101845.459123043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit 3f7d9c1964fcd16d02a8a9d4fd6f6cb60c4cc530 ]

Add hash_key_length check in virtnet_probe() to avoid possible out of
bound errors when setting/reading the hash key.

Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Joe Damato <jdamato@fastly.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e3e5107adaca6..11aa0a7d54cd7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3887,6 +3887,12 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (vi->has_rss || vi->has_rss_hash_report) {
 		vi->rss_key_size =
 			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
+		if (vi->rss_key_size > VIRTIO_NET_RSS_MAX_KEY_SIZE) {
+			dev_err(&vdev->dev, "rss_max_key_size=%u exceeds the limit %u.\n",
+				vi->rss_key_size, VIRTIO_NET_RSS_MAX_KEY_SIZE);
+			err = -EINVAL;
+			goto free;
+		}
 
 		vi->rss_hash_types_supported =
 		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
-- 
2.43.0



