Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8830117A2F6;
	Tue, 21 Jul 2026 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661339; cv=none; b=D8mexWJQs8Ws56PTSGp2NzCtXF0RqY/SiumnE2BPPEwCh1/Aze7K7nIdMSKvxOw51bfbJRLDStCTUFmFHmO/AC+xd6HibqUBu5ZorlISThGCgZ4mU7k09ZQ4qqxoE7mglYcOPpXNYsuGytHRNTP05BcGUuNCiCy8nhibMmoZrdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661339; c=relaxed/simple;
	bh=ZaKxldXmXWZ2qSiirG6Up5/rtl+9zacXx/qFLuw78Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJ3Eb0isjDBZtheVLmcyc56S8Xv6b/ScYGXlJkTPfrpoYKl1xc7NpXm4joSPTX7X2F3agC7nC4HVYRArcZIwO1jYmEP6V4nYWDlmZPqtqwLmi4ojmk2QKdYrqk5MBvIpqrOhlLd1awE+yOEdiHthzYH6GwR4xnBlTBvXNAMUU4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvhXAniS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvhXAniS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBF31F00A3A;
	Tue, 21 Jul 2026 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661338;
	bh=hO6iEMtcT1NANMYj58/6WuBXQsocNkzqhcIbxM+I83w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvhXAniSe4RMoM19mkUtdbQe0Y8oE0hlMo/hoVqE/jcwm9R9222nfmKWMojuj/qVg
	 hHlUhbgP/9U8fwzMXH4P6MlLYnUa/cf+RmXPCUfYvAwhOBRi5iwTuZGZjtY858lsNt
	 myutyisLKpY9IVlMJiPP9CC9pQf4vpYdu8DtFD8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0029/1276] af_unix: Set drop reason in unix_stream_read_skb().
Date: Tue, 21 Jul 2026 17:07:52 +0200
Message-ID: <20260721152446.734588521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit bace4b468049a558295a0f59460fcb51e28f8fde ]

unix_stream_read_skb() is called when BPF SOCKMAP reads some data
from a socket in the map.

SOCKMAP does not support MSG_OOB, and reading OOB results in a drop.

Let's set drop reasons respectively.

  * SOCKET_CLOSE  : the socket in SOCKMAP was close()d
  * UNIX_SKIP_OOB : OOB was read from the socket in SOCKMAP

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250116053441.5758-7-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e0f5a93821490a..1d426f5b2580d5 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2743,7 +2743,7 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 
 		if (sock_flag(sk, SOCK_DEAD)) {
 			unix_state_unlock(sk);
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_SOCKET_CLOSE);
 			return -ECONNRESET;
 		}
 
@@ -2757,7 +2757,7 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		unix_state_unlock(sk);
 
 		if (drop) {
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_UNIX_SKIP_OOB);
 			return -EAGAIN;
 		}
 	}
-- 
2.53.0



