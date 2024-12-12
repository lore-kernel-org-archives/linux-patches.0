Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9478F2153EC;
	Thu, 12 Dec 2024 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024735; cv=none; b=snNxmq+e4ih2AQBnoPF1hGIgZ6VlVVzaXXmDkyjy8fvEuI4U1wkzfyPf6cHUXSP8jtc/8O3DyoRnPBRO4rza7t8/nFqM48icWn3PP4jsY4GhNTwvuiEWToCoOxMwcH5HotWW/knyAjFZXejw/DntBQEas0jgJ26hu/6bG39kgEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024735; c=relaxed/simple;
	bh=qO1tKx8zIn9EMGYZ84eg0rGvRV5O2nFxuMQdBa3oAxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4L2KPdrwlzDz8UKQzdaDayTXo6Bn5nF10fPKd6AabdY5pcGUXFeZ2fFs6OPqHyzaH3gigQ/Z+fM+L9hqroebMsRtr4EEMaWuQWcX5O4sIJ+474HEvnhROi0PG51g+cs+63iz9D3cYiIVvdlnKk6Y/8NsjtkvQS3JKEBtKcEnGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWJSwASt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWJSwASt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1490DC4CECE;
	Thu, 12 Dec 2024 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024735;
	bh=qO1tKx8zIn9EMGYZ84eg0rGvRV5O2nFxuMQdBa3oAxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWJSwAStf9YJryaXNsjVV+J+3UCWV20lzlggFFC47SwZfitoAPwhcu6wDw2StzaQo
	 ps4oEsOm6Sz/ZdlRWhFt01KZzrLqpcPbr2jb0Yvq/JbkfgZ8AhLX6hruNg/GriKjMT
	 09Y0PKNv9jS7LyiBBv9X+KuKe/Sxa7SmS3IEWV4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 395/459] Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()
Date: Thu, 12 Dec 2024 16:02:13 +0100
Message-ID: <20241212144309.367995420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 93afa52c04660..cbaefbba6f4db 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1864,6 +1864,7 @@ static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock,
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
+		sock->sk = NULL;
 		return NULL;
 	}
 
-- 
2.43.0



