Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036909;
	b=rG4gA81eEBO2BO20mvCEdTeCG2V+0roa1g48jpbtzdQOlOn0RYohTBf5txU0ve8XKH6H
	 2zHh5tM4BJHsv43Wom96TiKjwbUSdrsN1VvbzptGW1mSKij5dNmZlgv39zGps0+dRZIDI
	 ou+DqtoFtDtf9ampmCQEeBqZyATa+wGojA5EqcXLb/1K6aLXc1Nbq9Fd+VFmWSrJZWbCm
	 QaNVPsCCV3+aB7ws1xh+fpfbFE6dlVmhk/VafSzXfGbuLDmKTc34trCs6dNmBHZ4u2F1w
	 amwtP0iu9TpsFEF1HiTPxNzGch7ipM0YioQZcoNReq6FPq2GnYQd/tCuaODl2LzOC5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s29ec7rqVZiUlUptiwhu5zz/ogidRPRhbrD1wR/poFQ=;
	b=E258EUd0VdKBVWyiPKwNaLPtfD/uXU047YjWIxl1Oz1NGEI8yevh4Jz02t8XfFW2cGq9
	 GW+vZsIWTXWuN6mOgURPL2d0R1DZcMDwH0H2tun1MmFpLOaLznK3jdBthovzpgreurGbk
	 sU1/rS6zcYX7iPDkfJEHGq8QtI/rtfTjIK8Fx+D3Z1jm7NIvMuGmBlfkez+Vt0djM93xO
	 y4dpKLNeVxTOJ4p0Pu9exVUz9Jzu6SDEkl1TBrlyPoyeUbw3YfSKpu6S0mVk385u6UrUB
	 tW02mYSDThfeRLQcZdCmPEkGMhzDXEV/RLXs9IuReQs6IWvt0W2HiwSbNiJaTjaSxyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adqWZ0t4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24FB606A31C;
	Wed, 18 Nov 2026 21:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adqWZ0t4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF8B1F000C4;
	Wed, 18 Nov 2026 21:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036908;
	bh=s29ec7rqVZiUlUptiwhu5zz/ogidRPRhbrD1wR/poFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adqWZ0t40HgWmOI0uIQrpUsED25x9kpkV4QZCC2giXWOupIrQbqj76z/q1u+KSU46
	 d69y+/BrDB9xji5tvfRajEk02TLwjhXm7RgbzIq9hmT5jSQu4zzSstGmC0jl4EqHla
	 NFWDhNX6wXzKaEPO1wmwevJL21ZJs/qrc4qCf+7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1226/3318] ceph: avoid pending truncate during nonblocking cap acquire
Date: Wed, 18 Nov 2026 15:30:48 +0100
Message-ID: <20261118150356.962269834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee80fe4c0266a..1bf14f16055b6 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2851,6 +2851,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
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



