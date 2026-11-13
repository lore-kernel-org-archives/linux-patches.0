Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591002;
	b=xNZ9qPMQ3tZk/gEQZBwy3aQndXcqo1tJK/sifnfsAXo5zjblGaTHS9Sk1ju2gmZBurj8
	 PFOeNyTHu1fcosGS5MI7BXwxrpToFHanWUrjhKHcY0irtvKz7kWB1LiKRMtoOdSXFrpxs
	 qf2BcN1bNsC8vC3b3vt9nq5V/VglS9NMQPiuQtkqGGRmtN+ytcNk6Y0XU7QqDkiMIDtD6
	 JYQd/BN8UMkxXv2+kkeNlTaE4eHcjVkkQeDqx+zatVpRpqVP1rMmxLqzYDPIuZfG+07qk
	 /DH/XV901uFefIcX1Py128Z7tA+ajlluBid9s09yOc7XGXem5KhRPMAet/4BSk8HYZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=34vKvq9MsmvV9w1dP4IoELgwoje1kswDFVhBLrsPwlA=;
	b=T6eZ/1/9pwf0lKUuO9aToZA0i6MWdgh4Y5BRrZz9P3HEZc9L99kYe1RzG6p2c1Hat3lv
	 tN+nE48bnC9pmn9Bdyqt80gmE3m1mBDWJhnVOtCOgggzs+eiVdmV389SFOsGIBizFP3dY
	 5IrtUKad4vncmea5M3AO/5srmq+cJDXL5Ljiu5/7QfStIw3ZiVRUbtPA3a+TlEdHO5i+x
	 NQ9g4EjD0WPr1mC/iLAJLBv4zgvDsl6L1YuISVZLeF3PJZ6trnWZg9/xHlULcPWYwSpRB
	 igj1cCfHCQAmKNtDAbdDOy9TN7p9hc9g2pcsctw54VMMqFBpsnnM2CsmsK2McXZ+NzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iOqpIaQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D416070F08;
	Fri, 13 Nov 2026 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iOqpIaQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC621F000C4;
	Fri, 13 Nov 2026 17:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591002;
	bh=34vKvq9MsmvV9w1dP4IoELgwoje1kswDFVhBLrsPwlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOqpIaQGXjO/+ZmLxjYfscrrru0bCOHMpdcSiVsdcJ+WLhaL/Mi6dTaJX5ATZge0+
	 s30ePvOIr4Yc03ZBLRmF81Il5X5QOtH4gPE6KdOGBh23f7ZY3VoknqttgdsxFU5t+F
	 kEdk/eT00MYXaAOPiUB9tyjdMSU9rDxXmfqqHkhc=
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
Subject: [PATCH 6.12 173/670] 9p: fix caches_show() out-of-bounds write
Date: Fri, 13 Nov 2026 10:45:37 -0500
Message-ID: <20261113153817.922793036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index bc879d32cfcf5..66b072152745a 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -16,6 +16,7 @@
 #include <linux/parser.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/sysfs.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include <net/9p/transport.h>
@@ -555,21 +556,14 @@ static ssize_t caches_show(struct kobject *kobj,
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



