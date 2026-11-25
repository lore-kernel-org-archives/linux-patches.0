Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621339;
	b=1U+jBLinyNl5xiyHbRqoRdS6GP/ODuZc18L6ihsuJATFx4kQwJGtJ+JzXNtGTWwEpIy4
	 rZrELvYzdDzPvucwpS/WvxBZ71GqLzfn70zNsaVt8ueNlmf+OZmmOuHrypsWuYF7SXDxc
	 9NIw/FmGn5aW6hIgJU4moHw880GcbkHdZFDeGxS50j/GryMpufTP7QqAEqVLOhlsQ+iUd
	 4PBsbKJCY71KDYQmYXOXmmd9YD74Cxody8CSr+yoYSa400SWB5oE48lKvzInEDTpFnMuK
	 YDfGbIde3GMEey8f3DE84yCbbcOk7cmMjIcMyeUyj9Fjw2Z21bpl/tTSXXgTt9TFefw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+RvxM2jQAzEyVzW7IO93vdP+52EOUh9bnH/BIDE2Xdc=;
	b=G5ICp4x5+mr+oDOStFqvIVe1naOLl0x3pq3hyjk4jEPYg9vLlweX6kDCbJzLrYLiSmH8
	 W3RvDQDCBqLbT0H6PksQIUXlXQ60LcB2j2Q4KHERUJRHPFYAoHVTcXXTUJLfPJpR+3q/h
	 ANIGpSs1XnHBih/IRe6/KqcNN1bKkI1sqD4eBkyW1Ulh4TPiwfrqX/kA5OMljqVoOy7L+
	 nKwdRJ2b0+SuDO1/RXGzTD1ea1Hx3i38YgMfikkkroIqbIJbO9mn2SRS/nRdxHX4v8OyU
	 ZTmfcjFzsFCQLosQ3JjgZn3zaeAdGD01JbcmfdJUijUDZm//jWRUMyLM1BGVY7xjpyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VR85ZWHR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE947606A31E;
	Wed, 25 Nov 2026 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VR85ZWHR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF001F0089F;
	Wed, 25 Nov 2026 15:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621339;
	bh=+RvxM2jQAzEyVzW7IO93vdP+52EOUh9bnH/BIDE2Xdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VR85ZWHRh8nVZwyp2PmB+xiaQYE51AoxPR96iAih95iRev9j9Yt8fWRUVIUOOqeCO
	 5lENikkiZtzX3PgmM1CxXF9t76RATETEboUjln5x55IGnsv9viBUwQHPgnKBrYhdud
	 /pqVdDGkb2qmTjh/qHsFeP8ALI5ac9639vKfmXL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yang <Leo-Yang@quantatw.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	netdev@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/990] mctp i3c: Fix locking in an error path
Date: Wed, 25 Nov 2026 15:26:01 +0100
Message-ID: <20261125143826.638463978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 750eb5ab457e62e221a9c8521e2274f14c85b387 ]

If netdev_alloc_skb() fails, mctp_i3c_read() jumps to a label that
unlocks mi->lock although that mutex has not been locked yet. Fix this
by returning -ENOMEM directly. This bug has been detected by the Clang
thread-safety analyzer.

Cc: Leo Yang <Leo-Yang@quantatw.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Cc: netdev@vger.kernel.org
Fixes: 2d2d4f60ed26 ("mctp i3c: fix MCTP I3C driver multi-thread issue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/71e0a880ffe7a83237e501b07884bf54343e76ca.1793296780.git.bvanassche@acm.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index 1d9d0c1418ebd..22376ea460f12 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -111,8 +111,7 @@ static int mctp_i3c_read(struct mctp_i3c_device *mi)
 			       mi->mrl + sizeof(struct mctp_i3c_internal_hdr));
 	if (!skb) {
 		stats->rx_dropped++;
-		rc = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	skb->protocol = htons(ETH_P_MCTP);
-- 
2.53.0



