Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF10B4F218;
	Thu, 12 Dec 2024 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018257; cv=none; b=WAU7h1roG9pdBk/2Lne3E1x8GL0bCnkvELsfLDhJwatxg49PPicQSNZsxn3sBHZyt2YTv76nN6cdKjvXfjSuIVs5CVasZSYd0l0UEmEivrK3mp31kvT1iSaIicxoqcePYyYhn5zGhAtvW80yMr+Bzg4DThMpKbtIS/6g6l3VOag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018257; c=relaxed/simple;
	bh=kV9G2O1n4OMMtzYZghh+nIYNxXIackMO+zu9pcHA24k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op+w9srd9V7VKN03MRkYPflcx53BVQsY3kU0BeqS6qIZz10V8atwtdBWcs7jP0vGu+fvQH9IoG/ZseAoamGKM6DafndXKEhrfgJDku8pg/g0Edc087xfuBn91wy/v62FSFFreJKKqIogb7YmjcUkViXn1MMaZevu8gkMMWZmVNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJOpN+c3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJOpN+c3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10937C4CECE;
	Thu, 12 Dec 2024 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018256;
	bh=kV9G2O1n4OMMtzYZghh+nIYNxXIackMO+zu9pcHA24k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJOpN+c3kF6Fxd69A2rGANlOLpprvmj9uWp+XHXTUyFjAMzMWUKZSXsrVe9TyWp2x
	 Gcv9UPfzYwaH4BQV5SjkgNhyDbmIV6wxDP/rDrzVk6iU/RJYZ+ZhrUa6haEjYFdZmO
	 uk4vPuny/7C1PuVNk5jQwScnKsAdQpPiZ8E+2Alw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/356] Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()
Date: Thu, 12 Dec 2024 15:59:04 +0100
Message-ID: <20241212144253.510815303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit 7c4f78cdb8e7501e9f92d291a7d956591bf73be9 ]

bt_sock_alloc() allocates the sk object and attaches it to the provided
sock object. On error l2cap_sock_alloc() frees the sk object, but the
dangling pointer is still attached to the sock object, which may create
use-after-free in other code.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014153808.51894-3-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index f04ce84267988..379ca86c41cd5 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1885,6 +1885,7 @@ static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock,
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
+		sock->sk = NULL;
 		return NULL;
 	}
 
-- 
2.43.0



