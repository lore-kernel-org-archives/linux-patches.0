Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585413;
	b=TJdLn+iGPBGj7b8wx0jyF4cJAvzdvafeIAGKwX06dPGuw/BuiefFApDUTExWvL9mdxeb
	 BVVKKjWlat7IwdJPfgVfbtJQXrbT3ASya1mv+iGs/ecnztP00RSuevSpHuzjKAfg8OTCv
	 mU64pBjiugqjyGvTyNqIAAV+Hp/SmKEl9aE3mrtPXgA7+9t+g6d7aZXoHKvbF+Btcgt7i
	 3ox/9NbGLEDOh36ULf1+YRbcDWCaMNuu7WQLCuvfskFvuaRfoNbrbkO8bWME5kU8Zr+vS
	 6RNuLpnDRMCPqaFN2WsXh095oy8phR0bYdp67o0F3o6lEWrFWcD+Q4NZOy3zGbwzTQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ueEPkb2vNoDyCxMo6GTcriFaARl7YTwG2S4dmI+/UBE=;
	b=MQ7eQ6fUyyarVdWq0X8l5BZHLeNMZUeDOuGopYoPTI0CHIPH2rudOYjRy6ZehFqC4I+k
	 xB0NEC9+V5bJPHgp7FyOdZ3Ijw5UDpWODVM45LCdVXKT9TB7jaF83eJOrrT9/xfNs5YRX
	 kWuERkTGb6c6IRVDw7farBLOYJHGPQ0krARzqCyT/TJKG1f2kwPJeds/HVUK9lfIyQtvQ
	 FX9ELM52815pBOP3P1iD9l0jKpfuaLAqu2XFMWf9XP9u2n4Sx1E561gGj7f3/pxf/Bg7m
	 jpOx+Jot3ShlLWaaUK3QJz2oadLSv0ks/L5gpuoZTDMcYnTpTOfrBpFBHh9hLqT9e+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLAZpQNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DDD606A88B;
	Fri, 13 Nov 2026 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLAZpQNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBC61F000C4;
	Fri, 13 Nov 2026 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585413;
	bh=ueEPkb2vNoDyCxMo6GTcriFaARl7YTwG2S4dmI+/UBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLAZpQNh2P60mV0qPTSeBkpjsB0FDI3ZXoSaFm0zoHChn3ZVwEiCulgOD14p77ETD
	 w8sRuWDdd2XGPR3ZRzjhxYXs4YErlnsEPOavXNl+zpq2KoWZvGCeF8NKspH3OR6emH
	 n13OaOY42Bqhwn7KRi5MWf3St4veoR0UyJFdREj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 053/507] net/9p/usbg: always reset completion when disconnecting
Date: Fri, 13 Nov 2026 10:45:57 -0500
Message-ID: <20261113153755.350780372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit 08c6b9f484a406d9d87c5b2580725d2e0597f3b9 ]

When some tx or rx transfers were pending while closing the connection,
the completion handler could catch one pending completion call. To
ensure a normal start when mounting again, we have to reset the
completion and flush any pending completions.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-3-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index a06d0ac163b0d..ce952a5de4260 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -469,6 +469,7 @@ static void p9_usbg_close(struct p9_client *client)
 	mutex_unlock(&usb9pfs_lock);
 
 	disable_usb9pfs(usb9pfs);
+	reinit_completion(&usb9pfs->send);
 }
 
 static int p9_usbg_request(struct p9_client *client, struct p9_req_t *p9_req)
@@ -758,6 +759,7 @@ static void usb9pfs_disable(struct usb_function *f)
 		usb9pfs->client->status = Disconnected;
 	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 	usb9pfs_clear_tx(usb9pfs);
+	reinit_completion(&usb9pfs->send);
 }
 
 static struct usb_function *usb9pfs_alloc(struct usb_function_instance *fi)
-- 
2.53.0



