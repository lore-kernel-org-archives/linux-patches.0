Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C981521E0AE;
	Thu, 12 Dec 2024 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018296; cv=none; b=iOy8KUAl9oNFHgUKg0W9CsgN/KQUSWWF1P6wvBrX/wQLyv1Ds8LDrNmXgJCRp5vX9AMsvYzSy5g63LfLz4CSO48XiozaPWfGuI0ueLX0QckKoU57agDBMMT3QiIRV+p/yncR5vbuB6sIunZ8B7/3Kv29asTTKOtyjhBKPy15524=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018296; c=relaxed/simple;
	bh=khhYCPcN5U1AaoxDTy7YZEXS0Ew/RHr5c3WPlwOS5Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiBrupzEJ/SlryWL6ZISlDw5rCW4akK2iyThrIEOBNMGp4dQWows4pPkAriXHOu61axlFdqffocbCyXSuFyQXs302pVu5PEPkAxsxmQ/XwDx7Od5Ov1voFepeUPljOgAOw1d3iu02MIDPrhOGKfe1kHXp/5vkv/UP+WKKIO/UsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oshIAd9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oshIAd9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ABCC4CECE;
	Thu, 12 Dec 2024 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018296;
	bh=khhYCPcN5U1AaoxDTy7YZEXS0Ew/RHr5c3WPlwOS5Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oshIAd9Hv3V4OLd2Ch/HrKd5w/kuPVERge/elUxd9ORN46keg1RERQESHWcxfYmYV
	 tUVgExdBN6CQRwhLYyGAYoVxLbbw3rKSxbvagvsNHWAqjtLWhGKX4UbPWdoeAgM9D5
	 gKWihbm7slIcmF7VAOPLImID80UO2+QsdI5hBUtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/356] Bluetooth: RFCOMM: avoid leaving dangling sk pointer in rfcomm_sock_alloc()
Date: Thu, 12 Dec 2024 15:59:05 +0100
Message-ID: <20241212144253.548346566@linuxfoundation.org>
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

[ Upstream commit 3945c799f12b8d1f49a3b48369ca494d981ac465 ]

bt_sock_alloc() attaches allocated sk object to the provided sock object.
If rfcomm_dlc_alloc() fails, we release the sk object, but leave the
dangling pointer in the sock object, which may cause use-after-free.

Fix this by swapping calls to bt_sock_alloc() and rfcomm_dlc_alloc().

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014153808.51894-4-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/sock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4fae82fedccaf..1cf6543bdec55 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -274,13 +274,13 @@ static struct sock *rfcomm_sock_alloc(struct net *net, struct socket *sock,
 	struct rfcomm_dlc *d;
 	struct sock *sk;
 
-	sk = bt_sock_alloc(net, sock, &rfcomm_proto, proto, prio, kern);
-	if (!sk)
+	d = rfcomm_dlc_alloc(prio);
+	if (!d)
 		return NULL;
 
-	d = rfcomm_dlc_alloc(prio);
-	if (!d) {
-		sk_free(sk);
+	sk = bt_sock_alloc(net, sock, &rfcomm_proto, proto, prio, kern);
+	if (!sk) {
+		rfcomm_dlc_free(d);
 		return NULL;
 	}
 
-- 
2.43.0



