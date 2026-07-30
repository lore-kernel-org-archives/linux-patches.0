Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECABB448D15;
	Thu, 30 Jul 2026 16:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427844; cv=none; b=EayyrUAjiDmlU6jW5DaTo1uxOhAHZlkbx3wz8n7tPEkVt2p9ovKI+P6hpupq5yHibBFJRyzuVkTDlFijziPjIh95LuvWftRAaK7sIWP00YG5eQrWo/363uo2L4UCpcP2l6hReTZqH4oKLNEvt5kKLUuK5Z8vzpS6YOeqBXKdUWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427844; c=relaxed/simple;
	bh=+3yNxU6556mMOzfvCOVmpbAXL2xhX2Ob4P3/HRqNv6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJfUeWpG/tTW5yMO+fSRbdhLTTat0FL1kEVnZWUiyP5tirHLQC4e05kCLC5A1kXbhGdC8LWSMW8cf6NEbv3kx0WZbLfM4Id0l0gz4aPYdDtKfzVJFsbBX5IMBhz6BbZpKiEZ6ejPPQxzKGhTpHfWwYIluKZsb7n43hxOvSF47hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNJiU4YO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNJiU4YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F311F00A3A;
	Thu, 30 Jul 2026 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427842;
	bh=s3zVunj3OYeox+YgScXuxpHm6pmFGRYilzBAHf515Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNJiU4YO8siE1aKZl3HHY1Sm2S4jbsqqseO2rQvVLNNhxD6VugCfubI1NXi+UHRKH
	 HIZZeuGKNsNlbm3ETqfzjGtorh+7wzc91FmapfZKN79Kv6tplag4GhtwM8w8gJe/hI
	 r/AzcGYEDc462+/A2DVvkUbZHSXRLfyhn1+p7flw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Luis Henriques <luis@igalia.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 312/484] fs: preserve ACL_DONT_CACHE state in forget_cached_acl()
Date: Thu, 30 Jul 2026 16:13:29 +0200
Message-ID: <20260730141430.266037102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 4b9a5458d02e214ef2b384124ca626e3e381d778 upstream.

The ACL_DONT_CACHE state is meant to be a constant state for the inode
for filesystems that want to opt out of posix acl caching.

Commit facd61053cff1 ("fuse: fixes after adapting to new posix acl api")
used this facility to opt out of posix acl caching for fuse inodes with
fuse server that does not negotiate FUSE_POSIX_ACL (fc->posix_acl).

The commit also takes care to gate the forget_all_cached_acls() call in
fuse_set_acl() on fc->posix_acl because there is no need for it, but
there are other placed in fuse code which call forget_all_cached_acls()
unconditional to fc->posix_acl and those cause the loss of the
ACL_DONT_CACHE state.

This is not only a functional bug. Properly timed, a get_acl() from this
fuse filesystem can return a stale cached value, as was observed in tests,
because set_acl() does not invalidate the unintentional acl cache.

We could fix this in fuse, but it actually makes no sense for the vfs
helper forget_cached_acl() to invalidate the ACL_DONT_CACHE state, so
let it not do that to fix fuse and future users of ACL_DONT_CACHE.

Fixes: facd61053cff1 ("fuse: fixes after adapting to new posix acl api")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260713220932.413004-2-amir73il@gmail.com
Reviewed-by: Luis Henriques <luis@igalia.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/posix_acl.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -94,6 +94,13 @@ static void __forget_cached_acl(struct p
 {
 	struct posix_acl *old;
 
+	/*
+	 * ACL_DONT_CACHE is expected to be a "const" value and xchg it with
+	 * ACL_NOT_CACHED would enable acl caching for the inode -
+	 * clearly not what the caller has intended.
+	 */
+	if (READ_ONCE(*p) == ACL_DONT_CACHE)
+		return;
 	old = xchg(p, ACL_NOT_CACHED);
 	if (!is_uncached_acl(old))
 		posix_acl_release(old);


