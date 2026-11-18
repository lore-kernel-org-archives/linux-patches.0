Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041233;
	b=4OIsxj8PbFWXA+3NXde3mNi/LcRvZ62izY0porq5WuF9qSbuagYMXWY9II5ifQBC783q
	 u2nfh/MoIXn4JLGjdIjAL2cPZNLnqlhVL2QuvWef8S3tglnkOueCHSNXzjQBAL4Cu3mf5
	 pAyH60hIgAyUzQ4PWmKrdZODKf+kf56kRJC0AYJkekYEapV27SVglSPKm+fQylSenTb9e
	 1d57oWtfe3a4W1SwhpHxIY7fW8E391Xctrl3C47z5WqnG5T/7PMin3fC9m4/O6pwo7Y4Z
	 veF1F48uDIUyIhudER3IMg11geCxT4XpVXqm8cfrK7Vv9qsOMZ30MWqeJjo+ivYwMIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMvEJM2K7b2OpO6K0zKUqu1Y48vOCxIeMNalOssNAO8=;
	b=bAdDr991120CJ9eIiBJXG2KuKOfLUi7NNSN1SvmCxc2+fGErBA+xNYJoXHgEZfy2hwUV
	 pnrqqO3MeF8T+gPU1WVbP+IQG39rsZZogaQ9LSl1Yf/jjoy8x7ex/1IaMRjK3N8JHUvxW
	 YnhNq9ONhm7vyqEhOvrRHoojsqtt/wBcaXwvYOtzIj+C+ynukek4EUDWsgyzcQjRDu4Wc
	 7Z4viEY8MPia/eMgk2nOJMNShIeVgnzlfF0FlrOnK9F89HomWU6TYE2ci2+ZkZO0h+Vwe
	 h5u5uL9aybGzB5LvIS6Z2pQoz1+JxT5itIvAwAdedYrDOzD2IQOQ857Ad2urhhqJGrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfjlGEfk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE038606A32A;
	Wed, 18 Nov 2026 22:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfjlGEfk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE3B1F000C4;
	Wed, 18 Nov 2026 22:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041233;
	bh=KMvEJM2K7b2OpO6K0zKUqu1Y48vOCxIeMNalOssNAO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfjlGEfkqGP5fqjnZhaHkBgV8SIZ80nlUGxkE8Y5B9Y4/0oQj/VQDpaqB8R9/SN0b
	 /B4It6Y2bcWOxTWU6U+L1PPJ0QYyb+j6JzRxOPlQxI02/k6xvzQDTCiPQcRjfyiVIr
	 tD5C5/T5EeGG9H3Ow0EX2JEnYbU7VL0p190lbdfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2740/3318] dm-snapshot: make the chunk list sorted by the chunk number
Date: Wed, 18 Nov 2026 15:56:02 +0100
Message-ID: <20261118150442.986667583@linuxfoundation.org>
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
index ebe5fa1566c8a..a34bddbf2721c 100644
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



