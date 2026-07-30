Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AFF443AAA;
	Thu, 30 Jul 2026 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425481; cv=none; b=kSBCCUr+zIf7621nOdy0tNi47YUEevS6aYy4b7tGeLoZnhxTJoKOEn/zau3tIqg1p03Evglsq40MkDq6OY8i5BUQwr38jEQF4Oxm5oq7DFlcXTmPomrUtsJ/yyIFeDq37YTDshOHsfT0iigwVbcNncy8/60604VqkwsvPc7DQo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425481; c=relaxed/simple;
	bh=biq8rDPIpdJyi3bc9CIc9v56SZER4o57yV9t2PlhiqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2sRFJWno0nX4+RZyqB70Uge+ug9DYNp/Bu1lb2mEYYq6aQwOV8xqFwaBu1AWOmNHqc1VdMO/jEH1yFR6FwY291LViHsxtN1F5aNqPY+aGaR7KVJYyPSfMsC9VEXxwNkA7mnnmE6mzvTADfMSpO8SsdJ8S5l7RID72/O7p6zEv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk+wYcbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk+wYcbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A81F000E9;
	Thu, 30 Jul 2026 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425480;
	bh=6bfQWTRQfmAiO/irvSpy49wMgno4c8rGCEFsHG7WOv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kk+wYcbMPnx8yN8vxxhllMuTTqSbFm/aRedEpShO0EoWcKRnfpEJOykHvXi7vDMKU
	 GsL1kcPHoz9hcSkFVblcmL9aHPJ7c1FHbIJ9cW2tg03WUZL9/v7irCMJvFAFJ++X7D
	 gNEdY5zxIMGg9HT7FIZmALRWxDXXzDcuO6vkVEXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/602] net/iucv: take a reference on the socket found in afiucv_hs_rcv()
Date: Thu, 30 Jul 2026 16:07:54 +0200
Message-ID: <20260730141437.721109310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1a0b41fcea8131..bb54e23397e8c6 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2088,6 +2088,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 			}
 		}
 	}
+	if (sk)
+		sock_hold(sk);
 	read_unlock(&iucv_sk_list.lock);
 	if (!iucv)
 		sk = NULL;
@@ -2137,6 +2139,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 		kfree_skb(skb);
 	}
 
+	if (sk)
+		sock_put(sk);
 	return err;
 }
 
-- 
2.53.0



