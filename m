Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B15E1DF74C;
	Wed, 19 Feb 2025 09:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957272; cv=none; b=CItx4ytUYdUmMMDnk5T3NYSnPjH4HgW6b7L8CbR32RsYwoOKDvur7Er6sRgYWgnOMkvT86MBOOBjhSG0SrKHfAGXC92Nlt1+NoIjVn25Nuyemb6WFAFCFmcd201xVsAOpGPxrfFKkPFM96wjxIflcYqK8UA8K5+TsvZPgDNDS6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957272; c=relaxed/simple;
	bh=Up6mrYyStS+fV2kaFrtsagoZqFk8UbgMikbN8Q4QMRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASbCSngWZ95WpazU4xUd+UNkduCB7EICpHD6bN6gQ+MVjSAUbq6o7SbDIQJPetj1KSMk0hx0TreARRvm97I8sDBqUnlhj1aiBhICpy7YWw0rubhkp8LB6RUmLmNKIkAwyYaZSnlX+BjoSqmiIyK/PbxjIlSQgyn16YeCiIYuybk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmNciYGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmNciYGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032FCC4CED1;
	Wed, 19 Feb 2025 09:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957272;
	bh=Up6mrYyStS+fV2kaFrtsagoZqFk8UbgMikbN8Q4QMRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmNciYGKM6gZydmRsup6Xg6iu98kNoUyrRiatWFtRVR1XDV55BFodAvz3NHTAQBwE
	 sHZn+Zr6TItQWedN5uQ+MwLel2gsJi74xXZ1HbmTBA8PGBumMd9s6Rb+9UC5MAJqMV
	 uCrw/dg48tdUTOTX1TLeb77txj3c7ZsDXXCyqUNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 469/578] vrf: use RCU protection in l3mdev_l3_out()
Date: Wed, 19 Feb 2025 09:27:53 +0100
Message-ID: <20250219082711.455604084@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6d0ce46a93135d96b7fa075a94a88fe0da8e8773 ]

l3mdev_l3_out() can be called without RCU being held:

raw_sendmsg()
 ip_push_pending_frames()
  ip_send_skb()
   ip_local_out()
    __ip_local_out()
     l3mdev_ip_out()

Add rcu_read_lock() / rcu_read_unlock() pair to avoid
a potential UAF.

Fixes: a8e3e1a9f020 ("net: l3mdev: Add hook to output path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/l3mdev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
index 031c661aa14df..bdfa9d414360c 100644
--- a/include/net/l3mdev.h
+++ b/include/net/l3mdev.h
@@ -198,10 +198,12 @@ struct sk_buff *l3mdev_l3_out(struct sock *sk, struct sk_buff *skb, u16 proto)
 	if (netif_is_l3_slave(dev)) {
 		struct net_device *master;
 
+		rcu_read_lock();
 		master = netdev_master_upper_dev_get_rcu(dev);
 		if (master && master->l3mdev_ops->l3mdev_l3_out)
 			skb = master->l3mdev_ops->l3mdev_l3_out(master, sk,
 								skb, proto);
+		rcu_read_unlock();
 	}
 
 	return skb;
-- 
2.39.5



