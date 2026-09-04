Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9179A378838;
	Fri,  4 Sep 2026 06:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501727; cv=none; b=QywuMvMZg2Vy2qo3ApNTXfN4L0lYrBNj0y24S5sH8glINyXeVDUJB6nmmSyxN5lV7I9au8JpK6wLOrUht6YVD5mNVhWbFlaXjtLc3xLTZYBGY0mSWKApFUa7ZLsreLW8/9U8WRjsW+CR3pQmsTbp+xdBxe07aBKvSVCI7Tk/7GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501727; c=relaxed/simple;
	bh=TwnRmUXfJWdyejHRz9QtZ5EyuP/mfavGwc3e8bLxfWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h42rbEZOWQpS5G9aKmsru25h83Zw4kjJTxd0LTnjGbYgRxpD2oTcBaGVfF6lT9jRJsw3tuTZ2RSM2rThicaO0fg1D7zbLNO/ctrXcFcLM1N7Uc3ZZ/HIH9/azDKVcm+6fzKep+uga5mm30YBh8rXIHpjFlYhdRr6MTbh/aUTeuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwWRrTfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwWRrTfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E981F00A3E;
	Fri,  4 Sep 2026 06:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501726;
	bh=WmK7OI8id9+XD8inVDf0DlWBlNH7RvoSDUNnKTKf9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwWRrTfbWIT9ciG03OwSxjLm9JB/9YwqWtMBnsWCK9osFvxHIGtcfpdCg2aom/ENv
	 Ufv0kH7Plf7drVyKW/+jghXG4h5OlpU4DPlGeY0SrUp8G4g2dlXVC7Xm6O85AB+a2b
	 ox37vVtrgs5cUn0mZzFcgIJGH9s1JjN81/ep0QpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 511/552] dm-pcache: detect a cycle in the last-kset chain during replay
Date: Fri,  4 Sep 2026 07:01:08 +0200
Message-ID: <20260904045802.223446874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


