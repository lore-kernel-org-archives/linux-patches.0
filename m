Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639B217AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6B3C433C7;
	Wed,  9 Aug 2023 11:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580223;
	bh=m4dYF1+WgbW18hp6wxm29QriCDU3RIlVRdsNh0cDupQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z++vZMGF67oEqTqVXcET1y1gPDiKSzYRjcwRoRYk3n3U3sskvuk/nU63+aoYkunIB
	 +O1jUq9x3LfsTnDplBx7+sh8JFVODV4aADiuLmMoYppTP3FsI4rHksS4MyHzEQJfQA
	 Ygqq7bSTv0F2gNhL74EkfH2nPCpUPE3Z/7nDO7Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@resnulli.us>,
	Xiao Ma <xiaom@google.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 241/323] ipv6 addrconf: fix bug where deleting a mngtmpaddr can create a new temporary address
Date: Wed,  9 Aug 2023 12:41:19 +0200
Message-ID: <20230809103709.102142836@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 69172f0bcb6a09110c5d2a6d792627f5095a9018 ]

currently on 6.4 net/main:

  # ip link add dummy1 type dummy
  # echo 1 > /proc/sys/net/ipv6/conf/dummy1/use_tempaddr
  # ip link set dummy1 up
  # ip -6 addr add 2000::1/64 mngtmpaddr dev dummy1
  # ip -6 addr show dev dummy1

  11: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
      inet6 2000::44f3:581c:8ca:3983/64 scope global temporary dynamic
         valid_lft 604800sec preferred_lft 86172sec
      inet6 2000::1/64 scope global mngtmpaddr
         valid_lft forever preferred_lft forever
      inet6 fe80::e8a8:a6ff:fed5:56d4/64 scope link
         valid_lft forever preferred_lft forever

  # ip -6 addr del 2000::44f3:581c:8ca:3983/64 dev dummy1

  (can wait a few seconds if you want to, the above delete isn't [directly] the problem)

  # ip -6 addr show dev dummy1

  11: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
      inet6 2000::1/64 scope global mngtmpaddr
         valid_lft forever preferred_lft forever
      inet6 fe80::e8a8:a6ff:fed5:56d4/64 scope link
         valid_lft forever preferred_lft forever

  # ip -6 addr del 2000::1/64 mngtmpaddr dev dummy1
  # ip -6 addr show dev dummy1

  11: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
      inet6 2000::81c9:56b7:f51a:b98f/64 scope global temporary dynamic
         valid_lft 604797sec preferred_lft 86169sec
      inet6 fe80::e8a8:a6ff:fed5:56d4/64 scope link
         valid_lft forever preferred_lft forever

This patch prevents this new 'global temporary dynamic' address from being
created by the deletion of the related (same subnet prefix) 'mngtmpaddr'
(which is triggered by there already being no temporary addresses).

Cc: Jiri Pirko <jiri@resnulli.us>
Fixes: 53bd67491537 ("ipv6 addrconf: introduce IFA_F_MANAGETEMPADDR to tell kernel to manage temporary addresses")
Reported-by: Xiao Ma <xiaom@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230720160022.1887942-1-maze@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 23edc325f70be..5c5c5736f6892 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2488,12 +2488,18 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 			ipv6_ifa_notify(0, ift);
 	}
 
-	if ((create || list_empty(&idev->tempaddr_list)) &&
-	    idev->cnf.use_tempaddr > 0) {
+	/* Also create a temporary address if it's enabled but no temporary
+	 * address currently exists.
+	 * However, we get called with valid_lft == 0, prefered_lft == 0, create == false
+	 * as part of cleanup (ie. deleting the mngtmpaddr).
+	 * We don't want that to result in creating a new temporary ip address.
+	 */
+	if (list_empty(&idev->tempaddr_list) && (valid_lft || prefered_lft))
+		create = true;
+
+	if (create && idev->cnf.use_tempaddr > 0) {
 		/* When a new public address is created as described
 		 * in [ADDRCONF], also create a new temporary address.
-		 * Also create a temporary address if it's enabled but
-		 * no temporary address currently exists.
 		 */
 		read_unlock_bh(&idev->lock);
 		ipv6_create_tempaddr(ifp, NULL, false);
-- 
2.39.2



