Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF7E138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608C6C433D2;
	Tue,  3 Jan 2023 08:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733700;
	bh=S2YwlKiHHuyCFJGS/ymJNKJ+MvKMUE0WxqOys/uYsnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtmVKLn12QRjjzP5lIZaK1eenGBPmu1oqE6IlWI/idNWKvzIIztpvYY8XgTjD6MHm
	 8G8qhZraxFtDzLDVq3ohF88blOraY4H01tIE4UdUXKY6J+nYA5T9b8eQz4RxSnaQcI
	 fSZvcfqMQX+wyGkeF8pUOhj9344vZJ7VSLuXIYVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 04/63] fs: add support for LOOKUP_CACHED
Date: Tue,  3 Jan 2023 09:13:34 +0100
Message-Id: <20230103081308.820048429@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 6c6ec2b0a3e0381d886d531bd1471dfdb1509237 ]

io_uring always punts opens to async context, since there's no control
over whether the lookup blocks or not. Add LOOKUP_CACHED to support
just doing the fast RCU based lookups, which we know will not block. If
we can do a cached path resolution of the filename, then we don't have
to always punt lookups for a worker.

During path resolution, we always do LOOKUP_RCU first. If that fails and
we terminate LOOKUP_RCU, then fail a LOOKUP_CACHED attempt as well.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c            |    9 +++++++++
 include/linux/namei.h |    1 +
 2 files changed, 10 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -686,6 +686,8 @@ static bool try_to_unlazy(struct nameida
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 
 	nd->flags &= ~LOOKUP_RCU;
+	if (nd->flags & LOOKUP_CACHED)
+		goto out1;
 	if (unlikely(!legitimize_links(nd)))
 		goto out1;
 	if (unlikely(!legitimize_path(nd, &nd->path, nd->seq)))
@@ -722,6 +724,8 @@ static bool try_to_unlazy_next(struct na
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 
 	nd->flags &= ~LOOKUP_RCU;
+	if (nd->flags & LOOKUP_CACHED)
+		goto out2;
 	if (unlikely(!legitimize_links(nd)))
 		goto out2;
 	if (unlikely(!legitimize_mnt(nd->path.mnt, nd->m_seq)))
@@ -792,6 +796,7 @@ static int complete_walk(struct nameidat
 		 */
 		if (!(nd->flags & (LOOKUP_ROOT | LOOKUP_IS_SCOPED)))
 			nd->root.mnt = NULL;
+		nd->flags &= ~LOOKUP_CACHED;
 		if (!try_to_unlazy(nd))
 			return -ECHILD;
 	}
@@ -2204,6 +2209,10 @@ static const char *path_init(struct name
 	int error;
 	const char *s = nd->name->name;
 
+	/* LOOKUP_CACHED requires RCU, ask caller to retry */
+	if ((flags & (LOOKUP_RCU | LOOKUP_CACHED)) == LOOKUP_CACHED)
+		return ERR_PTR(-EAGAIN);
+
 	if (!*s)
 		flags &= ~LOOKUP_RCU;
 	if (flags & LOOKUP_RCU)
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -46,6 +46,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_NO_XDEV		0x040000 /* No mountpoint crossing. */
 #define LOOKUP_BENEATH		0x080000 /* No escaping from starting point. */
 #define LOOKUP_IN_ROOT		0x100000 /* Treat dirfd as fs root. */
+#define LOOKUP_CACHED		0x200000 /* Only do cached lookup */
 /* LOOKUP_* flags which do scope-related checks based on the dirfd. */
 #define LOOKUP_IS_SCOPED (LOOKUP_BENEATH | LOOKUP_IN_ROOT)
 


