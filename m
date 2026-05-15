Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B26303CB0;
	Fri, 15 May 2026 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861294; cv=none; b=paP6F+UCwFxASyKjncNEr9pUR+wie8rWFs/WwuUh1USnM1IjO4dn9S8Erq2Srxi42rTwegjxXwSbL8gauaRO9LHvaHQOlyCQlcYB+y+mZVCGYm8x6RPPNjaJXD2YKykSVuLVrc+qSNVF/jfcwWeTc3A/FjXRVn3IE8d8e3gnAOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861294; c=relaxed/simple;
	bh=LNLQQ5Qn6VIaexJn5O6fqAo47uZ2Fp2N0zce9vvGs1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnP1wEg1ms/rONmQRABMxX6c4pLkT4gEi/atoK6CAcOpj/f8mRlBztQOmQNpYMCBMHb17MvJDAbQCwNu14nD8Och27By59JmMKC98Wtayk5bMH3+YG0BLSX6y3Ki8zeeFR6Wb31tsKdQE3mXZgBP4dtYNIXrXT0A+gq+hojwSYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3qR57ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3qR57ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1FEC2BCB0;
	Fri, 15 May 2026 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861293;
	bh=LNLQQ5Qn6VIaexJn5O6fqAo47uZ2Fp2N0zce9vvGs1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3qR57ck35s8XZMoo7ZwVpEzOaEKYBMa7IpS9s1UPyJwplojCOqk5O84jCqXR4TtU
	 lUuiM89vt54nSJ5lYiYwG0Ijjtc5ALTROTzQOcx3aOu3edxH4+PZKjevPwSzITBRGZ
	 I2zlAhqXe8bUgDWWN9UJaGUjlhlUWTM5BUw1Fokc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 273/474] mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
Date: Fri, 15 May 2026 17:46:22 +0200
Message-ID: <20260515154720.908473342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -360,9 +360,14 @@ static ssize_t memcg_path_show(struct ko
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
@@ -376,8 +381,13 @@ static ssize_t memcg_path_store(struct k
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
 


