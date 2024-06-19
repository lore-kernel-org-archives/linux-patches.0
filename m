Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DB3AD58;
	Wed, 19 Jun 2024 13:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802996; cv=none; b=Gh7Nv8lZEtZRwh2uZZaKoPOIGc0dOeo6qmX7pKd/E0Zn158FMA1YpCMwX4BzoJTbyG0XC4wbbF9CHJPl2vE+EVZsi96u2fszEuWOffXvelYUJ4L1INicyay/goEU+rZKm5iPpWEQcDIiysFZDymEA8dkFXhbJ1V5u9A83/V8LIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802996; c=relaxed/simple;
	bh=OsEqO6e2o7BeV+tgcEcGdayN3SnJE/cfhrJbhadz65Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7GxgFB1zL1YjG4NH0hAj0cL1MRKrdAlvZAzDvQymbYOcYkqcJuIyzyDqESJVJzOPux2yP5E5WkaLT9jlwM1tU47Kr3J1VDzcpSxFLUrfB5wtZCpgsPGuKl84kAeZCWoK26O6w/ZjYrJrJPLJDsP74bXLXc5P1Y3SO5MIPlSrwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7rBPNtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7rBPNtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B3BC2BBFC;
	Wed, 19 Jun 2024 13:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802995;
	bh=OsEqO6e2o7BeV+tgcEcGdayN3SnJE/cfhrJbhadz65Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7rBPNtAL+SzAxJvnbXPDCz6L5zcWP5gAqyNuy0oqx2+BUAmkYk3m1W+unXE+r56D
	 GbCqcr80vvFQK48gBi17r3WEAjqRSYDhIL47sRC3CjQphfq/LAru8g09ZzqIP/xJ8y
	 j1LvCzkiJJ/G6kYZ7FtJKYZBF/cvplNdiYllvwyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 118/281] cachefiles: flush all requests after setting CACHEFILES_DEAD
Date: Wed, 19 Jun 2024 14:54:37 +0200
Message-ID: <20240619125614.387549928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 85e833cd7243bda7285492b0653c3abb1e2e757b ]

In ondemand mode, when the daemon is processing an open request, if the
kernel flags the cache as CACHEFILES_DEAD, the cachefiles_daemon_write()
will always return -EIO, so the daemon can't pass the copen to the kernel.
Then the kernel process that is waiting for the copen triggers a hung_task.

Since the DEAD state is irreversible, it can only be exited by closing
/dev/cachefiles. Therefore, after calling cachefiles_io_error() to mark
the cache as CACHEFILES_DEAD, if in ondemand mode, flush all requests to
avoid the above hungtask. We may still be able to read some of the cached
data before closing the fd of /dev/cachefiles.

Note that this relies on the patch that adds reference counting to the req,
otherwise it may UAF.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-12-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/daemon.c   | 2 +-
 fs/cachefiles/internal.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index ccb7b707ea4b7..06cdf1a8a16f6 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -133,7 +133,7 @@ static int cachefiles_daemon_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static void cachefiles_flush_reqs(struct cachefiles_cache *cache)
+void cachefiles_flush_reqs(struct cachefiles_cache *cache)
 {
 	struct xarray *xa = &cache->reqs;
 	struct cachefiles_req *req;
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 45c8bed605383..6845a90cdfcce 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -188,6 +188,7 @@ extern int cachefiles_has_space(struct cachefiles_cache *cache,
  * daemon.c
  */
 extern const struct file_operations cachefiles_daemon_fops;
+extern void cachefiles_flush_reqs(struct cachefiles_cache *cache);
 extern void cachefiles_get_unbind_pincount(struct cachefiles_cache *cache);
 extern void cachefiles_put_unbind_pincount(struct cachefiles_cache *cache);
 
@@ -426,6 +427,8 @@ do {							\
 	pr_err("I/O Error: " FMT"\n", ##__VA_ARGS__);	\
 	fscache_io_error((___cache)->cache);		\
 	set_bit(CACHEFILES_DEAD, &(___cache)->flags);	\
+	if (cachefiles_in_ondemand_mode(___cache))	\
+		cachefiles_flush_reqs(___cache);	\
 } while (0)
 
 #define cachefiles_io_error_obj(object, FMT, ...)			\
-- 
2.43.0



