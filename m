Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BF4138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1654C433D2;
	Tue,  3 Jan 2023 08:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733709;
	bh=zHbGUamkF3+tVfJYq766+p207MhUgTPfux6jcmaZ27Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+tOoveA8GCRLNf7DF/1bUOPj/ZYOO5joWYwc0pRRegnTtSC/cea8gTuqnGsxSe/n
	 Y798AcVZDfLj0Ac2ErdLETlVZYj4tWQRdF45YEgW48d7DasE1MNkpQjdvysdPmBH7S
	 swJ80Il4It08VFXN0J2+ZGHAM7Xt4nPHKQCo3avg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 07/63] fs: expose LOOKUP_CACHED through openat2() RESOLVE_CACHED
Date: Tue,  3 Jan 2023 09:13:37 +0100
Message-Id: <20230103081309.004611226@linuxfoundation.org>
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

[ Upstream commit 99668f618062816ca7ba639b007eb145b9d3d41e ]

Now that we support non-blocking path resolution internally, expose it
via openat2() in the struct open_how ->resolve flags. This allows
applications using openat2() to limit path resolution to the extent that
it is already cached.

If the lookup cannot be satisfied in a non-blocking manner, openat2(2)
will return -1/-EAGAIN.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c                    |    6 ++++++
 include/linux/fcntl.h        |    2 +-
 include/uapi/linux/openat2.h |    4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -1099,6 +1099,12 @@ inline int build_open_flags(const struct
 		lookup_flags |= LOOKUP_BENEATH;
 	if (how->resolve & RESOLVE_IN_ROOT)
 		lookup_flags |= LOOKUP_IN_ROOT;
+	if (how->resolve & RESOLVE_CACHED) {
+		/* Don't bother even trying for create/truncate/tmpfile open */
+		if (flags & (O_TRUNC | O_CREAT | O_TMPFILE))
+			return -EAGAIN;
+		lookup_flags |= LOOKUP_CACHED;
+	}
 
 	op->lookup_flags = lookup_flags;
 	return 0;
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -19,7 +19,7 @@
 /* List of all valid flags for the how->resolve argument: */
 #define VALID_RESOLVE_FLAGS \
 	(RESOLVE_NO_XDEV | RESOLVE_NO_MAGICLINKS | RESOLVE_NO_SYMLINKS | \
-	 RESOLVE_BENEATH | RESOLVE_IN_ROOT)
+	 RESOLVE_BENEATH | RESOLVE_IN_ROOT | RESOLVE_CACHED)
 
 /* List of all open_how "versions". */
 #define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
--- a/include/uapi/linux/openat2.h
+++ b/include/uapi/linux/openat2.h
@@ -35,5 +35,9 @@ struct open_how {
 #define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
 					be scoped inside the dirfd
 					(similar to chroot(2)). */
+#define RESOLVE_CACHED		0x20 /* Only complete if resolution can be
+					completed through cached lookup. May
+					return -EAGAIN if that's not
+					possible. */
 
 #endif /* _UAPI_LINUX_OPENAT2_H */


