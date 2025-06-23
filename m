Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA9815ADB4;
	Mon, 23 Jun 2025 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717272; cv=none; b=FS5I7YWYnS5rFw+3A48Veef1Zu960079oWBjZAEE6JaU8WQO/MgNWBNB8vkjGAvUWM5PR1Uc+vfw2XYYXZ+9BEQ/tRU5Le8hlcAIizzzTCA8FZqn6jlsSzqzceUo4hRt8m4YaFNKhJTjui3twxJxLOQ+ao8L/AbI0Rn8p2yEUnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717272; c=relaxed/simple;
	bh=SE8pE2Qy380dGX6kkBHXLiIplFKPTowJtwCP7Q1JPqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxQLYr7UzacklZ6LbROqzFWgyKQRfci/E3h6mIqc3zxJIf0CU9WFMq12RD5zB3BKo54Ydq2IU6eisXqOuOShuHT9FTURSDZr9WDU6CKVNac9H5HkJEfpF1+1ZsriAfwijCjaxMuJlNfcH6w8NhFsjEv/ijwT4lgD6nGEwsdM3rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0qXMUSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0qXMUSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33808C4CEED;
	Mon, 23 Jun 2025 22:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717272;
	bh=SE8pE2Qy380dGX6kkBHXLiIplFKPTowJtwCP7Q1JPqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0qXMUSn6hvvcNXMPUl1KWMYFvwXXGTTjneyxtkYbzVfUrHxIiMDsgrTkBYwgSQwM
	 DCVqK3iLquRk0V4vlMPS5IUgqpdQEILSORihVCh3Rw0RvjvXuyRvGOxwLSuCW01lBh
	 BSD78mUDQKJrL+bTkWdjA5y6jLDQwJIYg4VKg23Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 350/414] ipv6: remove leftover ip6 cookie initializer
Date: Mon, 23 Jun 2025 15:08:07 +0200
Message-ID: <20250623130650.726178264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit 54580ccdd8a9c6821fd6f72171d435480867e4c3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -2043,8 +2043,6 @@ struct sk_buff *ip6_make_skb(struct sock
 		ip6_cork_release(cork, &v6_cork);
 		return ERR_PTR(err);
 	}
-	if (ipc6->dontfrag < 0)
-		ipc6->dontfrag = inet6_test_bit(DONTFRAG, sk);
 
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,


