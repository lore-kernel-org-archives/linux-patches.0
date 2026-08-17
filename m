Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0737124EA90;
	Mon, 17 Aug 2026 14:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976601; cv=none; b=O9TdNPGFxwlKpIDO3nVdXwruFLXoWrXfeAOQ1/Lf4J1NYH//ipuJJXAeSrYoSVMQxp/VswvBa65ac5o90HU7qjiyYQ8BPbEOH1bgyZ/izkV1tDSNRSqJWUwhVSojGH9CUmmh8p140EngWxtLhDjHOPjlNXg67Zpkxj0qZaGMG/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976601; c=relaxed/simple;
	bh=fKfYzL788UpcMPM2OqmXvxhEYmsb6Ml4dqqXklJLMRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOD3gAH8wcjlM4gO9BjLzU8NviMpC+5bVbhQ8QTpSsVxxkiKpjG8QuY+DPeuOklbTKJOqK00sqD9HQOaT6TCkoYD3sif7yLC6mO3c47cY7hLukUyohZk9RPsYWbLSW/SC1u4U9u+MPGIQfFRQxyq9PaDrg2DN6z+L09yTTidlJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ct6oWtSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ct6oWtSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604C11F000E9;
	Mon, 17 Aug 2026 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976599;
	bh=NPK3JdoHtcQsFiuUh6vWNDR82bH3pjG0wYjt2/es6HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ct6oWtSyilzgMu6JJ/dcLRit+RYzbtuHhuM2uDrn9hB0l4tnXyT9X6wzmigQLxkwd
	 LX0n45rMGXq9di5Nc/FiB6cjh4GZEb/rUqjL8FCFoTKWemCq8pq6fLaQGwIbWJz4Gl
	 epXTYDV+50IGFTc/xSkfTRQ8aij8kE2puGQSfxvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/456] net/iucv: take a reference on the socket found in afiucv_hs_rcv()
Date: Mon, 17 Aug 2026 15:27:09 +0200
Message-ID: <20260817132541.556304428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 4fa349156043dc119721d067329714179f501749 ]

afiucv_hs_rcv() looks up the destination socket under iucv_sk_list.lock,
drops the lock, and then passes the socket to the afiucv_hs_callback_*()
handlers without holding a reference. AF_IUCV sockets are not
RCU-protected and are freed synchronously by iucv_sock_kill() ->
sock_put(), so a concurrent close can free the socket in the window
between read_unlock() and the handler, which then dereferences freed
memory (for example sk->sk_data_ready() in afiucv_hs_callback_syn()).

Take a reference with sock_hold() while the socket is still on the list
and release it with sock_put() once the handler has run.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260705-b4-disp-fc79c0dc-v1-1-d2cdcb57afa9@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 3188d719a2e42d..4156e69496b67e 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2084,6 +2084,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 			}
 		}
 	}
+	if (sk)
+		sock_hold(sk);
 	read_unlock(&iucv_sk_list.lock);
 	if (!iucv)
 		sk = NULL;
@@ -2133,6 +2135,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 		kfree_skb(skb);
 	}
 
+	if (sk)
+		sock_put(sk);
 	return err;
 }
 
-- 
2.53.0



