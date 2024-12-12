Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B16222D70;
	Thu, 12 Dec 2024 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021183; cv=none; b=eXCvV+cPt62BqefOzC/wUBAaHYP4MV202tQZkbEQ4NT9aZ1ToR1ImmCvf4RVZGF6zbXgjhsyM7tt/BKTWDicn+qX82DHyHm5rD0XRGlbDPLPNrp83/2bToxRXv1la9oHRvu5JqeB6GtTcIdp3MV9GabXL3I6U2OSUFNOL3UQFpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021183; c=relaxed/simple;
	bh=wGUt6wBkJdYni3WtQQfGJeHtpivty55OuQ10LFzd3jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csZFOGxmUjVRqQr2vZ7FHrZL2GvcZrqKCmEZN3N/QGlXOqkjAAzoD3XS9Sz5TgbTkJBXc20SLfcEj6JG7S9JXUB7DOmM+ZJ5V1cPolC1bd/eJkMUHDhmHtDSxj7N33C2oO7CXltoz6//FC8tPftJt13JX9KFqSspdk8rrL6YqYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlPo6Pxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlPo6Pxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A210C4CECE;
	Thu, 12 Dec 2024 16:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021183;
	bh=wGUt6wBkJdYni3WtQQfGJeHtpivty55OuQ10LFzd3jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlPo6PxaDGkmJhD4AXzY5w0p8aYORwvl36Q1x+b2d8/3Mr2+uMiAGFFjBs/0sG82C
	 SgYfUIUhQfp3936MU2p9bNIsrrx5FPFcHEZCQA6tGXfEjaO9aIRCyMPdyBtlRpSgQ1
	 5QuugUCwr9LhvFVky7YJ1MYTatScXIUSxI+im184=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 668/772] Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()
Date: Thu, 12 Dec 2024 16:00:13 +0100
Message-ID: <20241212144417.515525975@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b17782dc513b5..4e965916c17c1 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1920,6 +1920,7 @@ static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock,
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
+		sock->sk = NULL;
 		return NULL;
 	}
 
-- 
2.43.0



