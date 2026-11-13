Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590366;
	b=fCSBXYrUbOYb1oFT2SWfp+27PBtJuDSE5NC5dwt4Y3lin/9timxZ/IEmWWsl2RFWpKRF
	 FvJMTaop4zW21Ag+ktdLe1sC1GzvKNm31s+7GMkQh1f112EL8VAiAlp5hbTWLfIV5gHzQ
	 BzhLe8xmzXm8gqoQWymW9RyLlNLiSzjGH3YocNctmproaJXfpaBGf6sr9AOyki4V7GFY3
	 rrCseEyp+H0Zdm9PjROu0OCeoteMGfr7F/ULVj4SflscuvV9wtH7GII1aSom9dDwbywws
	 KFMsIOkLLQiquwxOnA8hgNR+NlTZ3IqJb65OgyvETrmJrStkhVqRQFfu50+gFZPeLCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+JRmkGhnTYsUfK+U9otDBCDtnV8yD2/0VtYqrzkRObo=;
	b=ftVBzPAmw18RqAGEHrUyj7w+WnS53lwO7Comb9iB6KM1dWKN4/pt6HGhAtdJG4MPICMr
	 dECD3qfUkfbpZNZoWRLiJmKnXgznZiivef4x53wemHzUBgTLsONSwpXrfkgwQ1csau8wr
	 +XkxvuOhHMjSiOTBirkVLMsAD4hpUdBVJvPHbzpGh7YN5IKhfr8G4dnkCKsnwdg+oQAy9
	 7O3Eljd/EgIOO3nw2dpWog04DOeUX71E9SSRoJOvbb6Zxn3xKF6z3loJSz57bjkxHdgJn
	 PN/Xg3Iht6z1KYBa4UkK/tcTWCpDuZ2belQaOZTOCBUbG3FPmsSVbH8neuYd66Z4Ikw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVByr5Xe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1224D606B340;
	Fri, 13 Nov 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVByr5Xe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36D61F000C4;
	Fri, 13 Nov 2026 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590365;
	bh=+JRmkGhnTYsUfK+U9otDBCDtnV8yD2/0VtYqrzkRObo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVByr5XePlCWhVeAMm7ooi0Hn/0MehHDcTtCTrAvGmnL0uxxFpeqawdf5mPpX+3ei
	 07xXX8D/05vsJS+3b5v3aybWdUFn2tkhmEilc84ls61lCRPZJyF60GnD7bpr8B5GeB
	 bD178iwymB8r61zt4Lc8fqtMNhL1JDiDszte7uCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 340/686] vhost: fix used ring index wrap in vhost_add_used_n_in_order
Date: Fri, 13 Nov 2026 10:47:53 -0500
Message-ID: <20261113153832.454860533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit e244725e86be02cd85cb878b3ed8570eba2e4be1 ]

vhost_add_used_n_in_order() advances start by nheads[i] but wraps it
with a single subtraction.  If start + nheads[i] >= 2 * vq->num, start
can remain outside the ring.

With used-ring logging enabled, start > vq->num makes (vq->num - start)
underflow.  log_write() then sets bits beyond the dirty-log bitmap,
potentially corrupting adjacent userspace memory.  This is reachable on
the vhost-net TX path with VIRTIO_F_IN_ORDER: done_idx can reach
VHOST_NET_BATCH (64), triggering the issue with a 32-entry ring.

Wrap start with a mask to keep it within the ring.  VHOST_SET_VRING_NUM
enforces a nonzero power-of-two ring size, allowing start to be wrapped
using & (vq->num - 1).

Fixes: 67a873df0c41 ("vhost: basic in order support")
Cc: stable@vger.kernel.org
Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261020232956.99970-1-fangxy@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ebdbf1cf9143a..78cee55cedf85 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -3145,8 +3145,7 @@ static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
 		}
 		start += nheads[i];
 		new += nheads[i];
-		if (start >= vq->num)
-			start -= vq->num;
+		start &= vq->num - 1;
 	}
 
 	if (unlikely(vq->log_used)) {
-- 
2.53.0



