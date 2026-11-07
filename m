Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062570;
	b=tlfz3DfWx7Uvm5q97jQLfiL/+ZfZgG50Zd33R6aaHIsN6HI/OUskoVQFBkjLdFDOo+d2
	 8HtP568Dwt2OK3EjbMZjco62c1wi2x2U7Sn3eW7MwwYVtnrB54GJGbE4b6u4RbKUjdStg
	 QT1FbDv+J8V+HaZrQ8rhdx0VPNsOL9fFDZmwW+Sq9GqchHA6agHi/3avRep8Cpl9gHA1V
	 CY/6A3FHF3aBvpOLwolMYvXO55MkI6jjrIQS9DNRIgKC60tZ5z2x23Iy04r9iRAuj4Jxs
	 Dfqt4N0FKRVMT7j1U/maabhKZW6dZvG9HKJoQ8UeU9q1QKxaFbmtcKSyz6DpUvBPenQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+egf5oDpVvdgqCZCenD+oqs3o+WmIgAUa1bmjA+g1m0=;
	b=1qNnM0s18c0He5vDbn9JcQnLmjcdrjgHyDotAmDhp0J/XNmVe+0us4V845yNRwUUzqSV
	 kY3szBtrr1H7FkJPDKBuIILKVp90MhVwS8sBozDOWuy2Hzh7SJxJ3DGCrjinh4ECfrU37
	 GYE3F8vr/ybjyRbji5gQkIdu+PmjlszCHPG9Uc0BUVmZXE3DP7N5RGWwUQI1757ygOx0b
	 0rdyAk/ickYI5MGIXI3Fphn35WELsrsSg+fuQRovo/n4s8C6luCELEYaZm7dEFr+bn9Lw
	 z+71BdmD7OirLxYf87PvHkTqzi8DKRkg95w3eqkcgr9+wQZhgetrpxvfcGkKrUgvl8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DlElOiFk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE925606A32D;
	Sat,  7 Nov 2026 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DlElOiFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3AE1F0089F;
	Sat,  7 Nov 2026 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062569;
	bh=+egf5oDpVvdgqCZCenD+oqs3o+WmIgAUa1bmjA+g1m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DlElOiFk7gEJxEqlohPq2plyf9GgWijQZ63R1qyTcG4f2bCR5yplk8VfjUgmB16jP
	 O7Wcmz7fNzhFa/kBla7oGPeIoXmzv4+PD7hzTZordHQKjAQCbvKTFnJxwUBJJ8sfwu
	 jgZxdsfrXGEsIDpwJVBBvJSP8bShCV4U6WgUGoRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1453/1536] ceph: avoid pending truncate during nonblocking cap acquire
Date: Sat,  7 Nov 2026 08:57:49 -0500
Message-ID: <20261107135038.649648681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e580a330d33fa..3525d60ed9774 100644
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



