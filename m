Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590182;
	b=HgbccUL00bTWlXHevPz+AGLf4TBKBGJhse1LGxWfYkfil1tYP6SFwYytmk6x/aaQlDBw
	 IUbNXcISGouP69+VA6O/tcm7ye/wzTIYGDdx137CO/ybyae/WEAdSIFMBMFVxwDFMT4v9
	 rywYVJ0XlJDd4QcEt+64JmlXxgscTGS7DsP+xQFlRr3H8wJzYzttT6picKrOLB0/4QLx3
	 18nv3z69fxhsKAz2EnCKmbWQqP3CAYg6iFjgGSx2iIMtqpj56z95qg5dtIrGhGNu49tDy
	 qgs8YEYYKIgo0uRYNzIBcIYSVuednUm5Ex4AVz/ZdUgGS5gmwfS12F9rl8kMaaaxfqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v76LMvKh/Ru/Nv5foWpkeVoq5Y3txKrbmozGO6lEwSE=;
	b=l+ebV8J7isf69OEBvo16IeCcbPCZT9EnPXOCgzUMYVYLN6nqSOUdwaNt+wDY0QoEW2iq
	 yQzU5SxJA4tB8e8wu/IqXULLAh/UlsKiYbxYIPRihc8ZbobQl2ROfM9wG0RKFKL5o5zMl
	 9Ebcl4wIRHw9rf8kKB4LmP/FD5y22wYGYXJbdRHanI3I5zgoKF9/cPTxD+eGu1Z6eg3Qj
	 cAOs8O0Nwel3D/AhfyrUX965AH4TKeRX1O5cbIc5JGAe9WjNJmuIyLcb0whWe4avZJmq0
	 VUsh2xq9ieb2lsgdgmuYnNgQ0MKC7C4U5c4yddaicCJzynA8J0iid+J/HLCXo25Z5Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIpFRG2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E0E606B836;
	Fri, 13 Nov 2026 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIpFRG2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFB01F000C6;
	Fri, 13 Nov 2026 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590182;
	bh=v76LMvKh/Ru/Nv5foWpkeVoq5Y3txKrbmozGO6lEwSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIpFRG2iFedmaU4Dk03a8tDM6FIxSsnFdJJ5dsy+498tJfZO7bdydGGUbwYxME5ez
	 O++1CfYREtbTFbRiJLu4LdhQxNEsQ5qvvpbcq0IsvJkr19V2LuiC4ZAuM1kZkZd3YZ
	 n6nME3dj5+3dMMWhTgv3ztBrNfeeEMKOwjoXeQm0=
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
Subject: [PATCH 6.18 184/686] 9p: fix caches_show() out-of-bounds write
Date: Fri, 13 Nov 2026 10:45:17 -0500
Message-ID: <20261113153827.241080707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index bde3ffb0e319a..20dc6a03826a3 100644
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
@@ -554,21 +555,14 @@ static ssize_t caches_show(struct kobject *kobj,
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



