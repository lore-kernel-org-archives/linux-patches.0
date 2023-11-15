Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE16A364B3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyF6Y+5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C97C433C7;
	Wed, 15 Nov 2023 20:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081065;
	bh=aT0bowef7g+54DoodT7uEjflb07FlyqRJ0AzSSHHrMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyF6Y+5eK9xpRJlWK59YOXQIyUzrB60ggmlx40kNtauTQPxDi1ZpfTykXrbNqWhGo
	 U2oxffe4BAY2Br7+4Nr8G1YiGvQZnPj/pkBlE3yJ9MM0sGdQolJ9/Ik8sef5UiwEL8
	 0Dn9STb9/OmAlJwqvjrdkxib/7nFrtLTZAFp68jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/88] net: add DEV_STATS_READ() helper
Date: Wed, 15 Nov 2023 15:35:29 -0500
Message-ID: <20231115191427.206566708@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0b068c714ca9479d2783cc333fff5bc2d4a6d45c ]

Companion of DEV_STATS_INC() & DEV_STATS_ADD().

This is going to be used in the series.

Use it in macsec_get_stats64().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ff672b9ffeb3 ("ipvlan: properly track tx_errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c      | 6 +++---
 include/linux/netdevice.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index e22d336679d12..54b19977fb675 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2999,9 +2999,9 @@ static void macsec_get_stats64(struct net_device *dev,
 		s->tx_bytes   += tmp.tx_bytes;
 	}
 
-	s->rx_dropped = atomic_long_read(&dev->stats.__rx_dropped);
-	s->tx_dropped = atomic_long_read(&dev->stats.__tx_dropped);
-	s->rx_errors = atomic_long_read(&dev->stats.__rx_errors);
+	s->rx_dropped = DEV_STATS_READ(dev, rx_dropped);
+	s->tx_dropped = DEV_STATS_READ(dev, tx_dropped);
+	s->rx_errors = DEV_STATS_READ(dev, rx_errors);
 }
 
 static int macsec_get_iflink(const struct net_device *dev)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 744017475b1db..ac87fcc4d44b4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4853,5 +4853,6 @@ do {								\
 #define DEV_STATS_INC(DEV, FIELD) atomic_long_inc(&(DEV)->stats.__##FIELD)
 #define DEV_STATS_ADD(DEV, FIELD, VAL) 	\
 		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
+#define DEV_STATS_READ(DEV, FIELD) atomic_long_read(&(DEV)->stats.__##FIELD)
 
 #endif	/* _LINUX_NETDEVICE_H */
-- 
2.42.0



