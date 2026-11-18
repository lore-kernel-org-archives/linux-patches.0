Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031581;
	b=FV/hFjm/6StOmBnxDRe5Acj/XOZXJGIUeSyisg/x1zIXsAaMFRaK7YXgVBgmlpq8nnQ8
	 VYKOnKGiKugrkwKsKq0Ro6FLtyZ1qmp7pQ94hSLh1wvEqzUp81j6bxg0d4cYI5gTEb0Ws
	 UlWuS94X/5/WlSrWe2AgF4j4srclcfgs3lWFbDQcMN30K+SVm83pSCXrpTMSBPkguwvUX
	 QToSXnxAhuujusmT6JxCN3U2sjvyRCF0tebTBnESnwQSBjWr4NrRB4+rCvMPrrMCtm/aj
	 awzZGJU7tjfsZMt7C7UsOMKBaJcChieVJcvFR+PrZq9zBkl7bzejbMpLXoG+cEgDx6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=90vV/sporvwYDIyZBbGNb4QLau2y6gs+JbZvmTJUSH8=;
	b=u1WXyz6L0BIkhidjsAN8rNddNDB0OE7+HiLXPb1NNFd6/CM/wwnOkuOfW7EpMek2TmwV
	 Ne+YIGxJxyGjeKvvRf5GXC1nSeDH76O13NEvXvyYUhCCqUnyxXfNEbU4yt4P0fq5brsJQ
	 9Ta6+GqlcWyQx1GL0W7xoGzxefe2v1W0/WTP8adAq0pr004Bqz+Q0RJbnYxICECgK1Fwg
	 h2SgqmoHs4GrkUukeUrrvRPPbcwnezkjdoEbBYksAPEBUu6dj+CQiOBpidUyTbKUnuacy
	 yjoUxIJW0oCXPlYe2jMWkRf20kPS0HVkP4bjf36DHWH00bBYe/dEng1o1MJb6axZ2Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mj/6B8ak";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC6D606A325;
	Wed, 18 Nov 2026 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mj/6B8ak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B101F000C4;
	Wed, 18 Nov 2026 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031580;
	bh=90vV/sporvwYDIyZBbGNb4QLau2y6gs+JbZvmTJUSH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mj/6B8akgaRyFCcMA9pIqunkhsIA4mwQjQBw4q1RyuEm1TtQmrRpcq3PPTfp4bc8q
	 OET1AS5IFdpxQQsuhoxUu3FcYYKSMBO6MEw5kN2AMpVc3elxBTXY8SLrW1wYrrcItv
	 dBgkusPU81jBh/gor/fQUEYDfsm03L6EAVjt7Yt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1057/1756] dm-snapshot: make the chunk list sorted by the chunk number
Date: Wed, 18 Nov 2026 15:53:04 +0100
Message-ID: <20261118150052.312148207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit bbd6f974d0386036e560af332b6b8cdd17010a72 ]

Commit 8581b19eb2c5 ("dm-snapshot: fix 'scheduling while atomic' on
real-time kernels") replaced hlist_bl_for_each_entry with
hlist_for_each_entry, but the two iteration macros differ after the loop
ends: hlist_bl_for_each_entry leaves "e" pointing at the last element,
while hlist_for_each_entry() sets it to NULL.

The result is that the list is no longer sorted by chunk number as it was
intended to be. This bug doesn't cause data corruption because
dm_lookup_exception walks the full list.

Restore the invariant by tracking the list tail in the "prev" variable
and appending after it with hlist_add_behind.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 8581b19eb2c5 ("dm-snapshot: fix 'scheduling while atomic' on real-time kernels")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 4a3a6cf772f77..c04e570756ef2 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -770,7 +770,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 				struct dm_exception *new_e)
 {
 	struct hlist_head *l;
-	struct dm_exception *e = NULL;
+	struct dm_exception *e = NULL, *prev = NULL;
 
 	l = &eh->table[exception_hash(eh, new_e->old_chunk)].head;
 
@@ -802,21 +802,23 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 
 		if (new_e->old_chunk < e->old_chunk)
 			break;
+
+		prev = e;
 	}
 
 out:
-	if (!e) {
+	if (e && new_e->old_chunk < e->old_chunk) {
+		/* Add before an existing exception */
+		hlist_add_before(&new_e->hash_list, &e->hash_list);
+	} else if (prev) {
+		/* Add to l's tail: prev is the last exception in this slot */
+		hlist_add_behind(&new_e->hash_list, &prev->hash_list);
+	} else {
 		/*
 		 * Either the table doesn't support consecutive chunks or slot
 		 * l is empty.
 		 */
 		hlist_add_head(&new_e->hash_list, l);
-	} else if (new_e->old_chunk < e->old_chunk) {
-		/* Add before an existing exception */
-		hlist_add_before(&new_e->hash_list, &e->hash_list);
-	} else {
-		/* Add to l's tail: e is the last exception in this slot */
-		hlist_add_behind(&new_e->hash_list, &e->hash_list);
 	}
 }
 
-- 
2.53.0



