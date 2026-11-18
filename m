Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018776;
	b=dbMVa0aDAVF8P91RZ1Mt6mtiEqHmD14rflOTpkr31iCmCngWf9gmBREo0XM8Hw/JPxLF
	 7Y/AeWby0siWhanMdLgFKcn3BPXVvm8qyYVAeqzSche4VzimMW86owOOGaBmtjmht9nSF
	 +A9yuAC3SrOulYrydpO/hJjbEFeKmmwuBF7JTjndjXq+sXoIWm2FXyclAKIreq3ZiZOVe
	 SEshMjrwGNU6RwIVmzvo7s8Vknr9fdNtxC8wdbY0cFKpM6u8+H7wlgw8WmDTw0J+nC8HJ
	 Uhm4cQUiW6IJKvNCrezA5AOJBLLgi3zaVoNHINvAe3oSrgEEU90pfE8ibJZ9gjD6p9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZkO3M5cVZzLLYE7x5jMrgzyH6HGNN4Z5gzHslSiR2/A=;
	b=fFWCEKHbkBar3VtK0ek9x4+EG1sUn6salVlUDhu+xeaJfHzw3efJaKTWGO7e/uZ9yo0p
	 nkpR4d+a2aDGNiis9ASiX2HQBDYC2Iu8Isp739WwtcqYjorRiZyKG/meT9R4OfFeiMYch
	 LEaGeY3XlAIWPPS2am79gToWpbZSpUuN5w0M+MZOLeu9ve21Q3sgZ/1ThKQkWNE2x5TaN
	 LTGzKL5+RHSBaKnNweGYOGZUL+HMnrw5oIinGfWeNcv2HTJKIVQCp4IqWvGWT5NhgdJ8m
	 EpIhoM8jHhTu5DkYggkjVOWfZwFj0hzM/qMI2tJiKhvJo8Nb0AgBcK4ahxLd6Lje6yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nD4uPbIw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BAA606A32C;
	Wed, 18 Nov 2026 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nD4uPbIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA8C1F000C4;
	Wed, 18 Nov 2026 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018776;
	bh=ZkO3M5cVZzLLYE7x5jMrgzyH6HGNN4Z5gzHslSiR2/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nD4uPbIw/aow4HF62sodll+XGYjxx9fKmLe4qeMRpAdIM1UWMrT738XqJatdcZpb3
	 nJIodoOev5D2O8Qz1XFQnZ4DuTX0uOyIYHhDdCNslkJ08Mby9wCQT5+f4M5z91M0fF
	 gxesevXrzneWKWR7XiG0jMkNQ57d/j/eg33gMVI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1361/2651] ipv4: fix IP ID reuse in ip_select_ident_segs()
Date: Wed, 18 Nov 2026 15:43:21 +0100
Message-ID: <20261118150337.024714225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit fe7ca0c13f7d477d6f461114815c57fde3f930ca ]

ip_select_ident_segs() must put the first of the @segs reserved IP IDs
in iph->id, as GSO assigns id, id + 1, ..., id + segs - 1 to segments.

Commit f866fbc842de ("ipv4: fix data-races around inet->inet_id")
used atomic_add_return() for non-TCP sockets, which returns the first
ID of the next packet instead. Consecutive GSO packets can then reuse
IP IDs.

SCTP GSO is affected. Other callers use segs == 1, and only see
a harmless off-by-one (UDP GSO has a separate, older issue).

Use atomic_fetch_add() instead, like the TCP path.

Fixes: f866fbc842de ("ipv4: fix data-races around inet->inet_id")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930144018.1174068-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index f0aeab1b1a3b3..29bb02db8782c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -580,7 +580,7 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
 			val = atomic_read(&inet_sk(sk)->inet_id);
 			atomic_set(&inet_sk(sk)->inet_id, val + segs);
 		} else {
-			val = atomic_add_return(segs, &inet_sk(sk)->inet_id);
+			val = atomic_fetch_add(segs, &inet_sk(sk)->inet_id);
 		}
 		iph->id = htons(val);
 		return;
-- 
2.53.0



