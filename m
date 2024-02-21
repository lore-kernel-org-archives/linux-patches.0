Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A4469954;
	Wed, 21 Feb 2024 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521137; cv=none; b=sKkSjRqpwws7UsJ3rRwImKJ6Bc9fDJY6dQBX3bpQZC3knIKtFfZZ1SLzH31f3VEfLCAeHRMkSW6cP73i9mIcehmQih4l1Ajc3dDCQ/gGOlKRt8CIhTnuiOQM4hZ4nrRrdJsf3vvUBabN42/G+Twde/ceX216j7TH/YD6eGsNmLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521137; c=relaxed/simple;
	bh=lrDgqVVjxri6rVUhCnbEmiLuOwB3LrtQiMLWlu/QaJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyQAk6/k5Uc+EGiN3REhBelpE+zwu6f1dsbpjjXBSnyyK+U68iGK+c4bsYO4/c1D6bi1XKYyLxisVfK/Tl9oXs9xKrMSBEV/u5d8jRw8n+kx61m9p/Z8Tdz8ZiIfKfoK0tRrS9Mb4sjOKusX/qutSfVJ5ogAR2C6Y+yoVyUshfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuMNU2Br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuMNU2Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A2EC433C7;
	Wed, 21 Feb 2024 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521136;
	bh=lrDgqVVjxri6rVUhCnbEmiLuOwB3LrtQiMLWlu/QaJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuMNU2BrepB5OXtpH0r46B3z+WP8JA13f4ZpoMQ6n5H6AMR3YIeB2GdFM10GWdbz8
	 kqAmnC5P+9iLGv2B0SxlDIBZg9Lq97QLgnbTFmRCnCrMlrrtKJov12WszgpAUvrunt
	 SpP1nppwDVPYdV9kgZi7F/JacIwlXic6+XaJaIUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/202] netlink: fix potential sleeping issue in mqueue_flush_file
Date: Wed, 21 Feb 2024 14:05:32 +0100
Message-ID: <20240221125932.786503356@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e91489b3274c..72936d154c96 100644
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



