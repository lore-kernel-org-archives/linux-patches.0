Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C97A124;
	Mon,  4 Mar 2024 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587651; cv=none; b=ZWj+gPmKYvho9vOfaMSfWq7OBAtLw7OFAgZNkKE4PxfJw2UKYSCpyp1XuKlFDQIdeq3pQ0ncPsX4QUZcP1Ox/mAhtDqLFqOxbkTquUE3YLsmMjhCjTRX6SBj6jCqggnzPy2jyZq1PJlny75KLvtd9V1hEg0H/08mQL9K6B/8Tpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587651; c=relaxed/simple;
	bh=bw3J/FHCDU6oxkCYgdz4TDR1N6MpOdBwdEkxm0Cge0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZspB9V+Dflm+NbRVB80uCdf14N8NtLUwPTTLpc35JgAheciH+xG73rO9lVIVk/x+etGdEBaaDF2abkacGcWsVYpeUgOKQw4daaJJOw037ejJMALvz3zJ9l00xRyJZJZ7GZeNS/4oRxE5tR6oGi0XCEXqQbxWCfIC8cAsrXV6s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpNBR6D/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpNBR6D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2050AC43390;
	Mon,  4 Mar 2024 21:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587651;
	bh=bw3J/FHCDU6oxkCYgdz4TDR1N6MpOdBwdEkxm0Cge0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpNBR6D/KdpoZqqHLnmzHXf76dMBiwVwB1QMcuMeoR/dZIbrjqPYPIv3aGMH2f2Ya
	 FeTrjmgltufVahOXh1jJVIxpDuPfRZHvc2aDqbqDZ/8PsKfcbSaelL9qjyHNRXBcc4
	 ebUwjxDE3fCgrw42DGo38Yipr/lmbhK1/rb6r0w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 013/162] net: mctp: take ownership of skb in mctp_local_output
Date: Mon,  4 Mar 2024 21:21:18 +0000
Message-ID: <20240304211552.261297356@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 3773d65ae5154ed7df404b050fd7387a36ab5ef3 ]

Currently, mctp_local_output only takes ownership of skb on success, and
we may leak an skb if mctp_local_output fails in specific states; the
skb ownership isn't transferred until the actual output routing occurs.

Instead, make mctp_local_output free the skb on all error paths up to
the route action, so it always consumes the passed skb.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240220081053.1439104-1-jk@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mctp.h |  1 +
 net/mctp/route.c   | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index da86e106c91d5..2bff5f47ce82f 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -249,6 +249,7 @@ struct mctp_route {
 struct mctp_route *mctp_route_lookup(struct net *net, unsigned int dnet,
 				     mctp_eid_t daddr);
 
+/* always takes ownership of skb */
 int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		      struct sk_buff *skb, mctp_eid_t daddr, u8 req_tag);
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 6218dcd07e184..ceee44ea09d97 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -888,7 +888,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		dev = dev_get_by_index_rcu(sock_net(sk), cb->ifindex);
 		if (!dev) {
 			rcu_read_unlock();
-			return rc;
+			goto out_free;
 		}
 		rt->dev = __mctp_dev_get(dev);
 		rcu_read_unlock();
@@ -903,7 +903,8 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		rt->mtu = 0;
 
 	} else {
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out_free;
 	}
 
 	spin_lock_irqsave(&rt->dev->addrs_lock, flags);
@@ -966,12 +967,17 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		rc = mctp_do_fragment_route(rt, skb, mtu, tag);
 	}
 
+	/* route output functions consume the skb, even on error */
+	skb = NULL;
+
 out_release:
 	if (!ext_rt)
 		mctp_route_release(rt);
 
 	mctp_dev_put(tmp_rt.dev);
 
+out_free:
+	kfree_skb(skb);
 	return rc;
 }
 
-- 
2.43.0



