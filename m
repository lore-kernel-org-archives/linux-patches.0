Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045776;
	b=zMwhhY1WzpYNgLvDVRy4A4Ro2QeTLCJz1K4aKGdjfwJA8A629542ygZqqZK/pRYPm/xU
	 7vuz8e4vLP4syLDaI4eQijZGNuNVpGAbGk8YfNwLTxormDgTTekRd4irnsHwawQZilCwg
	 oR9oGsYUZMgStvG4ccef82OCjtPbxTrT3e6PtcFXH8MKhubXJwepVuJH6bEFI4p3TWNUO
	 rqMfTXBWKLozuILq2uohEad7RRNC0wv9qLhZ0vw5UlobwGFZAu6Gz+0+4n7ETZYgA5SVe
	 SSPnxhOg6snYg0+cPSiK5PYxR8nMX0vwk/A6GoGOMvjjyQvO/WnpOZ6OBkViyamLcgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pWdTfSma76IkgF8QxjWWKYmvH4XLbIzmrTgf6aHIyIc=;
	b=I1syGzu1MyFpBqBcO59gEVSPAkd6//D33WtD8bRCa5DF3bTABdn2e1MNFK9sO1HFVXg1
	 dv2Z0A91mGbsVuWeko+Nuu611acnl9vrckZCB+IBGIaxyU6kYGLgoB3F+bhZqesY9Iqmz
	 nv1Ew8AsUzrkDQ/G0/T9ldbPxCjOtkmfKMwt4bXXOZpiTJk++qQ7ffz193Xg1sTNTddJ3
	 zT6rGSWULh7oyk7rF5XFB0AUetQoRvkKKJ9nl2+31gHzcODUBv3CZc/srzUlhQs6QSsNs
	 aG5LfHNukTerJK16+SNNMWtFFaXhr+zDEMf8uTWKmGMTAvgsPR8XtoFP+6M12iThjMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkfGaWtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B2A606A31C;
	Wed, 18 Nov 2026 23:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkfGaWtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96E71F000C4;
	Wed, 18 Nov 2026 23:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045776;
	bh=pWdTfSma76IkgF8QxjWWKYmvH4XLbIzmrTgf6aHIyIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkfGaWtA5Vq4+dj5tOV5TOYTCV7o6+1Eocq/D+h1cdajYHD5/LMZgDbma6tmdxv8B
	 il91RAMpbYRJjWwbVr7d+C8iW7d8XpaXxA0QvnteZw0ik07c6CVjF3UdGL67wKWb8U
	 Mv4hHpo604O9394sKiaKamMwvyEO7MMwFc+6XKiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1045/2857] ceph: avoid pending truncate during nonblocking cap acquire
Date: Wed, 18 Nov 2026 15:34:39 +0100
Message-ID: <20261118150239.221130729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 979b7ed4457a04c5a41c36f86052ecc6b76c67d9 ]

Readahead acquires caps while the folios are locked.  This can
deadlock when processing a pending truncate; truncate_pagecache() can
then attempt to a folio that is already locked.

Return -EAGAIN instead when `NON_BLOCKING` is set, causing the
readahead to be abandoned.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c1f21170cc6df..448ba5ec4e3b3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2717,6 +2717,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 	}
 
 	/* finish pending truncate */
+	if (ci->i_truncate_pending && (flags & NON_BLOCKING)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
 	while (ci->i_truncate_pending) {
 		spin_unlock(&ci->i_ceph_lock);
 		if (snap_rwsem_locked) {
-- 
2.53.0



