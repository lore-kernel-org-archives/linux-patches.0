Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C7120E325;
	Tue, 12 Nov 2024 10:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408094; cv=none; b=s+gnc2Umz8oATPvqxTcqE5B3gchUvkU3QSSqlyQFFYZTvxxW5CjO5Su7tRPVhfm8S0hYfbvkmAwB5wIbq8Rb2EPlzGH7LQCYtmGyYiAZshjtvmXf51MuaV6vPvNJpdATZ98IdBSgOsSY3HVPta0xDAY4KdUl+lWZjts9sBB/qps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408094; c=relaxed/simple;
	bh=wbm1thDBnvNrVjdjlRAI540VGoDDyttTl3oPgzSiLXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5YeTJb3N+ekiAsODyraGWbxWyoqtMZNMRtZ06A7B8Py6jMjYDNj909LdTlOho7IUFzhRfBvOYqzU5ooEK/eGnV18eas0ONdoTtNTZgfOahtFa7refPUAMJMAyEzH9KvbtVfIRfzuIGF8hpW2ism62uwi6uN2EyLyEeiIF7p4e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmBiXz8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmBiXz8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEE4C4CED4;
	Tue, 12 Nov 2024 10:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408094;
	bh=wbm1thDBnvNrVjdjlRAI540VGoDDyttTl3oPgzSiLXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmBiXz8XAjuFiNMWWu0W4F6wR/WSRCa1wv5mCgJQm3HYXsJn1uf6bopS328lUIsCo
	 76EQjvnZLBUg7zegH0weWV5iVcpLVc1yh2NboJEfyLOMdGJ9AvhNxT5IBjuwWd/7uR
	 G3q5jRX58KSU3SxtPP+PrhoGQRvcyhj00nKQtrUA=
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
Subject: [PATCH 6.11 056/184] virtio_net: Add hash_key_length check
Date: Tue, 12 Nov 2024 11:20:14 +0100
Message-ID: <20241112101903.010953018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4b507007d242b..545dda8ec0775 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -6451,6 +6451,12 @@ static int virtnet_probe(struct virtio_device *vdev)
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



