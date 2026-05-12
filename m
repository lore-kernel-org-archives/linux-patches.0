Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8497342509;
	Tue, 12 May 2026 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609499; cv=none; b=NpNv5xyphukPkpmKiM9Vd+miR3f9AW6b3CJIYl15Jii58qmVBObeKg/e7jmsKQH2tLcR5cs3eDMDCHU4zJoWHYT3gpJraExMNdthSZoH9c72tpI08YzFQuOX5aVHSqbQxytgALYikI1mnU0qLRt/vaBX6zwKDL4gmP5e4wgH8gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609499; c=relaxed/simple;
	bh=Y4iH4ObgExJ3xARiwLEMqC1s5SbjqYK+ebEicaEK7XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8/hapzSNscJO+PhSLy47P3UwsHaX3L3dxNS6L71QaCgcVm7f1derw5A+P8QjVgTMqLVhBP5eP+h+FBgaZ2Jbd48rTEfBlTTIvzsYqmMhMyWCM180KAKPCmUcbqdCKEG/g3G+b8W+bSM4McscE3rTVVAvOD8w4AhitTmjIEeFOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dufzb/Ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dufzb/Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3818DC2BCB0;
	Tue, 12 May 2026 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609499;
	bh=Y4iH4ObgExJ3xARiwLEMqC1s5SbjqYK+ebEicaEK7XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dufzb/Ci5IzaFIjxzPFBr/0jRYPZ9NaD1bLLS08tTi5y4IsJV5qU7upTScsTsZ7bd
	 4LqWhBfY8luqlWnP07pBmgRFsWwT4Y/2D5hinc1irrsszNC/7wDLipW3mKNYzF+juS
	 jJOsnetJsIh9g31xdbgNNfX8A3Wwt36c60O0dUvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 220/307] mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
Date: Tue, 12 May 2026 19:40:15 +0200
Message-ID: <20260512173944.760682768@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 1e68eb96e8beb1abefd12dd22c5637795d8a877e upstream.

Patch series "mm/damon/sysfs-schemes: fix use-after-free for [memcg_]path".

Reads of 'memcg_path' and 'path' files in DAMON sysfs interface could race
with their writes, results in use-after-free.  Fix those.


This patch (of 2):

damon_sysfs_scheme_filter->mmecg_path can be read and written by users,
via DAMON sysfs memcg_path file.  It can also be indirectly read, for the
parameters {on,off}line committing to DAMON.  The reads for parameters
committing are protected by damon_sysfs_lock to avoid the sysfs files
being destroyed while any of the parameters are being read.  But the
user-driven direct reads and writes are not protected by any lock, while
the write is deallocating the memcg_path-pointing buffer.  As a result,
the readers could read the already freed buffer (user-after-free).  Note
that the user-reads don't race when the same open file is used by the
writer, due to kernfs's open file locking.  Nonetheless, doing the reads
and writes with separate open files would be common.  Fix it by protecting
both the user-direct reads and writes with damon_sysfs_lock.

Link: https://lore.kernel.org/20260423150253.111520-1-sj@kernel.org
Link: https://lore.kernel.org/20260423150253.111520-2-sj@kernel.org
Fixes: 4f489fe6afb3 ("mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write")
Co-developed-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -533,9 +533,14 @@ static ssize_t memcg_path_show(struct ko
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
+	int len;
 
-	return sysfs_emit(buf, "%s\n",
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n",
 			filter->memcg_path ? filter->memcg_path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
 }
 
 static ssize_t memcg_path_store(struct kobject *kobj,
@@ -550,8 +555,13 @@ static ssize_t memcg_path_store(struct k
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
 	kfree(filter->memcg_path);
 	filter->memcg_path = path;
+	mutex_unlock(&damon_sysfs_lock);
 	return count;
 }
 


