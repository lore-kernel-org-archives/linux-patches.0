Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25442372ECB;
	Thu, 30 Jul 2026 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423693; cv=none; b=KftWOrfCTzfdBijeC/EVtCdbbtNU0cNeJLb/EX3RQp7jH1x4/g3flb3XamTSyG3yhQ7/5IsXpAHGmb1XxyyqZXRMFu5/H/7PlxNSAqBL96iWXaSZLsRIfMZHkleb6wUr7hNKESTdMqSixnJDdoNp2wglR2pzGZ7b9DcDEffFR8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423693; c=relaxed/simple;
	bh=wzGV9GnUi49xLqXJ9u4Zw37F6J+2MR/MMMDfxspgikc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCXPZIKBxcj2pNfxnmAHvt0IBe84oEZJZY7sLYZU7X7DpxiANBi3a/vxxUfa/1xzCcmYyLJqobrFGwZXZW3Uhm7q4/NvgU20PyLdkFwBM6r33j/tALxc02xraX9mvoSajNDvWMQrIPx/smpD1m9DW0cGtwSPvDKyzm8EMTOb4TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgZagqKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgZagqKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFEC1F000E9;
	Thu, 30 Jul 2026 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423691;
	bh=pdni7gOInC5TYmAVFzXEoilAMDSHlbwKgycFhyIGn8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgZagqKPbsp8bXdkB2Ig/T7W+S+ElQgoJERKe3WZRJojTGov8SbQX0q6lXASbu8g1
	 lunpkzLOv7ZnWvTC0srGAxR4rz4dxeOI3kMZcvL/sRQYJ6mPcnLAYqQNngwFeoubYk
	 tZBfhZkIPuXw6Hvf6sQoWdS0exzy0wLspxMppzbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/675] tcp: fix TIME_WAIT socket reference leak on PSP policy failure
Date: Thu, 30 Jul 2026 16:07:44 +0200
Message-ID: <20260730141447.988661947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2c1931a81122c3cdc4c89448fe0442c69e21c0d5 ]

Release the TIME_WAIT socket reference and jump to discard_it
upon PSP policy failure in both IPv4 and IPv6 receive paths.
This prevents a memory leak of tcp_tw_bucket structures.

Fixes: 659a2899a57d ("tcp: add datapath logic for PSP with inline key exchange")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260710181317.4060230-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 6 ++++--
 net/ipv6/tcp_ipv6.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f0106c2be1cf23..a1ed4fa264836d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2452,8 +2452,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 
 		drop_reason = psp_twsk_rx_policy_check(inet_twsk(sk), skb);
-		if (drop_reason)
-			break;
+		if (drop_reason) {
+			inet_twsk_put(inet_twsk(sk));
+			goto discard_it;
+		}
 	}
 		/* to ACK */
 		fallthrough;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 59b5900dd42bd6..ad9f69d49f2e3d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1984,8 +1984,10 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		}
 
 		drop_reason = psp_twsk_rx_policy_check(inet_twsk(sk), skb);
-		if (drop_reason)
-			break;
+		if (drop_reason) {
+			inet_twsk_put(inet_twsk(sk));
+			goto discard_it;
+		}
 	}
 		/* to ACK */
 		fallthrough;
-- 
2.53.0



