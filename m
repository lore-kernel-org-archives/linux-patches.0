Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9D315FB30;
	Mon, 29 Jan 2024 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548320; cv=none; b=TkmK2tUTDPQPmDOuRlHaKMA95OfH1/DGrdkKPH/1A5IseGpx6juZVN5onsNXfIPyft/17CCk4Kl0DWIAksVtc1nQZH0QZl+HAABV1X4JwuX+pjNvS/Nvu/NxPJ+Y3P9bWTBkSF+PpTdSkhE+d3oCtuYWCZeqEsnNPFPF/D9J0TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548320; c=relaxed/simple;
	bh=Y8wPl9RxiTKOOGg+0dDUKTrHLMhiWSQzEHJjnDAp+qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnfDYuDllBKauJ6yI7bZIn21WQ31rz9h6ERIEJDN4t96KvJS7KcpKf11pVGHQ822k8IThgwStXf66gE0aleG4QrJ9HUcB8q5d3xLEzEs7mb0H9FQGOOxhKXUe1Sh80thvxxIs0rwlSkvbH88qy96gC00UXHxB5PI/sG0WfTClDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZwcVj7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZwcVj7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDFEC43390;
	Mon, 29 Jan 2024 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548320;
	bh=Y8wPl9RxiTKOOGg+0dDUKTrHLMhiWSQzEHJjnDAp+qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZwcVj7mdhrhFSE8CzHCjSo2eXxoeChtyi7h7gBD0HOj52NvMOHeYN9pSjE0BSQsy
	 v60x2IikK1cGuPIfEmeNxZ1ZjaUPnDLiL3iLxRNhZRAQ6roph9oGV4hEzLK+ztRNV3
	 55UTGbZ7iUwK8Xnue5CN6GpnocE+U0DmKKypnTCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/185] netlink: fix potential sleeping issue in mqueue_flush_file
Date: Mon, 29 Jan 2024 09:04:53 -0800
Message-ID: <20240129170001.582195527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 234ec0b6034b16869d45128b8cd2dc6ffe596f04 ]

I analyze the potential sleeping issue of the following processes:
Thread A                                Thread B
...                                     netlink_create  //ref = 1
do_mq_notify                            ...
  sock = netlink_getsockbyfilp          ...     //ref = 2
  info->notify_sock = sock;             ...
...                                     netlink_sendmsg
...                                       skb = netlink_alloc_large_skb  //skb->head is vmalloced
...                                       netlink_unicast
...                                         sk = netlink_getsockbyportid //ref = 3
...                                         netlink_sendskb
...                                           __netlink_sendskb
...                                             skb_queue_tail //put skb to sk_receive_queue
...                                         sock_put //ref = 2
...                                     ...
...                                     netlink_release
...                                       deferred_put_nlk_sk //ref = 1
mqueue_flush_file
  spin_lock
  remove_notification
    netlink_sendskb
      sock_put  //ref = 0
        sk_free
          ...
          __sk_destruct
            netlink_sock_destruct
              skb_queue_purge  //get skb from sk_receive_queue
                ...
                __skb_queue_purge_reason
                  kfree_skb_reason
                    __kfree_skb
                    ...
                    skb_release_all
                      skb_release_head_state
                        netlink_skb_destructor
                          vfree(skb->head)  //sleeping while holding spinlock

In netlink_sendmsg, if the memory pointed to by skb->head is allocated by
vmalloc, and is put to sk_receive_queue queue, also the skb is not freed.
When the mqueue executes flush, the sleeping bug will occur. Use
vfree_atomic instead of vfree in netlink_skb_destructor to solve the issue.

Fixes: c05cdb1b864f ("netlink: allow large data transfers from user-space")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20240122011807.2110357-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index cb833302270a..6857a4965fe8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -374,7 +374,7 @@ static void netlink_skb_destructor(struct sk_buff *skb)
 	if (is_vmalloc_addr(skb->head)) {
 		if (!skb->cloned ||
 		    !atomic_dec_return(&(skb_shinfo(skb)->dataref)))
-			vfree(skb->head);
+			vfree_atomic(skb->head);
 
 		skb->head = NULL;
 	}
-- 
2.43.0



