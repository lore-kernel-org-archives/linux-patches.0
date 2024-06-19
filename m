Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ACA12FB31;
	Wed, 19 Jun 2024 13:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802202; cv=none; b=qFJedGUmNDFlV0R21wiM5pbvryknNgnjLzCRxTHcKJ3IunXufuyKqoxcdtWIijlpMH0dVREuXk5eXxfm7DJLiR+NQHUbcHtIzwSiEivDHfX5NY9R3q+7DU6gUmXE2I9MftAEJF5EP3QYscCHc8ZfMLTarH5wpxNPdYEsTKI/PfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802202; c=relaxed/simple;
	bh=yf0vl1x5dNyfp2npKzq0OpDpjDTyP3WsJ65vAdqzRFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9z51KVT2yJHuGswZ1J6p2CaJOQrY8G1TCUhowZZxjKhbjEeUUxzd8jYcF+V8yxYSxO/ofTGVYM8c8tWhSyWElMVXzdNeDzxzWFj8xczk0ukh33yBTily64C58gYosyDKrZbi2bR/Qfblt5P/ldzOJZhhgjkpwe2b/56ZIlg+to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXbgmSvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXbgmSvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCA7C2BBFC;
	Wed, 19 Jun 2024 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802202;
	bh=yf0vl1x5dNyfp2npKzq0OpDpjDTyP3WsJ65vAdqzRFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXbgmSvKKY0vA8e2/d6+E2HE0MlH7jyCRBR9SpAYBY9tOTlUcbSxq3V3X/91kuJPP
	 c3DRMfQm2kWf6APDzpaY3qHEJ4H+Y35xGW9jdIar2BH6T5KGIQRB5jHRwcEINoRy1y
	 EGbqlSgNIqybHeDRH3dqGe5vkBpaPRUwQn8sq0Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/267] cachefiles: flush all requests after setting CACHEFILES_DEAD
Date: Wed, 19 Jun 2024 14:54:26 +0200
Message-ID: <20240619125610.764860715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 26b487e112596..b9945e4f697be 100644
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
index 28799c8e2c6f6..3eea52462fc87 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -188,6 +188,7 @@ extern int cachefiles_has_space(struct cachefiles_cache *cache,
  * daemon.c
  */
 extern const struct file_operations cachefiles_daemon_fops;
+extern void cachefiles_flush_reqs(struct cachefiles_cache *cache);
 extern void cachefiles_get_unbind_pincount(struct cachefiles_cache *cache);
 extern void cachefiles_put_unbind_pincount(struct cachefiles_cache *cache);
 
@@ -414,6 +415,8 @@ do {							\
 	pr_err("I/O Error: " FMT"\n", ##__VA_ARGS__);	\
 	fscache_io_error((___cache)->cache);		\
 	set_bit(CACHEFILES_DEAD, &(___cache)->flags);	\
+	if (cachefiles_in_ondemand_mode(___cache))	\
+		cachefiles_flush_reqs(___cache);	\
 } while (0)
 
 #define cachefiles_io_error_obj(object, FMT, ...)			\
-- 
2.43.0



