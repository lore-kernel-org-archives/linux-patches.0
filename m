Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047422;
	b=FMjLe8Ks16By39+47Yih9A9hTd8Qo4wr5osisZpJXVaHUV5eFCH9xYqXQVt3xYaTcnk+
	 LKQ9wJRlO2SryZDcGtCB2Q2Uc589IkozRYt/AVNuZ+AtvFHdj0P+MoOgPTfK9LWXJvJmQ
	 QU5ryddK0VznNAdEVC2zY0m1x7+FakOjKQ/KHzgdZm1vPu8N6I9KjDKeTwROl35Y8ca0u
	 bL6nK2uyGNsV+Bv4vltpFNH/vynxPjwygdQ1PEDTGujd4fantj6MnANkp2mNliqDCxASG
	 6ODfuoCIBJusdsnd9Ro0+ewG3IS7wHJMZ6PHzXTOsNo52rEZui8f+1zj66VzcXZdUSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=os82c2qdlmoIt5qQ5B9Iza3KfhvQ7uNwe7TndWFXaSk=;
	b=2z8QKBw3TKXml0El5wwnAbGmEyWP6Xlfm9I2Bg/CioO297QrziZUq3qd3bx0yOa0DJsK
	 w4gVBysLbaNIh7QEVbJ1BUvURTEHi8gptbG4rNPAMawkPoWIhBn35jcH5d6SLitiRUVM4
	 dzGaAtdgQeKwk9/EewYVwjwd5PKK92q41AR/ICLdNrm4U/0EsKKJKJthE3LgJH3AAVWv2
	 LdGfHen5ueE6lFddbmXs2zblWGjGBqAZ6w043OCx3GSkeI3vUF3752eOHLsq2EAzbpmAE
	 egPsoxJJW+dBYChH8+GIv4VjiisQvFxEKo/UGE7/MoDyUjZG8CeSacwrUbEE5bqSaHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKF1xBgu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4BB606A31C;
	Thu, 19 Nov 2026 00:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKF1xBgu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBC81F000C4;
	Thu, 19 Nov 2026 00:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047422;
	bh=os82c2qdlmoIt5qQ5B9Iza3KfhvQ7uNwe7TndWFXaSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKF1xBguw2iI6UAolNWEqNClJH3GAXcwwhb77uuYxLRT8Jsj8f2oOzt4OAZCBp7Qf
	 OOmLCYQpgemaZ5lz8V03dxiTGWLcvmbjB5M46+g8OiH4Ow+840+FRz4/gIn2KYBMj+
	 pDy9vf2tGp1BXcbF3UdJlxuub9R1b6bp6dJMuJ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1632/2857] xfs: dont skip free extents of the longest length in a whole-AG FITRIM
Date: Wed, 18 Nov 2026 15:44:26 +0100
Message-ID: <20261118150300.099468835@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99 ]

Since commit a66d636385d6 ("xfs: fix fstrim offset calculations"), the
by-length walk of an AG in FITRIM starts with
xfs_alloc_lookup_ge(cur, 0, pagf_longest) and walks down. The lookup
lands on the longest free extent with the lowest block number. The
other free extents of that length sort after it and are never
discarded.

Start every by-length batch with xfs_alloc_lookup_le() at restart_bno.

Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/r/ZgiJWxVcVwag0fIP@dread.disaster.area
Cc: stable@vger.kernel.org
Fixes: a66d636385d6 ("xfs: fix fstrim offset calculations")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted the batched xfs_trim_gather_extents() lookup to the unbatched xfs_trim_extents() loop ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index bfc829c07f035..f6305377add4b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -53,9 +53,10 @@ xfs_trim_extents(
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
 
 	/*
-	 * Look up the longest btree in the AGF and start with it.
+	 * Start at the last record of the longest length.
 	 */
-	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
+	error = xfs_alloc_lookup_le(cur, NULLAGBLOCK,
+				    be32_to_cpu(agf->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
-- 
2.53.0



