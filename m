Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585375;
	b=dPd7TgF2WAb2mVeDuM1jgdnJ/YPVi2/TkM6vn3NmKX05CmxvRvLhRiD1oJIDsEE9tNiH
	 0iRMfj0fq/X+ysusp3sCdj/Rn7xjrMeTMoMzgfS0sx3pl0gUtPt0sScmvIGGGWmmz63vy
	 NWCiY0rwbGD04xULoUDgdjB47+9tk6Rabp2Qpuj56cPhOrZsi0bY5wcJkvTvFov0HWuBm
	 L0yJjQBnovCsAhBOajagHXp6/LXSxFshcmTYdBnbJraq8VQ4Tewau6NOGDG+Mlm5tqRA2
	 6rdbEACuSTVhIzzqfs1udCT0LzTdQn8/wAKviK4Kp9/p8kA/GUKLzNOi0yrWjTN66Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z3yhyD1LO/yVvhghNG0oylCDZPsPcHU1yiaOzlIDKP0=;
	b=W9KjyT9vZx/mfAF3ejeKMnLu6IdtvOxsfzutwcalE4iAlSIlP0N4H2JqsycYeM7Cfydy
	 XhtpLGvJyOu/T1M+Tw/BLotzpkahEwnMs6szIP8N+/iIATm3IWM+S7iQYpg7xXxfI5jUZ
	 64U1+uBGCS6r62Sw8ncTJ2PDMg3qGhj1XY+Vvm3O1fqWL9QIsZmYaWBWtNclk7bwu9CCD
	 kBHNk4skGXeJSMM4lmxHbSnqidJnhMw4/VWvKDrAw5lSMJWUOBodorNdltFp6KMak9fft
	 XE/w03haGH4VWQ3UBi30r4kxTm1bejDqZFaJOHkUkYT1NVtmrY8nBmvBsRryR7qh9lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNON0iRq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D05560A2601;
	Fri, 13 Nov 2026 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNON0iRq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FABD1F000C6;
	Fri, 13 Nov 2026 15:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585375;
	bh=z3yhyD1LO/yVvhghNG0oylCDZPsPcHU1yiaOzlIDKP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNON0iRqBAG5SX08rhwmiPKReDUDfMXwYDszJGyn6Bj2fmYIqSpsVv2fmBH+M+NHl
	 lNMZ+tjSofFopghyF9dftk8rVWOVIG00P0DHvGbYqyVbO3016ynQfXz5WlGGarz7DW
	 /JGZwws40kX+zViAjVbJ/z+TL3oLt7CWj5Pd87Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 049/507] 9p: fix caches_show() out-of-bounds write
Date: Fri, 13 Nov 2026 10:45:53 -0500
Message-ID: <20261113153755.214236719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Zhao Zhang <zzhan461@ucr.edu>

[ Upstream commit 2acd800de8827b7cdce8cb5c2c63b8e8608ec8e3 ]

The sysfs show handler for /sys/fs/9p/caches appends cache tags with
snprintf(buf + count, limit, ...) and then advances count and limit by
the return value. This is incorrect for truncation because snprintf()
returns the full would-have-been length, not the number of bytes stored.

Once the accumulated output exceeds PAGE_SIZE, count can advance past
the sysfs buffer and limit can become negative. A later iteration then
passes an out-of-bounds destination pointer and an oversized size_t
into snprintf(), leading to an out-of-bounds write.

Use sysfs_emit_at() for the append instead. It follows the sysfs buffer
contract and returns the number of bytes actually stored, so the offset
remains bounded even when the output is truncated.

Fixes: 86db0c32f16c ("9p: fix /sys/fs/9p/caches overwriting itself")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Co-authored-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Message-ID: <abfb65f4800634dafb08238bba20cb48797e796f.1781908090.git.zzhan461@ucr.edu>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index f426cee374148..b30ca5145faef 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -17,6 +17,7 @@
 #include <linux/fs_context.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/sysfs.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include <net/9p/transport.h>
@@ -617,21 +618,14 @@ static ssize_t caches_show(struct kobject *kobj,
 			   struct kobj_attribute *attr,
 			   char *buf)
 {
-	ssize_t n = 0, count = 0, limit = PAGE_SIZE;
+	ssize_t count = 0;
 	struct v9fs_session_info *v9ses;
 
 	spin_lock(&v9fs_sessionlist_lock);
 	list_for_each_entry(v9ses, &v9fs_sessionlist, slist) {
-		if (v9ses->cachetag) {
-			n = snprintf(buf + count, limit, "%s\n", v9ses->cachetag);
-			if (n < 0) {
-				count = n;
-				break;
-			}
-
-			count += n;
-			limit -= n;
-		}
+		if (v9ses->cachetag)
+			count += sysfs_emit_at(buf, count, "%s\n",
+					       v9ses->cachetag);
 	}
 
 	spin_unlock(&v9fs_sessionlist_lock);
-- 
2.53.0



