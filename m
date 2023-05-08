Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9B7171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5FC433D2;
	Mon,  8 May 2023 11:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546027;
	bh=4bvK5xWF+rnCBBdTS+ZwDWwNmO9OBRZrzBV3nkqzjjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDJv33xO2iKl6TLaMmsMa5gtDX6DUbA2VET9yTCXmx21YYYme/R1hND+gLdn/XO24
	 CxNtJG0XFde6wekEn1iO+EYWA+urWWGINL2BZZZ3VpvTWLcoDhJCp3pkLHZqLZ1cWM
	 nGptGQiV9j7OF4YwxfSewuSGpUxkqSScOc6Ckecs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Spencer <bspencer@blackberry.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/371] netlink: Use copy_to_user() for optval in netlink_getsockopt().
Date: Mon,  8 May 2023 11:47:14 +0200
Message-Id: <20230508094821.315398633@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit d913d32cc2707e9cd24fe6fa6d7d470e9c728980 ]

Brad Spencer provided a detailed report [0] that when calling getsockopt()
for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
options require at least sizeof(int) as length.

The options return a flag value that fits into 1 byte, but such behaviour
confuses users who do not initialise the variable before calling
getsockopt() and do not strictly check the returned value as char.

Currently, netlink_getsockopt() uses put_user() to copy data to optlen and
optval, but put_user() casts the data based on the pointer, char *optval.
As a result, only 1 byte is set to optval.

To avoid this behaviour, we need to use copy_to_user() or cast optval for
put_user().

Note that this changes the behaviour on big-endian systems, but we document
that the size of optval is int in the man page.

  $ man 7 netlink
  ...
  Socket options
       To set or get a netlink socket option, call getsockopt(2) to read
       or setsockopt(2) to write the option with the option level argument
       set to SOL_NETLINK.  Unless otherwise noted, optval is a pointer to
       an int.

Fixes: 9a4595bc7e67 ("[NETLINK]: Add set/getsockopt options to support more than 32 groups")
Fixes: be0c22a46cfb ("netlink: add NETLINK_BROADCAST_ERROR socket option")
Fixes: 38938bfe3489 ("netlink: add NETLINK_NO_ENOBUFS socket flag")
Fixes: 0a6a3a23ea6e ("netlink: add NETLINK_CAP_ACK socket option")
Fixes: 2d4bc93368f5 ("netlink: extended ACK reporting")
Fixes: 89d35528d17d ("netlink: Add new socket option to enable strict checking on dumps")
Reported-by: Brad Spencer <bspencer@blackberry.com>
Link: https://lore.kernel.org/netdev/ZD7VkNWFfp22kTDt@datsun.rim.net/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Link: https://lore.kernel.org/r/20230421185255.94606-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 75 ++++++++++++----------------------------
 1 file changed, 23 insertions(+), 52 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 011ec7d9a719e..84a7a29be49d8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1752,7 +1752,8 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
-	int len, val, err;
+	unsigned int flag;
+	int len, val;
 
 	if (level != SOL_NETLINK)
 		return -ENOPROTOOPT;
@@ -1764,39 +1765,17 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case NETLINK_PKTINFO:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
-		val = nlk->flags & NETLINK_F_RECV_PKTINFO ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
+		flag = NETLINK_F_RECV_PKTINFO;
 		break;
 	case NETLINK_BROADCAST_ERROR:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
-		val = nlk->flags & NETLINK_F_BROADCAST_SEND_ERROR ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
+		flag = NETLINK_F_BROADCAST_SEND_ERROR;
 		break;
 	case NETLINK_NO_ENOBUFS:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
-		val = nlk->flags & NETLINK_F_RECV_NO_ENOBUFS ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
+		flag = NETLINK_F_RECV_NO_ENOBUFS;
 		break;
 	case NETLINK_LIST_MEMBERSHIPS: {
-		int pos, idx, shift;
+		int pos, idx, shift, err = 0;
 
-		err = 0;
 		netlink_lock_table();
 		for (pos = 0; pos * 8 < nlk->ngroups; pos += sizeof(u32)) {
 			if (len - pos < sizeof(u32))
@@ -1813,40 +1792,32 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))
 			err = -EFAULT;
 		netlink_unlock_table();
-		break;
+		return err;
 	}
 	case NETLINK_CAP_ACK:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
-		val = nlk->flags & NETLINK_F_CAP_ACK ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
+		flag = NETLINK_F_CAP_ACK;
 		break;
 	case NETLINK_EXT_ACK:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
-		val = nlk->flags & NETLINK_F_EXT_ACK ? 1 : 0;
-		if (put_user(len, optlen) || put_user(val, optval))
-			return -EFAULT;
-		err = 0;
+		flag = NETLINK_F_EXT_ACK;
 		break;
 	case NETLINK_GET_STRICT_CHK:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
-		val = nlk->flags & NETLINK_F_STRICT_CHK ? 1 : 0;
-		if (put_user(len, optlen) || put_user(val, optval))
-			return -EFAULT;
-		err = 0;
+		flag = NETLINK_F_STRICT_CHK;
 		break;
 	default:
-		err = -ENOPROTOOPT;
+		return -ENOPROTOOPT;
 	}
-	return err;
+
+	if (len < sizeof(int))
+		return -EINVAL;
+
+	len = sizeof(int);
+	val = nlk->flags & flag ? 1 : 0;
+
+	if (put_user(len, optlen) ||
+	    copy_to_user(optval, &val, len))
+		return -EFAULT;
+
+	return 0;
 }
 
 static void netlink_cmsg_recv_pktinfo(struct msghdr *msg, struct sk_buff *skb)
-- 
2.39.2



