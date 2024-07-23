Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2737158A06;
	Tue, 23 Jul 2024 18:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760276; cv=none; b=cWaDK3FdphupAz/yCY110S7nxrVT1BD6zUTSErNMJdQzRvEU7jXyi1AxjKQKxjHcvfh2WbyFvwgSt44ftgBbMGuSzL52FWHH5qoECwto9GhNd2nWNMKXlUaFewyC7WOpzIpjRDkwxuUdOJUPswLwE3+8QC0UYQ95WsDVvnI5g+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760276; c=relaxed/simple;
	bh=PzNef/mhQ+Ksj9OxzWKr/ujJA987d1MTqRB7cfnRk54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vw+2cPqr+l9TI7ZeSmOFF/ncQ8n7csL2NFviWz3HNmGL616vEyoJN8tn2Cl2d+HneHhof1H8+2Y32+KtXXlING4aR2wQzkhu3u5PhvYvtmFJqN4LKgvRalkzTuLDyxxmeN987KW0uBRBWKySx1YrmmzfW34T2utL4zoBerj964c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2hPCF2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2hPCF2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691CFC4AF0A;
	Tue, 23 Jul 2024 18:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760275;
	bh=PzNef/mhQ+Ksj9OxzWKr/ujJA987d1MTqRB7cfnRk54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2hPCF2O0lsE0e4KiHg+Z2Ss0ErKLlxgxwQavbfuPTf3mAANdvJvRv5iJltqYTwRU
	 4aNcE4ZHK9+/qRynsj9EGMnRHmZ0dZkG9pdg+S7RmK2qdQqVTv4YMeJWHkBmSujTee
	 3xJ+oSWyvC8UMuijyDgQ1ORUS/lKpWl5cvLwU45k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.9 161/163] netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()
Date: Tue, 23 Jul 2024 20:24:50 +0200
Message-ID: <20240723180149.690379529@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

[ Upstream commit 85b08b31a22b481ec6528130daf94eee4452e23f ]

Export fscache_put_volume() and add fscache_try_get_volume()
helper function to allow cachefiles to get/put fscache_volume
via linux/fscache-cache.h.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-2-libaokun@huaweicloud.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 522018a0de6b ("cachefiles: fix slab-use-after-free in fscache_withdraw_volume()")
Stable-dep-of: 5d8f80578907 ("cachefiles: fix slab-use-after-free in cachefiles_withdraw_cookie()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/fscache_volume.c     |   14 ++++++++++++++
 fs/netfs/internal.h           |    2 --
 include/linux/fscache-cache.h |    6 ++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/fs/netfs/fscache_volume.c
+++ b/fs/netfs/fscache_volume.c
@@ -27,6 +27,19 @@ struct fscache_volume *fscache_get_volum
 	return volume;
 }
 
+struct fscache_volume *fscache_try_get_volume(struct fscache_volume *volume,
+					      enum fscache_volume_trace where)
+{
+	int ref;
+
+	if (!__refcount_inc_not_zero(&volume->ref, &ref))
+		return NULL;
+
+	trace_fscache_volume(volume->debug_id, ref + 1, where);
+	return volume;
+}
+EXPORT_SYMBOL(fscache_try_get_volume);
+
 static void fscache_see_volume(struct fscache_volume *volume,
 			       enum fscache_volume_trace where)
 {
@@ -420,6 +433,7 @@ void fscache_put_volume(struct fscache_v
 			fscache_free_volume(volume);
 	}
 }
+EXPORT_SYMBOL(fscache_put_volume);
 
 /*
  * Relinquish a volume representation cookie.
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -326,8 +326,6 @@ extern const struct seq_operations fscac
 
 struct fscache_volume *fscache_get_volume(struct fscache_volume *volume,
 					  enum fscache_volume_trace where);
-void fscache_put_volume(struct fscache_volume *volume,
-			enum fscache_volume_trace where);
 bool fscache_begin_volume_access(struct fscache_volume *volume,
 				 struct fscache_cookie *cookie,
 				 enum fscache_access_trace why);
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -19,6 +19,7 @@
 enum fscache_cache_trace;
 enum fscache_cookie_trace;
 enum fscache_access_trace;
+enum fscache_volume_trace;
 
 enum fscache_cache_state {
 	FSCACHE_CACHE_IS_NOT_PRESENT,	/* No cache is present for this name */
@@ -97,6 +98,11 @@ extern void fscache_withdraw_cookie(stru
 
 extern void fscache_io_error(struct fscache_cache *cache);
 
+extern struct fscache_volume *
+fscache_try_get_volume(struct fscache_volume *volume,
+		       enum fscache_volume_trace where);
+extern void fscache_put_volume(struct fscache_volume *volume,
+			       enum fscache_volume_trace where);
 extern void fscache_end_volume_access(struct fscache_volume *volume,
 				      struct fscache_cookie *cookie,
 				      enum fscache_access_trace why);


