Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73E6200CD;
	Mon,  4 Mar 2024 21:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588625; cv=none; b=qZOB64ndK1B46mhqbAQBniZGH2lv2YGUqefc6zhSboJprRXT42RNkCS/wZuG6bYYyD0TGEbik7CYUbvkWheyzOcm9/Ne3FM482H10ZKYswveFW/4klq3WV8lyEBZczH79bTwt3hl1YBRkBa7snKhs4hhfb+2ZXxZGXPwdjXa710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588625; c=relaxed/simple;
	bh=o+y+y+34/+0xrOe4B+4lj1gdLvk/hzFbvs/A6Maw8QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n8zPxJlyR0i4jF8v29VptbNAdMWvYKBXCVEhEo7Z7r5/XFuKyXMSUYmFGkX5wswS3AUJJESFRgXRNIWpJB0sMRMyOu7I5hUiXx1cwUoKsM0LjLq8mF3t2TINAYpYGVK6DlzzSAZC9eHAzMjVk9h1MD10r9A89uOcMLPlw8L0WW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq9TmdOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq9TmdOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794E5C433C7;
	Mon,  4 Mar 2024 21:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588624;
	bh=o+y+y+34/+0xrOe4B+4lj1gdLvk/hzFbvs/A6Maw8QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fq9TmdOrU13kcDlrinVDSUgo/HU0jFE+bP+tC+VQDjLMWQvOC5qscJNhpzIeDSfR3
	 1jmz0i441UuPsoP3LhxSPQw1Xqr0BpLoqjGKfz+lUFE4HJTOivNCVjfOKAbfB+QIOx
	 6yVqPN/ZKVQDmR0S/Aw4kKi8XPbUC/U8VPDZTCnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	syzbot+039399a9b96297ddedca@syzkaller.appspotmail.com,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/215] net: veth: clear GRO when clearing XDP even when down
Date: Mon,  4 Mar 2024 21:21:37 +0000
Message-ID: <20240304211558.069392239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fe9f801355f0b47668419f30f1fac1cf4539e736 ]

veth sets NETIF_F_GRO automatically when XDP is enabled,
because both features use the same NAPI machinery.

The logic to clear NETIF_F_GRO sits in veth_disable_xdp() which
is called both on ndo_stop and when XDP is turned off.
To avoid the flag from being cleared when the device is brought
down, the clearing is skipped when IFF_UP is not set.
Bringing the device down should indeed not modify its features.

Unfortunately, this means that clearing is also skipped when
XDP is disabled _while_ the device is down. And there's nothing
on the open path to bring the device features back into sync.
IOW if user enables XDP, disables it and then brings the device
up we'll end up with a stray GRO flag set but no NAPI instances.

We don't depend on the GRO flag on the datapath, so the datapath
won't crash. We will crash (or hang), however, next time features
are sync'ed (either by user via ethtool or peer changing its config).
The GRO flag will go away, and veth will try to disable the NAPIs.
But the open path never created them since XDP was off, the GRO flag
was a stray. If NAPI was initialized before we'll hang in napi_disable().
If it never was we'll crash trying to stop uninitialized hrtimer.

Move the GRO flag updates to the XDP enable / disable paths,
instead of mixing them with the ndo_open / ndo_close paths.

Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: syzbot+039399a9b96297ddedca@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 36c5a41f84e44..dea9cc8c39f7a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1135,14 +1135,6 @@ static int veth_enable_xdp(struct net_device *dev)
 				veth_disable_xdp_range(dev, 0, dev->real_num_rx_queues, true);
 				return err;
 			}
-
-			if (!veth_gro_requested(dev)) {
-				/* user-space did not require GRO, but adding XDP
-				 * is supposed to get GRO working
-				 */
-				dev->features |= NETIF_F_GRO;
-				netdev_features_change(dev);
-			}
 		}
 	}
 
@@ -1162,18 +1154,9 @@ static void veth_disable_xdp(struct net_device *dev)
 	for (i = 0; i < dev->real_num_rx_queues; i++)
 		rcu_assign_pointer(priv->rq[i].xdp_prog, NULL);
 
-	if (!netif_running(dev) || !veth_gro_requested(dev)) {
+	if (!netif_running(dev) || !veth_gro_requested(dev))
 		veth_napi_del(dev);
 
-		/* if user-space did not require GRO, since adding XDP
-		 * enabled it, clear it now
-		 */
-		if (!veth_gro_requested(dev) && netif_running(dev)) {
-			dev->features &= ~NETIF_F_GRO;
-			netdev_features_change(dev);
-		}
-	}
-
 	veth_disable_xdp_range(dev, 0, dev->real_num_rx_queues, false);
 }
 
@@ -1558,6 +1541,14 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		}
 
 		if (!old_prog) {
+			if (!veth_gro_requested(dev)) {
+				/* user-space did not require GRO, but adding
+				 * XDP is supposed to get GRO working
+				 */
+				dev->features |= NETIF_F_GRO;
+				netdev_features_change(dev);
+			}
+
 			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
 			peer->max_mtu = max_mtu;
 		}
@@ -1568,6 +1559,14 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			if (dev->flags & IFF_UP)
 				veth_disable_xdp(dev);
 
+			/* if user-space did not require GRO, since adding XDP
+			 * enabled it, clear it now
+			 */
+			if (!veth_gro_requested(dev)) {
+				dev->features &= ~NETIF_F_GRO;
+				netdev_features_change(dev);
+			}
+
 			if (peer) {
 				peer->hw_features |= NETIF_F_GSO_SOFTWARE;
 				peer->max_mtu = ETH_MAX_MTU;
-- 
2.43.0



