Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB3A349AF5;
	Tue, 12 May 2026 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609505; cv=none; b=NMl7R85PtKMG/BPaPHlP8Gnnd9TWj/lJVPecG6B3X0YZuu4Q6tsrppoeasVJsSlvgcrs/R0SJYHyoAcxhq4RIUUYUJc7JTjp75q74dCdLmvjopZ5lGLWXqUVSLLz2JZcdur8u4W1z6WXKMT14XG8C5ml54aRBpDLLfCjVHtOlOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609505; c=relaxed/simple;
	bh=/UiTJ0SOBuNYaikO0JQPwEUnaJ2qgOGNziTvamzDHN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQmiIbuGMrNu13LDLcCu+sbvTJGYCu9eKev8P3eGSC0J66qtSWLlotayJtaH17PClW8m39p2pN+2jK9ZLtfwrRsR8+Vjb47DckzWLF0iXmHwZvty4st8+WXc5GSNzfJtrYD+ENwoiq/2GS0MRoOPNX9yRH5BcMraK44YZc4l1Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhTEO329; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhTEO329"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60129C2BCB0;
	Tue, 12 May 2026 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609504;
	bh=/UiTJ0SOBuNYaikO0JQPwEUnaJ2qgOGNziTvamzDHN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhTEO329NDn8fQgnjRe9IDMM970S8egzuNWbSsRnwsvFRDkME6/dMMH+7+4KWDFH7
	 GUK3aifKsGhMLdqgcwCNeIAlK4Gf8ai+zFPsVY+XjOSbkrXV0Cszr3LqHZIhPmEZzE
	 M+nYIq3F1BL8TomMMMSLcpvmhGnKNVp7CcofQ5Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 221/307] mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
Date: Tue, 12 May 2026 19:40:16 +0200
Message-ID: <20260512173944.782639554@linuxfoundation.org>
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

commit cf3b71421ca00807328c6d9cd242f9de3b77a4bf upstream.

damon_sysfs_quot_goal->path can be read and written by users, via DAMON
sysfs 'path' file.  It can also be indirectly read, for the parameters
{on,off}line committing to DAMON.  The reads for parameters committing are
protected by damon_sysfs_lock to avoid the sysfs files being destroyed
while any of the parameters are being read.  But the user-driven direct
reads and writes are not protected by any lock, while the write is
deallocating the path-pointing buffer.  As a result, the readers could
read the already freed buffer (user-after-free).  Note that the user-reads
don't race when the same open file is used by the writer, due to kernfs's
open file locking.  Nonetheless, doing the reads and writes with separate
open files would be common.  Fix it by protecting both the user-direct
reads and writes with damon_sysfs_lock.

Link: https://lore.kernel.org/20260423150253.111520-3-sj@kernel.org
Fixes: c41e253a411e ("mm/damon/sysfs-schemes: implement path file under quota goal directory")
Co-developed-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1197,8 +1197,13 @@ static ssize_t path_show(struct kobject
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
+	int len;
 
-	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
 }
 
 static ssize_t path_store(struct kobject *kobj,
@@ -1213,8 +1218,13 @@ static ssize_t path_store(struct kobject
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
 	kfree(goal->path);
 	goal->path = path;
+	mutex_unlock(&damon_sysfs_lock);
 	return count;
 }
 


