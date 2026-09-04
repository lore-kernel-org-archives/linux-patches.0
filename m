Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BC03815E1;
	Fri,  4 Sep 2026 05:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500136; cv=none; b=Xk5+uy2ZgPr97qX2fj3zzvKUH00UHei570+2f56Uv0N1EOSOC6an5h4eeB6U+ASQ0QuQBjS9k9DLCmkdhDS/6PFXZvfU0+P9tPGDlZZoDa1ZJapZAm2ILB0z/GvT4rv4PPEF3/a/6VKpEshXqROBYXgOiLDKIuyeI/L+R+HT/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500136; c=relaxed/simple;
	bh=V/180up1bBe+v7I/KzWcak4VZp002Hwi/9IG0FX7qng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkOFp6Ydo7f04CaBxOIhuYdQMv+iTY0drvo39V064sUXZ68y/AOTHDT14Lt/7c9FkkRirezqWA8CrX+9WUdQZZfZUZtVZUGw9Q9OyIpGzktoOmkDvSUX11TmNsd4AkP4Pdeahxc/3HAFQFaMr+80bLrbUiDd3zL1aTAAt7c/yTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mv5LFjUz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mv5LFjUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3FA1F00A3D;
	Fri,  4 Sep 2026 05:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500134;
	bh=AkGgp1jcbpgUxxTl8nKa9ZPZOF/BcrnK+6WJE2NTV94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mv5LFjUzTsJuIugjYPFm2URMCm/CpeUb0/wVNPyx3ggUoMKaCwgYPihLlo3NRbMP0
	 LXKxHYl0hgwehoUTS+TtPlXgZVBSRtJGYaMCaa0p4dct/T07k0cTLVJPOFt8ecKRiE
	 zy3oQjd2atON9VzL+tE//cNyYm6nsTfMoltcjau8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 662/713] dm-pcache: fix use-after-free and invalid seg operations in kset_replay()
Date: Fri,  4 Sep 2026 07:00:30 +0200
Message-ID: <20260904045818.675442763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

commit c2e894eac398b258f12fdec73ed6ba081047f7b3 upstream.

In kset_replay, when key->seg_gen is stale (key->seg_gen <
key->cache_pos.cache_seg->gen), cache_key_put(key) is called but then
key->cache_pos.cache_seg is accessed as the argument to cache_seg_get().
This is a use-after-free on the freed key memory. Although mempool
recycled memory is not immediately reclaimed or overwritten in practice,
this is still a potential UAF bug.

Additionally, for expired invalid keys, setting the cache->seg_map bit
and calling cache_seg_get() is unreasonable since the corresponding
segment data is no longer valid.

Fix both issues by moving cache_seg_get() and __set_bit() after the
gen check, so they only execute for valid keys, and using continue to
skip invalid keys.

Cc: stable@vger.kernel.org
Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache_key.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -736,18 +736,17 @@ static int kset_replay(struct pcache_cac
 			goto err;
 		}
 
-		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
-
 		/* Check if the segment generation is valid for insertion. */
 		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
 			cache_key_put(key);
-		} else {
-			cache_subtree = get_subtree(&cache->req_key_tree, key->off);
-			spin_lock(&cache_subtree->tree_lock);
-			cache_key_insert(&cache->req_key_tree, key, true);
-			spin_unlock(&cache_subtree->tree_lock);
+			continue;
 		}
 
+		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
+		cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+		spin_lock(&cache_subtree->tree_lock);
+		cache_key_insert(&cache->req_key_tree, key, true);
+		spin_unlock(&cache_subtree->tree_lock);
 		cache_seg_get(key->cache_pos.cache_seg);
 	}
 


