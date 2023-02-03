Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E0C1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A389C433EF;
	Fri,  3 Feb 2023 10:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419666;
	bh=sWNmFSAJP0r7Cr2Lz17OUH6SAVoWFwd0TaQ7BzeDIGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFe8Hwc6j28YK3k+8hzK/+TifMZyqjhETfaUO5uMT9fbNYo3VixGN8/r6fyFC1Lh0
	 ENnPW8hGNNvepAZhj9XuJE83iNeSn1W5ZJRZVP4AKYBNkNOY0DfJYIwCf5mAp45LZW
	 UXC3Xy+W2SZ8zu57FmN4dNYtY+eLvTR4XQHoP3lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yu <zhangyu31@baidu.com>,
	Li RongQing <lirongqing@baidu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/80] netlink: remove hash::nelems check in netlink_insert
Date: Fri,  3 Feb 2023 11:12:41 +0100
Message-Id: <20230203101017.236992079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0041195d55bc38df6b574cc8c36dcf2266fbee39 ]

The type of hash::nelems has been changed from size_t to atom_t
which in fact is int, so not need to check if BITS_PER_LONG, that
is bit number of size_t, is bigger than 32

and rht_grow_above_max() will be called to check if hashtable is
too big, ensure it can not bigger than 1<<31

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c1bb9484e3b0 ("netlink: annotate data races around nlk->portid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6ffa83319d08..966c709c3831 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -578,11 +578,6 @@ static int netlink_insert(struct sock *sk, u32 portid)
 	if (nlk_sk(sk)->bound)
 		goto err;
 
-	err = -ENOMEM;
-	if (BITS_PER_LONG > 32 &&
-	    unlikely(atomic_read(&table->hash.nelems) >= UINT_MAX))
-		goto err;
-
 	nlk_sk(sk)->portid = portid;
 	sock_hold(sk);
 
-- 
2.39.0



