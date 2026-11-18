Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019627;
	b=fuZtGqpKG+fPKfC8b6uJ8ZdJOSvX323vyLE3PRQVgJtg+J/9w0nIYpuTEpc2ydvRkuTs
	 ndTJxRrthFeB14XtF+dieqiEjWtws3iDSAs6TjShE5MjYwigXa0HoBol6hXsBpxTGDk8o
	 6SHfaiRLvwf3X+HG/G/HkUGWVdQjVVRXesQBvPauH+K9qvzoomki+QZt9yDFERTunVx7l
	 x2slfnyhMcunvUJ2ElKUL1eu2DNf7keP0R5c/fomIz2XkhGIS/vciWkjtTvA/QjAbf75X
	 uQpIBXI5MVGhza//8ZPo/q/FLa8lRXEweWutMT7RkJiHuLwdZdJNHf25HAEYrNwB81Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4h9AD2dh1aczDB4LBvR0oW58/re9wWERKFRTIAvl8pA=;
	b=bRdByDQCkRe4jdpOxeyUW41I+h3PZJgqde/3SDp68bIe/lseGYX6P1vFWGpcW3LtNB4a
	 i9sGWi3SgnxzSORFRUvUqzWFpsLmGnSoI+1tZIPrfq44UmlC40WKxOBbY1ce2q+zR2ZzB
	 67bSkMPnAxK6e3nX1Fi4ZZcx2/eNcIeVprLO43UNrTOYzZkoS/eyFYja9zwHdoMSQJTjn
	 n5AXlzICv3LgfFbc3OeBIf4LrA4rluWSxLkjJIMqoqf87ztBF2hcSTzuQV75QsfqvDlPk
	 ErJp22c4d13mYt0KDcmdTyaXAO7pDpkST6IRFgLBgduJXsSILKbTLqwe8Zvz66+1KXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1J5djrw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B35C606A7D3;
	Wed, 18 Nov 2026 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1J5djrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5FD1F000C6;
	Wed, 18 Nov 2026 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019627;
	bh=4h9AD2dh1aczDB4LBvR0oW58/re9wWERKFRTIAvl8pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1J5djrwUzWZbmiIx0vRsALQ70eg9QVOtXbLetL5bRzT/1WEF6M7tmJEgfAS7N6u3
	 hTEZnW09k5UBzf++cqfNIOECMOIrXrhEjk/gIbq//PNw5MXwpX0P5u3V/Es/gEtL/D
	 n2PwN+Yoy/PdYtehKzQN0kt+bupwY4l6todeakag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1623/2651] dm-snapshot: make the chunk list sorted by the chunk number
Date: Wed, 18 Nov 2026 15:47:43 +0100
Message-ID: <20261118150346.286231439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7c3725e4ac54a..797c432594d86 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -766,7 +766,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 				struct dm_exception *new_e)
 {
 	struct hlist_head *l;
-	struct dm_exception *e = NULL;
+	struct dm_exception *e = NULL, *prev = NULL;
 
 	l = &eh->table[exception_hash(eh, new_e->old_chunk)].head;
 
@@ -798,21 +798,23 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 
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



