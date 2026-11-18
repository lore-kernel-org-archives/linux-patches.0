Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025807;
	b=QQtqMNe3s7ig583g5L47ixJ1m1Ae0sxcq3FA479NMtbc4rZyVfUCooPuEHy3Vg0fgABL
	 YOLZVMvlLPp0E1ayTUMDYtYdfDnvxUBWrB9zh7jSGDm8garKEIlTlpPKfi3eCylJteUZ5
	 XjrfPDV7VdCjamKd8LAWYIN2UQ0Wp/o9o1HPpGpFdh7FZErSJ7ia/wVWJ0WHL5+vlS7G8
	 YeN1selpKZnt4EX11bzQo5HpPPdLQ1fz07wimXJI2tG3xTh8KarFuDaSK7AtrTTEqvoXk
	 Qk9yU1wl4TEoyTsFzCLzN4TSjs/WWPSm9xu3kCf4pVGafaDtwwxjBIgEu30tXYIoZgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GM9j16QIPjRUxkn1t/rjjpXNJGafkyYweC4TwwNvgU4=;
	b=YtD9vE8LKzS+uO4TptMnc2yxCaGHnA13OFKm6Z6ztXt/xCZrkEY4xIzU/BaVV6hVkP4b
	 9XE+OVRqgf7aL55jX4BIvPiGls1oyBv6PM0rhPp1ao73+gkvaa+RYrSYmEuUMT1AFdxB9
	 pLmzMKzUu5hhGbWAnXipyJULIqqsYhhphWsQfn/9XnXl5UqJT9aJ0b9v3xtK2a1jiaUKv
	 MhBfH78pjFqC/y1cBqbfcSeNP0kfl3A3xzoIYis1J58gdlgJbgyaTH2IOolqNBZLT1s7H
	 +0/sreY4PIWM9X+a2vo5pXd/S358okTwGVgcPZybiIcna+E63PTSzbZPoWzI9c10x1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufMehvw4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449B3606A31C;
	Wed, 18 Nov 2026 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufMehvw4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1A01F000C4;
	Wed, 18 Nov 2026 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025807;
	bh=GM9j16QIPjRUxkn1t/rjjpXNJGafkyYweC4TwwNvgU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufMehvw4zBtwGx07UuZdA33jDVeVB1eIt8G9aMwMuyuyTbhyEfV+j+K6Hdv6qRYoG
	 x4giVvi2ldomvCitZatDNZ7+EkIvJER7vNHkWyJQpzLBdPBKhcGFhP2hJjhXhDInN9
	 C9WQVkkdXIdPZfqZfcdL6eASNRqx3B/eN0VPShNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1211/2151] wifi: mt76: fix wcid teardown ordering in mt76_reset_device()
Date: Wed, 18 Nov 2026 15:49:06 +0100
Message-ID: <20261118150206.316207168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit 5cebbd7a87df834efe002c8e54211e6adc99703a ]

mt76_reset_device() tears down each wcid's pktid idr before clearing
dev->wcid[i], which is the reverse of the ordering used on the
sta removal path. Until the pointer is cleared, a concurrent lookup
under status_lock can still find the wcid and access its
already destroyed idr.

Clear dev->wcid[i] before calling mt76_wcid_cleanup(), reproducing
the ordering mac80211 already enforces for normal sta removal (where
mt76_sta_pre_rcu_remove() clears dev->wcid[idx] before
mt76_wcid_cleanup() runs via the .sta_state callback).

Fixes: 065c79df595a ("wifi: mt76: mt7915: fix list corruption after hardware restart")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260821-mt76-wcid-null-before-cleanup-v1-1-0e364d9062d6@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ae1623215894a..9f70bef1749fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -848,8 +848,8 @@ void mt76_reset_device(struct mt76_dev *dev)
 			continue;
 
 		wcid->sta = 0;
-		mt76_wcid_cleanup(dev, wcid);
 		rcu_assign_pointer(dev->wcid[i], NULL);
+		mt76_wcid_cleanup(dev, wcid);
 	}
 	rcu_read_unlock();
 
-- 
2.53.0



