Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15DF2C11FE;
	Wed, 20 May 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301281; cv=none; b=odI33zwfZp5t2F1MbAGT7m1KJ8fuquCWoffVV6uiIu+tz96YPQ4T1Wp2BHqXyBGXOGRG1as6rKjmrHaYEqrTIfPFP4yp44y07t4RashK3umgU9UMKrfxQFO/uvBo/xybeho9XVLLVOiCyS4c2pN0DDND52uz/Gaf0yE//xZhKDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301281; c=relaxed/simple;
	bh=NWzs4Sf/r9dAR1tk69Y+fwypcbDMDgWziDbu89R5DjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDAq3HNFjiKPogZAe5cpc4/BoR+cO/qOqx+7rzBXxoA40qCCs34XdU8k0BYK+Ek0z9AEZ8G5x0ipBQV9jDZfjOWa3j5fsRybI0RqmuJwzra9a7KNnJlghdq4VgYRCi/EwGbXxC4nxPvskBDVHCFdMde/lCDuN+NlW0Da2fyDMes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bUNwnyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bUNwnyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225BF1F000E9;
	Wed, 20 May 2026 18:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301280;
	bh=qY3W1iOV5OUrQ18xUQOrPCDABXktSJdKlCq63PjzCx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bUNwnyZHbRfXU8ahIsURe8HHO9FCTLCFg6B6bsC7rblMJIhHRi97KB3t/hGpKj6J
	 1gFdHyXbdJ0xl3BVIJQts1VP3kY+Z6TPxRC0pLYU0QTGDTd+Y+7xQ+/shC92sCNbvb
	 VWRHJ51Z62UJZDsTuD9VsuH/K8kpLYgp7S2nr2Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 495/666] virtio_net: sync rss_trailer.max_tx_vq on queue_pairs change via VQ_PAIRS_SET
Date: Wed, 20 May 2026 18:21:46 +0200
Message-ID: <20260520162121.990595195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 3bc06da858ef17cfe94b49efc0d9713727012835 ]

When netif_is_rxfh_configured() is true (i.e., the user has explicitly
configured the RSS indirection table), virtnet_set_queues() skips the
RSS update path and falls through to the VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET
command to change the number of queue pairs. However, it does not update
vi->rss_trailer.max_tx_vq to reflect the new queue_pairs value.

This causes a mismatch between vi->curr_queue_pairs and
vi->rss_trailer.max_tx_vq. Any subsequent RSS reconfiguration (e.g.,
via ethtool -X) calls virtnet_commit_rss_command(), which sends the
stale max_tx_vq to the device, silently reverting the queue count.

Reproduction:
1. User configured RSS
  ethtool -X eth0 equal 8
2. VQ_PAIRS_SET path; max_tx_vq stays 16
  ethtool -L eth0 combined 12
3. RSS commit uses max_tx_vq=16 instead of 12
  ethtool -X eth0 equal 4

Fix this by updating vi->rss_trailer.max_tx_vq after a successful
VQ_PAIRS_SET command when RSS is enabled, keeping it in sync with
curr_queue_pairs.

Fixes: 50bfcaedd78e ("virtio_net: Update rss when set queue")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260416212121.29073-1-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7aa1832672942..324802cef40b4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3517,6 +3517,12 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 			 queue_pairs);
 		return -EINVAL;
 	}
+
+	/* Keep max_tx_vq in sync so that a later RSS command does not
+	 * revert queue_pairs to a stale value.
+	 */
+	if (vi->has_rss)
+		vi->rss_trailer.max_tx_vq = cpu_to_le16(queue_pairs);
 succ:
 	vi->curr_queue_pairs = queue_pairs;
 	/* virtnet_open() will refill when device is going to up. */
-- 
2.53.0



