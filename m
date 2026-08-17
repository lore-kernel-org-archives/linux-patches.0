Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8A2282F29;
	Mon, 17 Aug 2026 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978962; cv=none; b=jSA+VVN6gucWOjp7gLHpH1R6Z7Kswikk5cOKuLPitOzBfloVmXRlQbYZT1KnQNV1Ba55Ok6n8GhFEsN7u7TtfMTyHn19D/wiJReJgdtJAWXI8Ia9UGb+910Hl/VN8gvPGdwhH0O4oBUniORKGCEO7rKWN7f/VYgug8RUxQCCNR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978962; c=relaxed/simple;
	bh=/GBDYJAXJTIQE04cseblJoSiCqu0dOi9ORMF2y3BpZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGfYEF9getakmc6awYkcOevbHfXqRuh1ThdKEYXh1Y6bM1wCPNYou0r6z6IHZm7xsRn6L5/PIWezAz6in1sBD6QIPoSaH1DlKzqObDVWNIMUNFIAjO+VMQFE4sWIPnUTucPMzM6Vz4WLOv07nt1fXmJv+6N43nWfKdUQmgrGPSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X98m61ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X98m61ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685351F000E9;
	Mon, 17 Aug 2026 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978961;
	bh=kA3Bkrpr2pnIsZ0O/6XXMOdeunO8o8LNOBoDrEWGUts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X98m61ipL94LYr601MrZ5/9luwxGAJUrVw+Q2v5TPcepNIsOyZKqyofLDJW+UIhoi
	 Z+Qisd8+gUtXUOBHA6QlgcpKV6hhEvLruGoV+Rr3y2xCmFua6101xhkFqvDZt1+440
	 DuK7ewt2oPrPYl2qJKrWLGnkmaPP95Pxgg8rYv9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/609] net/iucv: take a reference on the socket found in afiucv_hs_rcv()
Date: Mon, 17 Aug 2026 15:25:55 +0200
Message-ID: <20260817132545.431615881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e9a9bb0dee065a..a7b95590f6c96c 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2090,6 +2090,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 			}
 		}
 	}
+	if (sk)
+		sock_hold(sk);
 	read_unlock(&iucv_sk_list.lock);
 	if (!iucv)
 		sk = NULL;
@@ -2139,6 +2141,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 		kfree_skb(skb);
 	}
 
+	if (sk)
+		sock_put(sk);
 	return err;
 }
 
-- 
2.53.0



