Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704431;
	b=AkEKOP3UEwCYjpYpmO+bQiPAVP6JYJInSXa+Pi7dOatiQZRJfS2jw6iTFoM/g/37dvDG
	 6IkrwatIUTybxVHV/3UfcAl4rdcSSI7sI+qFkK0Sogqp/ddzed8fzNNMCdk2AOFy7HyW8
	 YX1enCoMozAuaDYNr+rCAVwRpOfTyV2SCVfEChkJxfN20yynj2gO355JoYH+q1jYu0mJX
	 5GTK6kjQKT3uxHRl3l7xB8d/Wz14GhoqwpUcMsgSx6gf4539+jSdnztbiwjRVPxaOptsi
	 5LXFkZKnqy5wgCa6Ov7Wg0Dt6waD711ZUG2WM4PdCpdIMLbCdZTKYKNEOr9U+JSAcng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VsP8R9BqyE0dnfxkBNgIzFjJfuM5Y3aYchySlZ60vPQ=;
	b=FmiYEcpWfP6/YVBfU21LQq0crT1ZB4lczdThzEMYHmPdmBWhztFcer9mVM+/RQAfiTVQ
	 Gqa8ttwsa14uHtS8ZNdX3H6P0HplpoQHBw539ilCwaJI7zzY1a4ygzVE7K2qe5oQ9E7q+
	 OgwurCqGrkekUe7pdPQMgzq/m9lsDsDzP1eVJQqr8kMwuNtShMIA/7Ds4PxrDKWV8BqDA
	 p64+0GzlL3hDgWIv9q5T/k7QbfUs2yhR38YS24OyNfKZoRlLtES7hZcKjegnReHnya7tX
	 j4CFA3mR13VtoxiiWduK5kEsaNh1p3MftXs4mEQX7jJbWZ0tvnn/pFooMCxFTa+eHcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulDE6vBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92EE606A31C;
	Thu, 26 Nov 2026 14:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulDE6vBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EC91F000CA;
	Thu, 26 Nov 2026 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704431;
	bh=VsP8R9BqyE0dnfxkBNgIzFjJfuM5Y3aYchySlZ60vPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulDE6vBveeJyyOsMkf74oraH1yGGh6DMIxKKTV1TvkRvQV7aRQidxfYf7jixEQZIi
	 wEAVSSi/2nxPwVIVos7BlpktiEF41LDXpF9p8Gh7UZnraxxK88r1NlXZTnpmIcdfPQ
	 Bfg5jXfTSA2vTmDEqaM/b938LlI5/TPY7hmV3/C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/265] net: protect negative destination advice with RCU
Date: Thu, 26 Nov 2026 15:37:32 +0100
Message-ID: <20261126143613.534072598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 4b77d2792c3e482afa108c08f224ea6fa396d80b ]

SO_CNX_ADVICE calls __dst_negative_advice() while holding the socket
lock. Connected UDP sends can still invalidate or replace sk_dst_cache
without that lock. A concurrent sk_dst_check() can drop the final
destination reference and allow an RCU callback to destroy it while
__dst_negative_advice() retains only a borrowed pointer. This can cause
a use-after-free while accessing dst->ops or running the negative_advice
callback.

The writer-side ordering fixed by commit 92f1655aa2b2 ("net: fix
__dst_negative_advice() race") does not protect this reader from an
independent cache replacement.

Hold an RCU read-side critical section across the lookup and callback.
This follows the datagram release callbacks and covers IPv4, IPv6, and
XFRM advice without changing cache-reset or reference-ownership rules.

Fixes: a87cb3e48ee8 ("net: Facility to report route quality of connected sockets")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104131744.1056562-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b9c44e47cb7a7..4081cae7172b0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2070,10 +2070,13 @@ sk_dst_get(struct sock *sk)
 
 static inline void __dst_negative_advice(struct sock *sk)
 {
-	struct dst_entry *dst = __sk_dst_get(sk);
+	struct dst_entry *dst;
 
+	rcu_read_lock();
+	dst = __sk_dst_get(sk);
 	if (dst && dst->ops->negative_advice)
 		dst->ops->negative_advice(sk, dst);
+	rcu_read_unlock();
 }
 
 static inline void dst_negative_advice(struct sock *sk)
-- 
2.53.0



