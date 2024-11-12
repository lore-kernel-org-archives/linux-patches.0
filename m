Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0A32123EF;
	Tue, 12 Nov 2024 10:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407666; cv=none; b=cGrzFrL0LKxQDu0wbzOiO1Xsnmx4lKNiqLqOt8IflteP7Bd0/aw9bluVTAHBy7MIT0jFTCeZ/pjU2iuJ8f4dH9DecPcx0zT/GbZ3C628b3KppF5GnQeneUm6UjH6W1QLvz/Veh6ART78gGDeyKqwVlikynpB2FTI84L55KOWZkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407666; c=relaxed/simple;
	bh=quTFI4HZHBS5oG1NlN3vVuZ3dGFLktKKWAdoLTvzcyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaoCb4b3V2F6x0ak2WeEPgJzUtfbKrP+kJc6iAsAiRPY4pxppSr1C21wIFByXVNOF7/lBWgQnlyvpMfh7MLBXFXmx6nm98yHM4kPJjJkXv/0JMRftA/h7hqAdBjL5tHI19sHUlGe2+pnLpfyP7my1bl9H7ZJF6YnR4UYl1QYmXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+DNDfRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+DNDfRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D4DC4CECD;
	Tue, 12 Nov 2024 10:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407666;
	bh=quTFI4HZHBS5oG1NlN3vVuZ3dGFLktKKWAdoLTvzcyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+DNDfRNns7DKe866Jf700mr+QI1rhw4RowCfzj8rA+7k3QTMPgnOfBRLj6WaqmMb
	 tbMHsSdovl7MqJqnBiic02hcQ/yMjxBv25lGw9rvbNIi5wduiUGNRQdJrrn/7J83oB
	 jDp8Cifhvule7qxai1y4y0UowOgGcU6RWW31mSfA=
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
Subject: [PATCH 6.6 045/119] virtio_net: Add hash_key_length check
Date: Tue, 12 Nov 2024 11:20:53 +0100
Message-ID: <20241112101850.439367824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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
index 2da3be3fb9423..426c05d5b1381 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -4549,6 +4549,12 @@ static int virtnet_probe(struct virtio_device *vdev)
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



