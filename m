Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE889443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CD1C433C7;
	Sun, 13 Aug 2023 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962166;
	bh=n0v67YACvTUQXMZR49lG4H1m64K8P+DhK3T0nJ0nkzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYYMb07KG1jtjC0qft3Vghcmg7LdUVObGljx2tx8tE41Px1JRNXjShqWNWtI6jRzj
	 RVq6CH+vPoxr8EaKFJFOaY/omQZoCPN4u5L4gov5IlAvj/XBjLFDl5urSoMTc6J9Dn
	 7yyMj6RvhNUzSmd3rj9VkSLG/zWmE73w2kcIoFEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 138/206] dccp: fix data-race around dp->dccps_mss_cache
Date: Sun, 13 Aug 2023 23:18:28 +0200
Message-ID: <20230813211728.970040349@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

commit a47e598fbd8617967e49d85c49c22f9fc642704c upstream.

dccp_sendmsg() reads dp->dccps_mss_cache before locking the socket.
Same thing in do_dccp_getsockopt().

Add READ_ONCE()/WRITE_ONCE() annotations,
and change dccp_sendmsg() to check again dccps_mss_cache
after socket is locked.

Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230803163021.2958262-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dccp/output.c |    2 +-
 net/dccp/proto.c  |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/net/dccp/output.c
+++ b/net/dccp/output.c
@@ -187,7 +187,7 @@ unsigned int dccp_sync_mss(struct sock *
 
 	/* And store cached results */
 	icsk->icsk_pmtu_cookie = pmtu;
-	dp->dccps_mss_cache = cur_mps;
+	WRITE_ONCE(dp->dccps_mss_cache, cur_mps);
 
 	return cur_mps;
 }
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -630,7 +630,7 @@ static int do_dccp_getsockopt(struct soc
 		return dccp_getsockopt_service(sk, len,
 					       (__be32 __user *)optval, optlen);
 	case DCCP_SOCKOPT_GET_CUR_MPS:
-		val = dp->dccps_mss_cache;
+		val = READ_ONCE(dp->dccps_mss_cache);
 		break;
 	case DCCP_SOCKOPT_AVAILABLE_CCIDS:
 		return ccid_getsockopt_builtin_ccids(sk, len, optval, optlen);
@@ -739,7 +739,7 @@ int dccp_sendmsg(struct sock *sk, struct
 
 	trace_dccp_probe(sk, len);
 
-	if (len > dp->dccps_mss_cache)
+	if (len > READ_ONCE(dp->dccps_mss_cache))
 		return -EMSGSIZE;
 
 	lock_sock(sk);
@@ -772,6 +772,12 @@ int dccp_sendmsg(struct sock *sk, struct
 		goto out_discard;
 	}
 
+	/* We need to check dccps_mss_cache after socket is locked. */
+	if (len > dp->dccps_mss_cache) {
+		rc = -EMSGSIZE;
+		goto out_discard;
+	}
+
 	skb_reserve(skb, sk->sk_prot->max_header);
 	rc = memcpy_from_msg(skb_put(skb, len), msg, len);
 	if (rc != 0)


