Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE87443A9D;
	Thu, 30 Jul 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424913; cv=none; b=WlpTOa/3GNtrpy8yzt7nkIX2mp1XkAY9zFBSpQvy26H1rMzdIDHtFbKXNP/HE0DwSdQSRQHMrCrWu61Oj/VOnZfNjUEg6DKfPXRWIl7UwfvoebYViBsS1S155W+f1Tgtu/+mmmL7Z6/fvGCRAlqaaygVJ+sqSQzGaqhZvjgNAPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424913; c=relaxed/simple;
	bh=cFiI00n5pryNbK27TuRKk47l4k088tF6Aq4mug1gpAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDoEWDFgK962V8/zHj5JoKUe3VcRDpm3Dpbs+ra2uA0BE36xGreXooZR6gX0agQ+9CCdYy+ca/C/CHMgLUFyFVB4Kch31mbsWaFiF+JVh3jBh4L/t1l8IBrPRGxDo+DvflLnqX7gRUuHheTdUY9cwy2uAIEbKXA+hNNVKTB+lhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7Tu1GYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7Tu1GYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D371F000E9;
	Thu, 30 Jul 2026 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424911;
	bh=oaWwEmC7GLI7mBG1odeS3QJYsx8dyP1dxsMtUQOTDE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7Tu1GYWGCZ2B94YjvHyYAD1itUaZMxvVoQS7iaEi6D3KMIkHiZ0O6fKMKY1GmIhv
	 bpR1mE7ot9aoFORUtwa8zX0P8avXZ1sT6gVQc1qyS5RZZWjg31PPZM0PnuXI+7KnDb
	 nHqlBkYTv9ugeZp4l3oay0Qo5hKut6F6nxeJmeJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>
Subject: [PATCH 6.18 561/675] ovpn: hold peer before scheduling keepalive work
Date: Thu, 30 Jul 2026 16:14:51 +0200
Message-ID: <20260730141457.057499642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit a4710ae2e7e322fdaefb4be8604228279cfaf48c upstream.

ovpn_peer_keepalive_send() passes its peer reference to
ovpn_xmit_special(), which ultimately drops it. The keepalive scheduler
currently queues the work first and takes the reference only after
schedule_work() reports that the work was queued.

Once schedule_work() queues the item, another CPU may run the worker
before the caller gets to ovpn_peer_hold(). In that case the worker can
consume a reference that was not acquired for it, corrupting the peer
lifetime accounting.

Take the peer reference before queueing the work and drop it again when
the work was already pending.

Fixes: 3ecfd9349f40 ("ovpn: implement keepalive mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ovpn/peer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -1280,8 +1280,10 @@ static time64_t ovpn_peer_keepalive_work
 		netdev_dbg(peer->ovpn->dev,
 			   "sending keepalive to peer %u\n",
 			   peer->id);
-		if (schedule_work(&peer->keepalive_work))
-			ovpn_peer_hold(peer);
+		if (WARN_ON(!ovpn_peer_hold(peer)))
+			return 0;
+		if (!schedule_work(&peer->keepalive_work))
+			ovpn_peer_put(peer);
 	}
 
 	if (next_run1 < next_run2)


