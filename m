Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6680143C69;
	Tue, 23 Apr 2024 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908660; cv=none; b=nzwSggJYdE9c41x5hrfOC/lshDlTsQ64ThEym/T2ZnAdoK354k3vRejL6HHlf6EpQmFHJyGiFjcfvvLZqMbAoOmkaf+JsJ2GgSuXgSOJAdAi7xvFs2emcA2/FjgAbJO6+B0QCmimdfx7iUd8HEaQicjHoBHzpfoFvqF0YuuAUIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908660; c=relaxed/simple;
	bh=UjoA6V0036zekFPRJZHvdkpX+1cdG39k2bgLXgJFrkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqc+SIu3EMZ/fzTrOQJqYHHGEGVDXDDzlufHNlk97risKN4LtTADN0ewk9Tsw2gZA8RyZuudk9WOpkUidIEHtOFybv/nWIYhAmwxUBKJRFfrJS9Q46SKGDQ1yaI2V6cVmuHDyIX7jR0U4APzDbKDG39QJTZtSGXZqjMtl9/EYMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1L1CPTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1L1CPTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A239C116B1;
	Tue, 23 Apr 2024 21:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908660;
	bh=UjoA6V0036zekFPRJZHvdkpX+1cdG39k2bgLXgJFrkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1L1CPTNKSyXJ8WEyxYmUIw04+7p0v/+Bkl+Io4Fqr7y7Jg5tZ5Rh6csHyUnaQBle
	 5YZVjgoWsGOvUhRX0/zm/d2AzKO9gAAQ8YTcOqzbvXQD1gKS9F5iBllZ/8qMup+DfE
	 tEIdqX1xioKzGSQ3pJkQJp+EqleTkGg/pQQ8kEU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qemu-devel@nongnu.org,
	Breno Leitao <leitao@debian.org>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Vlad Poenaru <vlad.wing@gmail.com>
Subject: [PATCH 6.6 152/158] virtio_net: Do not send RSS key if it is not supported
Date: Tue, 23 Apr 2024 14:39:49 -0700
Message-ID: <20240423213900.607828253@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 059a49aa2e25c58f90b50151f109dd3c4cdb3a47 upstream.

There is a bug when setting the RSS options in virtio_net that can break
the whole machine, getting the kernel into an infinite loop.

Running the following command in any QEMU virtual machine with virtionet
will reproduce this problem:

    # ethtool -X eth0  hfunc toeplitz

This is how the problem happens:

1) ethtool_set_rxfh() calls virtnet_set_rxfh()

2) virtnet_set_rxfh() calls virtnet_commit_rss_command()

3) virtnet_commit_rss_command() populates 4 entries for the rss
scatter-gather

4) Since the command above does not have a key, then the last
scatter-gatter entry will be zeroed, since rss_key_size == 0.
sg_buf_size = vi->rss_key_size;

5) This buffer is passed to qemu, but qemu is not happy with a buffer
with zero length, and do the following in virtqueue_map_desc() (QEMU
function):

  if (!sz) {
      virtio_error(vdev, "virtio: zero sized buffers are not allowed");

6) virtio_error() (also QEMU function) set the device as broken

    vdev->broken = true;

7) Qemu bails out, and do not repond this crazy kernel.

8) The kernel is waiting for the response to come back (function
virtnet_send_command())

9) The kernel is waiting doing the following :

      while (!virtqueue_get_buf(vi->cvq, &tmp) &&
	     !virtqueue_is_broken(vi->cvq))
	      cpu_relax();

10) None of the following functions above is true, thus, the kernel
loops here forever. Keeping in mind that virtqueue_is_broken() does
not look at the qemu `vdev->broken`, so, it never realizes that the
vitio is broken at QEMU side.

Fix it by not sending RSS commands if the feature is not available in
the device.

Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Cc: stable@vger.kernel.org
Cc: qemu-devel@nongnu.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3570,19 +3570,34 @@ static int virtnet_get_rxfh(struct net_d
 static int virtnet_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key, const u8 hfunc)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
+	bool update = false;
 	int i;
 
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
 
 	if (indir) {
+		if (!vi->has_rss)
+			return -EOPNOTSUPP;
+
 		for (i = 0; i < vi->rss_indir_table_size; ++i)
 			vi->ctrl->rss.indirection_table[i] = indir[i];
+		update = true;
 	}
-	if (key)
+	if (key) {
+		/* If either _F_HASH_REPORT or _F_RSS are negotiated, the
+		 * device provides hash calculation capabilities, that is,
+		 * hash_key is configured.
+		 */
+		if (!vi->has_rss && !vi->has_rss_hash_report)
+			return -EOPNOTSUPP;
+
 		memcpy(vi->ctrl->rss.key, key, vi->rss_key_size);
+		update = true;
+	}
 
-	virtnet_commit_rss_command(vi);
+	if (update)
+		virtnet_commit_rss_command(vi);
 
 	return 0;
 }
@@ -4491,13 +4506,15 @@ static int virtnet_probe(struct virtio_d
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
 		vi->has_rss_hash_report = true;
 
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
 		vi->has_rss = true;
 
-	if (vi->has_rss || vi->has_rss_hash_report) {
 		vi->rss_indir_table_size =
 			virtio_cread16(vdev, offsetof(struct virtio_net_config,
 				rss_max_indirection_table_length));
+	}
+
+	if (vi->has_rss || vi->has_rss_hash_report) {
 		vi->rss_key_size =
 			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
 


