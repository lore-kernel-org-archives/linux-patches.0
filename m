Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555272236F0;
	Thu, 12 Dec 2024 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023387; cv=none; b=rDQ781U6rhkq5yTLUDjHO7yZaxjfe005rGbnzKLzomvqyCjdBNUbvOGjqjzUGAVyxjXAvbkvCk2Wa7zdvw8EhKe9GrxYqGJ9AyZFMHpRDsGZM6i11O1y9F5c7v4CC6bT/r5ytqpjLx3zML6uBAmH6aFyGNSXlTYwBkKgM24knaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023387; c=relaxed/simple;
	bh=dz+pv+xOrhr6mYRYBslAHoeGFYxrt2fT3VC/Cbq4arM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HESgFpb9WlLRstE+GaAijnTXPNPG3f5qa/1KU98kMFlYENh6PsVWAnUfv8SDKL6XKi2celkCHFaRDk+DGL/jPhA0hNyzEriRhf03nZoZ1xNuiCQ05yjNuZMwJQLmkL+3OyAoiRi14yfN7yWL+W3PND4RYstw1+gjVqkwRjgF1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2oa1vMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2oa1vMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE351C4CECE;
	Thu, 12 Dec 2024 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023387;
	bh=dz+pv+xOrhr6mYRYBslAHoeGFYxrt2fT3VC/Cbq4arM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2oa1vMPAbTFducIX0Z8qpJ5AVprzwzo9T1AftN5b1a2tjzAcCwjkk4Xrn0OXn2oH
	 ILQp1kzOCv/tj+EtJ2R5pUYSIy/7f30G1NIcvONMyDL2W7T4/hkVQG4Go0URVuBRn6
	 Yj7DX9Eif2Y+Wax0xZqkoiFDKRoXCl8PbXudNnbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/565] Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()
Date: Thu, 12 Dec 2024 16:01:22 +0100
Message-ID: <20241212144331.012380235@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3a2be1b4a5743..57035e46f7151 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1876,6 +1876,7 @@ static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock,
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
+		sock->sk = NULL;
 		return NULL;
 	}
 
-- 
2.43.0



