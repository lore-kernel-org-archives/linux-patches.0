Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A50B145B15;
	Thu, 13 Jun 2024 12:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280397; cv=none; b=daEexPUcaNtH1v6C+qnCKdYjbW6bBJoVled79gDegS/xAD/C+8yxUS1kjBM8HOTHnpzsdHqtXPjKWnZyq6uvzn1LwTK3XO6ETb1G7shFpvORW+9CX7WurPEEa5ttLC8tcE5EiPCWvzwltXhDuy9fcH1GjYuTYzjIVqf/oOnnfw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280397; c=relaxed/simple;
	bh=t69aR8N8Zispxe0JuaHFMNB2rAABqZC2GbKttFzdJH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8GjblRKnIXVX6MuqovpQUauQFeOzpKS0Rxfr/Dx27SNcTlu1NTIVM3ayNCdJf0lck+Gjeu5H7cf063i4b0JOaXBsSLpLd+oBuQ07TQt5NwaR7M8P5bzaaJpgHPCttBM/z5Mu8ZAMOZg4dvrT8mgsL0iLo2X43jZ7Yeh4ZnmSzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/q2ZxLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/q2ZxLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4926C2BBFC;
	Thu, 13 Jun 2024 12:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280397;
	bh=t69aR8N8Zispxe0JuaHFMNB2rAABqZC2GbKttFzdJH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/q2ZxLC5q4+hrKi2iyrm6RMiduhlWw0iVzP7hlKwcHg5li2cymmSNw9KY4/4lsu6
	 ap1tqE3V43dyF8X7lJzE+/ItAYQNfBu6SUMsTitJ4aITCwL8inWh7qPmDBUlZoR8mN
	 YkYGZylmu96eXGDd5dPSeAzRcykhw0agpN1k6H3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandeep Dhavale <dhavale@google.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.6 009/137] erofs: avoid allocating DEFLATE streams before mounting
Date: Thu, 13 Jun 2024 13:33:09 +0200
Message-ID: <20240613113223.649602154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 80eb4f62056d6ae709bdd0636ab96ce660f494b2 upstream.

Currently, each DEFLATE stream takes one 32 KiB permanent internal
window buffer even if there is no running instance which uses DEFLATE
algorithm.

It's unexpected and wasteful on embedded devices with limited resources
and servers with hundreds of CPU cores if DEFLATE is enabled but unused.

Fixes: ffa09b3bd024 ("erofs: DEFLATE compression support")
Cc: <stable@vger.kernel.org> # 6.6+
Reviewed-by: Sandeep Dhavale <dhavale@google.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240520090106.2898681-1-hsiangkao@linux.alibaba.com
[ Gao Xiang: resolve trivial conflicts. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor_deflate.c |   57 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

--- a/fs/erofs/decompressor_deflate.c
+++ b/fs/erofs/decompressor_deflate.c
@@ -47,39 +47,15 @@ int __init z_erofs_deflate_init(void)
 	/* by default, use # of possible CPUs instead */
 	if (!z_erofs_deflate_nstrms)
 		z_erofs_deflate_nstrms = num_possible_cpus();
-
-	for (; z_erofs_deflate_avail_strms < z_erofs_deflate_nstrms;
-	     ++z_erofs_deflate_avail_strms) {
-		struct z_erofs_deflate *strm;
-
-		strm = kzalloc(sizeof(*strm), GFP_KERNEL);
-		if (!strm)
-			goto out_failed;
-
-		/* XXX: in-kernel zlib cannot shrink windowbits currently */
-		strm->z.workspace = vmalloc(zlib_inflate_workspacesize());
-		if (!strm->z.workspace) {
-			kfree(strm);
-			goto out_failed;
-		}
-
-		spin_lock(&z_erofs_deflate_lock);
-		strm->next = z_erofs_deflate_head;
-		z_erofs_deflate_head = strm;
-		spin_unlock(&z_erofs_deflate_lock);
-	}
 	return 0;
-
-out_failed:
-	pr_err("failed to allocate zlib workspace\n");
-	z_erofs_deflate_exit();
-	return -ENOMEM;
 }
 
 int z_erofs_load_deflate_config(struct super_block *sb,
 			struct erofs_super_block *dsb, void *data, int size)
 {
 	struct z_erofs_deflate_cfgs *dfl = data;
+	static DEFINE_MUTEX(deflate_resize_mutex);
+	static bool inited;
 
 	if (!dfl || size < sizeof(struct z_erofs_deflate_cfgs)) {
 		erofs_err(sb, "invalid deflate cfgs, size=%u", size);
@@ -90,9 +66,36 @@ int z_erofs_load_deflate_config(struct s
 		erofs_err(sb, "unsupported windowbits %u", dfl->windowbits);
 		return -EOPNOTSUPP;
 	}
-
+	mutex_lock(&deflate_resize_mutex);
+	if (!inited) {
+		for (; z_erofs_deflate_avail_strms < z_erofs_deflate_nstrms;
+		     ++z_erofs_deflate_avail_strms) {
+			struct z_erofs_deflate *strm;
+
+			strm = kzalloc(sizeof(*strm), GFP_KERNEL);
+			if (!strm)
+				goto failed;
+			/* XXX: in-kernel zlib cannot customize windowbits */
+			strm->z.workspace = vmalloc(zlib_inflate_workspacesize());
+			if (!strm->z.workspace) {
+				kfree(strm);
+				goto failed;
+			}
+
+			spin_lock(&z_erofs_deflate_lock);
+			strm->next = z_erofs_deflate_head;
+			z_erofs_deflate_head = strm;
+			spin_unlock(&z_erofs_deflate_lock);
+		}
+		inited = true;
+	}
+	mutex_unlock(&deflate_resize_mutex);
 	erofs_info(sb, "EXPERIMENTAL DEFLATE feature in use. Use at your own risk!");
 	return 0;
+failed:
+	mutex_unlock(&deflate_resize_mutex);
+	z_erofs_deflate_exit();
+	return -ENOMEM;
 }
 
 int z_erofs_deflate_decompress(struct z_erofs_decompress_req *rq,


