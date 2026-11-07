Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063698;
	b=d+KkY0pCYPhoJA1FBrowZi5hmtHy+zcqG3cOGzlqg7c5cqaW4xkcsQWKI8UmutcCf7yA
	 V7TZujq4oDwPiTC4tcdOovgrDG6sfDHIB94MQliETnK+o2cmPYD/3Kdp3w3vID1otWoD3
	 SrXDFjNtbT9yz++w8YBvR5ypWpIxOHEzSTtTZ/y4Rbz+H7+5pmIGqwHT2AS/UR8QoNBsQ
	 SzDzdlpYv2JYJP9EmAUbNPF1BUoC+MKg7DG10Z8o4BQjaccPf3rb/tRhit4xi94Gu9ytl
	 E5X13j9Qear+1xqQ5L5twnHr8UuLyRPJua0mtnKo6TVew31fCnBxhGx8s19z7JG46Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0ts/BofrkzRBgXWwVqVxHmTeGofeK2DSYMH/QvWD58=;
	b=WDqU2ZuMlZdkDaAbK7gbZtQW1TEN4f6npFvQ9E9SQaXCPzidh2dYi8ft8CMpih8RMC4I
	 wsxUMgZesEamkjCEvl2hGK/3fmInvr7XfkXkByTdc3KsWMKFuRV3YYH4CJcwEe0vt0Yeg
	 mmCVsi8bd3Pu2hjAHIYM79DT3Tnw5TDuYztSZXWSwbhw2ECC1sivcuUuNLWH6VjrCGJN5
	 7GJSAiRCsgiMcsC03G/HPRcDuxg/i3qk6StEitYx25VS4W0HFiDyFDem2smcLSBnadOxn
	 NAUgniiILjEgwoQmGU0K4ah6CA1GyFByXMZoMEvj1Jy5zo97ztW9jDJBg2aUtRg7LuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDw1q42d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD521606B8A6;
	Sat,  7 Nov 2026 15:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDw1q42d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6071F0089F;
	Sat,  7 Nov 2026 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063697;
	bh=+0ts/BofrkzRBgXWwVqVxHmTeGofeK2DSYMH/QvWD58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDw1q42duFj8EYx5OgQ46/EwRKIULBdkZJMSEylLTpdtMvKN2iwnUYJ9n+epnnaDq
	 pbVPPdayUYEK8CgRuQH5TyrKQxL+cg/MRbHRCRu+1i4m5nPBnHAU1zjG4Dr2o//DAY
	 63RqpnMOYJxRjGYcaY8LMMHV2RgDZ9LKFY2hFoTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 766/869] ceph: avoid pending truncate during nonblocking cap acquire
Date: Sat,  7 Nov 2026 08:57:28 -0500
Message-ID: <20261107134918.685756272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 91cb305815cbd..7ce1af5b61c88 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2878,6 +2878,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
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



