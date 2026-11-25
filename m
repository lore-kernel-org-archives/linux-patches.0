Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622707;
	b=RIpulB1N532vvVIYel8f1nYtgfyJXf+y9//wSLCu3xw56rOotlFjEjhOa4TXUxizD+41
	 fVZg0Y8ARv297B+D1YOZwCsQHioBUnmmkAevJvP5MvNYVNdRoGzKXeozWRDC7Xa9utGVx
	 djHExuSXQNqWpZ6yn1GuutE5uJtJSHNTR5lhYbUd06Rk/aYNUTPBFJ4Z9smybEgLDnHuy
	 onTwK6CXAAjhZHVwiVu2LVT2UCvvfBdMT6tgmJKavIg0O0giDa7jkm6M8X1D5qrINBeyp
	 V/EzsLz+yqchhgRDTgXPM6sY2IKf2YycTbDUMVqBYprLlWqY/al9Rb8zPdfMQbbFmlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uhF2qlZYOEzmMSDLn0rA6m1wTZ7s5IlATl/mPnxsgWI=;
	b=wR/9l/xLclGX2OH/YUjvwbOv0eDVXHsFkR/AiBxP89kZSdS67RrfpX4N/L9dSmqxt7zf
	 OFhLZhRvIkaj3F0L3cVSvEr2e39eeit5I1Dde3hh5lf8MvrqZoQVdrT/Y0eB9SlfxnPQ8
	 Rc9c8pnl6tBSyh9OIR5vG2JVQFuUD6nh1vmSk3R5ZaJ+3t4TXyktjlfEw+e6a8NkSgS+c
	 RvFZZKyyQNeVk/hyiM+XCc6uH/lNxnEHzBM97tvZd06VnvgEOl0EwWImxroA5omo7qKS9
	 pkoIGzGRTkqA4dJSuFOV8SaJwZIdc+LNhEjhKUokNCleCvjKbdCDXdATr3PX9y7+UAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/Ioa5bf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B33606A31E;
	Wed, 25 Nov 2026 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/Ioa5bf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47981F000C0;
	Wed, 25 Nov 2026 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622706;
	bh=uhF2qlZYOEzmMSDLn0rA6m1wTZ7s5IlATl/mPnxsgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/Ioa5bfzgfbzyqzD1Yfmp8ecoWPruTyz4A/JT8X7IdzdHyqXzeG6P5z1N5fx5iYd
	 5HZIUnEgXkirClezZ42iKPXQYD37YIcAssvI0P8m16iM0KbUCkfDmlJxVrW3MN2ytv
	 HsTwmZHMDxSjBxxwyLGPGzUwf6/3Fsh9oEps4V2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 621/990] exfat: take bitmap_lock at the start of exfat_alloc_cluster()
Date: Wed, 25 Nov 2026 15:33:08 +0100
Message-ID: <20261125143836.647538735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 48acff2eedef7fecdfbd39be1b6f4463a9e43e3e ]

exfat_alloc_cluster() checks sbi->used_clusters against the total
number of data clusters before acquiring sbi->bitmap_lock. A concurrent
allocation can update sbi->used_clusters after the check but before
the lock is acquired, making the check stale. This can allow the
allocation to proceed even though there are not enough free clusters,
causing it to fail partway through.

Acquire sbi->bitmap_lock before checking sbi->used_clusters so that
the free-space check and subsequent cluster allocation are serialized
with concurrent allocations.

Fixes: f55c096f62f1 ("exfat: do not zero the extended part")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 13a79845be016..87c7823efa718 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -355,19 +355,22 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
+	mutex_lock(&sbi->bitmap_lock);
+
 	total_cnt = EXFAT_DATA_CLUSTER_COUNT(sbi);
 
 	if (unlikely(total_cnt < sbi->used_clusters)) {
 		exfat_fs_error_ratelimit(sb,
 			"%s: invalid used clusters(t:%u,u:%u)\n",
 			__func__, total_cnt, sbi->used_clusters);
-		return -EIO;
+		ret = -EIO;
+		goto unlock;
 	}
 
-	if (num_alloc > total_cnt - sbi->used_clusters)
-		return -ENOSPC;
-
-	mutex_lock(&sbi->bitmap_lock);
+	if (num_alloc > total_cnt - sbi->used_clusters) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
 
 	hint_clu = p_chain->dir;
 	/* find new cluster */
@@ -437,8 +440,8 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 
 		if (p_chain->size == num_alloc) {
 			sbi->clu_srch_ptr = hint_clu;
-			mutex_unlock(&sbi->bitmap_lock);
-			return 0;
+			ret = 0;
+			goto unlock;
 		}
 
 		hint_clu = new_clu + 1;
-- 
2.53.0



