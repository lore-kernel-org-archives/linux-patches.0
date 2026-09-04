Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B446A414A29;
	Fri,  4 Sep 2026 05:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500124; cv=none; b=AlmcenGnDrir2Yv5Qi0o1i3890ZA01+5xVtd/whm1WvS/Nj2N1kt9E7n0CFXR87jE6EqW+CTLSCbK/xjoMHcNY9FCXjLzJFrVbkKu0IA4kl5RJsdA3dOvPm8/OkgPTsWBKIv6b7DFvwigZbfPiO+FJytbji1Od2esF8HuDChH80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500124; c=relaxed/simple;
	bh=q5dNblQy2KVsvIj+9X1OY3UZrlMpfNJPrRLc1pRvm1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kE6FMxDE+pPUhODlHbVD+RafsUDJbnCkPFFcda8MqBT+c+XE4ReBKMEGKwM3mFGRlFFjbFBmSrsos4ypMigVY5+whE9ZOSkcdiEtjVNZfwZz4zNjKx5pB4KeT91f5+1wdct48p7Hqrm4OpYSQWWBQ+dC74Z/PgSSuykGU2eVqgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ek8N2YXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ek8N2YXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6FD1F00A3D;
	Fri,  4 Sep 2026 05:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500123;
	bh=iD8ZrGd1p9fNriQWNo0Dk9uPpWves4L+NBe5lboqEd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ek8N2YXRFgUs6nh9rP1NciSI4xM907XdQgRJDJzkwHSxTCblj6WpG/oXaotvefDDG
	 rCgbnjZ0kXxeCJf9zEx+TfxkXTMDC8V1rAktDHntpLux8LfNjLDugSFIFrCIAeUjMz
	 VGsSW6GtHrIru1yCqDWYFceZatQFh6Pw19zSMs00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 659/713] dm-pcache: detect a cycle in the last-kset chain during replay
Date: Fri,  4 Sep 2026 07:00:27 +0200
Message-ID: <20260904045818.607076567@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 16c3b3a326e70f246a605b3dc27b7f83ba4743e3 upstream.

cache_replay() follows the on-media last-kset chain by next_cache_seg_id
with no cond_resched(). A forged chain that points back into a segment it
has already visited makes the replay loop follow it forever.

Cap the last-kset hops at cache->n_segs; a valid chain visits each segment
at most once.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache_key.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -762,7 +762,7 @@ int cache_replay(struct pcache_cache *ca
 	struct pcache_cache_pos pos_tail;
 	struct pcache_cache_pos *pos;
 	struct pcache_cache_kset_onmedia *kset_onmedia;
-	u32 to_copy, count = 0;
+	u32 to_copy, count = 0, last_hops = 0;
 	int ret = 0;
 
 	kset_onmedia = kzalloc(PCACHE_KSET_ONMEDIA_SIZE_MAX, GFP_KERNEL);
@@ -797,6 +797,11 @@ int cache_replay(struct pcache_cache *ca
 
 			pcache_dev_debug(pcache, "last kset replay, next: %u\n", kset_onmedia->next_cache_seg_id);
 
+			if (++last_hops > cache->n_segs) {
+				ret = -EIO;
+				goto out;
+			}
+
 			next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
 
 			pos->cache_seg = next_seg;


