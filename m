Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA0F171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9CDC433AE;
	Mon, 22 May 2023 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783944;
	bh=ArcQF516hMZWJ3h6Uf2CV1TL9M6mRuKJDgmBIIFqhA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkDuTAdKQF+HRpk2N6GxFjHE/2JritKPZFSdnxUfgWLTDlx+aQWKb674v2S53mYFm
	 SanZiyqR+azbIj7G1l8CyDZL1ML4IFpIUM0vE627dRPqpFboQMKogA2xs3GudV+qY9
	 x2PWaY99ZmxQZGEiyp/mQvEBTQDvfP14+/gfV4vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuang Wang <nashuiliang@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/292] net: tun: rebuild error handling in tun_get_user
Date: Mon, 22 May 2023 20:09:31 +0100
Message-Id: <20230522190411.307114804@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuang Wang <nashuiliang@gmail.com>

[ Upstream commit ab00af85d2f886a8e4ace1342d9cc2b232eab6a8 ]

The error handling in tun_get_user is very scattered.
This patch unifies error handling, reduces duplication of code, and
makes the logic clearer.

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 82b2bc279467 ("tun: Fix memory leak for detached NAPI queue.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 65 +++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 91d198aff2f9a..65706824eb828 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1748,7 +1748,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
-	enum skb_drop_reason drop_reason;
+	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1809,10 +1809,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 * skb was created with generic XDP routine.
 		 */
 		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
-		if (IS_ERR(skb)) {
-			dev_core_stats_rx_dropped_inc(tun->dev);
-			return PTR_ERR(skb);
-		}
+		err = PTR_ERR_OR_ZERO(skb);
+		if (err)
+			goto drop;
 		if (!skb)
 			return total_len;
 	} else {
@@ -1837,13 +1836,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					    noblock);
 		}
 
-		if (IS_ERR(skb)) {
-			if (PTR_ERR(skb) != -EAGAIN)
-				dev_core_stats_rx_dropped_inc(tun->dev);
-			if (frags)
-				mutex_unlock(&tfile->napi_mutex);
-			return PTR_ERR(skb);
-		}
+		err = PTR_ERR_OR_ZERO(skb);
+		if (err)
+			goto drop;
 
 		if (zerocopy)
 			err = zerocopy_sg_from_iter(skb, from);
@@ -1853,27 +1848,14 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		if (err) {
 			err = -EFAULT;
 			drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
-drop:
-			dev_core_stats_rx_dropped_inc(tun->dev);
-			kfree_skb_reason(skb, drop_reason);
-			if (frags) {
-				tfile->napi.skb = NULL;
-				mutex_unlock(&tfile->napi_mutex);
-			}
-
-			return err;
+			goto drop;
 		}
 	}
 
 	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
-		kfree_skb(skb);
-		if (frags) {
-			tfile->napi.skb = NULL;
-			mutex_unlock(&tfile->napi_mutex);
-		}
-
-		return -EINVAL;
+		err = -EINVAL;
+		goto free_skb;
 	}
 
 	switch (tun->flags & TUN_TYPE_MASK) {
@@ -1889,9 +1871,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				pi.proto = htons(ETH_P_IPV6);
 				break;
 			default:
-				dev_core_stats_rx_dropped_inc(tun->dev);
-				kfree_skb(skb);
-				return -EINVAL;
+				err = -EINVAL;
+				goto drop;
 			}
 		}
 
@@ -1933,11 +1914,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
-				if (frags) {
-					tfile->napi.skb = NULL;
-					mutex_unlock(&tfile->napi_mutex);
-				}
-				return total_len;
+				goto unlock_frags;
 			}
 		}
 		rcu_read_unlock();
@@ -2017,6 +1994,22 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		tun_flow_update(tun, rxhash, tfile);
 
 	return total_len;
+
+drop:
+	if (err != -EAGAIN)
+		dev_core_stats_rx_dropped_inc(tun->dev);
+
+free_skb:
+	if (!IS_ERR_OR_NULL(skb))
+		kfree_skb_reason(skb, drop_reason);
+
+unlock_frags:
+	if (frags) {
+		tfile->napi.skb = NULL;
+		mutex_unlock(&tfile->napi_mutex);
+	}
+
+	return err ?: total_len;
 }
 
 static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
-- 
2.39.2



