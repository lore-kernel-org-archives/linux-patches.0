Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5B2171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DF7C433EF;
	Mon, 22 May 2023 19:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784776;
	bh=St5QlSY1Lhp1rWCSmBbrz/VUEdthoS+jnsfhFhr72hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ3BwAQoSZPwgxZ0fq3hZAalffLoiZ6RZW3sehmw3ISbOxF0soInKMFSjcakIfacx
	 chkEqpQJaCKpkGYaS10WNOFzhSXlNAMzjBIjZrlbc+NiauDGQWE59aPhTsoRnNA9cM
	 zcmxwlEpbb4wu1O1RiuDHUe72YaJgHQ9IUjwqN3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 199/364] xfrm: release all offloaded policy memory
Date: Mon, 22 May 2023 20:08:24 +0100
Message-Id: <20230522190417.705464429@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 94b95dfaa814f565d92f5a65f0ff12a483095522 ]

Failure to add offloaded policy will cause to the following
error once user will try to reload driver.

Unregister_netdevice: waiting for eth3 to become free. Usage count = 2

This was caused by xfrm_dev_policy_add() which increments reference
to net_device. That reference was supposed to be decremented
in xfrm_dev_policy_free(). However the latter wasn't called.

 unregister_netdevice: waiting for eth3 to become free. Usage count = 2
 leaked reference.
  xfrm_dev_policy_add+0xff/0x3d0
  xfrm_policy_construct+0x352/0x420
  xfrm_add_policy+0x179/0x320
  xfrm_user_rcv_msg+0x1d2/0x3d0
  netlink_rcv_skb+0xe0/0x210
  xfrm_netlink_rcv+0x45/0x50
  netlink_unicast+0x346/0x490
  netlink_sendmsg+0x3b0/0x6c0
  sock_sendmsg+0x73/0xc0
  sock_write_iter+0x13b/0x1f0
  vfs_write+0x528/0x5d0
  ksys_write+0x120/0x150
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 103af2b3e986f..af8fbcbfbe691 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1978,6 +1978,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (err) {
 		xfrm_dev_policy_delete(xp);
+		xfrm_dev_policy_free(xp);
 		security_xfrm_policy_free(xp->security);
 		kfree(xp);
 		return err;
-- 
2.39.2



