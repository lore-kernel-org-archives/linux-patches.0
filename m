Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C012E274FE3;
	Mon, 13 Apr 2026 16:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096841; cv=none; b=on78DQhidKeIIbMU2wJkEdShIrqlvdngoRlxWu1OArcklYNTN2JwnQsOVaMynaMyak1O9Z9c4zGKnxQakmuk0WRddvNfLSttDGxO8O1N5wY9QxRRm2iq+h2LSXQ86GtoAFvdPaR047biMoVNtW/ZYLXToUjUAtB8HvWUwjtwklM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096841; c=relaxed/simple;
	bh=pZiwilJF1rWmkxZKIHnUHyXoOGg9HHk2+NZ44eQc69k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NA57Pl+ZZveXTRJU/1Fzogk/xj0QLNjE2CNciR8IEupCuHAn8Dwqz5S6bp/0eYBHLvYPQqNgR/gu1b8KZeiBslWj7rsyRYSVk4uGyYM5XjDwVHMevdsUQUJ9SmJ1MkcmB2DXRbnfXDK1qOp5RKnE6PjxvRVrqNUCpmF59vcKNso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy+dmXeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy+dmXeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541F6C2BCB6;
	Mon, 13 Apr 2026 16:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096841;
	bh=pZiwilJF1rWmkxZKIHnUHyXoOGg9HHk2+NZ44eQc69k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy+dmXeM1OWfwY03kEIHzt6kOsrE5Ti464zX/7Yq5Fc6CU/9lYgRh6gUQd2Y+dAsb
	 1A/xbo9bQJwff+RPtlx3l4R7CxkUafd7dzPb0FLAzaRB6GfAw77EarK3W3N7piTaO7
	 22MzWdZCMkq2GcfZRjvW0o6gLslE/TDufVX2yWhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/50] virtio_net: clamp rss_max_key_size to NETDEV_RSS_KEY_LEN
Date: Mon, 13 Apr 2026 18:00:40 +0200
Message-ID: <20260413155725.004505927@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit b4e5f04c58a29c499faa85d12952ca9a4faf1cb9 ]

rss_max_key_size in the virtio spec is the maximum key size supported by
the device, not a mandatory size the driver must use. Also the value 40
is a spec minimum, not a spec maximum.

The current code rejects RSS and can fail probe when the device reports a
larger rss_max_key_size than the driver buffer limit. Instead, clamp the
effective key length to min(device rss_max_key_size, NETDEV_RSS_KEY_LEN)
and keep RSS enabled.

This keeps probe working on devices that advertise larger maximum key sizes
while respecting the netdev RSS key buffer size limit.

Fixes: 3f7d9c1964fc ("virtio_net: Add hash_key_length check")
Cc: stable@vger.kernel.org
Signed-off-by: Srujana Challa <schalla@marvell.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260326142344.1171317-1-schalla@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ changed clamp target from NETDEV_RSS_KEY_LEN to VIRTIO_NET_RSS_MAX_KEY_SIZE ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -4465,6 +4465,7 @@ static int virtnet_probe(struct virtio_d
 	struct virtnet_info *vi;
 	u16 max_queue_pairs;
 	int mtu = 0;
+	u16 key_sz;
 
 	/* Find if host supports multiqueue/rss virtio_net device */
 	max_queue_pairs = 1;
@@ -4589,14 +4590,13 @@ static int virtnet_probe(struct virtio_d
 	}
 
 	if (vi->has_rss || vi->has_rss_hash_report) {
-		vi->rss_key_size =
-			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
-		if (vi->rss_key_size > VIRTIO_NET_RSS_MAX_KEY_SIZE) {
-			dev_err(&vdev->dev, "rss_max_key_size=%u exceeds the limit %u.\n",
-				vi->rss_key_size, VIRTIO_NET_RSS_MAX_KEY_SIZE);
-			err = -EINVAL;
-			goto free;
-		}
+		key_sz = virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
+
+		vi->rss_key_size = min_t(u16, key_sz, VIRTIO_NET_RSS_MAX_KEY_SIZE);
+		if (key_sz > vi->rss_key_size)
+			dev_warn(&vdev->dev,
+				 "rss_max_key_size=%u exceeds driver limit %u, clamping\n",
+				 key_sz, vi->rss_key_size);
 
 		vi->rss_hash_types_supported =
 		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));


