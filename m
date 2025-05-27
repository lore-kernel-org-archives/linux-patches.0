Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA127D784;
	Tue, 27 May 2025 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368231; cv=none; b=Lnwn02DwNuA/V1LzmrWlBA+AHVS07oFHDzct14Q5PNoljiX7ZIFPATvVfW7HHffBUDIYYG5vDXTruMuhxy0zHLN3I3o8+cj0u8yZEwMHi9toTVEMgA83x6SEu42NckunrABCRK/ypGcP8dNRVa0IoCDHvxfscbloCc2zxArtc+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368231; c=relaxed/simple;
	bh=tmDKwsNoYq3p9T9IPX7ZNmscQmPTu6F9uwLhv0dyTy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRyVrAjR2IVhPu6mpcnCYpu/Y1W4ZhqB7w0v9Xw9KlYKSVq2ro50vjWpIiebvzUZ+6xpNGNJj5uDKqCCfOyui4VkrIMWdwbxmBnrZwEq+YRNnXmB/2NkGgYxz5OmICFzzzm/snb8ooZKpRDIcTbTR9n28ICQuazWgxWUHoxgM4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVI2jH/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVI2jH/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B404C4CEE9;
	Tue, 27 May 2025 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368231;
	bh=tmDKwsNoYq3p9T9IPX7ZNmscQmPTu6F9uwLhv0dyTy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVI2jH/wN8ZS98JuyJtBmRm8B6vt6RxXngUw6ZQAoBd7OdSejpJPgsbpUc40YbCbb
	 xb3Y8SfrHMSTDxcCCDqFiWMvxaW3npLnWOObyotRnhUDDfJjx46AqoRbZDwKeY6+CR
	 Kznczqa4WCExcKZzaG81jrJ0BQsEwZamZRnywLok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 639/783] ipv6: remove leftover ip6 cookie initializer
Date: Tue, 27 May 2025 18:27:16 +0200
Message-ID: <20250527162539.169761688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 54580ccdd8a9c6821fd6f72171d435480867e4c3 ]

As of the blamed commit ipc6.dontfrag is always initialized at the
start of udpv6_sendmsg, by ipcm6_init_sk, to either 0 or 1.

Later checks against -1 are no longer needed and the branches are now
dead code.

The blamed commit had removed those branches. But I had overlooked
this one case.

UDP has both a lockless fast path and a slower path for corked
requests. This branch remained in the fast path.

Fixes: 096208592b09 ("ipv6: replace ipcm6_init calls with ipcm6_init_sk")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250307033620.411611-2-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index eb636bec89796..581bc62890818 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -2055,8 +2055,6 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 		ip6_cork_release(cork, &v6_cork);
 		return ERR_PTR(err);
 	}
-	if (ipc6->dontfrag < 0)
-		ipc6->dontfrag = inet6_test_bit(DONTFRAG, sk);
 
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
-- 
2.39.5



