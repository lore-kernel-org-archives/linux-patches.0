Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E0F36A01A;
	Tue,  6 Jan 2026 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722111; cv=none; b=f5iKdiN6C3sHK5jI9AQOc9PFrQYW/fSfMnknRIWIF+BO4BMc6+BLjTTq3AFGUUKIhNnZzGt05oFGltHBQofXzz/o3+pvj42KmRNMxKvGJTmKCyTlzLX+CALDSq6uFyNkPqAfKcjmTRZcrDUsTsvJ53EJi3jbljq7qj8u7ZQPI3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722111; c=relaxed/simple;
	bh=bAopCIBf7locl9E6z00CbXZX/4IOPOvlVGOmS0Ti62c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaRH+oPLDOyncCrQlPcJxvoKUKnrww31jCzXl9BcJnRtbZp1JETgA3q7vEbyGRP/fGZgyzN10vEs10MKySHQEiOQ3zqGwaDVoxWLnvB/dOqMZTQ38jGMUwxf1A9PEhE6YlTW9PpFWwkt+2vGGAcOabbhYrpwHd7PB0Rkc8hgDSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3kStpvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3kStpvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AE4C116C6;
	Tue,  6 Jan 2026 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722111;
	bh=bAopCIBf7locl9E6z00CbXZX/4IOPOvlVGOmS0Ti62c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3kStpvgLa18VWD2HvBPiY2+DOqwudLBZLTr7N4ifJjIj+qOf0gCpm63GGRABFJ5x
	 qDJXyb2Bcq8vQVEYJrkZQ4jXfCBAmCeA2CF/WdOVIDU1IfDacn1QcDo0ttYmOLiQx5
	 I6SWA3cb5ckJxi+DAClb/a6RsKPBtdy9FjqbbrgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH 6.18 169/312] dm pcache: fix cache info indexing
Date: Tue,  6 Jan 2026 18:04:03 +0100
Message-ID: <20260106170553.949623834@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Li Chen <chenl311@chinatelecom.cn>

commit ee7633178321f5d983db3adfdea9322456cfdaaa upstream.

The on-media cache_info index used sizeof(struct) instead of the
4K metadata stride, so gc_percent updates from dmsetup message
were written between slots and lost after reboot. Use
PCACHE_CACHE_INFO_SIZE in get_cache_info_addr() and align
info_index with the slot returned by pcache_meta_find_latest().

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Zheng Gu <cengku@gmail.com>
Cc: stable@vger.kernel.org	# 6.18
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -10,7 +10,8 @@ struct kmem_cache *key_cache;
 
 static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
 {
-	return cache->cache_info_addr + cache->info_index;
+	return (struct pcache_cache_info *)((char *)cache->cache_info_addr +
+						(size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
 }
 
 static void cache_info_write(struct pcache_cache *cache)
@@ -49,6 +50,8 @@ static int cache_info_init(struct pcache
 			return -EINVAL;
 		}
 
+		cache->info_index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
+
 		return 0;
 	}
 


